
import 'package:flutter/material.dart';
import '../model/Materia.dart';
import '../api/ApiService.dart';

//final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class AddNewMateriaPage extends StatefulWidget {
  final Materia materia; 
  //AddNewMateriaPage({Key key}) : super(key: key);
  AddNewMateriaPage({this.materia});
  @override
  _AddNewMateriaPageState createState() => _AddNewMateriaPageState();
}

class _AddNewMateriaPageState extends State<AddNewMateriaPage> {
  final _nombreController = TextEditingController();
  final _profesorController = TextEditingController();
  final _cuatrimestreController = TextEditingController();
  final _horarioController = TextEditingController();
  final _calificacionController = TextEditingController();
  String _titulo = 'Nueva Materia';

  @override
  void initState(){
    if(widget.materia != null){
      _nombreController.text = widget.materia.nombre;
      _profesorController.text = widget.materia.profesor;
      _cuatrimestreController.text = widget.materia.cuatrimestre;
      _horarioController.text = widget.materia.horario;
      _calificacionController.text = widget.materia.calificacion.toString();
      _titulo = 'Actualizar Materia';
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$_titulo'),),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(hintText: 'Nombre de la materia'),
              ),
              TextField(
                controller: _profesorController,
                decoration: InputDecoration(hintText: 'Nombre del profesor'),
              ),
              TextField(
                controller: _cuatrimestreController,
                decoration: InputDecoration(hintText: 'Cuatrimestre'),
              ),
              TextField(
                controller: _horarioController,
                decoration: InputDecoration(hintText: 'Horario'),
              ),
              TextField(
                controller: _calificacionController,
                decoration: InputDecoration(hintText: 'Calificacion'),
              ),
              RaisedButton(
                child: Text(widget.materia != null ? 'Actualizar' :'Guardar', style: TextStyle(color: Colors.white),),
                color: Colors.purple,
                onPressed: (){
                  final body = {
                    'nombre' : _nombreController.text,
                    'profesor' : _profesorController.text,
                    'cuatrimestre': _cuatrimestreController.text,
                    'horario': _horarioController.text,
                    'calificacion': _calificacionController.text,
                    'id': widget.materia == null ? '0' : widget.materia.id
                  };
                  if(widget.materia == null){
                      ApiService.addMateria(body).then((success){
                      if(success){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Materia agregada con exito!'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  _nombreController.text = '';
                                  _profesorController.text = '';
                                  _cuatrimestreController.text = '';
                                  _horarioController.text = '';
                                }, 
                                child: Text('OK'),
                              )
                            ],
                          ),
                        );
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error al añadir la materia'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: (){
                                  Navigator.pop(context);
                                }
                              )
                            ],
                          ),
                        );
                        return;
                      }
                    });
                  }
                  else {
                      ApiService.updateMateria(body).then((success){
                      if(success){
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Materia actualizada con exito!'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  _nombreController.text = '';
                                  _profesorController.text = '';
                                  _cuatrimestreController.text = '';
                                  _horarioController.text = '';
                                  _calificacionController.text = '';
                                }, 
                                child: Text('OK'),
                              )
                            ],
                          ),
                        ).then((value) => Navigator.pop(context));
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error al actualizar la materia'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: (){}
                              )
                            ],
                          ),
                        ).then((value) => Navigator.pop(context));
                        return;
                      }
                    });
                  }              
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}