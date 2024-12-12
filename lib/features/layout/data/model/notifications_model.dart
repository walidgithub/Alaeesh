import '../../../../core/utils/constant/app_assets.dart';
import '../../../home_page/data/model/comments_model.dart';
import '../../../home_page/data/model/post_model.dart';

class NotificationsModel {
  final int id;
  final String username;
  PostModel postModel;
  NotificationsModel({
    required this.id,
    required this.username,
    required this.postModel,
  });

  factory NotificationsModel.fromMap(
      int id, PostModel postModel, String username) {
    return NotificationsModel(
      id: id,
      username: username,
      postModel: postModel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'postModel': postModel,
    };
  }
}

List<NotificationsModel> notificationsModel = [
  NotificationsModel(
      id: 1,
      username: "walidddd",
      postModel: PostModel(
          id: 1,
          emojiDataCount: 0,
          postAlsha:
              " الشة رقم 1 الشة رقم 1الشة رقم 1الشة رقم 1 الشة رقم 1 الشة رقم 1 الشة رقم 1",
          username: "walid111",
          commentsList: [
            CommentsModel(
                id: 1,
                postId: 1,
                username: "walid2222",
                userImage: AppAssets.profile.toString(),
                time: "2h",
                comment: "التعليقاتتتتتتتتت",
                emojiDataCount: 0,
                emojisList: [])
          ],
          userImage: AppAssets.profile.toString(),
          emojisList: [],
          time: "2h")),
  NotificationsModel(
      id: 1,
      username: "walidddd",
      postModel: PostModel(
          id: 1,
          emojiDataCount: 0,
          postAlsha:
              " الشة رقم 1 الشة رقم 1الشة رقم 1الشة رقم 1 الشة رقم 1 الشة رقم 1 الشة رقم 1",
          username: "walid111",
          commentsList: [
            CommentsModel(
                id: 1,
                postId: 1,
                username: "walid2222",
                userImage: AppAssets.profile.toString(),
                time: "2h",
                comment: "التعليقاتتتتتتتتت",
                emojiDataCount: 0,
                emojisList: [])
          ],
          userImage: AppAssets.profile.toString(),
          emojisList: [],
          time: "2h"))
];
