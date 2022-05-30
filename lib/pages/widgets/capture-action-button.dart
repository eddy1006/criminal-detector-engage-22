import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/models/criminal.model.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import '../home.dart';
import 'app_text_field.dart';

class CaptureActionButton extends StatefulWidget {
  CaptureActionButton(
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _CaptureActionButtonState createState() => _CaptureActionButtonState();
}

class _CaptureActionButtonState extends State<CaptureActionButton> {
  final MLService _mlService = locator<MLService>();
  final CameraService _cameraService = locator<CameraService>();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _ageTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _identificationTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _threatTextEditingController =
      TextEditingController(text: '');

  Criminal? predictedUser;

  Future _signUp(context) async {
    DatabaseHelper _databaseHelper = DatabaseHelper.instance;
    List predictedData = _mlService.predictedData;
    String name = _userTextEditingController.text;
    String age = _ageTextEditingController.text;
    String identification = _identificationTextEditingController.text;
    String threat = _threatTextEditingController.text;
    Criminal userToSave = Criminal(
      name: name,
      age: age,
      identification: identification,
      threat: threat,
      modelData: predictedData,
    );
    await _databaseHelper.insert(userToSave);
    this._mlService.setPredictedData(null);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyHomePage(),
            settings: RouteSettings(arguments: true)));
  }

  Future<Criminal?> _predictUser() async {
    Criminal? userAndPass = await _mlService.predict();
    return userAndPass;
  }

  Future onTap() async {
    try {
      bool faceDetected = await widget.onPressed();
      if (faceDetected) {
        if (widget.isLogin) {
          var user = await _predictUser();
          if (user != null) {
            this.predictedUser = user;
          }
        }
        PersistentBottomSheetController bottomSheetController =
            Scaffold.of(context)
                .showBottomSheet((context) => signSheet(context));
        bottomSheetController.closed.whenComplete(() => widget.reload());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[200],
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Container(
                  child: Text(
                    'Welcome back, ' + predictedUser!.name + '.',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : widget.isLogin
                  ? Container(
                      child: Text(
                      "Person doesn't have a criminal record",
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          Container(
            child: Column(
              children: [
                !widget.isLogin
                    ? AppTextField(
                        controller: _userTextEditingController,
                        labelText: "Name",
                      )
                    : Container(),
                SizedBox(height: 10),
                widget.isLogin && predictedUser == null
                    ? Container()
                    : AppTextField(
                        controller: _ageTextEditingController,
                        labelText: "Age",
                        keyboardType: TextInputType.number,
                      ),
                SizedBox(height: 10),
                !widget.isLogin
                    ? AppTextField(
                        controller: _identificationTextEditingController,
                        labelText: "Identification marks",
                      )
                    : Container(),
                SizedBox(height: 10),
                !widget.isLogin
                    ? AppTextField(
                        labelText: "Describe threat level",
                        controller: _threatTextEditingController,
                      )
                    : Container(),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                !widget.isLogin
                    ? AppButton(
                        text: 'ADD',
                        onPressed: () async {
                          await _signUp(context);
                        },
                        icon: Icon(
                          Icons.person_add,
                          color: Colors.white,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
