import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class SalesData {
  String month;
  int TotalPenjualan; // Updated variable name

  SalesData(this.month, this.TotalPenjualan); // Updated variable name
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Histogram',
      home: SalesHistogram(),
    );
  }
}

class SalesHistogram extends StatefulWidget {
  @override
  _SalesHistogramState createState() => _SalesHistogramState();
}

class _SalesHistogramState extends State<SalesHistogram> {
  List<SalesData> salesData = [];

  Future<void> loadSalesData() async {
    try {
      final rawData =
          await rootBundle.loadString('assets/data/datapenjualan.csv');
      final List<List<dynamic>> data = const CsvToListConverter(
        fieldDelimiter: ';',
        eol: '\n',
      ).convert(rawData);

      for (var i = 1; i < data.length; i++) {
        setState(() {
          salesData.add(SalesData(data[i][0], int.parse(data[i][1])));
        });
      }
    } catch (e) {
      print("Error loading CSV: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Histogram'),
      ),
      body: Center(
        child: FutureBuilder(
          future: loadSalesData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total Penjualan per Bulan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: salesData.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Text(salesData[index].month),
                              SizedBox(width: 10),
                              Container(
                                height: 30,
                                width:
                                    salesData[index].TotalPenjualan.toDouble() /
                                        10000000,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 10),
                              Text(salesData[index].TotalPenjualan.toString()),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
