import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungfindfriend/models/user_model.dart';
import 'package:ungfindfriend/utility/dialog.dart';
import 'package:ungfindfriend/utility/my_constant.dart';
import 'package:ungfindfriend/widgets/show_image.dart';
import 'package:ungfindfriend/widgets/show_title.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  final formKey = GlobalKey<FormState>();
  bool statusRedEye = true;
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              buildImage(),
              buildTitle(),
              buildUser(),
              buildPassword(),
              buildLogin(),
              buildCreateAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'Non Account ? ',
          textStyle: MyConstant().h3Style(),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, MyConstant.routeCrateAccount);
          },
          child: ShowTitle(
            title: 'Create Account',
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Row buildLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: 250,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: MyConstant.primary),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                checkAuthen();
              }
            },
            child: Text('Login'),
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
            obscureText: statusRedEye,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Password';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: Icon(Icons.remove_red_eye),
              ),
              border: OutlineInputBorder(),
              labelText: 'Password :',
              prefixIcon: Icon(Icons.lock),
            ),
          ),
        ),
      ],
    );
  }

  Row buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: MyConstant.appName,
          textStyle: MyConstant().h1Style(),
        ),
      ],
    );
  }

  Widget buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: ShowImage(
            image: MyConstant.image4,
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen() async {
    String user = userController.text;
    String password = passwordController.text;
    print('user = $user, password = $password');

    String api =
        'https://www.androidthai.in.th/bigc/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(api).then(
      (value) {
        print('value = $value');
        if (value.toString() == 'null') {
          print('User False');
          normalDialog(context, 'User False ?', 'No $user in my Database');
        } else {
          for (var item in json.decode(value.data)) {
            UserModel model = UserModel.fromMap(item);
            if (password == model.password) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyConstant.routeMyService, (route) => false);
            } else {
              normalDialog(context, 'Password False',
                  'Please Try Agains Password False');
            }
          }
        }
      },
    );
  }
}
