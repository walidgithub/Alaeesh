class GetPostsRequest {
  final String currentUser;
  String? username;
  final bool allPosts;
  GetPostsRequest({required this.currentUser,required this.allPosts,this.username});
}