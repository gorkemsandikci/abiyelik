import 'package:abiyelik/model/register_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterAPIService {
  Future<RegisterResponseModel?> Register(RegisterRequestModel requestModel) async{
    String url = "http://umaymusic.com/RegisterApi.php";

    final response = await http.post(Uri.parse(url),body: requestModel.toJson(),
    );
    if(response.statusCode == 200 || response.statusCode == 400){
      return RegisterResponseModel.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception('Failed Api Service');
    }
  }
}