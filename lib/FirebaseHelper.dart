import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static get auth => _auth;

}