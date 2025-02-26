import 'dart:convert';
import 'package:demo_urban/helpers/version_app.dart';
import 'package:demo_urban/shared/models/login_response.dart';
import 'package:demo_urban/shared/models/user_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UserDataStorage {
  static AndroidOptions _getAndroidOptions() =>
  const AndroidOptions(encryptedSharedPreferences: true);
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  Future<LoginResponse?> getUserData() async {
    final versionAppStorage = await UserDataStorage().getVersionApp();
    if (Version.versionApp != versionAppStorage) return null;
    final data = await storage.read(key: 'userData');
    if (data != null) {
      LoginResponse response = loginResponseFromJson(data);
      return response;
    }
    return null;
  }

  Future<DataUserModel?> getUserCredentials() async {
    final data = await storage.read(key: 'userCredentials');
    if (data != null) {
      DataUserModel response = dataUserModelFromJson(data);
      return response;
    }
    return null;
  }

  void setUserCredentials(DataUserModel userModel) async {
    final data = jsonEncode(userModel);
    await storage.write(key: 'userCredentials', value: data);
  }

  void setUserData(LoginResponse userData) async {
    setVersionApp(Version.versionApp);
    final data = jsonEncode(userData);
    await storage.write(key: 'userData', value: data);
  }

  removeUserData() async {
    await storage.delete(key: 'userData');
  }

  removeUserCredentials() async {
    await storage.delete(key: 'userCredentials');
  }

  void setDataLogin(LoginResponse dataLogin) async {
    setVersionApp(Version.versionApp);
    final data = jsonEncode(dataLogin);
    await storage.write(key: 'userData', value: data);
  }

  Future<DataUserModel> getUserCredentialsBiometric() async {
    DataUserModel response = DataUserModel();
    final data = await storage.read(key: 'credentialsBiometric');
    if (data != null) {
      response = dataUserModelFromJson(data);
      return response;
    }
    return response;
  }

  void setUserCredentialsBiometric(DataUserModel userModel) async {
    final data = jsonEncode(userModel);
    await storage.write(key: 'credentialsBiometric', value: data);
  }

  void setFingerprintButton(bool fingerprintButton) async {
    final data = jsonEncode(fingerprintButton);
    await storage.write(key: 'fingerprintButton', value: data);
  }

  Future<bool> getFingerprintButton() async {
    bool response;
    final data = await storage.read(key: 'fingerprintButton');
    if (data == 'true') {
      response = true;
    } else {
      response = false;
    }
    return response;
  }

  void setVersionApp(String versionApp) async {
    await storage.write(key: 'versionApp', value: versionApp);
  }

  Future<String?> getVersionApp() async {
    final versionApp = await storage.read(key: 'versionApp');
    return versionApp;
  }
}