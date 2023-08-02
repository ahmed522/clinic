import 'dart:async';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationServices {
  static Future<Map<String, double?>> getCurrentLocation() async {
    Map<String, double?> latAndLong = {
      'lat': null,
      'long': null,
    };
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionIsGiven;
    LocationData locationData;
    permissionIsGiven = await location.hasPermission();
    if (permissionIsGiven == PermissionStatus.denied) {
      permissionIsGiven = await location.requestPermission();
      if (permissionIsGiven == PermissionStatus.denied) {
        return latAndLong;
      }
    }
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return latAndLong;
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        locationData = await location.getLocation();
        latAndLong['lat'] = locationData.latitude;
        latAndLong['long'] = locationData.longitude;
        return latAndLong;
      }
    }

    locationData = await location.getLocation();
    latAndLong['lat'] = locationData.latitude;
    latAndLong['long'] = locationData.longitude;
    return latAndLong;
  }

  static Future openMapsSheet(
      BuildContext context, double lat, double long) async {
    try {
      final coords = Coords(lat, long);

      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: coords,
                        title: 'موقع العيادة',
                      ),
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } on Exception {
      CommonFunctions.errorHappened();
    }
  }
}
