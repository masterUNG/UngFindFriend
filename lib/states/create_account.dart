import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ungfindfriend/utility/my_constant.dart';
import 'package:ungfindfriend/widgets/show_progress.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
    });
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Row buildName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: 250,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Name in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name :',
              prefixIcon: Icon(Icons.face),
            ),
          ),
        ),
      ],
    );
  }

  Row buildUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: 250,
          child: TextFormField(
            controller: userController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill User';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User :',
              prefixIcon: Icon(Icons.person),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: 250,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Password';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password :',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildUpload(),
        ],
        backgroundColor: MyConstant.primary,
        title: Text('Create New Account'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            buildName(),
            buildUser(),
            buildPassword(),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: lat == null ? ShowProgress() : buildMap(),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildUpload() {
    return IconButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          String name = nameController.text;
          String user = userController.text;
          String password = passwordController.text;
          print('name= $name, user = $user, password = $password');
          processCreateAccount(name, user, password);
        }
      },
      icon: Icon(Icons.cloud_upload_outlined),
    );
  }

  Future<Null> processCreateAccount(
      String name, String user, String password) async {
    String api =
        'https://www.androidthai.in.th/bigc/insertUser.php?isAdd=true&name=$name&user=$user&password=$password&lat=$lat&lng=$lng';
    await Dio().get(api).then((value) => Navigator.pop(context));
  }

  Set<Marker> setMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('id'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
            title: 'You Here !!!', snippet: 'lat = $lat, lng = $lng'),
      ),
    ].toSet();
  }

  Widget buildMap() => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 16,
        ),
        onMapCreated: (controller) {},
        markers: setMarker(),
      );
}
