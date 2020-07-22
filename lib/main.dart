import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'api/ApiService.dart';
import 'model/Materia.dart';
import 'widgets/AddNewMateriaPage.dart';
import 'widgets/Graficas.dart';

void main() {
  runApp(MaterialApp(title: 'Materias', home: MateriasPage()));
}

class MateriasPage extends StatefulWidget {
  MateriasPage({Key key}) : super(key: key);
  @override
  _MateriasPageState createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  final myTween = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero);
  dynamic _list;
  dynamic materias;
  bool isLoading = false;
  BuildContext context;

  Future<dynamic> updateList() async {
    return ApiService.getMaterias();
  }

  @override
  void initState() {
    super.initState();
    _list = updateList();
  }

  @override
  void didUpdateWidget(MateriasPage oldWidget) {
    _list = updateList();
    super.didUpdateWidget(oldWidget);
  }

  final _myListKey = GlobalKey<AnimatedListState>();

  Future<void> updateAnimatedList() async {
    int itemsOld = materias.length;
    materias = await updateList();
    for (int ind = itemsOld; ind < materias.length; ind++) {
      _myListKey.currentState.insertItem(ind);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Materias'),
            Spacer(),
            FlatButton(
              child: Icon(FontAwesomeIcons.solidChartBar, color: Colors.white,),
              onPressed: () async {
                await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Graficas()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
          future: _list,
          builder: (context, snapshot) {
            materias = snapshot.data;
            if (snapshot.connectionState == ConnectionState.done) {
              return AnimatedList(
                key: _myListKey,
                initialItemCount: materias.length,
                itemBuilder: (context, index, animation) {
                  Materia materia = materias[index];
                  return SlideTransition(
                    position: animation.drive(myTween),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(materia.nombre ?? ''),
                            Text('profesor:\t' + materia.profesor ?? ''),
                            Text('cuatrimestre:\t' + materia.cuatrimestre ?? ''),
                            Text('horario:\t' + materia.horario ?? ''),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton(
                                  child: Text('Eliminar', style: TextStyle(color: Colors.red),),
                                  onPressed: (){
                                    showDialog(context: context, 
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Precaucion'),
                                          content: Text('Estas seguro de eliminar la materia ${materia.nombre}?'),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('Si'), 
                                              onPressed: (){
                                                Navigator.pop(context);
                                                ApiService.deleteMateria(materia.id)
                                                  .then((value) async{
                                                    if(value){
                                                      //AnimatedList.of(context).removeItem(index, (context, animation) => null);
                                                      //setState((){
                                                        //updateAnimatedList();
                                                        //_myListKey.currentState.removeItem(index, (context, animation) => null);
                                                      //});
                                                      materias.removeAt(index);
                                                      _myListKey.currentState.removeItem(index, (context, animation) => null);
                                                      
                                                      Scaffold.of(this.context).showSnackBar(
                                                        SnackBar(content: Text('Elemento eliminado')));
                                                    }
                                                    else {
                                                      Scaffold.of(this.context).showSnackBar(
                                                        SnackBar(content: Text('Error al eliminar')));
                                                    }
                                                  });
                                              }, 
                                            ),
                                            FlatButton(onPressed: () => Navigator.pop(context), child: Text('No')),
                                          ],
                                        );
                                      }
                                    );
                                  }, 
                                ),
                                FlatButton(child: Text('Editar'), 
                                  onPressed: () async {
                                    await Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => AddNewMateriaPage(materia: materia,)));
                                    _myListKey.currentState.removeItem(index, (context, animation) => null);
                                    materias = await updateList();
                                    setState(() { isLoading = true; });
                                    //await updateAnimatedList();
                                    _myListKey.currentState.insertItem(index);
                                    setState(() { isLoading = false; });
                                  }
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            else {
              return Center(child: CircularProgressIndicator(strokeWidth: 2));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewMateriaPage()));
          await updateAnimatedList();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
