import 'package:json_annotation/json_annotation.dart';
import '../types/er.dart';
import 'audio_file.dart';
import 'customer.dart';
import 'entity.dart';
import 'user.dart';

part 'voicemail_box.g.dart';

@JsonSerializable()
class VoicemailBox extends Entity<VoicemailBox> {
  @ERCustomerConverter()
  ER<Customer> customer;

  @ERUserConverter()
  ER<User> owner;

  /// globally unique mailbox no. used by Asterisk when routing calls
  int mailboxNo;

  // A name for the mailbox which is shown to the user if necessary.
  String label;

  @ERAudioFileConverter()
  ER<AudioFile> greeting;

  // required by json.
  VoicemailBox();

  VoicemailBox.create(Customer customer, User user, this.mailboxNo) {
    this.customer = ER(customer);
    owner = ER(user);
  }

  ER<Customer> getCustomer() {
    return customer;
  }

  ER<User> getOwner() {
    return owner;
  }

  int getMailboxNo() {
    return mailboxNo;
  }

  ER<AudioFile> getGreeting() {
    return greeting;
  }

  void setGreeting(AudioFile greeting) {
    this.greeting = ER(greeting);
  }

  void setCustomer(Customer customer) {
    this.customer = ER(customer);
  }

  void setOwner(User owner) {
    this.owner = ER(owner);
  }

  bool isOwner(ER<User> user) {
    return owner == user;
  }

  factory VoicemailBox.fromJson(Map<String, dynamic> json) =>
      _$VoicemailBoxFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VoicemailBoxToJson(this);
}
