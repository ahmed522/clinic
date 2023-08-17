import 'dart:async';

import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/chat/model/chat_model.dart';
import 'package:clinic/features/chat/model/chatter_model.dart';
import 'package:clinic/features/chat/model/message_model.dart';
import 'package:clinic/features/chat/model/message_state.dart';
import 'package:clinic/features/medical_record/model/medical_record_model.dart';
import 'package:clinic/global/constants/gender.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/age.dart';
import 'package:clinic/global/data/services/debouncer.dart';
import 'package:clinic/global/functions/common_functions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SingleChatPageController extends GetxController {
  static SingleChatPageController find(String tag) => Get.find(tag: tag);
  SingleChatPageController({
    required this.chatterId,
    required this.chatterType,
    required this.screenHeight,
    this.chatId,
  });
  String? chatId;
  double screenHeight;
  RxBool loading = true.obs;
  RxBool messageLoading = true.obs;
  RxBool chatCreatedListener = false.obs;
  RxBool showGoToBottomButton = false.obs;
  bool deleteMessageLoading = false;
  Rx<ChatModel>? chat;
  final String chatterId;
  final UserType chatterType;
  final AuthenticationController _authenticationController =
      AuthenticationController.find;
  MedicalRecordModel? medicalRecord;
  Age? medicalRecordUserAge;
  Gender? medicalRecordUserGender;
  String? medicalRecordUserName;
  String? medicalRecordUserPic;
  List<String> selectedDiseases = [];
  List<String> selectedSurgeries = [];
  List<String> selectedMedicines = [];
  bool includeMedicalRecordMoreInfo = false;
  final debouncer = Debouncer(milliseconds: 1000);
  final UserDataController _userDataController = UserDataController.find;
  final ScrollController scrollController =
      ScrollController(keepScrollOffset: false);
  TextEditingController textController = TextEditingController();
  @override
  void onReady() async {
    updateLoading(true);
    if (chatId == null) {
      await _getChat();
    } else {
      chatCreatedListener.value = true;
      chat = ChatModel(
        chatter1: ChatterModel(
          id: currentUserId,
          name: currentUserName,
          picURL: currentUserPersonalImage,
          userType: currentUserType,
        ),
        chatter2: ChatterModel(
          id: chatterId,
          name:
              await _userDataController.getUserNameById(chatterId, chatterType),
          picURL: await _userDataController.getUserPersonalImageURLById(
              chatterId, chatterType),
          userType: chatterType,
        ),
        lastMessage: MessageModel(
          senderId: currentUserId,
          recieverId: chatterId,
          content: '',
          messageId: '',
          messageTime: Timestamp.now(),
        ),
      ).obs;
      chat!.bindStream(chatStream);
    }
    updateLoading(false);
    messageLoading.value = true;
    await Future.delayed(
      const Duration(seconds: 1),
    );
    messageLoading.value = false;
    scrollController.addListener(() {
      if (scrollController.position.pixels -
              scrollController.position.minScrollExtent >
          2 * screenHeight) {
        showGoToBottomButton.value = true;
      } else {
        showGoToBottomButton.value = false;
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Stream<QuerySnapshot> get chatMessagesStream {
    if (chat!.value.chatter1.deletedBefore) {
      return _userDataController
          .getChatMessagesCollectionById(chatId!)
          .where('message_time',
              isGreaterThan: chat!.value.chatter1.lastDeletionTime)
          .orderBy('message_time', descending: true)
          .snapshots();
    } else {
      return _userDataController
          .getChatMessagesCollectionById(chatId!)
          .orderBy('message_time', descending: true)
          .snapshots();
    }
  }

  Stream<ChatModel> get chatStream => _userDataController
          .getChatDocumentById(chatId!)
          .snapshots()
          .map<ChatModel>((snapshot) {
        return ChatModel.fromSnapshot(snapshot);
      });
  Stream<bool> chatCreated(String chatter1Id, String chatter2Id) =>
      _userDataController.chatsCollection
          .where(FieldPath.documentId, whereIn: [
            '$chatter1Id - $chatter2Id',
            '$chatter2Id - $chatter1Id',
          ])
          .limit(1)
          .snapshots()
          .map<bool>((snapshot) {
            if (snapshot.docs.isNotEmpty) {
              chatId = snapshot.docs.first.id;
            }
            return snapshot.docs.isNotEmpty;
          });
  updateMessageState(String messageId, MessageState state) =>
      _userDataController.updateMessageStateById(chatId!, messageId, state);
  updateChatLastMessageState(MessageState state) =>
      _userDataController.updateLastMessageState(chatId!, state);

  blockChatter() async {
    await _userDataController.getChatDocumentById(chatId!).update(
      {
        '$currentUserId.blocks': true,
        '$currentUserId.blocks_time': Timestamp.now(),
        '$chatterId.is_blocked': true,
      },
    );
  }

  unBlockChatter() async {
    await _userDataController.getChatDocumentById(chatId!).update(
      {
        '$currentUserId.blocks': false,
        '$chatterId.is_blocked': false,
      },
    );
  }

  deleteChat() async {
    Map<String, dynamic> updatedData = {
      '$currentUserId.delete_chat': true,
      '$currentUserId.last_deletion_time': Timestamp.now(),
    };
    updatedData.addIf(
      !chat!.value.chatter1.deletedBefore,
      '$currentUserId.deleted_before',
      true,
    );
    await _userDataController.getChatDocumentById(chatId!).update(updatedData);
    if (chat!.value.chatter2.deletedBefore) {
      await _userDataController.deleteOldMessages(
          chatId!, chat!.value.chatter2.lastDeletionTime!);
    }
  }

  _getChat() async {
    ChatModel? tempChat =
        await _userDataController.getSingleChat(currentUserId, chatterId);
    if (tempChat == null) {
      chat = ChatModel(
        chatter1: ChatterModel(
          id: currentUserId,
          name: currentUserName,
          picURL: currentUserPersonalImage,
          userType: currentUserType,
        ),
        chatter2: ChatterModel(
          id: chatterId,
          name:
              await _userDataController.getUserNameById(chatterId, chatterType),
          picURL: await _userDataController.getUserPersonalImageURLById(
              chatterId, chatterType),
          userType: chatterType,
        ),
        lastMessage: MessageModel(
          senderId: currentUserId,
          recieverId: chatterId,
          content: '',
          messageId: '',
          messageTime: Timestamp.now(),
        ),
      ).obs;
      chatId = chat!.value.chatId;
      chatCreatedListener.bindStream(chatCreated(currentUserId, chatterId));
      ever(chatCreatedListener, _onChatCreated);
    } else {
      chatCreatedListener.value = true;

      chat = tempChat.obs;
      chatId = tempChat.chatId;
      chat!.bindStream(chatStream);
    }
  }

  _onChatCreated(bool created) async {
    if (created) {
      chat!.bindStream(chatStream);
      chatCreatedListener.close();
      chatCreatedListener = true.obs;
    }
  }

  updateSeenedMessage(MessageModel message) {
    if (!message.sendedMessage &&
        message.messageState != MessageState.seen &&
        message.messageState != MessageState.deleted) {
      updateMessageState(message.messageId, MessageState.seen);
      updateChatLastMessageState(MessageState.seen);
    }
  }

  updateLoading(bool value) {
    loading.value = value;
  }

  updateIsTypingValue(bool value) =>
      _userDataController.setIsUserTyping(chatId!, currentUserId, value);

  void scrollToBottom(int milliseconds) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: milliseconds),
        curve: Curves.easeInOut,
      );
    }
  }

  updateDeleteMessageLoading(bool value) {
    deleteMessageLoading = value;
    update();
  }

  deleteMessage(MessageModel message) async {
    updateDeleteMessageLoading(true);
    message = await _userDataController.deleteMessageById(chatId!, message);
    updateDeleteMessageLoading(false);
    if (chat!.value.lastMessage.messageId == message.messageId) {
      await _userDataController.updateChatLastMessage(message, chatId!);
    }
  }

  getUserMedicalRecord() async {
    updateDeleteMessageLoading(true);
    medicalRecord = await userMedicalRecord;
    updateDeleteMessageLoading(false);
  }

  selectDisease(String diseaseId) {
    if (selectedDiseases.contains(diseaseId)) {
      selectedDiseases.remove(diseaseId);
    } else {
      selectedDiseases.add(diseaseId);
    }
    update();
  }

  selectAllDiseases() {
    if (selectedDiseases.isEmpty) {
      for (var disease in medicalRecord!.diseases) {
        selectedDiseases.add(disease.diseaseId);
      }
    } else {
      selectedDiseases.clear();
    }
    update();
  }

  selectSurgery(String surgeryId) {
    if (selectedSurgeries.contains(surgeryId)) {
      selectedSurgeries.remove(surgeryId);
    } else {
      selectedSurgeries.add(surgeryId);
    }
    update();
  }

  selectAllSurgeries() {
    if (selectedSurgeries.isEmpty) {
      for (var surgery in medicalRecord!.surgeries) {
        selectedSurgeries.add(surgery.surgeryId);
      }
    } else {
      selectedSurgeries.clear();
    }
    update();
  }

  selectMedicine(String medicineId) {
    if (selectedMedicines.contains(medicineId)) {
      selectedMedicines.remove(medicineId);
    } else {
      selectedMedicines.add(medicineId);
    }
    update();
  }

  selectAllMedicines() {
    if (selectedMedicines.isEmpty) {
      for (var medicine in medicalRecord!.medicines) {
        selectedMedicines.add(medicine.medicineId);
      }
    } else {
      selectedMedicines.clear();
    }
    update();
  }

  updateIncludeMedicalRecordMoreInfo() {
    includeMedicalRecordMoreInfo = !includeMedicalRecordMoreInfo;
    update();
  }

  sendMedicalRecordMessage() async {
    updateDeleteMessageLoading(true);
    MessageModel message = MessageModel(
      messageId: const Uuid().v4(),
      senderId: currentUserId,
      recieverId: chatterId,
      content: 'سجل مرضي',
      messageTime: Timestamp.now(),
      medicalRecord: medicalRecord,
      isMedicalRecordMessage: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(400);
    });
    if (chatCreatedListener.isFalse) {
      chat!.value.lastMessage = message;
      await _userDataController.createChat(chat!.value);
    }
    await _userDataController.uploadMessage(message, chatId!);
    DocumentReference medicalRecordDocument = _userDataController
        .getMedicalRecordMessageDocument(chatId!, message.messageId);
    await medicalRecordDocument.set({
      'age': currntUserAge.toJson(),
      'gender': currentUserGender.name,
    });
    if (selectedDiseases.isNotEmpty) {
      await _uploadList('diseases', message.messageId);
    }
    if (selectedSurgeries.isNotEmpty) {
      await _uploadList('surgeries', message.messageId);
    }
    if (selectedMedicines.isNotEmpty) {
      await _uploadList('medicines', message.messageId);
    }
    if (includeMedicalRecordMoreInfo) {
      await medicalRecordDocument.update({'info': medicalRecord!.moreInfo});
    }
    if (chat!.value.chatter2.deleteChat || chat!.value.chatter1.deleteChat) {
      Map<String, dynamic> updatedData = {};
      updatedData.addIf(
        chat!.value.chatter1.deleteChat,
        '$currentUserId.delete_chat',
        false,
      );
      updatedData.addIf(
        chat!.value.chatter2.deleteChat,
        '$chatterId.delete_chat',
        false,
      );
      await _userDataController
          .getChatDocumentById(chatId!)
          .update(updatedData);
    }
    selectedDiseases.clear();
    selectedSurgeries.clear();
    selectedMedicines.clear();
    includeMedicalRecordMoreInfo = false;
    medicalRecord = null;
    updateDeleteMessageLoading(false);
  }

  onOpenMedicalRecordButtonPressed(String messageId, bool sendedMessage) async {
    messageLoading.value = true;
    medicalRecord =
        await _userDataController.getMedicalRecordMessage(chatId!, messageId);
    if (sendedMessage) {
      medicalRecordUserAge = currntUserAge;
      medicalRecordUserGender = currentUserGender;
      medicalRecordUserName = currentUserName;
      medicalRecordUserPic = currentUserPersonalImage;
    } else {
      DocumentSnapshot snapshot = await _userDataController
          .getMedicalRecordMessageDocument(chatId!, messageId)
          .get();
      medicalRecordUserAge = Age.fromJson(snapshot.get('age'));
      medicalRecordUserGender =
          snapshot.get('gender') == 'male' ? Gender.male : Gender.female;
      medicalRecordUserName = chat!.value.chatter2.name;
      medicalRecordUserPic = chat!.value.chatter2.picURL;
    }
    messageLoading.value = false;
  }

  Future<void> _uploadList(String collectionId, String messageId) async {
    DocumentReference medicalRecordDocument =
        _userDataController.getMedicalRecordMessageDocument(chatId!, messageId);
    switch (collectionId) {
      case 'diseases':
        for (var disease in medicalRecord!.diseases) {
          if (selectedDiseases.contains(disease.diseaseId)) {
            await medicalRecordDocument
                .collection(collectionId)
                .doc(disease.diseaseId)
                .set(disease.toJson());
          }
        }
        return;
      case 'surgeries':
        for (var surgery in medicalRecord!.surgeries) {
          if (selectedSurgeries.contains(surgery.surgeryId)) {
            await medicalRecordDocument
                .collection(collectionId)
                .doc(surgery.surgeryId)
                .set(surgery.toJson());
          }
        }
        return;
      case 'medicines':
        for (var medicine in medicalRecord!.medicines) {
          if (selectedMedicines.contains(medicine.medicineId)) {
            await medicalRecordDocument
                .collection(collectionId)
                .doc(medicine.medicineId)
                .set(medicine.toJson());
          }
        }
        return;
    }
  }

  onSendButtonPressed() async {
    if (textController.text.trim() != '') {
      MessageModel message = MessageModel(
        messageId: const Uuid().v4(),
        senderId: currentUserId,
        recieverId: chatterId,
        content: textController.text.trim(),
        messageTime: Timestamp.now(),
      );
      message.messageState = MessageState.sentOffline;
      textController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom(400);
      });
      if (chatCreatedListener.isFalse) {
        chat!.value.lastMessage = message;
        await _userDataController.createChat(chat!.value);
      } else {
        updateIsTypingValue(false);
      }
      await _userDataController.uploadMessage(message, chatId!);
      if (chat!.value.chatter2.deleteChat || chat!.value.chatter1.deleteChat) {
        Map<String, dynamic> updatedData = {};
        updatedData.addIf(
          chat!.value.chatter1.deleteChat,
          '$currentUserId.delete_chat',
          false,
        );
        updatedData.addIf(
          chat!.value.chatter2.deleteChat,
          '$chatterId.delete_chat',
          false,
        );
        await _userDataController.getChatDocumentById(chatId!).update(
              updatedData,
            );
      }
    }
  }

  Future<MedicalRecordModel?> get userMedicalRecord async =>
      await _userDataController.getUserMedicalRecord(currentUserId);
  UserType get currentUserType => _authenticationController.currentUserType;
  String get currentUserId => _authenticationController.currentUserId;
  String get currentUserName => _authenticationController.currentUserName;
  String? get currentUserPersonalImage =>
      _authenticationController.currentUserPersonalImage;
  Gender get currentUserGender => _authenticationController.currentUserGender;
  get currentUserBirthDate => _authenticationController.currentUserBirthDate;
  Age get currntUserAge => CommonFunctions.calculateAge(currentUserBirthDate);
}
