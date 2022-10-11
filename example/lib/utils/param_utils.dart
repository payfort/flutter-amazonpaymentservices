import 'package:flutter/cupertino.dart';

class ParamUtils {
  ///
  static List<ParamModel> getParanm({bool isShowFraudExtraParam: false}) {
    List<ParamModel> params = List.empty(growable: true);
    params.add(ParamModel(key: "customer_type"));
    params.add(ParamModel(key: "customer_first_name"));
    params.add(ParamModel(key: "customer_middle_initial"));
    params.add(ParamModel(key: "customer_address1"));
    params.add(ParamModel(key: "customer_phone"));
    params.add(ParamModel(key: "ship_type"));
    params.add(ParamModel(key: "ship_first_name"));
    params.add(ParamModel(key: "ship_last_name"));
    params.add(ParamModel(key: "ship_method"));
    params.add(ParamModel(key: "device_fingerprint"));
    params.add(ParamModel(key: "cart_details"));
    params.add(ParamModel(key: "command"));
    params.add(ParamModel(key: "currency"));
    params.add(ParamModel(key: "amount"));
    params.add(ParamModel(key: "sdk_token"));
    params.add(ParamModel(key: "customer_email"));
    params.add(ParamModel(key: "merchant_reference"));
    params.add(ParamModel(key: "check_fraud"));
    params.add(ParamModel(key: "customer_ip"));
    params.add(ParamModel(key: "order_description"));
    params.add(ParamModel(key: "customer_name"));
    params.add(ParamModel(key: "language"));
    params.add(ParamModel(key: "token_name"));
    params.add(ParamModel(key: "payment_option"));
    params.add(ParamModel(key: "eci"));
    params.add(ParamModel(key: "return_url"));
    params.add(ParamModel(key: "card_number"));
    params.add(ParamModel(key: "expiry_date"));
    params.add(ParamModel(key: "remember_me"));
    params.add(ParamModel(key: "check_3ds"));
    params.add(ParamModel(key: "card_security_code"));
    params.add(ParamModel(key: "merchant_token"));
    params.add(ParamModel(key: "digital_wallet"));
    params.add(ParamModel(key: "phone_number"));
    params.add(ParamModel(key: "settlement_reference"));
    params.add(ParamModel(key: "dynamic_descriptor"));
    params.add(ParamModel(key: "merchant_extra"));
    params.add(ParamModel(key: "merchant_extra1"));
    params.add(ParamModel(key: "merchant_extra2"));
    params.add(ParamModel(key: "merchant_extra3"));
    params.add(ParamModel(key: "merchant_extra4"));
    params.add(ParamModel(key: "flex_value"));
    if (isShowFraudExtraParam) {
      params.add(ParamModel(key: "ship_address_state"));
      params.add(ParamModel(key: "customer_id"));
      params.add(ParamModel(key: "ship_zip_code"));
      params.add(ParamModel(key: "ship_country_code"));
      params.add(ParamModel(key: "customer_last_name"));
      params.add(ParamModel(key: "ship_phone"));
      params.add(ParamModel(key: "customer_address2"));
      params.add(ParamModel(key: "customer_apartment_no"));
      params.add(ParamModel(key: "customer_city"));
      params.add(ParamModel(key: "customer_state"));
      params.add(ParamModel(key: "customer_zip_code"));
      params.add(ParamModel(key: "customer_alt_phone"));
      params.add(ParamModel(key: "customer_date_birth"));
      params.add(ParamModel(key: "ship_middle_name"));
      params.add(ParamModel(key: "ship_alt_phone"));
      params.add(ParamModel(key: "ship_address1"));
      params.add(ParamModel(key: "ship_address2"));
      params.add(ParamModel(key: "ship_apartment_no"));
      params.add(ParamModel(key: "ship_address_city"));
      params.add(ParamModel(key: "ship_email"));
      params.add(ParamModel(key: "ship_comments"));
      params.add(ParamModel(key: "fraud_extra1"));
      params.add(ParamModel(key: "fraud_extra2"));
      params.add(ParamModel(key: "fraud_extra3"));
      params.add(ParamModel(key: "fraud_extra4"));
      params.add(ParamModel(key: "fraud_extra5"));
      params.add(ParamModel(key: "fraud_extra6"));
      params.add(ParamModel(key: "fraud_extra7"));
      params.add(ParamModel(key: "fraud_extra8"));
      params.add(ParamModel(key: "fraud_extra9"));
      params.add(ParamModel(key: "fraud_extra10"));
      params.add(ParamModel(key: "fraud_extra11"));
      params.add(ParamModel(key: "fraud_extra12"));
      params.add(ParamModel(key: "fraud_extra13"));
      params.add(ParamModel(key: "fraud_extra14"));
      params.add(ParamModel(key: "fraud_extra15"));
      params.add(ParamModel(key: "fraud_extra16"));
      params.add(ParamModel(key: "fraud_extra17"));
      params.add(ParamModel(key: "fraud_extra18"));
      params.add(ParamModel(key: "fraud_extra19"));
      params.add(ParamModel(key: "fraud_extra20"));
      params.add(ParamModel(key: "fraud_extra21"));
      params.add(ParamModel(key: "fraud_extra22"));
      params.add(ParamModel(key: "fraud_extra23"));
      params.add(ParamModel(key: "fraud_extra24"));
      params.add(ParamModel(key: "fraud_extra25"));
    }
    params.sort((a, b) {
      return a.key!.toLowerCase().compareTo(b.key!.toLowerCase());
    });
    return params;
  }
}

class ParamModel {
  TextEditingController? controller;
  String? key;

  ParamModel({this.key}) {
    controller = TextEditingController();
  }
}
