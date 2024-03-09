import 'package:json_annotation/json_annotation.dart';
import '../../util/local_date.dart';
import '../types/er.dart';
import 'entity.dart';
import 'tutorial.dart';
import 'user.dart';

part 'tutorial_was_viewed.g.dart';

@JsonSerializable()
class TutorialWasViewed extends Entity<TutorialWasViewed> {
  @ERUserConverter()
  ER<User> user;

  @ERTutorialConverter()
  ER<Tutorial> tutorial;

  @LocalDateConverter()
  LocalDate dateViewed;

  TutorialWasViewed({
    this.user,
    this.tutorial,
    this.dateViewed,
  }) {
    dateViewed ??= LocalDate.today();
  }

  factory TutorialWasViewed.fromJson(Map<String, dynamic> json) => _$TutorialWasViewedFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TutorialWasViewedToJson(this);
}
