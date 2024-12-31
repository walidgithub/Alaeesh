class UserModel {
  String? name, id, email, photoUrl;

  UserModel({this.name, this.email, this.id, this.photoUrl});

  static UserModel fromJson(Map<String, dynamic> map) {
    UserModel user = UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}