import 'dart:convert';
import 'dart:io';
import 'package:clinic/features/authentication/model/user_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageHelper {
  Future<String> get _getLocalPath async {
    final folder = await getApplicationDocumentsDirectory();
    return folder.path;
  }

  static Future<File> getLoggedInFile() async {
    LocalStorageHelper localStorageHelper = LocalStorageHelper();
    final String path = await localStorageHelper._getLocalPath;
    File loggedInJson = File('$path/logged_in.json');
    print(loggedInJson.readAsStringSync());
    loggedInJson.writeAsString(json.encode({'isLoggedIn': false}));
    bool isFileExist = await loggedInJson.exists();
    if (!isFileExist) {
      loggedInJson.writeAsString(json.encode({'isLoggedIn': false}));
      loggedInJson.create();
    }
    return loggedInJson;
  }

  static Future<File> getUserDataFile() async {
    LocalStorageHelper localStorageHelper = LocalStorageHelper();
    final String path = await localStorageHelper._getLocalPath;
    File userDataJson = File('$path/user_data.json');
    bool isFileExist = await userDataJson.exists();
    if (!isFileExist) {
      userDataJson.create();
    }
    return userDataJson;
  }

  static Future<bool> isLoggedIn(File dataFile) async {
    String contents = await dataFile.readAsString();
    var jsonResponse = jsonDecode(contents);
    return jsonResponse['isLoggedIn'];
  }

  static Future<UserModel> readUserData(File dataFile) async {
    String contents = await dataFile.readAsString();
    var jsonResponse = jsonDecode(contents);
    Gender gender;
    if (jsonResponse['gender'] == 'male') {
      gender = Gender.male;
    } else {
      gender = Gender.female;
    }
    UserModel userModel = UserModel()
      ..firstName = jsonResponse['firstName']
      ..lastName = jsonResponse['lastName']
      ..age = jsonResponse['age']
      ..gender = gender
      ..likedPosts = List<Key>.from(jsonResponse['likedPosts']);
    return userModel;
  }
}
