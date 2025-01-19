import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_failure.dart';

class FirebaseErrorHandler {
  late FirebaseFailure firebaseFailure;
  /// Handle Firebase Authentication Errors
  static String handleAuthError(FirebaseAuthException e) {
    String errorMessage = 'An unknown error occurred';

    switch (e.code) {
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      case 'user-disabled':
        errorMessage = 'This user account has been disabled.';
        break;
      case 'user-not-found':
        errorMessage = 'No user found with this email address.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again.';
        break;
      case 'email-already-in-use':
        errorMessage = 'An account already exists with this email address.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'This operation is not allowed. Please contact support.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak. Please choose a stronger password.';
        break;
      case 'network-request-failed':
        errorMessage = 'Network error. Please check your internet connection.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Please try again later.';
        break;
      default:
        errorMessage = e.message ?? 'An unexpected error occurred';
    }
    return errorMessage;
  }

  /// Handle Firebase Database and Storage Errors
  static String handleFirebaseError(dynamic e) {
    String errorMessage = 'An unknown error occurred';

    if (e is FirebaseException) {
      switch (e.code) {
        case 'permission-denied':
          errorMessage = 'You do not have permission to perform this action.';
          break;
        case 'unavailable':
          errorMessage = 'Firebase service is currently unavailable.';
          break;
        case 'cancelled':
          errorMessage = 'The operation was cancelled.';
          break;
        case 'data-loss':
          errorMessage = 'Unrecoverable data loss occurred.';
          break;
        case 'deadline-exceeded':
          errorMessage = 'Operation timeout. Please try again.';
          break;
        default:
          errorMessage = e.message ?? 'An unexpected Firebase error occurred';
      }
    } else {
      errorMessage = e.toString();
    }
    return errorMessage;
  }

  /// Generic error handler for catching various errors
  static String handleGenericError(dynamic error) {
    String errorMessage = error.toString();
    return errorMessage;
  }
}
