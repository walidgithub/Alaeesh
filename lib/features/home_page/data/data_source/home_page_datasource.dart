import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/home_page/data/model/home_page_model.dart';
import 'package:last/features/home_page/data/model/post_model.dart';
import 'package:last/features/home_page/data/model/requests/add_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/add_post_subscriber_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_comment_request.dart';
import 'package:last/features/home_page/data/model/requests/delete_post_subscriber_request.dart';
import 'package:last/features/home_page/data/model/post_subscribers_model.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../model/comments_model.dart';
import '../model/emoji_model.dart';
import '../model/requests/add_comment_emoji_request.dart';
import '../model/requests/add_emoji_request.dart';
import 'package:uuid/uuid.dart';
import '../model/requests/add_subscriber_request.dart';
import '../model/requests/delete_comment_emoji_request.dart';
import '../model/requests/delete_emoji_request.dart';
import '../model/requests/delete_subscriber_request.dart';
import '../model/requests/get_subscribers_request.dart';
import '../model/requests/update_comment_request.dart';
import '../model/requests/update_post_request.dart';
import '../model/subscribers_model.dart';

abstract class BaseDataSource {
  Future<void> updatePost(UpdatePostRequest updatePostRequest);
  Future<void> deletePost(String postId);

  Future<void> addComment(AddCommentRequest addCommentRequest);
  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest);
  Future<void> updateComment(UpdateCommentRequest updateCommentRequest);

  Future<void> addEmoji(AddEmojiRequest addEmojiRequest);
  Future<void> deleteEmoji(DeleteEmojiRequest deleteEmojiRequest);

  Future<void> addPostSubscriber(
      AddPostSubscriberRequest addPostSubscriberRequest);
  Future<void> deletePostSubscriber(
      DeletePostSubscriberRequest deletePostSubscriberRequest);

  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest);
  Future<void> deleteSubscriber(
      DeleteSubscriberRequest deleteSubscriberRequest);
  Future<List<SubscribersModel>> getSubscribers(
      GetSubscribersRequest getSubscribersRequest);

  Future<void> addCommentEmoji(AddCommentEmojiRequest addCommentEmojiRequest);
  Future<void> deleteCommentEmoji(
      DeleteCommentEmojiRequest deleteCommentEmojiRequest);

  Future<List<HomePageModel>> getAllPosts(String currentUser);
  Future<List<HomePageModel>> getTopPosts(String currentUser);
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
  Future<List<HomePageModel>> getAllPosts(String currentUser) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch posts and filtered subscribers concurrently
      final postsFuture = firestore.collection('posts').get();
      final subscribersFuture = firestore
          .collection('subscribers')
          .where('username', isEqualTo: currentUser.trim())
          .get();

      final results = await Future.wait([postsFuture, subscribersFuture]);

      // Parse the data
      final postDocs = results[0].docs;
      final subscriberDocs = results[1].docs;

      // Convert Firestore documents to PostModel and SubscribersModel lists
      final postModels = postDocs.map((doc) {
        final postData = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        return PostModel.fromMap(postData);
      }).toList();

      final subscriberModels = subscriberDocs.map((doc) {
        final subscriberData = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        return SubscribersModel.fromMap(subscriberData);
      }).toList();

      // Combine data into HomePageModel
      List<HomePageModel> homePageModels = postModels.map((post) {
        final isSubscribed = subscriberModels.any((subscriber) =>
        subscriber.postAuther == post.username); // Match post author
        return HomePageModel(postModel: post, userSubscribed: isSubscribed);
      }).toList();

      return homePageModels;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomePageModel>> getTopPosts(String currentUser) async {
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

        await _appSecureDataHelper.saveCommentData(
            id: commentsList.last.id.toString());

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
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(updateCommentRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = List.from(snapshot['commentsList']);

        for (int i = 0; i < commentsList.length; i++) {
          if (commentsList[i]['id'] == updateCommentRequest.commentsModel.id) {
            commentsList[i]['comment'] = updateCommentRequest
                .commentsModel.comment; // Update the comment
            break;
          }
        }

        await postRef.update({'commentsList': commentsList});
      } else {
        throw "Post document does not exist.";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteComment(DeleteCommentRequest deleteCommentRequest) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(deleteCommentRequest.postId);

      // Fetch the post document
      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = snapshot['commentsList'];

        commentsList.removeWhere(
            (comment) => comment['id'] == deleteCommentRequest.commentId);

        await postRef.update({'commentsList': commentsList});
      } else {
        throw "Post document does not exist.";
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
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(deleteEmojiRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> emojisList = snapshot['emojisList'];

        emojisList
            .removeWhere((emoji) => emoji['id'] == deleteEmojiRequest.emojiId);

        await postRef.update({'emojisList': emojisList});
      } else {
        throw "Post document does not exist.";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addPostSubscriber(
      AddPostSubscriberRequest addPostSubscriberRequest) async {
    try {
      final postsCollection = firestore.collection('posts');

      final postDoc = await postsCollection
          .doc(addPostSubscriberRequest.postSubscribersModel.postId)
          .get();

      if (postDoc.exists) {
        List<dynamic> subscribers = postDoc.data()?['subscribersList'] ?? [];

        List<PostSubscribersModel> subscribersList = subscribers.map((emoji) {
          return PostSubscribersModel.fromMap(Map<String, dynamic>.from(emoji));
        }).toList();

        subscribersList.add(addPostSubscriberRequest.postSubscribersModel);

        List<Map<String, dynamic>> updatedSubscribers =
            subscribersList.map((subscriber) => subscriber.toMap()).toList();

        await postsCollection
            .doc(addPostSubscriberRequest.postSubscribersModel.postId)
            .update({
          'subscribersList': updatedSubscribers,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePostSubscriber(
      DeletePostSubscriberRequest deletePostSubscriberRequest) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(deletePostSubscriberRequest.postSubscribersModel.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> subscribersList = List.from(snapshot['subscribersList']);

        int index = subscribersList.indexWhere((subscriber) =>
            subscriber['username'] ==
            deletePostSubscriberRequest.postSubscribersModel.username);

        if (index != -1) {
          subscribersList.removeAt(index);

          await postRef.update({'subscribersList': subscribersList});
        } else {
          throw "Subscriber with the specified username not found.";
        }
      } else {
        throw "Post document does not exist.";
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

        await _appSecureDataHelper.saveCommentData(
            id: targetComment.id.toString());

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
  Future<void> deleteCommentEmoji(
      DeleteCommentEmojiRequest deleteCommentEmojiRequest) async {
    try {
      final postRef = FirebaseFirestore.instance
          .collection('posts')
          .doc(deleteCommentEmojiRequest.postId);

      final snapshot = await postRef.get();
      if (snapshot.exists) {
        List<dynamic> commentsList = List.from(snapshot['commentsList']);

        for (int i = 0; i < commentsList.length; i++) {
          if (commentsList[i]['id'] == deleteCommentEmojiRequest.commentId) {
            List<dynamic> emojisList = List.from(commentsList[i]['emojisList']);

            emojisList.removeWhere(
                (emoji) => emoji['id'] == deleteCommentEmojiRequest.emojiId);

            commentsList[i]['emojisList'] = emojisList;
            break;
          }
        }
        await postRef.update({'commentsList': commentsList});
      } else {
        throw "Post document does not exist.";
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSubscriber(AddSubscriberRequest addSubscriberRequest) async {
    try {
      final collection = FirebaseFirestore.instance.collection('subscribers');
      final docRef = collection.doc();
      addSubscriberRequest.id = docRef.id;
      await docRef.set(addSubscriberRequest.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSubscriber(
      DeleteSubscriberRequest deleteSubscriberRequest) async {
    try {
      final subscribersCollection = firestore.collection('subscribers');
      final subscriberQuery = await subscribersCollection
          .where('username', isEqualTo: deleteSubscriberRequest.username)
          .where('postAuther', isEqualTo: deleteSubscriberRequest.postAuther)
          .get();

      if (subscriberQuery.docs.isNotEmpty) {
        for (var doc in subscriberQuery.docs) {
          await subscribersCollection.doc(doc.id).delete();
        }
      } else {
        throw 'No matching subscriber found.';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SubscribersModel>> getSubscribers(
      GetSubscribersRequest getSubscribersRequest) async {
    List<SubscribersModel> subscribersList = [];
    try {
      var docs = await firestore.collection('subscribers')
          .where('username', isEqualTo: getSubscribersRequest.username)
          .get();

      subscribersList = docs.docs.map((doc) {
        var data = doc.data();
        return SubscribersModel(
            id: doc.id,
            postAuther: data['postAuther'] ?? '',
            username: data['username'] ?? '');
      }).toList();

      return subscribersList;
    } catch (e) {
      rethrow;
    }
  }
}
