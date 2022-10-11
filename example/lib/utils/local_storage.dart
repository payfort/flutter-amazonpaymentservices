import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  static final GetStorage _box = GetStorage();

  static void write(Keys key, var value) {
    _box.write(describeEnum(key), value);
  }

  static dynamic read(Keys key) {
    return _box.read(describeEnum(key)) ;
  }
}

enum Keys { merchantIdentifier, accessCode, sdkLanguage, passphrase,isShowFraudExtraParam,isShowResponsePage }
