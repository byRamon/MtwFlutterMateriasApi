import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/Materia.dart';
import '../api/ApiService.dart';

class Graficas extends StatefulWidget {
  Graficas({Key key}) : super(key: key);

  @override
  _GraficasState createState() => _GraficasState();
}

class _GraficasState extends State<Graficas> {
  List<charts.Series<Materia, String>> pieData;
  List<charts.Series<Materia, String>> serieData;
  List<charts.Series<Materia, int>> lineData;
  createSerie(List<Materia> list){
    pieData = [
      charts.Series<Materia, String>(
        id: 'Calificaciones',
        data: list,
        domainFn: (Materia materia, _) => materia.nombre,
        measureFn: (Materia materia, _) => materia.calificacion,
        labelAccessorFn: (Materia materia, _) =>'${materia.nombre}',
      )
    ];
    serieData = [
      charts.Series<Materia, String>(
        id: 'Calificaciones',
        data: list,
        domainFn: (Materia materia, _) => materia.nombre,
        measureFn: (Materia materia, _) => materia.calificacion,
        fillPatternFn: (_, __) => charts.FillPatternType.solid
      )
    ];
    lineData.add(
      charts.Series<Materia, int>(
        id: 'Calificaciones',
        data: list,
        domainFn: (Materia materia, _) => materia.calificacion.toInt(),
        measureFn: (Materia materia, _) => materia.calificacion,
        fillPatternFn: (_, __) => charts.FillPatternType.solid
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Text('Graficos'),
                backgroundColor: Color(0xff1976d2),
                bottom: TabBar(tabs: [
                  Tab(icon: Icon(FontAwesomeIcons.solidChartBar),),
                  Tab(icon: Icon(FontAwesomeIcons.chartPie),),
                  Tab(icon: Icon(FontAwesomeIcons.chartLine),
                  ),
                ]),
              ),
              body: FutureBuilder(
                future: ApiService.getMaterias(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    createSerie(snapshot.data);
                    return TabBarView(children: [
                      barChart(),
                      pieChart(),
                      lineChart(),
                    ]);
                  } else {
                    return Center(
                        child: CircularProgressIndicator(strokeWidth: 2));
                  }
                },
              ))),
    );
  }

  Widget pieChart() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Calificaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Expanded(
                child: charts.PieChart(
                  pieData,
                  animate: false,
                  //animationDuration: Duration(seconds: 5),
                  behaviors: [
                    new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding: EdgeInsets.only(right: 4, bottom: 4),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.green.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 11))
                  ],
                  defaultRenderer: charts.ArcRendererConfig(
                      arcLength: 100,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside,)
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget barChart() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Calificaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Expanded(
                child: charts.BarChart(
                  serieData,
                  animate: false,
                  //animationDuration: Duration(seconds: 5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget lineChart() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Calificaciones', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Expanded(
                child: charts.LineChart(
                  lineData,
                  animate: false,
                  //animationDuration: Duration(seconds: 5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
