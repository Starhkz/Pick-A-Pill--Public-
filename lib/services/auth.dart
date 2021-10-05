import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireUser _userFromFirebaseUser(User user) {
    return user != null ? FireUser(uid: user.uid) : null;
  }

  Stream<FireUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerwithEmailAndPassword(
      String email, String password, String pharmName) async {
    try {
      print('It has started');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      print('It has stopped\n Starting next Stage');
      await DatabaseService(uid: user.uid)
          .updateUserData(user.uid, pharmName, null);
      print('It should have ended by now');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signInwithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error Signing Out');
      return null;
    }
  }
}
