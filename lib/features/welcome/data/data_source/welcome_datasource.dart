import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:last/features/welcome/data/model/user_model.dart';
import '../../../../core/di/di.dart';
import '../model/user_permissions_model.dart';

abstract class BaseDataSource {
  Future<UserModel> login();
  Future<void> addUserPermission(UserPermissionsModel userPermissionsModel);
  Future<void> updateUserPermission(UserPermissionsModel userPermissionsModel);
  Future<UserPermissionsModel> getUserPermission(String username);
  Future<void> logout();
}

class WelcomeDataSource extends BaseDataSource {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = sl<FirebaseAuth>();
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();

  @override
  Future<UserModel> login() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential userCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      var googleUser = await auth.signInWithCredential(userCredential);

      final userData = {
        'id': googleUser.user!.uid,
        'email': googleUser.user!.email,
        'name': googleUser.user!.displayName,
        'photoUrl': googleUser.user!.photoURL,
      };

      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addUserPermission(
      UserPermissionsModel userPermissionsModel) async {
    try {
      final collection = firestore.collection('userPermissions');

      final querySnapshot = await collection
          .where('username', isEqualTo: userPermissionsModel.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return;
      }
      final docRef = collection.doc();
      userPermissionsModel.id = docRef.id;
      await docRef.set(userPermissionsModel.toMap());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserPermission(
      UserPermissionsModel userPermissionsModel) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('userPermissions')
          .where('username', isEqualTo: userPermissionsModel.username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docRef = querySnapshot.docs[0].reference;

        await docRef.update({
          'role': userPermissionsModel.role,
          'enableAdd': userPermissionsModel.enableAdd,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserPermissionsModel> getUserPermission(String username) async {
    try {
      final collection = firestore.collection('userPermissions');
      final querySnapshot = await collection
          .where('username', isEqualTo: username)
          .get();

      final doc = querySnapshot.docs.first;
      return UserPermissionsModel.fromMap(doc.data());
    } catch (e) {
      rethrow;
    }
  }
}
