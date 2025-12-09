import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_amazonpaymentservices/environment_type.dart';
import 'package:flutter_amazonpaymentservices/flutter_amazonpaymentservices.dart';
import 'package:flutter_amazonpaymentservices_example/model/token_model.dart';
import 'package:flutter_amazonpaymentservices_example/ui/settings/settings_screen.dart';
import 'package:flutter_amazonpaymentservices_example/utils/custom_widget/custom_testfield.dart';
import 'package:flutter_amazonpaymentservices_example/utils/extensions.dart';
import 'package:flutter_amazonpaymentservices_example/utils/local_storage.dart';
import 'package:flutter_amazonpaymentservices_example/utils/param_utils.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'dart:io' show Platform;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  var _merchantReferenceController = TextEditingController();
  int? environmentValue = 0;
  int? commandValue = 0;
  List<ParamModel>? paramList = List.empty(growable: true);
  bool? isShowFraudExtraParam;

  @override
  void initState() {
    getLocalStorage();
    isShowFraudExtraParam = LocalStorage.read(Keys.isShowFraudExtraParam);
    paramList = ParamUtils.getParanm(
        isShowFraudExtraParam: isShowFraudExtraParam ?? false);
    fillDefaultSettingValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Center(
            child: InkWell(
              onTap: createToken,
              child: const Text("Token"),
            ),
          ),
        ),
        actions: actionAppBar(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTopWidgets(),
          buildCenterWidgets(),
          buildBottomWidget(),
        ],
      ),
    );
  }

  void fillDefaultSettingValues() {
    if (LocalStorage.read(Keys.merchantIdentifier) == null ||
        LocalStorage.read(Keys.merchantIdentifier).toString().isEmpty) {
      LocalStorage.write(Keys.merchantIdentifier, "");
    }
    if (LocalStorage.read(Keys.accessCode) == null ||
        LocalStorage.read(Keys.accessCode).toString().isEmpty) {
      LocalStorage.write(Keys.accessCode, "");
    }
    if (LocalStorage.read(Keys.sdkLanguage) == null ||
        LocalStorage.read(Keys.sdkLanguage).toString().isEmpty) {
      LocalStorage.write(Keys.sdkLanguage, "en");
    }
  }

  Column buildTopWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8),
          child: Text("Select Your Environment",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8),
          child: environmentSegment(),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8),
          child: Text(
            "Command",
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: commandSegment(),
        )
      ],
    );
  }

  Expanded buildBottomWidget() {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        normalPay();
                      },
                      child: const Text(
                        "Normal Pay",
                        style: TextStyle(fontSize: 12),
                      )),
                ),
                const Padding(padding: EdgeInsets.only(right: 8)),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        validateApi();
                      },
                      child: const Text("Validate Api",
                          style: TextStyle(fontSize: 12))),
                ),
                const Padding(padding: EdgeInsets.only(right: 8)),
                // Conditionally render Apple Pay button
                if (Platform.isIOS) ...[
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          applePay();
                        },
                        child: const Text("Apple Pay",
                            style: TextStyle(fontSize: 12))),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                ],
              ],
            ),
          ), //Your widget here,
        ),
      ),
    );
  }

  Widget buildCenterWidgets() {
    return Expanded(
      flex: 5,
      child: ListView.builder(
        itemCount: paramList!.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField.buildTextField(
                paramList![i].controller, paramList![i].key),
          );
        },
      ),
    );
  }

  List<Widget> actionAppBar() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Center(
          child: InkWell(
            onTap: () {
              Get.offAll(SettingsScreen());
              // Get.to(const SettingsScreen());
            },
            child: const Text("Settings"),
          ),
        ),
      ),
    ];
  }

  Future<void> normalPay() async {
    var result;
    var requestParam = {};
    paramList!.forEach((e) => e.controller!.text.isNotEmpty
        ? requestParam[e.key ?? ""] = e.controller!.text
        : "");

    try {
      result = await FlutterAmazonpaymentservices.normalPay(
          requestParam,
          environmentValue == 0
              ? EnvironmentType.sandbox
              : EnvironmentType.production,
          isShowResponsePage: LocalStorage.read(Keys.isShowResponsePage));
    } on PlatformException catch (e) {
      _showMyDialog(e.message ?? "", e.details.toString());
      return;
    }
    if (!mounted) return;
    _showMyDialog("success", result.toString());
    // setState(() {
    //
    //   _status = result.toString();
    // });
  }

  Future<void> validateApi() async {
    var result;

    Map<String, String> requestParam = {};
    paramList!.forEach((e) => e.controller!.text.isNotEmpty
        ? requestParam[e.key ?? ""] = e.controller!.text
        : "");

    try {
      result = await FlutterAmazonpaymentservices.validateApi(
        requestParam,
        environmentValue == 0
            ? EnvironmentType.sandbox
            : EnvironmentType.production,
      );
    } on PlatformException catch (e) {
      _showMyDialog(e.message ?? "", e.details.toString());
      return;
    }

    if (!mounted) return;
    _showMyDialog("success", result.toString());
    // setState(() {
    //   _status = result.toString();
    // });
  }

  void getLocalStorage() {
    setState(() {
      _merchantReferenceController.text =
          LocalStorage.read(Keys.merchantIdentifier) ?? "";
      // _merchantReferenceController.text = "test";
    });
  }

  environmentSegment() {
    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: CupertinoColors.white,
      thumbColor: CupertinoColors.systemGrey3,
      groupValue: environmentValue,
      children: {
        0: buildSegment("SandBox"),
        1: buildSegment("Production"),
      },
      onValueChanged: (value) {
        setState(() {
          environmentValue = value;
        });
      },
    );
  }

  Widget buildSegment(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, color: Colors.black),
    );
  }

  commandSegment() {
    paramList!.firstWhere((e) => e.key == "command").controller!.text =
        commandValue == 0 ? "AUTHORIZATION" : "PURCHASE";

    return CupertinoSlidingSegmentedControl<int>(
      backgroundColor: CupertinoColors.white,
      thumbColor: CupertinoColors.systemGrey3,
      padding: EdgeInsets.all(8),
      groupValue: commandValue,
      children: {
        0: buildSegment("AUTHORIZATION"),
        1: buildSegment("PURCHASE"),
      },
      onValueChanged: (value) {
        setState(() {
          commandValue = value;
          updateParamList('command', value == 0 ? "AUTHORIZATION" : "PURCHASE");
        });
      },
    );
  }

  void updateParamList(String key, String? value) {
    paramList!.firstWhere((e) => e.key == key).controller!.text = value ?? "";
  }

  void createToken() async {
    // if (response.statusCode >= 200) {
    //   TokenModel tokenModel = TokenModel.fromJson(jsonDecode(response.body));
    //   setState(() {
    //     updateParamList('sdk_token', tokenModel.sdkToken);
    //     updateParamList('merchant_reference', tokenModel.sdkToken);
    //   });
    // } else {
    //   throw Exception('Failed to create token.');
    // }
  }

  Future<bool?> gettext() async {}

  Future<void> _showMyDialog(String title, String body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> applePay() async {
    var result;
    var requestParam = {};
    paramList!.forEach((e) => e.controller!.text.isNotEmpty
        ? requestParam[e.key ?? ""] = e.controller!.text
        : "");

    final transactionDetails = Map<String, dynamic>.from(requestParam);

    // Remove 'country_code' from the transaction details, since its required only for Apple pay setup.
    transactionDetails.remove('country_code');

    var params = {
      "displayAmount": requestParam['amount'], // Ensure it's a string
      "merchantIdentifier": "merchant.com.",
      'countryCode': requestParam['country_code'],
      'currencyCode': requestParam['currency'],
      'supportedNetworks': ['amex', 'visa', 'mastercard'],
      'transactionDetails': transactionDetails
    };

    try {
      result = await FlutterAmazonpaymentservices.applePay(
          params,
          environmentValue == 0
              ? EnvironmentType.sandbox
              : EnvironmentType.production);
    } on PlatformException catch (e) {
      if (e.code == "APPLE_PAY_CANCELLED") {
        _showMyDialog("Apple Pay Cancelled: ", e.details.toString());
      } else if (e.code == "PAYMENT_FAILED") {
        _showMyDialog("Apple Pay Failed: ", e.message.toString());
      } else {
        _showMyDialog("Apple Pay-Failed: ", e.message.toString());
      }
      Clipboard.setData(ClipboardData(text: e.details.toString()));
      return;
    }
    if (!mounted) return;
    _showMyDialog("success", result.toString());
  }
}
