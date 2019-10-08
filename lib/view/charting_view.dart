import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_agile_story_flutter_app/controller/charting_math.dart';
import 'package:my_agile_story_flutter_app/view/logged_in_page.dart';
import 'package:my_agile_story_flutter_app/controller/project.dart';

class BurnDownChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final chartTitle;

  BurnDownChart(this.seriesList, this.animate, this.chartTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              chartTitle,
              style: TextStyle(
                  fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
            Expanded(child: new charts.OrdinalComboChart(seriesList,
                animate: animate,
                defaultRenderer: new charts.BarRendererConfig(
                    groupingType: charts.BarGroupingType.stacked),
                customSeriesRenderers: [
                  new charts.LineRendererConfig(
                      customRendererId: 'customLine')
                ]),)
          ],
        ),
      ),
    );
  }
}

List<charts.Series<GraphData, String>> createBurnDownDataSet() {
  generateBurnChartData();
  List<GraphData> sprintData = [];
  List<GraphData> toDoData = [];
  List<GraphData> velocityData = [];

  if (burndown.length > 1){
    for (int i = 0; i < burndown.length; i++) {
      sprintData.add(new GraphData('S'+ (i+1).toString(), sprints[i].toDouble()));
    }

    for (int i = 0; i < burndown.length; i++) {
      toDoData.add(new GraphData('S'+ (i+1).toString(), todo[i].toDouble()));
    }

    for (int i = 0; i < burndown.length; i++) {
      velocityData.add(new GraphData('S'+ (i+1).toString(), burndown[i]));
    }
  }
  return [
    new charts.Series<GraphData, String>(
        id: 'Sprint',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: sprintData),
    new charts.Series<GraphData, String>(
        id: 'ToDo',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: toDoData),
    new charts.Series<GraphData, String>(
        id: 'Velocity',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GraphData sprint, _) => sprint.sprint,
        measureFn: (GraphData sprint, _) => sprint.points,
        data: velocityData)
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

class GraphData {
  final String sprint;
  final double points;
  GraphData(this.sprint, this.points);
}