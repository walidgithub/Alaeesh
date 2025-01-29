class UserPermissionsModel {
  String? id;
  String username;
  String role;
  String enableAdd;
  UserPermissionsModel(
      {this.id,
      required this.role,
      required this.username,
      required this.enableAdd});

  static UserPermissionsModel fromMap(Map<String, dynamic> map) {
    UserPermissionsModel userPermissionsModel = UserPermissionsModel(
      id: map['id'],
      username: map['username'],
      role: map['role'],
      enableAdd: map['enableAdd'],
    );
    return userPermissionsModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'enableAdd': enableAdd,
    };
  }
}
