class AddPostResponse {
  String postId;
  AddPostResponse({required this.postId});

  static AddPostResponse fromMap(Map<String, dynamic> map) {
    AddPostResponse addPostResponse = AddPostResponse(
        postId: map['postId']);
    return addPostResponse;
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
    };
  }
}