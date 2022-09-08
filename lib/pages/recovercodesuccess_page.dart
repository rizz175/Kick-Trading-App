import 'package:flutter/material.dart';
import 'package:kicks_trade/components/footerads_page.dart';
import 'package:kicks_trade/services/authentication.dart';

class RecoverCodeSuccessPage extends StatefulWidget {
  RecoverCodeSuccessPage({this.auth, this.recoverCodeSuccessCallback});

  final BaseAuth auth;
  final VoidCallback recoverCodeSuccessCallback;

  @override
  State<StatefulWidget> createState() => new _RecoverCodeSuccessPageState();
}

class _RecoverCodeSuccessPageState extends State<RecoverCodeSuccessPage> {
  final _formKey = new GlobalKey<FormState>();

  String _digit1;
  String _digit2;
  String _digit3;
  String _digit4;

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
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          //userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          //userId = await widget.auth.signUp(_email, _password);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
          widget.recoverCodeSuccessCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
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
      bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 6'),
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
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showSignInLabel(),
              showDescrtiptionLabel(),
              new Row( children: <Widget>[ showDigit1Input(), showDigit2Input(), showDigit3Input(), showDigit4Input()]),
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
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
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
      padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: new Text('Enter 4-Digit Recovery Code', style: new TextStyle(fontSize: 35.0, color: Colors.red, fontWeight: FontWeight.w600),
    ));
  }

  Widget showDescrtiptionLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: new Text('The recovery code was sent to your mobile device or email address', style: new TextStyle(fontSize: 15.0, color: Colors.red)),
    );
  }

Widget showEmailLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: new Text('Email', style: new TextStyle(fontSize: 20.0, color: Colors.red)),
    );
  }

  Widget showPasswordLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: new Text('Password', style: new TextStyle(fontSize: 20.0, color: Colors.red)),
    );
  }

  Widget showDigit1Input() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '',
            ),
        validator: (value) => value.isEmpty ? '' : null,
        onSaved: (value) => _digit1 = value.trim(),
      ),
    );
  }

  Widget showDigit2Input() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '',
            ),
        validator: (value) => value.isEmpty ? '' : null,
        onSaved: (value) => _digit2 = value.trim(),
      ),
    );
  }

  Widget showDigit3Input() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '',
            ),
        validator: (value) => value.isEmpty ? '' : null,
        onSaved: (value) => _digit3 = value.trim(),
      ),
    );
  }

  Widget showDigit4Input() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '',
            ),
        validator: (value) => value.isEmpty ? '' : null,
        onSaved: (value) => _digit4 = value.trim(),
      ),
    );
  }


  Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Row(
            children: <Widget>[
              showContinueButton()
            ],
          )
        );
  }

  Widget showContinueButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(50.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: Colors.red,
            child: new Text('Continue',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

}