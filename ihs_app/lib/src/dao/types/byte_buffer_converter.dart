import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

class ByteBufferConverter implements JsonConverter<ByteBuffer, String> {
  const ByteBufferConverter();

  @override
  ByteBuffer fromJson(String json) {
    var ints = Base64Decoder().convert(json);
    return ints.buffer;
  }

  @override
  String toJson(ByteBuffer byteBuffer) {
    return Base64Encoder().convert(byteBuffer.asUint8List());
  }
}
