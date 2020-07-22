import 'dart:convert';

class Materia{
  int id;
  String nombre;
  String profesor;
  String cuatrimestre;
  String horario;
  double calificacion;

  Materia({this.id, this.nombre, this.profesor, this.cuatrimestre, this.horario, this.calificacion});

  factory Materia.fromJson(Map<String, dynamic> map){
    return Materia(
      id: map['id'], nombre: map['nombre'], profesor: map['profesor'], cuatrimestre: map['cuatrimestre'], 
      horario: map['horario'], calificacion: map['calificacion']);
  }
  Map<String, dynamic> toJson(){
    return {'id':id, 'nombre':nombre,'profesor':profesor,'cuatrimestre':cuatrimestre,'horario':horario, 
      'calificacion':calificacion};
  }
  @override
  String toString(){
    return 'Materia{id:$id,nombre:$nombre,profesor:$profesor,cuatrimestre:$cuatrimestre,horario:$horario,calificacion:$calificacion}';
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