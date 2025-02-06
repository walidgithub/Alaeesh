import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../di/di.dart';

Future<String?> getUpdatedPhotoURL(String email) async {
  GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = sl<FirebaseAuth>();
  try {
    final user = auth.currentUser;
    if (user == null || user.email != email) {
      print("No matching user found or user is not signed in.");
      return null;
    }

    final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
    if (googleUser == null) {
      print("User is not signed in with Google.");
      return user.photoURL;
    }

    return user.photoURL;
  } catch (e) {
    print("Error fetching profile picture: $e");
    return null;
  }
}
