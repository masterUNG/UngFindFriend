import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungfindfriend/models/user_model.dart';
import 'package:ungfindfriend/utility/my_constant.dart';
import 'package:ungfindfriend/widgets/show_progress.dart';

class MyService extends StatefulWidget {
  const MyService({Key? key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  Map<MarkerId, Marker> markers = {};
  bool load = true;
  LatLng? latLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  Future<Null> readAllData() async {
    await Dio().get(MyConstant.apiReadAllUser).then((value) {
      for (var item in json.decode(value.data)) {
        UserModel model = UserModel.fromMap(item);

        if (load) {
          double lat = double.parse(model.lat);
          double lng = double.parse(model.lng);
          latLng = LatLng(lat, lng);
        }

        setState(() {
          load = false;
          createMarker(model);
        });
      }
    });
  }

  void createMarker(UserModel userModel) {
    MarkerId markerId = MarkerId(userModel.id);
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(userModel.lat),
        double.parse(userModel.lng),
      ),
    );
    markers[markerId] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primary,
        title: Text('Show Location Friend'),
      ),
      body: load
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLng!,
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: Set<Marker>.of(markers.values),
            ),
    );
  }
}
