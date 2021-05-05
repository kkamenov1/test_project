import 'package:test_project/test_project.dart';

class Drawing extends ManagedObject<_Drawing> implements _Drawing {}

class _Drawing {
  @primaryKey
  int id;

  @Column()
  String points;
}
