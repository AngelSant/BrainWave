import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_database/firebase_database.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final DatabaseReference usageRef = FirebaseDatabase.instance.ref().child('usage');
  List<charts.Series<UsageData, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    _fetchUsageData();
  }

  void _fetchUsageData() {
    usageRef.once().then((DatabaseEvent event) {
      final snapshotValue = event.snapshot.value;

      // Check if the snapshot value is a Map
      if (snapshotValue is Map) {
        final Map<String, dynamic> usageData = Map<String, dynamic>.from(snapshotValue);

        final List<UsageData> data = usageData.entries.map((entry) {
          final date = entry.key;
          final minutes = (entry.value as num).toDouble(); // Total minutes of usage
          final hours = (minutes / 60).floor().toDouble();
          final remainingMinutes = (minutes % 60).toInt();
          final displayText = '${hours.toStringAsFixed(0)}h ${remainingMinutes.toStringAsFixed(0)}m';

          return UsageData(date, minutes, displayText);
        }).toList();

        setState(() {
          seriesList = [
            charts.Series<UsageData, String>(
              id: 'Usage',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (UsageData usage, _) => usage.date,
              measureFn: (UsageData usage, _) => usage.totalMinutes,
              data: data,
              labelAccessorFn: (UsageData usage, _) => usage.displayText,
            )
          ];
        });
      } else {
        // Handle cases where snapshot value is not a Map
        setState(() {
          seriesList = [];
        });
      }
    }).catchError((error) {
      print('Error fetching usage data: $error');
      setState(() {
        seriesList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progreso'),
      ),
      body: Center(
        child: seriesList.isEmpty
            ? Text('No hay datos disponibles.')
            : charts.BarChart(
          seriesList,
          animate: true,
          vertical: false,
          barRendererDecorator: charts.BarLabelDecorator<String>(),
        ),
      ),
    );
  }
}

class UsageData {
  final String date;
  final double totalMinutes;
  final String displayText;

  UsageData(this.date, this.totalMinutes, this.displayText);
}
