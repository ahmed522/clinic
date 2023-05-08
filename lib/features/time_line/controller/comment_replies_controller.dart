import 'package:clinic/features/authentication/controller/firebase/authentication_controller.dart';
import 'package:clinic/features/authentication/controller/firebase/user_data_controller.dart';
import 'package:clinic/features/time_line/model/reply_model.dart';
import 'package:clinic/features/time_line/pages/post/comment/comment_widget.dart';
import 'package:clinic/global/constants/user_type.dart';
import 'package:clinic/global/data/models/parent_user_model.dart';
import 'package:clinic/global/widgets/error_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CommentRepliesController extends GetxController {
  static CommentRepliesController get find => Get.find();
  final _authenticationController = AuthenticationController.find;
  final _userDataController = UserDataController.find;
  RxBool loading = false.obs;
  RxList<CommentWidget> replies = <CommentWidget>[].obs;
  late String commentId;
  CommentRepliesController(this.commentId);
  @override
  void onReady() {
    loadCommentReplies(commentId);
    super.onReady();
  }

  Future loadCommentReplies(String commentId) async {
    loading.value = true;
    try {
      QuerySnapshot snapshot = await _getCommentRepliesCollectionById(commentId)
          .orderBy('comment_time', descending: true)
          .get();
      if (snapshot.size == 0) {
        loading.value = false;
        return;
      }
      _showCommentReplies(snapshot);
    } catch (e) {
      loading.value = false;
      Get.off(() => const ErrorPage(
            imageAsset: 'assets/img/error.svg',
            message:
                'حدثت مشكلة نعمل على حلها الان، يرجى إعادة المحاولة لاحقاً',
          ));
    }
  }

  reactReply(String commentDocumentId, String replyDocumentId) async {
    _getReplyReactsCollectionById(commentDocumentId, replyDocumentId)
        .doc(_authenticationController.currentUser!.userId!)
        .set({'reacted': true});
    await _updateReplyReacts(commentDocumentId, replyDocumentId, true);
  }

  unReactReply(String commentDocumentId, String replyDocumentId) async {
    _getReplyReactsCollectionById(commentDocumentId, replyDocumentId)
        .doc(_authenticationController.currentUser!.userId!)
        .delete();
    await _updateReplyReacts(commentDocumentId, replyDocumentId, false);
  }

  CollectionReference _getCommentRepliesCollectionById(String commentId) =>
      _userDataController.getCommentRepliesCollectionById(commentId);

  Future<void> _showCommentReplies(QuerySnapshot<Object?> snapshot) async {
    replies.clear();
    for (var replySnapshot in snapshot.docs) {
      final String uid = replySnapshot.get('uid');
      final UserType userType = replySnapshot.get('writer_type') == 'doctor'
          ? UserType.doctor
          : UserType.user;
      final ParentUserModel writer;
      if (userType == UserType.doctor) {
        writer = await _userDataController.getDoctorById(uid);
      } else {
        writer = await _userDataController.getUserById(uid);
      }
      ReplyModel reply = ReplyModel.fromSnapshot(
        commentSnapshot:
            replySnapshot as DocumentSnapshot<Map<String, dynamic>>,
        writer: writer,
      );
      reply.reacted = await _userDataController.isUserReactedReply(
        _authenticationController.currentUser!.userId!,
        reply.commentId,
        reply.replyId,
      );
      loading.value = false;
      replies.add(
        CommentWidget(
          comment: reply,
          isReply: true,
        ),
      );
    }
  }

  CollectionReference _getReplyReactsCollectionById(
    String commentDocumentId,
    String replyDocumentId,
  ) =>
      _getReplyDocumentRefById(commentDocumentId, replyDocumentId)
          .collection('reply_reacts');

  _updateReplyReacts(
      String commentDocumentId, String replyDocumentId, bool plus) async {
    int factor = -1;
    if (plus) {
      factor = 1;
    }
    int oldReacts =
        await _getReplyReactsById(commentDocumentId, replyDocumentId);
    await _getReplyDocumentRefById(commentDocumentId, replyDocumentId)
        .update({'reacts': oldReacts + factor});
  }

  Future<int> _getReplyReactsById(
      String commentDocumentId, String replyDocumentId) async {
    int? reacts;
    await _getReplyDocumentRefById(commentDocumentId, replyDocumentId)
        .get()
        .then((value) {
      final data = value.data() as Map<String, dynamic>;
      reacts = data['reacts'];
    });
    return reacts!;
  }

  _getReplyDocumentRefById(
    String commentDocumentId,
    String replyDocumentId,
  ) =>
      _userDataController.getReplyDocumentById(
          commentDocumentId, replyDocumentId);
}
