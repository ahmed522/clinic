import 'package:clinic/features/chat/controller/user_chats_page_controller.dart';
import 'package:clinic/features/chat/model/chat_model.dart';
import 'package:clinic/features/chat/pages/chat_page/single_chat_list_tile.dart';
import 'package:clinic/global/widgets/app_circular_progress_indicator.dart';
import 'package:clinic/global/widgets/default_appbar.dart';
import 'package:clinic/global/widgets/empty_page.dart';
import 'package:clinic/global/widgets/offline_page_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChatsPage extends StatelessWidget {
  const UserChatsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserChatsPageController());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const DefaultAppBar(title: 'الدردشات'),
      body: OfflinePageBuilder(
        child: StreamBuilder(
          stream: controller.chatsStream,
          builder: (context, snapshot) {
            return GetX<UserChatsPageController>(
              builder: (controller) {
                if ((!snapshot.hasData) ||
                    (snapshot.hasData && snapshot.data!.docs.isEmpty)) {
                  if (controller.loading.isTrue) {
                    return SizedBox(
                      height: size.height,
                      child: const Center(
                        child: AppCircularProgressIndicator(
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  }
                  return const EmptyPage(text: 'ليست هناك أي محادثات');
                }
                List<DocumentSnapshot> activeChats = snapshot.data!.docs
                    .where((element) =>
                        !element.get('${controller.currentUserId}.delete_chat'))
                    .toList();
                if (activeChats.isEmpty) {
                  return const EmptyPage(text: 'ليست هناك أي محادثات');
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8.0),
                  itemCount: activeChats.length,
                  itemBuilder: (context, index) {
                    ChatModel chat = ChatModel.fromSnapshot(activeChats[index]);
                    chat.lastMessage.sendedMessage =
                        chat.lastMessage.senderId == controller.currentUserId;
                    if (index == activeChats.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SingleChatListTile(chat: chat),
                      );
                    }
                    return SingleChatListTile(chat: chat);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
