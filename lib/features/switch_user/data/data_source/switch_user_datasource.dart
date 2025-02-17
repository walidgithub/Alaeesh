import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:last/features/welcome/data/model/user_model.dart';
import '../../../../core/di/di.dart';

abstract class BaseDataSource {
  Future<UserModel> switchUser();
}

class SwitchUserDataSource extends BaseDataSource {

  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = sl<FirebaseAuth>();

  @override
  Future<UserModel> switchUser() async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();

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
}
