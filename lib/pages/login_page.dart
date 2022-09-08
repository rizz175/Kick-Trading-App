import 'package:flutter/material.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/pages/recoverpassword_page.dart';
import 'package:kicks_trade/pages/signup_page.dart';
import 'package:kicks_trade/services/authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback, this.signUpCallback, this.homeCallback, this.forgotPasswordCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback signUpCallback;
  final VoidCallback homeCallback;
  final VoidCallback forgotPasswordCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  bool passwordVisible = false;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login 
  void validateAndSubmit() async {
    
    if (validateAndSave()) {
        setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email, _password);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null ) {
          widget.loginCallback();
        }

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.code == "ERROR_USER_NOT_FOUND" ? "Invalid Credentials" 
          : e.code == "ERROR_INVALID_EMAIL" ? "Invalid Email" : "Sorry Incorrect username or password"; //e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  // Perform  signup
  void openSignUp() async {
    setState(() {
      _errorMessage = "";
    });
      try {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              SignUpPage(
                auth: widget.auth,
                loginCallback: widget.loginCallback,
                homeCallback: widget.homeCallback,
                )
              ),
            );
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }

  // Perform  signup
  void openSignUpCallBack() async {
    setState(() {
      _errorMessage = "";
    });
      try {
        widget.signUpCallback();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }
  
  // Perform  signup
  void openForgotPassword() async {
    setState(() {
      _errorMessage = "";
    });
      try {
        Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              RecoverPasswordPage(
                auth: widget.auth,
                )
              ),
            );
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }


  // Perform forgot password
  void openForgotPasswordCallback() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
      try {
        widget.forgotPasswordCallback();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    passwordVisible = true;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void goToForgotPassword() {
    resetForm();
    openForgotPassword();
  }

  void goToSignUpPage() {
    resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
          child: new SingleChildScrollView(
            child: Stack(
            children: <Widget>[
              _showForm(),
              _showCircularProgress()
            ],
          ),
        ),
      )
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showSignInLabel(),
              showDescrtiptionLabel(),
              SizedBox(height: 15),
              showErrorMessage(),
              showEmailLabel(),
              showEmailInput(),
              showPasswordLabel(),
              showPasswordInput(),
              showActionButton(),
              showSecondaryButton()
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Padding(
        padding: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
        child: Text(
        _errorMessage,
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.red,
                height: 1.0,
                fontWeight: FontWeight.w300),
          ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'herologo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );

  }


Widget showSignInLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
      child: new Text('Sign In', style: new TextStyle(fontSize: 35.0, color: Colors.black, fontWeight: FontWeight.w600),
    ));
  }

  Widget showDescrtiptionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
      child: new Text('Start swapping Kicks!', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

Widget showEmailLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
      child: new Text('Email', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

  Widget showPasswordLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
      child: new Text('Password', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Your email address',
            ),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: TextFormField(
      keyboardType: TextInputType.text,
      maxLines: 1,
      obscureText: passwordVisible,//This will obscure text dynamically
      decoration: InputDecoration(
          hintText: 'Your password',
          // Here is key idea
          suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  !passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
                  color: Colors.grey[400],
                  ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                      passwordVisible = !passwordVisible;
                  });
                },
                ),
              ),
              validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
              onSaved: (value) => _password = value.trim(),
        ),
    );
  }

   Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Column (
          children : <Widget>[
            new Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: <Widget>[
                showSignInButton(),
                showSignUpButton()
              ],
          )
          ]
        )
        );
  }

  Widget showSignInButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: 120.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: HexColor.fromHex(APP_COLOR_RED),
            child: new Text('Sign In',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showSignUpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: 120.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: HexColor.fromHex(APP_COLOR_RED),
            child: new Text('Sign Up',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: openSignUp,
          ),
        ));
  }

    Widget showSecondaryButton() {
      return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new FlatButton(
        child: new Text('Forgot Password ?',
            style: new TextStyle(fontSize: 18.0, 
            fontWeight: FontWeight.w900, color: HexColor.fromHex(APP_COLOR_RED))),
        onPressed: goToForgotPassword)
        );
    }
  
}