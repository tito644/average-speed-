// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, depend_on_referenced_packages, unnecessary_import, use_build_context_synchronously, avoid_print, unused_local_variable, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:average_speed/show_custom_snakbar.dart';
import 'package:average_speed/show_results_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';

class HomeScreen extends StatefulWidget {

  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool endTime = true;


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
              'Calculate average speed within 30 seconds',
              style: TextStyle(
                color: Colors.pink,
              ),
            ),
            SizedBox(height: 20),

            endTime
                ? InkWell(
              onTap: _determinePosition,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            )
                : Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "The average speed is being calculated within 30 seconds while you are walking from now on .....",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  CircularProgressIndicator(color: Colors.green),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomSnackBar('Location services are disabled.',context);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCustomSnackBar('Location permissions are denied',context);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showCustomSnackBar('Location permissions are permanently denied, we cannot request permissions.',
          context);
    }

    _savePosition();
    //to get position and save it in my app
  }

  Future<void> _savePosition() async {
    endTime = false;
    setState(() {});
    List<Map<String,double>> latlng = [];

    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
            "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          )
      );
    }
    else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        timeLimit: const Duration(seconds: 1),
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    }
    else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        timeLimit: const Duration(seconds: 1),
      );
    }

    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          print(position == null ? 'Unknown' :
          '${position.latitude.toString()},'
              ' ${position.longitude.toString()}');
          if(position != null){
            latlng.add({
              "lat": position.latitude,
              "lng": position.longitude
            });
          }
        });


    Timer(Duration(seconds: 30),(){
      endTime = true;
      setState(() {});
      print("end time ******************");
      print("end time ****************** ===${latlng.length}");
      Navigator.push(context,
          MaterialPageRoute(builder: (context)=>ShowResultsScreen(latlng: latlng)
          ));
    });
  }
}

