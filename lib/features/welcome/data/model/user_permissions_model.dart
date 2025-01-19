class UserPermissionsModel {
  String? id;
  String username;
  String role;
  bool addOrEditPost;
  bool addOrEditComment;
  UserPermissionsModel(
      {this.id,
      required this.role,
      required this.username,
      required this.addOrEditPost,
      required this.addOrEditComment});

  static UserPermissionsModel fromMap(Map<String, dynamic> map) {
    UserPermissionsModel userPermissionsModel = UserPermissionsModel(
      id: map['id'],
      username: map['username'],
      role: map['role'],
      addOrEditPost: map['addOrEditPost'],
      addOrEditComment: map['addOrEditComment'],
    );
    return userPermissionsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'addOrEditPost': addOrEditPost,
      'addOrEditComment': addOrEditComment,
    };
  }
}
