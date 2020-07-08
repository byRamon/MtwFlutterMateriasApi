import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:materias_clienteapi/model/Materia.dart';

class URLs {
  static const String BASE_URL = 'https://materiaapi20200624114610.azurewebsites.net/api/Materias';
  static const Map<String,String> HEADER = const <String,String> {'content-type':'application/json',}; 
}

class ApiService{
  static Future<List<Materia>> getMaterias() async {
    final response = await http.get('${URLs.BASE_URL}');
    if(response.statusCode == 200)
      return materiasFromJson(response.body);
    return null;
  }

  static Future<bool> addMateria(body) async {
    final response = await http.post('${URLs.BASE_URL}', 
      headers: URLs.HEADER,
      body: jsonEncode(body),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
  static Future<bool> updateMateria(data) async{
    final response = await http.put('${URLs.BASE_URL}/${data['id']}',
      headers: URLs.HEADER,
      body: jsonEncode(data)
    );
    return response.statusCode == 200;
  }
  static Future<bool> deleteMateria(int id) async{
    final response = await http.delete('${URLs.BASE_URL}/$id', 
      headers: URLs.HEADER,
    );
    return response.statusCode == 200;
  }
}