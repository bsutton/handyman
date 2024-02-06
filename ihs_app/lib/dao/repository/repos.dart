import '../../../util/is_type_of.dart';
import '../../../util/strings.dart';
import '../../entities/entity.dart';
import 'after_hours_respository.dart';
import 'audio_file_respository.dart';
import 'busines_hours_for_day_repository.dart';
import 'call_forward_target_repository.dart';
import 'caller_details_repository.dart';
import 'customer_repository.dart';
import 'did_allocation_repository.dart';
import 'did_forward_repository.dart';
import 'dnd_repository.dart';
import 'email_verification_repository.dart';
import 'invite_user_repository.dart';
import 'ivr_respository.dart';
import 'leave_repository.dart';
import 'mobile_registration_reminder_repository.dart';
import 'mobile_registration_repository.dart';
import 'njcontact_repository.dart';
import 'office_holidays_repository.dart';
import 'override_hours_repository.dart';
import 'region_repository.dart';
import 'repository.dart';
import 'repository_search.dart';
import 'team_repository.dart';
import 'tutorial_repository.dart';
import 'tutorial_was_viewed_repository.dart';
import 'unauthed_action_repository.dart';
import 'user_repository.dart';
import 'voicemail_box_repository.dart';
import 'voicemail_message_repository.dart';

class Repos {
  static Repos _self;

  AfterHoursRepository afterHours;
  AudioFileRepository audioFile;
  BusinessHoursForDayRepository businessHoursForDay;
  CallerDetailsRepository callerDetails;
  CallForwardTargetRepository callForwardTarget;
  DIDAllocationRepository didAllocation;
  DIDForwardRepository didForward;
  EmailVerificationRepository emailVerification;
  UnAuthedActionRepository unAuthedActions;
  InviteUserRepository inviteUser;
  IVRRepository ivr;
  MobileRegistrationRepository registration;
  MobileRegistrationReminderRepository reminder;
  TutorialRepository tutorial;
  TutorialWasViewedRepository tutorialWasViewed;
  RegionRepository region;
  TeamRepository team;
  CustomerRepository customer;
  LeaveRepository leave;
  DNDRepository dnd;
  OfficeHolidaysRepository officeHolidays;
  OverrideHoursRepository overrideHours;
  UserRepository user;
  VoicemailBoxRepository voicemailBox;
  VoicemailMessageRepository voicemailMessage;

  NjContactRepository njContact;

  factory Repos() {
    _self ??= Repos._internal();
    return _self;
  }

  Map<String, Repository> repos = <String, Repository>{};

  //Repository<T> register<T extends Entity<T>>(Repository<T> repository) {
  R register<R>(R repository) {
    var repoType = repository.runtimeType.toString(); // typeOfGeneric<T>();
    var type = Strings.left(repoType, repoType.length - 'Repository'.length);

    repos[type] = repository as Repository;

    return repository;
  }

  Repos._internal() {
    afterHours = register(AfterHoursRepository());
    audioFile = register(AudioFileRepository());

    businessHoursForDay = register(BusinessHoursForDayRepository());
    callerDetails = register(CallerDetailsRepository());
    callForwardTarget = register(CallForwardTargetRepository());
    customer = register(CustomerRepository());
    dnd = register(DNDRepository());
    didAllocation = register(DIDAllocationRepository());
    didForward = register(DIDForwardRepository());
    emailVerification = register(EmailVerificationRepository());
    unAuthedActions = register(UnAuthedActionRepository());
    inviteUser = register(InviteUserRepository());
    ivr = register(IVRRepository());
    leave = register(LeaveRepository());
    officeHolidays = register(OfficeHolidaysRepository());
    overrideHours = register(OverrideHoursRepository());
    region = register(RegionRepository());
    registration = register(MobileRegistrationRepository());
    reminder = MobileRegistrationReminderRepository();
    team = register(TeamRepository());
    tutorial = register(TutorialRepository());
    tutorialWasViewed = register(TutorialWasViewedRepository());
    user = register(UserRepository());
    voicemailMessage = register(VoicemailMessageRepository());
    voicemailBox = register(VoicemailBoxRepository());

    // This is the NjContactClient and it's special, it communicates
    // directly with njadmin and it
    // doesn't use Entities at all so
    // it won't be registered. It also doesn't get wrapped up in
    // transactions as it does things like long polling
    njContact = NjContactRepository();

    // register(tutorial);
  }

  Repository<T> of<T extends Entity<T>>() {
    return repos[typeOfGeneric<T>()] as Repository<T>;
  }

  RepositorySearch<T> searchOf<T extends Entity<T>>() {
    return repos[typeOfGeneric<T>()] as RepositorySearch<T>;
  }
}
