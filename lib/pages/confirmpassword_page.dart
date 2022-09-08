import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/pages/passwordconfirmation_page.dart';
import 'package:kicks_trade/services/authentication.dart';

class ConfirmPasswordPage extends StatefulWidget {
  ConfirmPasswordPage({this.auth, this.userId, this.verifCode, this.changePasswordCallback});

  final BaseAuth auth;
  final String userId;
  final String verifCode;
  final VoidCallback changePasswordCallback;

  @override
  State<StatefulWidget> createState() => new _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  final _formKey = new GlobalKey<FormState>();

  String _password;
  String _confirmpassword;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;
  bool passwordVisible = true;
  bool confirmpasswordVisible = true;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    
    if (validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      try {
        
        setState(() {
          _isLoading = false;
        });

        if (_password == _confirmpassword ) {
          var resData = await widget.auth.updatePasswordFunction(widget.userId, _password);
          //var resData = await widget.auth.updatePassword(_password);
          await _goNext();
          //widget.changePasswordCallback();
        } else  {
          throw new Exception("The password don't match . Try Again ");
        }
        
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          var _errormessage = e.message != null ? e.message : 'Unknown error';
          _errorMessage = _errormessage;
          _formKey.currentState.reset();
        });
      }
    }
  }

  void beforeValidateAndSubmit() async {
    
    Fluttertoast.showToast(
            msg: " This feature will be available soon ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0
        );
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    passwordVisible = true;
    confirmpasswordVisible = true;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 1'),
        body: Center(
          child: SingleChildScrollView(
            child: Stack(
            children: <Widget>[
              _showForm(),
              _showCircularProgress(),
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
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showErrorMessage(),
              showPasswordLabel(),
              showPasswordInput(),
              showConfirmPasswordLabel(),
              showConfirmPasswordInput(),
              showActionButton()
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
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 38.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );

  }

  Widget showPasswordLabel() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
        child: new Text('Password', style: new TextStyle(fontSize: 18.0, color: HexColor.fromHex(APP_COLOR_RED))),
      );
    }

  Widget showConfirmPasswordLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
      child: new Text('Confirm Password', style: new TextStyle(fontSize: 18.0, color: HexColor.fromHex(APP_COLOR_RED))),
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
              onChanged: (value) => {
                if (_errorMessage.length > 0 && _errorMessage != null) {
                  setState(() { 
                    _errorMessage = '';
                  })
                }
              },
              onSaved: (value) => _password = value.trim(),
        ),
    );
  }

  Widget showConfirmPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: TextFormField(
      keyboardType: TextInputType.text,
      maxLines: 1,
      obscureText: confirmpasswordVisible,//This will obscure text dynamically
      decoration: InputDecoration(
          hintText: 'Confirm your password',
          // Here is key idea
          suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  !confirmpasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
                  color: Colors.grey[400],
                  ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                      confirmpasswordVisible = !confirmpasswordVisible;
                  });
                },
                ),
              ),
              validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
              onChanged: (value) => {
                if (_errorMessage.length > 0 && _errorMessage != null) {
                  setState(() { 
                    _errorMessage = '';
                  })
                }
              },
              onSaved: (value) => {
                if (_errorMessage.length > 0 && _errorMessage != null) {
                  setState(() { 
                    _errorMessage = '';
                  })
                },
                _confirmpassword = value.trim()
              },
        ),
    );
  }

 Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Column (
          children : <Widget>[
            showContinueButton()
          ]
        )
        );
  }


  Widget showContinueButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 60.0,
          width: 280.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: HexColor.fromHex(APP_COLOR_RED),
            child: new Text('Continue',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  _goNext() async {
    try {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              PasswordConfirmationPage(auth: widget.auth)
              )
            );
    } catch (e) {
      print(e);
    }
  }

}