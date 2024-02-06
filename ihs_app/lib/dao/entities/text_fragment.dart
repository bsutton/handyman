import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import '../types/er.dart';
import 'entity.dart';

part 'text_fragment.g.dart';

@JsonSerializable()
class TextAttributes extends Entity<TextAttributes> {
  int header;
  bool bold;
  bool italic;
  bool underline;
  bool strike;
  String link;
  String font;
  String align;
  String script;

  TextAttributes({this.italic});

  @override
  Future<bool> search(String filter) {
    return null;
  }

  factory TextAttributes.fromJson(Map<String, dynamic> json) =>
      _$TextAttributesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextAttributesToJson(this);
}

@JsonSerializable()
class TextFragment extends Entity<TextFragment> {
  String insert;

  @ERTextAttributesConverter()
  ER<TextAttributes> attributes;

  TextFragment({@required this.insert, this.attributes})
      : assert(insert != null);

  factory TextFragment.fromJson(Map<String, dynamic> json) =>
      _$TextFragmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TextFragmentToJson(this);
}
