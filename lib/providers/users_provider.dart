import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kicks_trade/models/user.dart';
import 'package:kicks_trade/services/users_services.dart';



class UsersProvider with ChangeNotifier {
  
  final Firestore firestore = Firestore.instance;

  bool pushRoutes = true;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  bool _signinError = false;
  bool get signinError => _signinError;

  User _userx;
  User get userx => _userx;

  bool _shouldContinue = true;

/* ------------------------------- NOTE Users ------------------------------- */
  List<User> _users = [];
  List<User> get users => _users;

  Future initState() async {
    var res = await UsersService.streamUsers();
    res.listen((r) {
      _users = r;
      notifyListeners();
    });
  }

  Future<bool> signInWithEmailAndPassword({@required String email, @required String password}) async {
    _signinError = false;
    _isSigningIn = true;
    notifyListeners();

    email.trim().toLowerCase();

    bool shouldContinue = await UsersService.signInWithEmailAndPaddword(email: email, password: password);

    _isSigningIn = false;
    if (!shouldContinue) _signinError = true;
    notifyListeners();

    return shouldContinue;
  }

  Future updateUser({@required User user, @required bool isRegistering}) async {
    return await UsersService.updateUser(user: user, isRegistering: isRegistering);
  }

  Future updateUserVerifCode({User user}) async {
    await UsersService.updateUserVerifCode(user: user);
  }

  Future updateUserPassword({User user}) async {
    await UsersService.updateUserPassword(user: user);
  }

  Future getUserWithEmailOrNumber({String dataValue}) async {
    await UsersService.getUserWithEmailOrNumber(dataValue: dataValue);
  }
}