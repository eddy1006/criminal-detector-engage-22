import 'package:face_net_authentication/pages/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'app_button.dart';

class AdminSheet extends StatefulWidget {
  AdminSheet({Key? key}) : super(key: key);

  @override
  State<AdminSheet> createState() => _AdminSheetState();
}

class _AdminSheetState extends State<AdminSheet> {
  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  _validate(context) {
    if (_usernameController.text == "admin" &&
        _passwordController.text == "123") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(),
          settings: RouteSettings(arguments: true)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'Please enter your credentials',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                AppTextField(
                    labelText: "Enter Your username",
                    controller: _usernameController),
                SizedBox(height: 10),
                AppTextField(
                    labelText: "Enter Your Password",
                    controller: _passwordController),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                AppButton(
                  text: 'LOGIN',
                  onPressed: () {
                    _validate(context);
                  },
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
