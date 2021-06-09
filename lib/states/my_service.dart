import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungfindfriend/models/user_model.dart';
import 'package:ungfindfriend/utility/my_constant.dart';
import 'package:ungfindfriend/widgets/show_progress.dart';
import 'package:ungfindfriend/widgets/show_title.dart';

class MyService extends StatefulWidget {
  const MyService({Key? key}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  Map<MarkerId, Marker> markers = {};
  bool load = true;
  LatLng? latLng;

  List<Widget> widgets = [];
  int indexWidget = 0;
  List<UserModel> userModels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widgets.add(listFriend());
    // widgets.add(buildMap());
    readAllData();
  }

  Future<Null> readAllData() async {
    await Dio().get(MyConstant.apiReadAllUser).then((value) {
      print('### value ==>> $value');
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
          userModels.add(model);
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
      body: load ? ShowProgress() : listFriend(),
    );
  }

  Widget listFriend() => userModels.length == 0
      ? ShowProgress()
      : ListView.builder(
          itemCount: userModels.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => print('### You Click ${userModels[index].name}'),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowTitle(
                        title: userModels[index].name,
                        textStyle: MyConstant().h2Style()),
                    ShowTitle(
                        title: 'lat = ${userModels[index].lat}',
                        textStyle: MyConstant().h3Style()),
                    ShowTitle(
                        title: 'lng = ${userModels[index].lng}',
                        textStyle: MyConstant().h3Style()),
                  ],
                ),
              ),
            ),
          ),
        );

  GoogleMap buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLng!,
        zoom: 16,
      ),
      onMapCreated: (controller) {},
      markers: Set<Marker>.of(markers.values),
    );
  }
}
