import 'package:mobile_number/mobile_number.dart' as mobile;
// import 'package:sms_advanced/sms_advanced.dart' hide SimCard;

Future<List<mobile.SimCard>> getSimCards() async {
  await _requestPermissions();

  final cards = await mobile.MobileNumber.getSimCards;

  return cards ?? [];

  // return SimCardsProvider().getSimCards();
}

Future<void> _requestPermissions() async {
  if (!(await mobile.MobileNumber.hasPhonePermission)) {
    await mobile.MobileNumber.requestPhonePermission;
  }

  // try {
  //   final _mobileNumber = (await mobile.MobileNumber.mobileNumber)!;
  //   print(_mobileNumber);
  //   print(await mobile.MobileNumber.getSimCards);
  // } on PlatformException catch (e) {
  //   print("Failed to get mobile number because of '${e.message}'");
  // }

  // final smsStatus = await Permission.phoneStatus.status;
  // if (smsStatus.isDenied) {
  //   final smsResult = await Permission.phoneStatus.request();
  //   if (smsResult.isDenied) {
  //     throw Exception(
  //  'Phone Status permission is required to get device ID');
  //   }
  // }
  // final phoneStatus = await Permission.phone.status;
  // if (phoneStatus.isDenied) {
  //   final phoneResult = await Permission.phone.request();
  //   if (phoneResult.isDenied) {
  //     throw Exception('Phone permission is required to get device ID');
  //   }
  // }
}
