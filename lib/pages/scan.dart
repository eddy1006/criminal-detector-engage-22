import 'dart:async';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/models/criminal.model.dart';
import 'package:face_net_authentication/pages/widgets/capture_button.dart';
import 'package:face_net_authentication/pages/widgets/camera_detection_preview.dart';
import 'package:face_net_authentication/pages/widgets/camera_header.dart';
import 'package:face_net_authentication/pages/widgets/criminal_details.dart';
import 'package:face_net_authentication/pages/widgets/single_picture.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  ScanState createState() => ScanState();
}

class ScanState extends State<Scan> {
  CameraService _cameraService =
      locator<CameraService>(); //initializing all the services
  FaceDetectorService _faceDetectorService = locator<FaceDetectorService>();
  MLService _mlService = locator<MLService>();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPictureTaken = false;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {    //disposing all the services when the widget tree is destroyed
    _cameraService.dispose();
    _mlService.dispose();
    _faceDetectorService.dispose();
    super.dispose();
  }

  Future _start() async {
    setState(() => _isInitializing = true);
    await _cameraService.initialize(); //starting the camera service
    setState(() => _isInitializing = false);
    _frameFaces(); //capturing faces from image stream
  }

  _frameFaces() async {
    bool processing = false;
    _cameraService.cameraController!
        .startImageStream((CameraImage image) async {
      if (processing) return; // prevents unnecessary overprocessing.
      processing = true;
      await _predictFacesFromImage(image: image);
      processing = false;
    });
  }

  Future<void> _predictFacesFromImage({@required CameraImage? image}) async {
    assert(image != null, 'Image is null');
    await _faceDetectorService.detectFacesFromImage(image!);
    if (_faceDetectorService.faceDetected) {
      _mlService.setCurrentPrediction(
          image, _faceDetectorService.faces[0]); //face detected
    }
    if (mounted) setState(() {});
  }

  Future<void> takePicture() async {
    if (_faceDetectorService.faceDetected) {
      //If face is detected we take picture otherwise show dialog that no face detected
      await _cameraService.takePicture();
      setState(() => _isPictureTaken = true);
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(content: Text('No face detected!')));
    }
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    if (mounted) setState(() => _isPictureTaken = false);
    _start();
  }

  Future<void> onTap() async {
    await takePicture();
    if (_faceDetectorService.faceDetected) {
      Criminal? criminal = await _mlService.predict();     //Getting the predicted user
      var bottomSheetController = scaffoldKey.currentState!
          .showBottomSheet((context) => bottomSheet(criminal: criminal));  //Passing it to the bottom Sheet function
      bottomSheetController.closed.whenComplete(_reload);
    }
  }

  Widget getBodyWidget() {
    if (_isInitializing) return Center(child: CircularProgressIndicator()); //if loading 
    if (_isPictureTaken)    //when user takes picture
      return SinglePicture(imagePath: _cameraService.imagePath!);
    return CameraDetectionPreview();   //rest other cases
  }

  @override
  Widget build(BuildContext context) {
    Widget header = CameraHeader("SCAN", onBackPressed: _onBackPressed); //camera preview 
    Widget body = getBodyWidget();
    Widget? fab;
    if (!_isPictureTaken) fab = CaptureButton(onTap: onTap);

    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [body, header],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }

  bottomSheet({@required Criminal? criminal}) => criminal == null    //displayed if face is not found
      ? Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Text(
            "Person doesn't have a criminal record",
            style: TextStyle(fontSize: 20),
          ),
        )
      : CriminalDetails(user: criminal);  //If criminal found then we display our widget
}
