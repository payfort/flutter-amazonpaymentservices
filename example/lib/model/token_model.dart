class TokenModel {
  String? sdkToken;

  TokenModel(
      {
      this.sdkToken});

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      sdkToken: json['sdk_token'],
    );
  }
}
