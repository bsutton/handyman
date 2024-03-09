import '../../entities/audio_file.dart';
import 'repository.dart';

class AudioFileRepository extends Repository<AudioFile> {
  AudioFileRepository() : super(Duration(minutes: 5));

  @override
  AudioFile fromJson(Map<String, dynamic> json) {
    return AudioFile.fromJson(json);
  }
}
