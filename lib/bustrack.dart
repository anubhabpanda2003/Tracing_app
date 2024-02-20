import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreentwState();
}

class _HomeScreentwState extends State<HomeScreen> {
  double latitude = 0.0000;
  double longitude = 0.0000;

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Current Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Latitude: $latitude"),
            Text("Longitude: $longitude"),
          ],
        ),
      ),
    );
  }

  getUserCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        normalConfirmationDialog(
          'Location Is Disabled. App wants to access your location',
          'Please Enable your location',
          'Enable Location',
        );
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        normalConfirmationDialog(
            'Permission Denied. Please go to settings and give access',
            'Location permission denied',
            'Open Settings');
        print('Location Permission Denied');
        return;
      }
    }
    location.onLocationChanged.listen(
      (LocationData currentLocation) async {
        print(
            "Location: ${currentLocation.latitude}, ${currentLocation.longitude}");
        setState(() {
          latitude = currentLocation.latitude!;
          longitude = currentLocation.longitude!;
        });
        sendLocationToServer(latitude, longitude);
      },
    );
  }

  sendLocationToServer(double latitude, double longitude) async {
    final String serverUrl =
        'https://b1e5-2401-4900-74eb-72cf-4150-b015-9ac4-3860.ngrok-free.app/save-location';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
      );

      if (response.statusCode == 200) {
        print('Location sent successfully.');
      } else {
        print('Failed to send location. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  normalConfirmationDialog(
      String confirmationText, String title, String buttonText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/codemelogo.png',
                height: 50.0,
                width: 100.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                confirmationText,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (buttonText == 'Open Settings') {
                    AppSettings.openAppSettings();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(buttonText),
              )
            ],
          ),
        );
      },
    );
  }
}
