// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, depend_on_referenced_packages, unnecessary_import, use_build_context_synchronously, avoid_print, unused_local_variable, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ShowResultsScreen extends StatefulWidget {
  final List<Map<String,double>> latlng;
  ShowResultsScreen({required this.latlng});
  @override
  State<ShowResultsScreen> createState() => _ShowResultsScreenState();
}
class _ShowResultsScreenState extends State<ShowResultsScreen> {
  double totalDistance = 0;
  double totalSecond = 30;
  double averageSpeed = 0;

  @override
  void initState() {
    _calAvrSpeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Average Speed"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'average speed within 30 seconds',
              style: TextStyle(
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total seconds: 30',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Distance: $totalDistance',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Average Speed: $averageSpeed',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _calAvrSpeed() async {
      for(int index = 0; index < widget.latlng.length - 1; index++){
          totalDistance = totalDistance + Geolocator.distanceBetween(
              widget.latlng[index]["lat"]!, widget.latlng[index + 1]["lat"]!,
              widget.latlng[index]["lng"]!, widget.latlng[index + 1]["lng"]!);
      }
      print("totalDistance ========>>> $totalDistance");

      averageSpeed = totalDistance/totalSecond;

      print("averageSpeed ========>>> $averageSpeed");
      setState(() {});
  }
}