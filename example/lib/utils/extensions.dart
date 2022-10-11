import 'dart:convert';

import 'package:crypto/crypto.dart';

extension HashSha on String {
  String get toSha256 {
    var bytes = utf8.encode(this);
    return sha256.convert(bytes).toString();
  }
}
