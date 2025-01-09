import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last/features/trending/data/model/requests/get_suggested_user_posts_request.dart';
import 'package:last/features/trending/data/model/suggested_user_model.dart';
import '../../../../core/di/di.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../home_page/data/model/subscribers_model.dart';
import '../model/requests/get_post_data_request.dart';
import '../model/requests/get_top_posts_request.dart';

abstract class BaseDataSource {
  Future<List<HomePageModel>> getTopPosts(
      GetTopPostsRequest getTopPostsRequest);
  Future<List<SuggestedUserModel>> getSuggestedUsers();
  Future<List<HomePageModel>> getSuggestedUserPosts(
      GetSuggestedUserPostsRequest getSuggestedUserPostsRequest);
}

class TrendingDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<HomePageModel>> getTopPosts(
      GetTopPostsRequest getTopPostsRequest) async {
    try {
      final Future<QuerySnapshot<Map<String, dynamic>>> postsFuture;

      postsFuture = firestore
          .collection('posts')
          .get();

      final subscribersFuture = firestore
          .collection('subscribers')
          .where('username', isEqualTo: getTopPostsRequest.currentUser.trim())
          .get();

      final results = await Future.wait([postsFuture, subscribersFuture]);

      // Parse the data
      final postDocs = results[0].docs;
      final subscriberDocs = results[1].docs;

      // Convert Firestore documents to PostModel and SubscribersModel lists
      final postModels = postDocs.map((doc) {
        final postData = {'id': doc.id, ...doc.data()};
        return PostModel.fromMap(postData);
      }).toList();

      final subscriberModels = subscriberDocs.map((doc) {
        final subscriberData = {
          'id': doc.id,
          ...doc.data()
        };
        return SubscribersModel.fromMap(subscriberData);
      }).toList();

      // Combine data into HomePageModel
      List<HomePageModel> homePageModels = postModels.map((post) {
        final isSubscribed = subscriberModels.any((subscriber) =>
            subscriber.postAuther == post.username); // Match post author
        return HomePageModel(postModel: post, userSubscribed: isSubscribed);
      }).toList();

      // Sort homePageModels by the count of subscribersList in descending order
      homePageModels.sort((a, b) => b.postModel.postSubscribersList.length
          .compareTo(a.postModel.postSubscribersList.length));

      return homePageModels;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SuggestedUserModel>> getSuggestedUsers() async {
    try {
      final snapshot = await firestore.collection('posts').get();

      final posts =
          snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();

      final Map<String, SuggestedUserModel> userMap = {};

      for (var post in posts) {
        for (var subscriber in post.postSubscribersList) {
          final userName = subscriber.username;
          final userImage = subscriber.userImage;

          if (userMap.containsKey(userName)) {
            userMap[userName]!.subscriptionsCount++;
          } else {
            userMap[userName] = SuggestedUserModel(
              userName: userName,
              userImage: userImage,
              subscriptionsCount: 1,
            );
          }
        }
      }

      final suggestedUsers = userMap.values.toList()
        ..sort((a, b) => b.subscriptionsCount.compareTo(a.subscriptionsCount));

      return suggestedUsers;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<HomePageModel>> getSuggestedUserPosts(
      GetSuggestedUserPostsRequest getSuggestedUserPostsRequest) async {
    try {

      // Fetch posts based on username or all posts
      final Future<QuerySnapshot<Map<String, dynamic>>> postsFuture;
       postsFuture = firestore
            .collection('posts')
            .where('username', isEqualTo: getSuggestedUserPostsRequest.userName)
            .get();


      // Fetch subscriber documents for the current user
      final subscribersFuture = firestore
          .collection('subscribers')
          .where('username', isEqualTo: getSuggestedUserPostsRequest.currentUser)
          .get();

      // Wait for both queries to complete
      final results = await Future.wait([postsFuture, subscribersFuture]);

      // Parse the data
      final postDocs = results[0].docs;
      final subscriberDocs = results[1].docs;

      // Convert Firestore documents to PostModel and SubscribersModel lists
      final postModels = postDocs.map((doc) {
        final postData = {'id': doc.id, ...doc.data()};
        return PostModel.fromMap(postData);
      }).toList();

      final subscriberModels = subscriberDocs.map((doc) {
        final subscriberData = {'id': doc.id, ...doc.data()};
        return SubscribersModel.fromMap(subscriberData);
      }).toList();

      // Extract post IDs from the subscribers list
      final postIdsFromSubscribers = subscriberModels.map((subscriber) => subscriber.id).toSet();

      // Fetch additional posts based on `postId` from the `subscribersList`
      QuerySnapshot<Map<String, dynamic>>? subscribedPostsSnapshot;
      if (postIdsFromSubscribers.isNotEmpty) {
        subscribedPostsSnapshot = await firestore
            .collection('posts')
            .where(FieldPath.documentId, whereIn: postIdsFromSubscribers.toList())
            .get();
      }

      // Convert additional fetched posts to PostModel
      final subscribedPostModels = (subscribedPostsSnapshot?.docs ?? []).map((doc) {
        final postData = {'id': doc.id, ...doc.data()};
        return PostModel.fromMap(postData);
      }).toList();

      // Combine posts from username query and subscribers query
      final allPosts = <dynamic>{...postModels, ...subscribedPostModels}.toList(); // Ensure distinct posts

      // Combine data into HomePageModel
      final homePageModels = allPosts.map((post) {
        final isSubscribed = subscriberModels.any((subscriber) =>
        subscriber.postAuther == post.username); // Match post author
        return HomePageModel(postModel: post, userSubscribed: isSubscribed);
      }).toList();

      return homePageModels;
    } catch (e) {
      rethrow;
    }
  }
}
