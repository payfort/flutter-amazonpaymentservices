import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazonpaymentservices_example/ui/main/main_screen.dart';
import 'package:flutter_amazonpaymentservices_example/utils/local_storage.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController? _merchantController = TextEditingController();
  final TextEditingController? _accessCodeController = TextEditingController();
  final TextEditingController? _languageController = TextEditingController();
  final TextEditingController? _passPhraseController = TextEditingController();
   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _isShowFraudExtraParam = false;
  var isShowResponsePage = false;

  @override
  void initState() {
    _merchantController?.text = LocalStorage.read(Keys.merchantIdentifier).toString();
    _accessCodeController?.text = LocalStorage.read(Keys.accessCode).toString();
    _languageController?.text = LocalStorage.read(Keys.sdkLanguage).toString();
    _passPhraseController?.text = LocalStorage.read(Keys.passphrase).toString();

    _isShowFraudExtraParam =
        LocalStorage.read(Keys.isShowFraudExtraParam) ?? false;
    isShowResponsePage =
        LocalStorage.read(Keys.isShowResponsePage) ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Center(
              child: InkWell(
                onTap: save,
                child: const Text("Save"),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildTextField(
                      _merchantController!, "Merchant Identifier"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildTextField(_accessCodeController!, "Access Code"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildTextField(_languageController!, "Language"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildTextField(_passPhraseController!, "Pass phrase"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("is Show Fraud Extra Param"),
                      Spacer(),
                      Checkbox(
                        value: _isShowFraudExtraParam,
                        onChanged: (bool? value) {
                          setState(() {
                            _isShowFraudExtraParam = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("is Show Response Page for iOS"),
                      Spacer(),
                      Checkbox(
                        value: isShowResponsePage,
                        onChanged: (bool? value) {
                          setState(() {
                            isShowResponsePage = value!;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      validator: (value) =>
          value != null && value.isEmpty ? 'This Field is Required' : null,
    );
  }

  void save() {
    LocalStorage.write(Keys.isShowFraudExtraParam, _isShowFraudExtraParam);
    LocalStorage.write(Keys.isShowResponsePage, isShowResponsePage);

    LocalStorage.write(Keys.merchantIdentifier, _merchantController?.text ?? "");
    LocalStorage.write(Keys.accessCode, _accessCodeController?.text ?? "");
    LocalStorage.write(Keys.sdkLanguage, _languageController?.text ?? "");
    LocalStorage.write(Keys.passphrase, _passPhraseController?.text ?? "");

    Get.to(const MainScreen());
  }
}
