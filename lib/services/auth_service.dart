import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kUser = 'auth_username';
  static const _kPass = 'auth_password';
  static const defaultCred = 'user';

  Future<void> ensureSeeded() async {
    final p = await SharedPreferences.getInstance();
    if (!p.containsKey(_kUser)) await p.setString(_kUser, defaultCred);
    if (!p.containsKey(_kPass)) await p.setString(_kPass, defaultCred);
  }

  Future<String> getUsername() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kUser) ?? defaultCred;
  }

  Future<bool> login(String username, String password) async {
    final p = await SharedPreferences.getInstance();
    final u = p.getString(_kUser) ?? defaultCred;
    final pw = p.getString(_kPass) ?? defaultCred;
    return username == u && password == pw;
  }

  Future<bool> changePassword(String current, String next) async {
    final p = await SharedPreferences.getInstance();
    final pw = p.getString(_kPass) ?? defaultCred;
    if (current != pw) return false;
    await p.setString(_kPass, next);
    return true;
  }
}
