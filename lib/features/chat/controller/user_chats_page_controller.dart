import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserChatsPageController extends GetxController {
  static UserChatsPageController get find => Get.find();
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  final UserDataController _userDataController = UserDataController.find;
  RxBool loading = true.obs;

  @override
  onReady() async {
    loading.value = true;
    await Future.delayed(
      const Duration(seconds: 1),
    );

    loading.value = false;
    super.onReady();
  }

  Future<String?> getChatterPic(String chatterId, UserType chatterType) async =>
      _userDataController.getUserPersonalImageURLById(chatterId, chatterType);
  Stream<QuerySnapshot> get chatsStream => _userDataController.chatsCollection
      .where('chatters_ids', arrayContains: currentUserId)
      .orderBy('last_message_time', descending: true)
      .snapshots();

  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
}
