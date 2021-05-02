import 'dart:convert';
import 'dart:math';
import 'package:test_project/test_project.dart';
import 'package:crypto/crypto.dart';
import '../models/user.dart';

class UserController extends ResourceController {
  UserController(this.context);

  ManagedContext context;

  @Operation.post()
  Future<Response> registerUser(@Bind.body() User body) async {
    //Retrieve reg details from req.body
    final username = body.username;
    final password = body.password;

    //Generate random salt
    final rand = Random();
    final saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
    final salt = base64.encode(saltBytes);

    //Hash the password combining the salt
    final hashedPassword = hashPassword(password, salt);

    //Store the username, salt and hashed password in the db
    final userQuery = Query<User>(context)
      ..values.username = username
      ..values.password = hashedPassword
      ..values.salt = salt;

    await userQuery.insert();

    return Response.ok('SUCCESS');
  }

  @Operation.post()
  Future<Response> loginUser(@Bind.body() User body) async {
    //Retrieve reg details from req.body
    final username = body.username;
    final password = body.password;

    //Find the user in the DB
    final userQuery = Query<User>(context)
      ..where((user) => user.username).equalTo(username);

    final user = await userQuery.fetchOne();

    if (user != null) {
      final salt = user.salt;
      final hashedPassword = hashPassword(password, salt);

      if (hashedPassword == user.password) {
        // log the user in
      } else {
        return Response.unauthorized();
      }
    }

    return Response.notFound();
  }

  String hashPassword(String password, String salt) {
    final key = utf8.encode(password);
    final bytes = utf8.encode(salt);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }
}
