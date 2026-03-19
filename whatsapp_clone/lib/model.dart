// import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class Model {
//   int id;
//   String name;
//   Model({
//     required this.id,
//     required this.name,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//     };
//   }

//   factory Model.fromMap(Map<String, dynamic> map) {
//     return Model(
//       id: map['id'] as int,
//       name: map['name'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Model.fromJson(String source) => Model.fromMap(json.decode(source) as Map<String, dynamic>);
// }
