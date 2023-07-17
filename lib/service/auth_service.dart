import 'package:firebase_auth/firebase_auth.dart';
import 'package:gupshup_firebase/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // * login

  // * register

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uId: user.uid).updateUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (err) {
      return err.message;
    }
  }

  // * sign out
}
