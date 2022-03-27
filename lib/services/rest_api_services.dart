import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_movieapp_module/services/api_constant.dart';
import 'package:riverpod_movieapp_module/services/api_response.dart';

class RestApiServices{
  Future<APIresponse> fetchApiData({String? append,required String path,int? id,String? text}) async{
    final queryParameters = {
        'api_key': APIconstant.apiKey,
        'language': APIconstant.language,
        'append_to_response': append,
        'with_genres': id.toString(),
        'query': text
      };
    var response = await http.get(
      Uri.https(APIconstant.authority,path,queryParameters )
    );
    if(response.statusCode==200){
      APIresponse apiResponse = APIresponse(data:  jsonDecode(response.body),errorMsg: '');
     
      return apiResponse;
    }
    else {
      switch (response.statusCode) {
      case 400:
        return APIresponse(data: '', errorMsg: 'Bad request');
      case 404:
        return APIresponse(data: '', errorMsg: 'The requested resource was not found');
      case 500:
        return APIresponse(data: '', errorMsg: 'Internal server error');
      default:
        return APIresponse(data: '', errorMsg: 'Oops something went wrong');
    }
    }
  }
}