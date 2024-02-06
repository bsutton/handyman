import 'package:json_annotation/json_annotation.dart';
import '../../util/format.dart';
import '../../util/local_date.dart';
import '../../util/local_time.dart';
import '../transaction/transaction.dart';
import '../types/day_of_week.dart';
import '../types/er.dart';
import 'business_hours_for_day.dart';
import 'call_forward_target.dart';
import 'customer.dart';
import 'entity.dart';
import 'override_hours.dart';
import 'region.dart';
import 'user.dart';

part 'team.g.dart';

/// Controls how we ring members of a team.
enum MemberRotation { ROUND_ROBIN, GROUP_RING }

enum MusicOnHold { JAZZ, CLASSIC, ELEVATOR }

///
/// We model an office as a 'team' as with our mobile system
/// there is really no concept of a physical office but rather a collection
/// of users that work together with similar office hours.
///

@JsonSerializable()
class Team extends Entity<Team> {
  /// the customer that this work group, work for.
  @ERCustomerConverter()
  ER<Customer> owner;

  /// name of the team
  String name;

  // really a timezone.
  @ERRegionConverter()
  ER<Region> region;

  // The time a team member gets after taking a call before we will call his phone again.
  Duration wrapTime = Duration(seconds: 15);

  MemberRotation rotation = MemberRotation.GROUP_RING;

  MusicOnHold musicOnHold = MusicOnHold.ELEVATOR;

  /// If set then all users are automatically counted as
  /// members of this queue.
  /// The default Primary team has this set on by default.
  bool includeAllUsers = true;

  @EROverrideHours()
  ER<OverrideHours> overrideHours;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> monday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> tuesday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> wednesday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> thursday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> friday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> saturday;

  @ERBusinessHoursForDayConverter()
  ER<BusinessHoursForDay> sunday;

  // Note if you regenerate the json
  // you need to remove members from the
  // toJson method as we cannot send a member
  // list to the server or the update/insert will fail
  // for team. Updates to the members list must be
  // done separately.
  @ERUserConverter()
  final List<ER<User>> _members = [];

  @ERCallForwardTargetConverter()
  ER<CallForwardTarget> callForward;

  // for json
  Team();

  /// Creates a team record with a guid.
  /// Use this when inserting a new record.
  Team.forInsert() : super.forInsert();

  // Team.withDefaults(this.owner, this.name) {
  //   _setDefaults();
  // }

  void setCustomer(Customer customer) {
    owner = ER(customer);
  }

  Future<String> get nextTransitionText async {
    var today = await getToday();
    var open = await isTimeInOfficeHours(today, LocalTime.now());

    var nextTransition = await getNextTransition();

    // If they are never open then will be no transition.
    if (nextTransition == null) {
      return '';
    }

    var transitionsToday = false;

    if (LocalDate.fromDateTime(nextTransition).isEqual(LocalDate.today())) {
      transitionsToday = true;
    }

    var transition = Format.formatNice(nextTransition);

    return "Office ${(open ? 'closes' : 'opens')} ${(transitionsToday ? 'at' : 'on')} $transition";
  }

  Future<DateTime> getNextTransition() async {
    var now = DateTime.now();
    var today = LocalDate.fromDateTime(now);
    var time = LocalTime.fromDateTime(now);

    var firstOpenDate = await getFirstOpenDate(today);

    if (firstOpenDate == null) {
      return null;
    }

    DateTime nextTransition;

    var firstHours = await getOfficeHoursForDate(firstOpenDate);

    if (firstOpenDate.isEqual(today) && time.isBefore(firstHours.closingTime)) {
      var todayHours = await getToday();

      if (time.isBefore(todayHours.openingTime)) {
        // opening time isn't here yet so must be the next transition.
        nextTransition = todayHours.openingTime.atDate(today);
      } else {
        // we must be between opening and closing, so closing is the next transition.
        nextTransition = todayHours.closingTime.atDate(today);
      }
    } else {
      BusinessHoursForDay nextOpenDay;

      if (firstOpenDate.isEqual(today)) {
        // we must be after closing time so scan ahead for next open day.
        firstOpenDate = await getFirstOpenDate(today.add(Duration(days: 1)));
      }
      nextOpenDay = await getOfficeHoursForDate(firstOpenDate);

      nextTransition = nextOpenDay.openingTime.atDate(firstOpenDate);
    }

    return nextTransition;
  }

  ///
  ///Returns the office Hours for today.
  ///
  ///@param officeHours
  /// @return
  ///
  Future<BusinessHoursForDay> getToday() {
    return getOfficeHoursForDate(LocalDate.today());
  }

  Future<DateTime> getNextOpeningTime(LocalDate asAtDate) async {
    DateTime nextOpenDateTime;

    var nextDay = asAtDate.add(Duration(days: 1));

    var nextOpen = await getFirstOpenDate(nextDay);

    if (nextOpen != null) {
      var hours = await getOfficeHoursForDate(nextOpen);
      nextOpenDateTime = DateTime(nextOpen.year, nextOpen.month, nextOpen.day,
          hours.openingTime.hour, hours.openingTime.minute);
    }

    return nextOpenDateTime;
  }

  // Find the first date the customer is open after  (and including) the fromDate
  // Returns null if they are never open.
  Future<LocalDate> getFirstOpenDate(LocalDate fromDate) async {
    // First check if they are ever open
    if (await isNeverOpen()) return null;

    var testDate = fromDate;
    var current = await getOfficeHoursForDate(testDate);

    while (!current.open) {
      testDate = testDate.add(Duration(days: 1));
      current = await getOfficeHoursForDate(testDate);
    }

    return testDate;
  }

  Future<bool> isNeverOpen() async {
    var neverOpen = true;
    for (var dayName in DayName.values) {
      var day = await getByWeekDay(DayOfWeek.fromDayName(dayName).weekday);
      if (day.open) {
        neverOpen = false;
        break;
      }
    }
    return neverOpen;
  }

  Future<String> getNextTransitionText(DateTime asAt) async {
    var callsAreFlowing = await areCallsFlowing(asAt);
    var nextTransition = await getNextTransition();

    var nextTransitionLabel = 'Office is has NO opening Hours!';
    if (nextTransition != null) {
      var time = Format.time(
          nextTransition); // , DateTimeFormatter.ofPattern("h:mma"));

      String day;

      if (nextTransition.difference(asAt).inDays != 0) {
        day = DayOfWeek.fromDateTime(nextTransition).dayName(abbreviate: true);
      }

      var transitionType = 'resume';
      if (callsAreFlowing) {
        transitionType = 'end';
      }

      if (day != null) {
        nextTransitionLabel = 'Office Hours $transitionType $day $time';
      } else {
        nextTransitionLabel = 'Office Hours $transitionType at $time';
      }
    }
    return nextTransitionLabel;
  }

  Future<bool> areCallsFlowing(DateTime asAt) async {
    await overrideHours.resolve;
    return await isOfficeHours(asAt) || overrideHours.entity.isOpenAt(asAt);
  }

  Future<bool> isOfficeHours(DateTime dateTime) async {
    var hours = await getOfficeHoursForDate(LocalDate.fromDateTime(dateTime));
    return isTimeInOfficeHours(hours, LocalTime.fromDateTime(dateTime));
  }

  Future<BusinessHoursForDay> getOfficeHoursForDate(LocalDate date) {
    var dayOfWeek = date.weekday;

    return getByWeekDay(dayOfWeek);
  }

  Future<bool> isTimeInOfficeHours(
      BusinessHoursForDay hours, LocalTime time) async {
    return (hours.open &&
        ((time.isAfter(hours.openingTime) || time.isEqual(hours.openingTime)) &&
            (time.isBefore(hours.closingTime) ||
                time.isEqual(hours.closingTime))));
  }

  /// [weekday] is a 1 based dayof the week Monday = 1, Sunday = 7
  Future<BusinessHoursForDay> getByWeekDay(int weekday,
      {Transaction transaction}) async {
    var er = getBusinessHoursByWeekDay(weekday);

    return await er.resolveWithinTransaction(transaction);
  }

  ///
  ///In accordance with ISO 8601
  ///a week starts with Monday, which has the value 1.
  ER<BusinessHoursForDay> getBusinessHoursByWeekDay(int weekday) {
    ER<BusinessHoursForDay> hoursForDay;

    switch (weekday) {
      case 1:
        hoursForDay = monday;
        break;
      case 2:
        hoursForDay = tuesday;
        break;
      case 3:
        hoursForDay = wednesday;
        break;
      case 4:
        hoursForDay = thursday;
        break;
      case 5:
        hoursForDay = friday;
        break;
      case 6:
        hoursForDay = saturday;
        break;
      case 7:
        hoursForDay = sunday;
        break;
      default:
        throw ArgumentError('Unexpected Day No. : $weekday');
    }
    return hoursForDay;
  }

  Future<bool> isCallForwardActive(DateTime asAt) async {
    await overrideHours.resolve;
    var isActive = false;
    // Start with check if the night switch is on.

    if (overrideHours.entity.isOpenAt(asAt)) {
      isActive = true;
    } else {
      var asAtDay = DayOfWeek.fromDateTime(asAt);
      var asAtTime = LocalTime.fromDateTime(asAt);

      switch (asAtDay.getEnum()) {
        case DayName.Friday:
          isActive = (await friday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Monday:
          isActive = (await monday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Saturday:
          isActive = (await saturday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Sunday:
          isActive = (await sunday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Thursday:
          isActive = (await thursday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Tuesday:
          isActive = (await tuesday.resolve).isOpenAt(asAtTime);
          break;
        case DayName.Wednesday:
          isActive = (await wednesday.resolve).isOpenAt(asAtTime);
          break;
      }
    }

    return isActive;
  }

  set members(Iterable<ER<User>> members) {
    _members.clear();
    if (members != null) {
      _members.addAll(members);
    }
  }

  bool hasMember(ER<User> user) {
    return _members.contains(user);
  }

  @ERUserConverter()
  List<ER<User>> get members => _members;

  bool hasMembers() {
    return _members.isNotEmpty;
  }

  // void _setDefaults() async {
  //   region = (await owner.resolve).region;
  //   LocalTime opening = LocalTime(hour: 9, minute: 0);
  //   LocalTime closing = LocalTime(hour: 17, minute: 0);
  //   monday =
  //       ER(BusinessHoursForDay.create(DayName.Monday, true, opening, closing));
  //   tuesday =
  //       ER(BusinessHoursForDay.create(DayName.Tuesday, true, opening, closing));
  //   wednesday = ER(
  //       BusinessHoursForDay.create(DayName.Wednesday, true, opening, closing));
  //   thursday = ER(
  //       BusinessHoursForDay.create(DayName.Thursday, true, opening, closing));
  //   friday =
  //       ER(BusinessHoursForDay.create(DayName.Friday, true, opening, closing));
  //   saturday = ER(
  //       BusinessHoursForDay.create(DayName.Saturday, false, opening, closing));
  //   sunday =
  //       ER(BusinessHoursForDay.create(DayName.Sunday, false, opening, closing));

  //   overrideHours = ER(OverrideHours.defaults(ER<Team>(this)));
  // }

  @override
  Future<bool> search(String filter) {
    return Future.value(name.contains(filter));
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
