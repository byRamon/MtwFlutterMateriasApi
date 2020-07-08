import 'dart:convert';

class Materia{
  int id;
  String nombre;
  String profesor;
  String cuatrimestre;
  String horario;

  Materia({this.id, this.nombre, this.profesor, this.cuatrimestre, this.horario});

  factory Materia.fromJson(Map<String, dynamic> map){
    return Materia(
      id: map['id'], nombre: map['nombre'], profesor: map['profesor'], cuatrimestre: map['cuatrimestre'], horario: map['horario']
    );
  }
  Map<String, dynamic> toJson(){
    return {'id':id, 'nombre':nombre, 'profesor':profesor, 'cuatrimestre':cuatrimestre, 'horario':horario};
  }
  @override
  String toString(){
    return 'Materia{id:$id,nombre:$nombre,profesor:$profesor,cuatrimestre:$cuatrimestre,horario:$horario}';
  }
}
List<Materia> materiasFromJson(String jsonData){
  final data = json.decode(jsonData);
  return List<Materia>.from(data.map((item)=> Materia.fromJson(item)));
}
String materiaToJson(Materia data){
  final jsonData = data.toJson();
  return json.encode(jsonData);
}