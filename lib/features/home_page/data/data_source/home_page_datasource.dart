import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/data/model/requests/add_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/add_subscriber_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_subscriber_request.dart';
import 'package:last/features/home_page/data/model/subscribers_model.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../model/comments_model.dart';
import '../model/emoji_model.dart';
import '../model/requests/add_comment_emoji_request.dart';
import '../model/requests/add_emoji_request.dart';
import 'package:uuid/uuid.dart';
import '../model/requests/delete_comment_emoji_request.dart';
import '../model/requests/delete_emoji_request.dart';
import '../model/requests/update_comment_request.dart';
import '../model/requests/update_post_request.dart';

abstract class BaseDataSource {
  Future<void> updatePost(UpdatePostRequest updatePostRequest);
  Future<void> deletePost(String postId);

  Future<void> addComment(AddCommentRequest addCommentRequest);
  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest);
  Future<void> updateComment(UpdateCommentRequest updateCommentRequest);

  Future<void> addEmoji(AddEmojiRequest addEmojiRequest);
  Future<void> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);

  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest);
  Future<void> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest);

  Future<void> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest);
  Future<void> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest);

  Future<List<PostModel>> getAllPosts();
  Future<List<PostModel>> getTopPosts();
}

class HomePageDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();
  final SecureStorageLoginHelper _appSecureDataHelper =
  sl<SecureStorageLoginHelper>();

  @override
  Future<void> updatePost(UpdatePostRequest updatePostRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc = await postsCollection.doc(updatePostRequest.postId).get();

      if (postDoc.exists) {
        String updatedPost = updatePostRequest.postModel.postAlsha;
        await postsCollection.doc(updatePostRequest.postId).update({
          'postAlsha': updatedPost,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final postsCollection = firestore.collection('posts');
      final postDoc = await postsCollection.doc(postId).get();
      if (postDoc.exists) {
        await postsCollection.doc(postId).delete();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> postsList = [];
    try {
      var docs = await firestore
          .collection('posts')
          .orderBy('time', descending: true)
          .get();

      postsList = docs.docs.map((doc) {
        var data = doc.data();
        return PostModel(
          id: doc.id,
          postAlsha: data['postAlsha'] ?? '',
          username: data['username'] ?? '',
          userImage: data['userImage'] ?? '',
          emojisList: (data['emojisList'] as List<dynamic>)
              .map((emoji) => EmojiModel.fromMap(emoji))
              .toList(),
          commentsList: (data['commentsList'] as List<dynamic>)
              .map((comment) => CommentsModel.fromMap(comment))
              .toList(),
          time: data['time'] ?? '',
          subscribersList: (data['subscribersList'] as List<dynamic>)
              .map((emoji) => SubscribersModel.fromMap(emoji))
              .toList(),
        );
      }).toList();

      return postsList;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> getTopPosts() async {
    try {
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addComment(AddCommentRequest addCommentRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc = await postsCollection.doc(addCommentRequest.postId).get();

      if (postDoc.exists) {
        List<dynamic> comments = postDoc.data()?['commentsList'] ?? [];

        List<CommentsModel> commentsList = comments.map((comment) {
          return CommentsModel.fromMap(Map<String, dynamic>.from(comment));
        }).toList();

        commentsList.add(addCommentRequest.commentsModel);

        var uuid = Uuid();
        commentsList.last.id = uuid.v4();

        await _appSecureDataHelper.saveCommentData(id: commentsList.last.id.toString());

        List<Map<String, dynamic>> updatedComments =
            commentsList.map((comment) => comment.toMap()).toList();

        await postsCollection.doc(addCommentRequest.postId).update({
          'commentsList': updatedComments,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateComment(UpdateCommentRequest updateCommentRequest) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(updateCommentRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = List.from(snapshot['commentsList']);

        for (int i = 0; i < commentsList.length; i++) {
          if (commentsList[i]['id'] == updateCommentRequest.commentsModel.id) {
            commentsList[i]['comment'] = updateCommentRequest.commentsModel.comment; // Update the comment
            break;
          }
        }

        await postRef.update({'commentsList': commentsList});
      } else {
        print("Post document does not exist.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(deleteCommentRequest.postId);

      // Fetch the post document
      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = snapshot['commentsList'];

        commentsList.removeWhere((comment) => comment['id'] == deleteCommentRequest.commentId);

        await postRef.update({'commentsList': commentsList});
      } else {
        print("Post document does not exist.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addEmoji(AddEmojiRequest addEmojiRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc = await postsCollection.doc(addEmojiRequest.postId).get();

      if (postDoc.exists) {
        List<dynamic> emojis = postDoc.data()?['emojisList'] ?? [];

        List<EmojiModel> emojisList = emojis.map((emoji) {
          return EmojiModel.fromMap(Map<String, dynamic>.from(emoji));
        }).toList();

        emojisList.removeWhere(
            (emoji) => emoji.username == addEmojiRequest.emojiModel.username);

        emojisList.add(addEmojiRequest.emojiModel);

        var uuid = Uuid();
        emojisList.last.id = uuid.v4();

        List<Map<String, dynamic>> updatedEmojies =
            emojisList.map((emoji) => emoji.toMap()).toList();

        await postsCollection.doc(addEmojiRequest.postId).update({
          'emojisList': updatedEmojies,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(deleteEmojiRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> emojisList = snapshot['emojisList'];

        emojisList.removeWhere((emoji) => emoji['id'] == deleteEmojiRequest.emojiId);

        await postRef.update({'emojisList': emojisList});
      } else {
        print("Post document does not exist.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc = await postsCollection.doc(addSubscriberRequest.subscriberModel.postId).get();

      if (postDoc.exists) {
        List<dynamic> subscribers = postDoc.data()?['subscribersList'] ?? [];

        List<SubscribersModel> subscribersList = subscribers.map((emoji) {
          return SubscribersModel.fromMap(Map<String, dynamic>.from(emoji));
        }).toList();

        subscribersList.add(addSubscriberRequest.subscriberModel);

        List<Map<String, dynamic>> updatedSubscribers =
        subscribersList.map((subscriber) => subscriber.toMap()).toList();

        await postsCollection.doc(addSubscriberRequest.subscriberModel.postId).update({
          'subscribersList': updatedSubscribers,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSubscriber(DeleteSubscriberRequest deleteSubscriberRequest) async {
    try {
      // final postRef = FirebaseFirestore.instance.collection('posts').doc(deleteSubscriberRequest.subscriberModel.postId);
      //
      // final snapshot = await postRef.get();
      // if (snapshot.exists) {
      //   List<dynamic> subscribersList = snapshot['subscribersList'];
      //
      //   subscribersList.removeWhere((subscriber) => subscriber['username'] == deleteSubscriberRequest.subscriberModel.username).f;
      //
      //   await postRef.update({'subscribersList': subscribersList});
      // } else {
      //   print("Post document does not exist.");
      // }

      final postRef = FirebaseFirestore.instance.collection('posts').doc(deleteSubscriberRequest.subscriberModel.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> subscribersList = List.from(snapshot['subscribersList']);

        int index = subscribersList.indexWhere((subscriber) =>
        subscriber['username'] == deleteSubscriberRequest.subscriberModel.username);

        if (index != -1) {
          subscribersList.removeAt(index);

          await postRef.update({'subscribersList': subscribersList});
        } else {
          print("Subscriber with the specified username not found.");
        }
      } else {
        print("Post document does not exist.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCommentEmoji(
      AddCommentEmojiRequest addCommentEmojiRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc =
          await postsCollection.doc(addCommentEmojiRequest.postId).get();

      if (postDoc.exists) {
        List<dynamic> comments = postDoc.data()?['commentsList'] ?? [];

        List<CommentsModel> commentsList = comments.map((comment) {
          return CommentsModel.fromMap(Map<String, dynamic>.from(comment));
        }).toList();

        final targetComment = commentsList.firstWhere(
          (comment) =>
              comment.id == addCommentEmojiRequest.commentEmojiModel.commentId,
        );

        targetComment.commentEmojiModel.removeWhere((emoji) =>
            emoji.username ==
            addCommentEmojiRequest.commentEmojiModel.username);

        targetComment.commentEmojiModel
            .add(addCommentEmojiRequest.commentEmojiModel);

        var uuid = Uuid();
        targetComment.commentEmojiModel.last.id = uuid.v4();

        await _appSecureDataHelper.saveCommentData(id: targetComment.id.toString());

        List<Map<String, dynamic>> updatedComments =
            commentsList.map((comment) => comment.toMap()).toList();

        await postsCollection.doc(addCommentEmojiRequest.postId).update({
          'commentsList': updatedComments,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCommentEmoji(DeleteCommentEmojiRequest deleteCommentEmojiRequest) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(deleteCommentEmojiRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = List.from(snapshot['commentsList']);

        for (int i = 0; i < commentsList.length; i++) {
          if (commentsList[i]['id'] == deleteCommentEmojiRequest.commentId) {
            List<dynamic> emojisList = List.from(commentsList[i]['emojisList']);

            emojisList.removeWhere((emoji) => emoji['id'] == deleteCommentEmojiRequest.emojiId);

            commentsList[i]['emojisList'] = emojisList;
            break;
          }
        }
        await postRef.update({'commentsList': commentsList});
      } else {
        print("Post document does not exist.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
