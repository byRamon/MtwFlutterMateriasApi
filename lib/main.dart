import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'api/ApiService.dart';
import 'widgets/AddNewMateriaPage.dart';

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

  Future<dynamic> updateList() async {
    print('Materias');
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
    int items = materias.length;
    materias = await updateList();
    items = materias.length - items;
    for (int ind = 0; ind < items; ind++) {
      _myListKey.currentState.insertItem(items + ind);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materias'),
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
                  return SlideTransition(
                    position: animation.drive(myTween),
                    child: ListTile(
                      title: Text(materias[index]['nombre'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('profesor:\t' + materias[index]['profesor'] ??
                              ''),
                          Text('cuatrimestre:\t' +
                                  materias[index]['cuatrimestre'] ??
                              ''),
                          Text('horario:\t' + materias[index]['horario'] ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
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
