import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinic/features/chat/controller/single_chat_page_controller.dart';
import 'package:clinic/features/doctor_profile/pages/doctor_profile_page.dart';
import 'package:clinic/features/user_profile/pages/user_profile_page.dart';
import 'package:clinic/global/colors/app_colors.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/fonts/app_fonts.dart';
import 'package:clinic/global/functions/common_functions.dart';
import 'package:clinic/global/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChatPageAppBarWidget extends StatelessWidget {
  const SingleChatPageAppBarWidget({
    Key? key,
    required this.chatterId,
    required this.isCreated,
    required this.blocks,
    required this.deleteChat,
    required this.muted,
  }) : super(key: key);
  final String chatterId;
  final bool isCreated;
  final bool blocks;
  final bool muted;
  final bool deleteChat;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SingleChatPageController controller = Get.find(tag: chatterId);
    return AppBar(
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton(
              onSelected: ((value) {
                switch (value) {
                  case 0:
                    if (controller.chatterType == UserType.user) {
                      Get.to(
                        () => UserProfilePage(userId: chatterId),
                        transition: Transition.rightToLeftWithFade,
                      );
                    } else {
                      Get.to(
                        () => DoctorProfilePage(
                          doctorId: chatterId,
                          isCurrentUser: false,
                        ),
                        transition: Transition.rightToLeftWithFade,
                      );
                    }
                    break;
                  case 1:
                    MyAlertDialog.showAlertDialog(
                      context,
                      'حذف المحادثة',
                      'ستظل الرسائل موجودة لدى الطرف الاخر ولن تستطيع حذفها',
                      MyAlertDialog.getAlertDialogActions(
                        {
                          'العودة': () => Get.back(),
                          'حذف': () {
                            controller.deleteChat();
                            Get.back();
                            Get.back();
                          }
                        },
                      ),
                    );

                    break;
                  case 2:
                    if (blocks) {
                      controller.unBlockChatter();
                    } else {
                      MyAlertDialog.showAlertDialog(
                        context,
                        'إيقاف المراسلة',
                        'لن تتمكن من إرسال أو إستقبال أي رسائل حتى تقوم بتفعيل المراسلة مرة أخرى',
                        MyAlertDialog.getAlertDialogActions(
                          {
                            'العودة': () => Get.back(),
                            'إيقاف': () {
                              controller.blockChatter();
                              Get.back();
                            }
                          },
                        ),
                      );
                    }
                    break;
                  case 3:
                    if (muted) {
                      controller.unMuteChat();
                    } else {
                      MyAlertDialog.showAlertDialog(
                        context,
                        'كتم الإشعارات',
                        'لن تتمكن من إستقبال أي إشعارات لهذه المحادثة',
                        MyAlertDialog.getAlertDialogActions(
                          {
                            'العودة': () => Get.back(),
                            'كتم': () {
                              controller.muteChat();
                              Get.back();
                            }
                          },
                        ),
                      );
                    }
                    break;
                }
              }),
              position: PopupMenuPosition.under,
              elevation: 5.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(5),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  textStyle: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    color: CommonFunctions.isLightMode(context)
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الصفحة الشخصية',
                    ),
                  ),
                ),
                PopupMenuItem(
                  enabled: isCreated && !deleteChat,
                  value: 1,
                  textStyle: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    color: CommonFunctions.isLightMode(context)
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'حذف المحادثة',
                    ),
                  ),
                ),
                PopupMenuItem(
                  enabled: isCreated,
                  value: 2,
                  textStyle: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    color: CommonFunctions.isLightMode(context)
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      blocks ? 'تفعيل المراسلة' : 'إيقاف المراسلة',
                    ),
                  ),
                ),
                PopupMenuItem(
                  enabled: isCreated,
                  value: 3,
                  textStyle: TextStyle(
                    fontFamily: AppFonts.mainArabicFontFamily,
                    color: CommonFunctions.isLightMode(context)
                        ? Colors.black
                        : Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      muted ? 'إلغاء الكتم' : 'كتم الإشعارات',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GetX<SingleChatPageController>(
                        tag: chatterId,
                        builder: (controller) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.chat!.value.chatter2.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              controller.chat!.value.chatter2.isTyping
                                  ? const Text(
                                      'يكتب',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          );
                        }),
                    const SizedBox(width: 10),
                    controller.chatter2PicUrl != null
                        ? CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            backgroundImage: CachedNetworkImageProvider(
                                controller.chatter2PicUrl!),
                            radius: (size.width < 330) ? 18 : 22,
                          )
                        : CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            backgroundImage:
                                const AssetImage('assets/img/user.png'),
                            radius: (size.width < 330) ? 18 : 22,
                          ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      elevation: 5,
      automaticallyImplyLeading: false,
    );
  }
}
