import '../../entities/entity_settings.dart';
import '../../entities/mobile_registration_reminder.dart';
import 'repository.dart';

class MobileRegistrationReminderRepository extends Repository<MobileRegistrationReminder>
    implements EntitySettings<MobileRegistrationReminder> {
  MobileRegistrationReminderRepository() : super(Duration(minutes: 5));

  @override
  MobileRegistrationReminder fromJson(Map<String, dynamic> json) => MobileRegistrationReminder.fromJson(json);
}
