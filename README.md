# Criminal Detector

Criminal Detector app helps you unmask criminals trying to hide their real identity from you. The app helps you figure out if the person you are interacting with is faking
about his identity or hiding about crucial details of their past from you.<br>

# How does it all work ?

The app is divided into two parts the admin side and the normal user side.<br><br>
<strong>General User</strong> :- The general user can directly use the "Continue to app" button and they will be redirected to the home page where they can use the 
"Scan" button to scan the face of that person who is suspecious to them. If the face of that person will be present in the db all the appropiate details will be displayed along with a report button which will act as an emergency number
otherwise "Person has no criminal history" will be shown.<br>
<p align="center"><img src = "WhatsApp Image 2022-05-30 at 10.00.19 AM.jpeg" height=350 /> &ensp;<img src="WhatsApp Image 2022-05-30 at 10.00.20 AM.jpeg" height=350 /> </p>
<strong>Admin</strong> :- The admin side can only be accessed by legal authoroties which will be incharge of adding criminal details into the database. Normal users can't access the admin panel as when you click on it, it asks you for admin username and password. In the admin side there are two options scan and add. Scan will serve the similar purpose it did in the general user side but with add the admin can scan for new faces which he wants to add in the db and fill in all the additional details along with the face data to insert it into the database.<br>
<p align='center'><img src = "WhatsApp Image 2022-05-30 at 10.38.06 AM.jpeg" height=350 /> &ensp;<img src = "WhatsApp Image 2022-05-30 at 10.38.07 AM.jpeg" height=350 /> &ensp;<img src = "WhatsApp Image 2022-05-30 at 10.38.07 AM (1).jpeg" height=350 /></p>
For demo purpose admin panel can be accessed using following credentials.<br>
<strong>username :</strong> admin<br>
  <strong>password :</strong> 123<br>
 
# Where it can be used ? 
The primary motive behind the app is to unmask any criminal who is trying to hide his identity from you OR is not giving you full information about his past. We can take examples of scenarios like renting a house to someone or hiring an employee for your new business. It is possible that the person is impersonating as someone else with fake documents in these given scenarios and there are high chances that one might also believe him. But with this app we can kind of run a background check on that person and if he was involved in any criminal affairs before and was also caught our app will have their details and once we scan their faces we will get all those details and so we can take appropiate measures quickly.

# Stack 
### Flutter
For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

https://flutter.dev/

### Tensorflow lite
TensorFlow Lite is an open source deep learning framework for on-device inference.

https://www.tensorflow.org/lite

#### Flutter + Tensrorflow lite = tflite_flutter package 
TensorFlow Lite plugin provides a dart API for accessing TensorFlow Lite interpreter and performing inference. It binds to TensorFlow Lite C API using dart:ffi.

https://pub.dev/packages/tflite_flutter/install

### sqflite

It is a flutter plugin to create a sql based database. We have used it to store all the data on user's device itself for demo purpose where ideally for an app like this cloud database should be used.

https://pub.dev/packages/sqflite

# Project Setup 
1- Clone the project:

```
git clone https://github.com/eddy1006/criminal-detector-engage-22.git
```
2- Open the folder:

```
cd criminal-detector-engage-22
```
3- Install dependencies:

```
flutter pub get
```
Run in iOS directory
```
pod install
```
4- Run on device (Check device connected or any virtual device running):

```
flutter run
```

To run on iOS you need to have a developer account.
See here https://stackoverflow.com/a/4952845

Download the apk :- https://drive.google.com/drive/folders/1UmV22mW7j_WoQR9KfniVItj7RHgcSoEN?usp=sharing

The Facial Recognition feature of the project is made following this Github repo and tutorial :-
https://github.com/MCarlomagno/FaceRecognitionAuth
https://medium.com/analytics-vidhya/face-recognition-authentication-using-flutter-and-tensorflow-lite-2659d941d56e
