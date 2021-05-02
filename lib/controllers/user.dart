import 'dart:convert';
import 'dart:math';
import 'package:test_project/test_project.dart';
import 'package:crypto/crypto.dart';
import '../models/user.dart';

class UserController extends ResourceController {
  @Operation.post()
  Future<Response> createNewUser(@Bind.body() User body) async {
    //Retrieve reg details from req.body
    final username = body.username;
    final password = body.password;

    //Generate random salt
    final rand = Random();
    final saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
    final salt = base64.encode(saltBytes);

    //Hash the password combining the salt
    final hashedPassword = hashPassword(password, salt);
    return Response.ok({"username": username, "password": hashedPassword});

    //Store the username, salt and hashed password in the db
  }

  String hashPassword(String password, String salt) {
    final key = utf8.encode(password);
    final bytes = utf8.encode(salt);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }
}
