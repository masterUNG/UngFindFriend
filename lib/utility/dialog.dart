import 'package:flutter/material.dart';
import 'package:ungfindfriend/utility/my_constant.dart';
import 'package:ungfindfriend/widgets/show_image.dart';
import 'package:ungfindfriend/widgets/show_title.dart';

Future<Null> normalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        leading: ShowImage(image: MyConstant.image1),
        title: ShowTitle(
          title: title,
          textStyle: MyConstant().h1Style(),
        ),
        subtitle: ShowTitle(
          title: message,
          textStyle: MyConstant().h2Style(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
