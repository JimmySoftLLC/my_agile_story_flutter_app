import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_agile_story_flutter_app/controller/charting_math.dart';

class BurnDownChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  BurnDownChart(this.seriesList, {this.animate});

  factory BurnDownChart.withData() {
    return new BurnDownChart(
      _createBurnDownDataSet(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.OrdinalComboChart(seriesList,
        animate: animate,
        // Configure the default renderer as a bar renderer.
        defaultRenderer: new charts.BarRendererConfig(
            groupingType: charts.BarGroupingType.stacked),
        // Custom renderer configuration for the line series. This will be used for
        // any series that does not define a rendererIdKey.
        customSeriesRenderers: [
          new charts.LineRendererConfig(
            // ID used to link series to this renderer.
              customRendererId: 'customLine')
        ]);
  }
}

/// Create series list with multiple series
List<charts.Series<GraphData, String>> _createBurnDownDataSet() {
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
    // Configure our custom line renderer for this series.
      ..setAttribute(charts.rendererIdKey, 'customLine'),
  ];
}

/// Sample ordinal data type.
class GraphData {
  final String sprint;
  final double points;
  GraphData(this.sprint, this.points);
}