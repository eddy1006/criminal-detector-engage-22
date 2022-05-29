import 'dart:convert';

class User {
  String user;
  String age;
  String identification;
  String threat;
  List modelData;

  User({
    required this.user,
    required this.age,
    required this.identification,
    required this.threat,
    required this.modelData,
  });

  static User fromMap(Map<String, dynamic> user) {
    return new User(
      user: user['user'],
      age: user['age'],
      identification: user['identification'],
      threat: user['threat'],
      modelData: jsonDecode(user['model_data']),
    );
  }

  toMap() {
    return {
      'user': user,
      'age': age,
      'identification': identification,
      'threat': threat,
      'model_data': jsonEncode(modelData),
    };
  }
}
