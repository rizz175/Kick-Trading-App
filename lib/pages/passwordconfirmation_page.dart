import 'package:flutter/material.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/services/authentication.dart';

class PasswordConfirmationPage extends StatefulWidget {
  PasswordConfirmationPage({this.auth, this.changePasswordConfirmationCallback});

  final BaseAuth auth;
  final VoidCallback changePasswordConfirmationCallback;

  @override
  State<StatefulWidget> createState() => new _PasswordConfirmationPageState();
}

class _PasswordConfirmationPageState extends State<PasswordConfirmationPage> {
  final _formKey = new GlobalKey<FormState>();

  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

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
  void confirmAndLogin() async {
      try {
        await _goNext();
        //widget.changePasswordConfirmationCallback();
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 4'),
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
              showSignInLabel(),
              showDescrtiptionLabel(),
              showActionButton(),
              showErrorMessage()
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
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 58.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );

  }


Widget showSignInLabel() {
    return new Hero(
      tag: 'herolabel',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 50.0,
          child: Icon(
            // Based on passwordVisible state choose the icon
            Icons.done,
            size: 100.0,
            color: Colors.white,
            ),
        ),
      ),
    );
  }

  Widget showDescrtiptionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: new Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        children: <Widget>[
          new Text('You have successfully reset your password.', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: HexColor.fromHex(APP_COLOR_RED))),
          new Text('Click the Sign In button below and start swapping kicks!', style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0, color: HexColor.fromHex(APP_COLOR_RED)))
        ],
      )
    );
  }

Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: new Column (
          children : <Widget>[
            showSignInButton()
          ]
        )
        );
  }


  Widget showSignInButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: 130.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: HexColor.fromHex(APP_COLOR_RED),
            child: new Text('Sign In',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: confirmAndLogin,
          ),
        ));
  }

  _goNext() async {
    try {
      Navigator.popUntil(context, (r) => r.isFirst);
    } catch (e) {
      print(e);
    }
  }


}