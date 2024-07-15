import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/http_exception.dart';
import '../models/auth_token.dart';
import '../models/user.dart';

class AuthService {
  static const _authTokenKey = 'authToken';
  late final String? _apiKey;
  late final String? _databaseurl;
  String? _token;
  String? get token => _token;
  UserData? _newUser;

  AuthService() {
    _apiKey = dotenv.env['FIREBASE_API_KEY'];
    _databaseurl = dotenv.env['FIREBASE_RTDB_URL'];
  }

  String _buildAuthUrl(String method) {
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=$_apiKey';
  }

  Future<AuthToken> _authenticate(
      String email, String password, String method) async {
    try {
      final url = Uri.parse(_buildAuthUrl(method));
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseJson = json.decode(response.body);
      if (responseJson['error'] != null) {
        throw HttpException.firebase(responseJson['error']['message']);
      }

      final authToken = _fromJson(responseJson);
      _token = authToken.token;
      _saveAuthToken(authToken);

      final userData = await _getUserDataFromDatabase(responseJson['localId']);

      if (userData == null) {
        final newUser = UserData(
          userId: responseJson['localId'],
          email: email,
          role: 'User',
        );
        _newUser = newUser;

        await _saveUserDataToDatabase(newUser);
      } else {
        _newUser = userData;
      }
      return authToken;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<UserData?> _getUserDataFromDatabase(String userId) async {
    final url = Uri.parse('$_databaseurl/users/$userId.json?auth=$token');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final userDataJson = json.decode(response.body);
        return UserData.fromJson(userDataJson);
      } else {
        print('Lỗi khi lấy dữ liệu người dùng: ${response.statusCode}');

        return null;
      }
    } catch (error) {
      print('Lỗi khi thực hiện HTTP request: $error');
      return null;
    }
  }

  Future<void> _saveUserDataToDatabase(UserData userData) async {
    final url =
        Uri.parse('$_databaseurl/users/${userData.userId}.json?auth=$token');

    try {
      final response = await http.put(
        url,
        body: json.encode(userData.toJson()),
      );

      if (response.statusCode != 200) {
        throw HttpException('Failed to save user data to the database');
      }
    } catch (error) {
      print(error);
      throw HttpException('Failed to save user data to the database');
    }
  }

  String isauth() {
    if (_newUser != null) {
      return _newUser!.role;
    }
    return 'User';
  }

  Future<AuthToken> signup(String email, String password) {
    return _authenticate(email, password, 'signUp');
  }

  Future<AuthToken> login(String email, String password) {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> _saveAuthToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_authTokenKey, json.encode(authToken.toJson()));
  }

  AuthToken _fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['idToken'],
      userId: json['localId'],
      expiryDate: DateTime.now().add(
        Duration(
          seconds: int.parse(
            json['expiresIn'],
          ),
        ),
      ),
    );
  }

  Future<AuthToken?> loadSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_authTokenKey)) {
      return null;
    }

    final savedToken = prefs.getString(_authTokenKey);

    final authToken = AuthToken.fromJson(json.decode(savedToken!));
    if (!authToken.isValid) {
      return null;
    }
    return authToken;
  }

  Future<void> clearSavedAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_authTokenKey);
  }
}
