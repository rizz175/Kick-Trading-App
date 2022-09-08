import 'package:flutter/material.dart';
import 'package:kicks_trade/pages/login_page.dart';
import 'package:kicks_trade/pages/signup_page.dart';
import 'package:kicks_trade/services/authentication.dart';
import 'package:kicks_trade/pages/home_page.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  FORGOT_PASSWORD,
  CHANGE_PASSWORD,
  RECOVER_CODE,
  RECOVER_CODE_SUCCESS,
  SIGNING_UP,
  LOGGED_IN,
  LOGGED_IN_FROM_SIGNUP,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String verifCode = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void homeCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
          _userId = user.uid.toString();
          authStatus = AuthStatus.LOGGED_IN_FROM_SIGNUP;
        });
    });
  }

    void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        setState(() {
          _userId = user.uid.toString();
          authStatus = AuthStatus.LOGGED_IN;
        });
      } else {
        setState(() {
          authStatus = AuthStatus.NOT_LOGGED_IN;
          _userId = '';
        });
      }
    });
    
  }

  void signUpCallback() {
    setState(() {
      authStatus = AuthStatus.SIGNING_UP;
    });
  }

  void forgotPasswordCallback() {
    setState(() {
      authStatus = AuthStatus.FORGOT_PASSWORD;
    });
  }
  
  void changePasswordCallback() {
    setState(() {
      authStatus = AuthStatus.CHANGE_PASSWORD;
    });
  }
  
  void changePasswordConfirmationCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }
  
  void recoverCodeCallback(_verifCode) {
    setState(() {
      authStatus = AuthStatus.RECOVER_CODE;
      this.verifCode = _verifCode;
    });
  }
  
  void passwordChangeCallback(_verifCode) {
    setState(() {
      authStatus = AuthStatus.RECOVER_CODE_SUCCESS;
    });
  }

  void recoverCodeSuccessCallback(_verifCode) {
    setState(() {
      authStatus = AuthStatus.RECOVER_CODE_SUCCESS;
      this.verifCode = verifCode;
    });
  }
  

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
          signUpCallback: signUpCallback,
          homeCallback: homeCallback,
          forgotPasswordCallback: forgotPasswordCallback,
        );
        break;
      case AuthStatus.SIGNING_UP:
        return new SignUpPage(
          auth: widget.auth,
          loginCallback: loginCallback,
          homeCallback: homeCallback,
        );
        break;
      case AuthStatus.LOGGED_IN_FROM_SIGNUP:
        if (_userId.length > 0 && _userId != null) {
          try {
            Navigator.pop(context);
            return new HomePage(
              userId: _userId,
              auth: widget.auth,
              logoutCallback: logoutCallback,
            );
          } catch (e) {
            print(e);
          }
        } else
            return buildWaitingScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
            return buildWaitingScreen();
        // if (_userId.length > 0 && _userId != null) {
        //   Navigator.pushAndRemoveUntil(context, 
        //       MaterialPageRoute(builder: (context) => 
        //       new HomePage(
        //           userId: _userId,
        //           auth: widget.auth,
        //           logoutCallback: logoutCallback,
        //         )
        //       ),
        //     (r) => r.isFirst);
        // } else
        // return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
    } catch (e) {
      return buildWaitingScreen();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   switch (authStatus) {
  //     case AuthStatus.NOT_DETERMINED:
  //       return buildWaitingScreen();
  //       break;
  //     case AuthStatus.NOT_LOGGED_IN:
  //       return new LoginPage(
  //         auth: widget.auth,
  //         loginCallback: loginCallback,
  //         signUpCallback: signUpCallback,
  //         forgotPasswordCallback: forgotPasswordCallback,
  //       );
  //       break;
  //     case AuthStatus.SIGNING_UP:
  //       return new SignUpPage(
  //         auth: widget.auth,
  //         loginCallback: loginCallback,
  //       );
  //       break;
  //     case AuthStatus.FORGOT_PASSWORD:
  //       return new RecoverPasswordPage(
  //         auth: widget.auth,
  //         recoverCodeCallback: recoverCodeCallback,
  //       );
  //       break;
  //     case AuthStatus.RECOVER_CODE:
  //       return new RecoverCodePage(
  //         auth: widget.auth,
  //         verifCode : this.verifCode,
  //         recoverCodeSuccessCallback: recoverCodeSuccessCallback,
  //       );
  //       break;
  //     case AuthStatus.RECOVER_CODE_SUCCESS:
  //       return new ConfirmPasswordPage(
  //         auth: widget.auth,
  //         verifCode : verifCode,
  //         changePasswordCallback: changePasswordCallback,
  //       );
  //       break;
  //     case AuthStatus.CHANGE_PASSWORD:
  //       return new PasswordConfirmationPage(
  //         auth: widget.auth,
  //         changePasswordConfirmationCallback: changePasswordConfirmationCallback,
  //       );
  //       break;
  //     case AuthStatus.LOGGED_IN:
  //       if (_userId.length > 0 && _userId != null) {
  //         return new HomePage(
  //           userId: _userId,
  //           auth: widget.auth,
  //           logoutCallback: logoutCallback,
  //         );
  //       } else
  //         return buildWaitingScreen();
  //       break;
  //     default:
  //       return buildWaitingScreen();
  //   }
  // }
}