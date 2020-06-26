
import 'package:flutter/material.dart';
import '../api/ApiService.dart';

class AddNewMateriaPage extends StatefulWidget {
  AddNewMateriaPage({Key key}) : super(key: key);
  @override
  _AddNewMateriaPageState createState() => _AddNewMateriaPageState();
}

class _AddNewMateriaPageState extends State<AddNewMateriaPage> {
  final _nombreController = TextEditingController();
  final _profesorController = TextEditingController();
  final _cuatrimestreController = TextEditingController();
  final _horarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Materia'),),
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
              RaisedButton(
                child: Text('Guardar', style: TextStyle(color: Colors.white),),
                color: Colors.purple,
                onPressed: (){
                  final body = {
                    'nombre' : _nombreController.text,
                    'profesor' : _profesorController.text,
                    'cuatrimestre': _cuatrimestreController.text,
                    'horario': _horarioController.text
                  };
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
              )
            ],
          ),
        ),
      ),
    );
  }
}