class RequestParamModel {
  String? amount;
  String? merchantReference;
  String? sdkToken;
  String? currency;
  String? command;
  String? language;
  String? customerEmail;

  RequestParamModel.name(
      {this.amount,
      this.merchantReference,
      this.sdkToken,
      this.currency,
      this.command,
      this.language,
      this.customerEmail});

}
