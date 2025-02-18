class AllowedUserModel {
  String? id;
  String email;
  AllowedUserModel({this.id, required this.email});

  static AllowedUserModel fromMap(Map<String, dynamic> map, String? id) {
    AllowedUserModel allowedUserModel = AllowedUserModel(
      id: id,
      email: map['email'],
    );
    return allowedUserModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }
}