// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_fragment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextAttributes _$TextAttributesFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const [
    'id',
    'guid',
    'header',
    'bold',
    'italic',
    'underline',
    'strike',
    'link',
    'font',
    'align',
    'script'
  ]);
  return TextAttributes(
    italic: json['italic'] as bool,
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid'])
    ..header = json['header'] as int
    ..bold = json['bold'] as bool
    ..underline = json['underline'] as bool
    ..strike = json['strike'] as bool
    ..link = json['link'] as String
    ..font = json['font'] as String
    ..align = json['align'] as String
    ..script = json['script'] as String;
}

Map<String, dynamic> _$TextAttributesToJson(TextAttributes instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'header': instance.header,
      'bold': instance.bold,
      'italic': instance.italic,
      'underline': instance.underline,
      'strike': instance.strike,
      'link': instance.link,
      'font': instance.font,
      'align': instance.align,
      'script': instance.script,
    };

TextFragment _$TextFragmentFromJson(Map<String, dynamic> json) {
  $checkKeys(json, allowedKeys: const ['id', 'guid', 'insert', 'attributes']);
  return TextFragment(
    insert: json['insert'] as String,
    attributes: const ERTextAttributesConverter().fromJson(json['attributes'] as String),
  )
    ..id = json['id'] as int
    ..guid = const GUIDConverter().fromJson(json['guid']);
}

Map<String, dynamic> _$TextFragmentToJson(TextFragment instance) => <String, dynamic>{
      'id': instance.id,
      'guid': const GUIDConverter().toJson(instance.guid),
      'insert': instance.insert,
      'attributes': const ERTextAttributesConverter().toJson(instance.attributes),
    };
