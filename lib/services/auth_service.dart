import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String url = "https://192.168.18.6:3000/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

  Future<bool> login({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse('${url}login'),
      body: {"email": email, "password": password},
    );
    if (response.statusCode != 200) {
      String content = json.decode(response.body);
      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }
      throw HttpException(response.body);
    }
    return true;
  }

  Future<bool>register({required String email, required String password}) async {
    http.Response response = await client.post(
      Uri.parse('${url}register'),
      body: {"email": email, "password": password},
    );
    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);
    return true;
  }

  saveUserInfos(body) async {
    Map<String, dynamic> map = json.decode(body);

    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("accessToken", token);
    prefs.setString("email", email);
    prefs.setInt("id", id);

    String? tokenSalvo = prefs.getString("accessToken");
  }
}

class UserNotFindException implements Exception {}
