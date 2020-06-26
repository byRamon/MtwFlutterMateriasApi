import 'dart:convert';
import 'package:http/http.dart' as http;

class URLs {
  static const String BASE_URL = '';
}

class ApiService{
  static Future<List<dynamic>> getMaterias() async {
    final response = await http.get('${URLs.BASE_URL}');
    if(response.statusCode == 200)
      return json.decode(response.body);
    return null;
  }

  static Future<bool> addMateria(body) async {
    final response = await http.post('${URLs.BASE_URL}', 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8', 
      },
      body: jsonEncode(body),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}