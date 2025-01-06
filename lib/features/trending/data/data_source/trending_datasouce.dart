import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/di/di.dart';
import '../../../../core/preferences/secure_local_data.dart';
import '../../../home_page/data/model/home_page_model.dart';
import '../../../home_page/data/model/post_model.dart';
import '../../../home_page/data/model/requests/get_posts_request.dart';
import '../../../home_page/data/model/subscribers_model.dart';

abstract class BaseDataSource {
  Future<List<HomePageModel>> getTopPosts(GetPostsRequest getPostsRequest);
}

class TrendingDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<List<HomePageModel>> getTopPosts(GetPostsRequest getPostsRequest) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch posts and filtered subscribers concurrently
      final Future<QuerySnapshot<Map<String, dynamic>>> postsFuture;
      if (getPostsRequest.allPosts) {
        postsFuture = firestore.collection('posts').get();
      } else {
        postsFuture = firestore.collection('posts')
            .where('username', isEqualTo: getPostsRequest.username!.trim())
            .get();
      }
      final subscribersFuture = firestore
          .collection('subscribers')
          .where('username', isEqualTo: getPostsRequest.currentUser.trim())
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
}