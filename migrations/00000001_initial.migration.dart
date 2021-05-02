import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_User", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("username", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: true),
      SchemaColumn("password", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("salt", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final List<Map> users = [
      {
        'username': 'test',
        'password':
            'fc795bd8d94b0ec6d34f522450108979cd64593fbf21de5b9f172fbfa106468d', //1234
        'salt': 'QDTAy2iCMAU2xhlMYOkxIKoCJeebr9WsJO6HS9kfNBM='
      },
      {
        'username': 'test2',
        'password':
            '6432bde0a553233d3b8db306fab1665fff61e9e393123f67796584252e6073ee', //5678
        'salt': '1joxelLgz3icSGERnkYtOjqIlQcNT9gHC7C84jy1v0Q='
      }
    ];

    for (final user in users) {
      await database.store.execute(
          'INSERT INTO _User (username, password, salt) VALUES (@username, @password, @salt)',
          substitutionValues: {
            'username': user['username'],
            'password': user['password'],
            'salt': user['salt']
          });
    }
  }
}
