class RegisterResponseModel {
  final String? token;
  final String? error;

  RegisterResponseModel({this.token,this.error,});

  factory RegisterResponseModel.fromJson(Map<String,dynamic> json) {
    return RegisterResponseModel(token: json['token'] ?? "", error: json['error'] ?? "" );
  }
}

class RegisterRequestModel {
  String? email;
  String? password;
  String? ad;
  String? soyad;

  RegisterRequestModel({
    this.email,
    this.password,
    this.ad,
    this.soyad,
  });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': this.email,
      'password': this.password,
      'ad': this.ad,
      'soyad': this.soyad,
    };
  }

}