import '../entities/attachment.dart';
import 'repository.dart';

class AttachmentRepository extends Repository<Attachment> {
  AttachmentRepository() : super(const Duration(minutes: 5));

  @override
  Attachment fromJson(Map<String, dynamic> json) => Attachment.fromJson(json);
}
