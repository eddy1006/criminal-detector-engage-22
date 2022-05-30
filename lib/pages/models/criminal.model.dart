import 'dart:convert';

class Criminal {
  String name;
  String age;
  String identification;
  String threat;
  List modelData;

  Criminal({
    required this.name,
    required this.age,
    required this.identification,
    required this.threat,
    required this.modelData,
  });

  static Criminal fromMap(Map<String, dynamic> criminal) {
    return new Criminal(
      name: criminal['name'],
      age: criminal['age'],
      identification: criminal['identification'],
      threat: criminal['threat'],
      modelData: jsonDecode(criminal['model_data']),
    );
  }

  toMap() {
    return {
      'name': name,
      'age': age,
      'identification': identification,
      'threat': threat,
      'model_data': jsonEncode(modelData),
    };
  }
}
