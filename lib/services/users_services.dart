
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kicks_trade/models/user.dart';

class UsersService {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore _firebase = Firestore.instance;
  
  static Future<Stream<List<User>>> streamUsers() async {
    var ref = Firestore.instance.collection('users');

    return ref.snapshots().map((list) => list.documents.map((doc) => User.fromFirestore(doc)).toList());
  }

  static Future<bool> signInWithEmailAndPaddword({String email, String password}) async {
    try {
      AuthResult authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult?.user;

      if (firebaseUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future updateUser({
    User user,
    bool isRegistering,
  }) async {
    if (isRegistering) {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);
      await Firestore.instance.collection('users_registrations')
      .document(result.user.uid)
			.setData(
        {
          'email': user.email,
          'isAdmin': false,
          'fullname': user.fullname,
          'phonenumber': user.phonenumber,
          'userId': result.user.uid,
        },
      );
      return result;
    } else {
      return await Firestore.instance.collection('users').document(user.userId).setData({
        'email': user.email,
        'isAdmin': user.isAdmin,
        'name': user.fullname,
        'phonenumber': user.phonenumber,
        'userId': user.userId,
      }, merge: true);
    }
  }

  static Future updateUserVerifCode({
    User user,
  }) async {
    await Firestore.instance.collection('users_update_password').add(
      {
        'verifcode': user.verifcode,
        'isUpdating': true,
        'password': '',
        'userId': user.userId,
        'resettype': user.resettype,
        'last_requested' : DateTime.now()
      },
    );
  }
  
  static Future updateUserPassword({
    User user,
  }) async {
    await Firestore.instance.collection('users_update_password').document(user.userId).setData(
      {
        'verifcode': '',
        'password': user.password,
        'isUpdating': false,
        'userId': user.userId,
        'resettype': user.resettype,
        'last_updated' : DateTime.now()
      },
    );
  }

  static Future getUserVerifCode({
    User user,
  }) async {
    await Firestore.instance.collection('users_update_password').document(user.userId).get();
  }

  static Future getUserWithEmailOrNumber({
    String dataValue,
  }) async {
    // var phonenumberCheck = await Firestore.instance.collection('users_update_password').where( "phonenumber", isEqualTo: dataValue).getDocuments();
    // var emailCheck = await Firestore.instance.collection('users_update_password').where( "email", isEqualTo: dataValue).getDocuments();
    // var phonenumberCheck = await Firestore.instance.collection('users').where( "phonenumber", isEqualTo: dataValue).getDocuments();
    // var emailCheck = await Firestore.instance.collection('users').where( "email", isEqualTo: dataValue).getDocuments();
    var phonenumberCheck = await Firestore.instance.collection('users_registrations').where( "phonenumber", isEqualTo: dataValue).getDocuments();
    var emailCheck = await Firestore.instance.collection('users_registrations').where( "email", isEqualTo: dataValue).getDocuments();
    if (phonenumberCheck != null && phonenumberCheck.documents.length > 0) {
      return phonenumberCheck.documents[0];
    } else if (emailCheck != null && emailCheck.documents.length > 0){
      return emailCheck.documents[0];
    } else {
      return null;
    }
  }
  
}