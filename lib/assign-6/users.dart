import 'package:uuid/uuid.dart';

class Users {
  String id = Uuid().v1();
  late String name;
  late String email;
}
