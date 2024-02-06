import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/phone_number.dart';

part 'did_range.g.dart';

@JsonSerializable()
class DIDRange {
  @PhoneNumberConverter()
  PhoneNumber startOfDIDRange;
  @PhoneNumberConverter()
  PhoneNumber endOfDIDRange;

  @LocalDateConverter()
  LocalDate dateAllocated = LocalDate.today();
  @LocalDateConverter()
  LocalDate dateReleased;

  // requried by json
  DIDRange();

  String get format {
    String formatted;
    if (isSingleNo()) {
      formatted = startOfDIDRange.toNational();
    } else {
      formatted =
          '${startOfDIDRange.toNational()} - ${endOfDIDRange.toNational()}';
    }
    return formatted;
  }

  ///
  /// returns true if the range only includes one phone number.
  bool isSingleNo() {
    return startOfDIDRange == endOfDIDRange;
  }

  bool isEntireRange(DIDRange rhs) {
    return startOfDIDRange.compareTo(rhs.startOfDIDRange) == 0 &&
        endOfDIDRange.compareTo(rhs.endOfDIDRange) == 0;
  }

  bool inRange(PhoneNumber phoneNumber) {
    return (phoneNumber >= (startOfDIDRange) &&
        phoneNumber.isLessThanOrEqual(endOfDIDRange));
  }

  bool isEmpty() {
    return startOfDIDRange.isEmpty() && endOfDIDRange.isEmpty();
  }

  int countRange() {
    var start = BigInt.parse(startOfDIDRange.phone);
    var end = BigInt.parse(endOfDIDRange.phone);

    var bigInterval = end - start;

    return bigInterval.toInt() + 1;
  }

  factory DIDRange.fromJson(Map<String, dynamic> json) =>
      _$DIDRangeFromJson(json);

  Map<String, dynamic> toJson() => _$DIDRangeToJson(this);
}
