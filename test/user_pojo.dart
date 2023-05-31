import 'package:dart_jwt/extensions.dart';

class UserPojo implements JsonSerializable {
  String name;
  int id;

  UserPojo(this.name, this.id);

  @override
  bool operator ==(Object other) =>
      other is UserPojo
          && other.id == id
          && other.name == name;

  @override
  int get hashCode => Object.hash(name, id);

  @override
  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'name': name,
        'id': id
      };
}