import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kicks_trade/models/user.dart';
import 'package:kicks_trade/providers/users_provider.dart';
import 'package:kicks_trade/services/twilio_helper.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/services/users_services.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<String> signUpFunctions(String fullname, String email, String password, String mobilenumber);
  
  Future<String> signUpWithNumber(String email, String password, String mobilenumber);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<Map> sendSMSRecoveryCode(String phoneNumber);

  Future<Map> sendSMSRecoveryWithCodeWithNum(String phoneNumber, String verifCode);

  Future<Map> sendSMSRecoveryWithCode(String phoneNumber, String verifCode, String userId);

  Future<Map> sendRecoveryWithCode(String phoneNumber, String verifCode, String userId, String resettype);

  Future<void> sendSMSRecoveryCodeFireBase(String phoneNumber);

  Future<void> sendSMSRecoveryFireBaseCodeCallback({String phoneNumber, Duration timeout, int forceResendingToken, void Function(AuthCredential) verificationCompleted, void Function(AuthException) verificationFailed, void Function(String, [int]) codeSent, void Function(String) codeAutoRetrievalTimeout});
  
  Future<void> sendEmailRecoveryCode(String userEmail);

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<dynamic> updatePasswordFunction(String _userId, String _newPassword);

  Future<dynamic> updatePassword(String _newPassword);
}

class Auth implements BaseAuth {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final String _authToken = TWILIO_AUTH_TOKEN;
  static final String _accountSid = TWILIO_ACCOUNTS_ID;
  static final String _accountNumber = TWILLIO_ACCOUNT_NUMBER;
  final TwilioHelper _twilioHelper = new TwilioHelper(_accountSid, _authToken);

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUpFunctions(String fullname, String email, String password, String phonenumber) async {
    User newUser = new User(
      fullname: fullname,
      email: email,
      password: password,
      phonenumber: phonenumber,
    );
    //dynamic result = await UsersProvider().updateUser(user: newUser, isRegistering: true);
    dynamic result = await UsersService.updateUser(user: newUser, isRegistering: true);
    dynamic user = result != null ? result.user.uid : null;
    return user;
  }

  Future<String> signUpWithNumber(String email, String password, String mobilenumber) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<Map> sendSMSRecoveryCode(String phoneNumber) async {
    // Send a text message
    var verifCode = '123456';
    Map messageResult = await _twilioHelper.messages.create({
      'body': 'Your Verification Code is : ' + verifCode,
      'from': _accountNumber, // a valid Twilio number
      'to': phoneNumber // your phone number
    });

    return messageResult ;
  }

  Future<Map> sendSMSRecoveryWithCode(String phoneNumber, String verifCode, String userId) async {
    // Send a text message
    Map messageResult = await _twilioHelper.messages.create({
      'body': 'Your Verification Code is : ' + verifCode,
      'from': _accountNumber, // a valid Twilio number
      'to': phoneNumber // your phone number
    });
    User newUser = new User(verifcode: verifCode, phonenumber: phoneNumber, userId: userId);
    UsersProvider().updateUserVerifCode(user: newUser);

    return messageResult ;
  }

  Future<Map> sendRecoveryWithCode(String phoneNumber, String verifCode, String userId, String resettype) async {
    Map messageResult ;
    if (resettype == 'sms') {
      // Send a text message
      messageResult = await _twilioHelper.messages.create({
        'body': 'Your Verification Code is : ' + verifCode,
        'from': _accountNumber, // a valid Twilio number
        'to': phoneNumber // your phone number
      });
    }
    User newUser = new User(verifcode: verifCode, phonenumber: phoneNumber, userId: userId, resettype: resettype);
    UsersProvider().updateUserVerifCode(user: newUser);
    if (resettype == 'email') {
      // Send a text message
      messageResult = { 'status' : 'success' };
    }
    return messageResult ;
  }

  Future<Map> sendSMSRecoveryWithCodeWithNum(String phoneNumber, String verifCode) async {
    // Send a text message
    Map messageResult = await _twilioHelper.messages.create({
      'body': 'Your Verification Code is : ' + verifCode,
      'from': _accountNumber, // a valid Twilio number
      'to': phoneNumber // your phone number
    });
    User newUser = new User(verifcode: verifCode, phonenumber: phoneNumber);
    UsersProvider().updateUserVerifCode(user: newUser);

    return messageResult ;
  }

  Future<void> sendSMSRecoveryCodeFireBase(String phoneNumber) async {
    _firebaseAuth.verifyPhoneNumber(phoneNumber: phoneNumber, timeout: null, verificationCompleted: null, verificationFailed: null, codeSent: null, codeAutoRetrievalTimeout: null);
  }

  Future<void> sendSMSRecoveryFireBaseCodeCallback({String phoneNumber, Duration timeout, int forceResendingToken, 
    void Function(AuthCredential) verificationCompleted, void Function(AuthException) verificationFailed, 
    void Function(String, [int]) codeSent, void Function(String) codeAutoRetrievalTimeout})  async {
    _firebaseAuth.verifyPhoneNumber(phoneNumber: phoneNumber, timeout: timeout, verificationCompleted: verificationCompleted,
     verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }


  Future<void> sendEmailRecoveryCode(String userEmail ) async {
    _firebaseAuth.sendPasswordResetEmail(email : userEmail);
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<dynamic> updatePasswordFunction(String _userId,String _newPassword) async {
    User newUser = new User(userId: _userId, password: _newPassword);
    var resData = await UsersProvider().updateUserPassword(user: newUser);
    return resData;
  }
  
  Future<dynamic> updatePassword(String _newPassword) async {  
    FirebaseUser user = await _firebaseAuth.currentUser();
    var resData = await user.updatePassword(_newPassword);
    return resData;
  }
}