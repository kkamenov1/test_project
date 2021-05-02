import 'package:test_project/test_project.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int id;

  @Column(unique: true)
  String username;

  @Column()
  String password;
}
