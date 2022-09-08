import 'package:flutter/material.dart';
import 'package:kicks_trade/components/verification_code_input.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/pages/confirmpassword_page.dart';
import 'package:kicks_trade/services/authentication.dart';

class RecoverCodePage extends StatefulWidget {
  RecoverCodePage({this.auth, this.verifCode,  this.userId, this.recoverCodeSuccessCallback});

  final BaseAuth auth;
  final String verifCode;
  final String userId;
  final Function(dynamic verifCode) recoverCodeSuccessCallback;

  @override
  State<StatefulWidget> createState() => new _RecoverCodePageState();
}

class _RecoverCodePageState extends State<RecoverCodePage> {
  final _formKey = new GlobalKey<FormState>();

  String _digitValue;

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
    
    if (validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      try {
        setState(() {
          _isLoading = false;
        });
        
        if (checkCodeEquality() ) {
          _goNext();
          //widget.recoverCodeSuccessCallback(widget.verifCode);
        } else  {
          throw new Exception("The code you entered doesn't match the code sent. Try Again ");
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

  bool checkCodeEquality () {
    
    bool checkResult = _digitValue != null && _digitValue != '' && widget.verifCode != null && widget.verifCode != '' && 
    _digitValue.trim().toLowerCase() == widget.verifCode.trim().toLowerCase();
    return checkResult;
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
      //bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 5'),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child:new AppBar(
            backgroundColor: Colors.white,
            leading: new FlatButton(
              child: Icon(
              // Based on passwordVisible state choose the icon
                Icons.arrow_back,
                size: 30.0,
                color: HexColor.fromHex(APP_COLOR_RED),
              ),
              onPressed: _goBack
              )
          )
        ),
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
              showErrorMessage(),
              showDigitInput(),
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
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 45.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );

  }


Widget showSignInLabel() {
  return new Column(
      children: <Widget> [
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Text('Enter 4-Digit Recovery Code', 
            style: new TextStyle(fontSize: 23.0, color: HexColor.fromHex(APP_COLOR_RED), fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            ),
        )
      ]
      );
  }

  Widget showDescrtiptionLabel() {
    return new Column(
      children: <Widget> [
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Text('The recovery code was sent to your mobile device ', 
            style: new TextStyle(fontSize: 15.0, color: HexColor.fromHex(APP_COLOR_RED)),
            textAlign: TextAlign.center,
            ),
        )
      ]
      );
  }

  Widget showDigitInput() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: Column (
            children: <Widget>[
              VerificationCodeInput(
                keyboardType: TextInputType.phone,
                length: 4,
                autofocus: true,
                onCompleted: (String uservalue) {
                _digitValue = uservalue;
                  },
                )
              ]
            ),
        ));
  }


  Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: new Column(
            children: <Widget>[
              showContinueButton()
            ],
          )
        );
  }

  Widget showContinueButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
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
              ConfirmPasswordPage(auth: widget.auth, userId: widget.userId)
              )
            );
    } catch (e) {
      print(e);
    }
  }

  _goBack() async {
    try {
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

}