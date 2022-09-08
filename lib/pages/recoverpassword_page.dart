import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/pages/passwordconfirmationemail_page.dart';
import 'package:kicks_trade/pages/recovercode_page.dart';
import 'package:kicks_trade/services/authentication.dart';
import 'package:kicks_trade/services/users_services.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';


class RecoverPasswordPage extends StatefulWidget {
  RecoverPasswordPage({this.auth, this.recoverCodeCallback});

  final BaseAuth auth;
  final void Function(dynamic verifCode) recoverCodeCallback;

  @override
  State<StatefulWidget> createState() => new _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _phoneNumber;
  String _phonenumberCountryCode;
  String _errorMessage;

  bool _isLoading;
  bool _smsOptionSelectd;
  bool _emailOptionSelectd;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true && (_smsOptionSelectd || _emailOptionSelectd);
    }
    return false;
  }

// Start Password Recovery Workflow
  void selectSMSOption() async {
    setState(() {
      _errorMessage = "";
      _isLoading = false;
      _smsOptionSelectd = true;
      _emailOptionSelectd = false;
    });
    String userId = "";
      try {
        toggleFormMode(_smsOptionSelectd, _emailOptionSelectd);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }

  // Start Password Recovery Workflow with email
  void selectEmailOption() async {
    setState(() {
      _errorMessage = "";
      _smsOptionSelectd = false;
      _emailOptionSelectd = true;
    });
    String userId = "";
      try {
        toggleFormMode(_smsOptionSelectd, _emailOptionSelectd);
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
  }



  // Start Password Recovery Workflow
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      if(_smsOptionSelectd){
        this.adaptPhoneNumberValues();
      }
      var checkUserExist =  _smsOptionSelectd ? await this.checkUserExist(this._phoneNumber) : await this.checkUserExist(this._email);

      dynamic userId =  checkUserExist != null ? checkUserExist.data['userId'] : 'FALSE';
      var rng = new Random.secure();
      var l = new List.generate(4, (_) => rng.nextInt(9));
      String verifCode = l[0].toString() + l[1].toString() + l[2].toString() + l[3].toString();
        try {
          

          if (userId != null && userId != '' && userId != 'FALSE' ) {
            if (_smsOptionSelectd) {
              
              var smsResult = await widget.auth.sendRecoveryWithCode(_phoneNumber, verifCode, userId, 'sms');
              if (smsResult['error_message'] == null && smsResult['error_code'] == null && ( smsResult['status'] == 'queued' ) ){
                  print('Success');
                  print('Recovery with sms in: $smsResult');
                  await _goNext(verifCode,userId);
                } else {
                  var errorMessage = smsResult['error_message'] != null ? smsResult['error_message'] : smsResult['message'];
                  errorMessage = errorMessage.toString().contains("not a valid phone number") ?  'Invalid phone number!' : errorMessage ; 
                   new Exception(errorMessage);
                }

            } else if (_emailOptionSelectd) {
              //await widget.auth.sendEmailRecoveryCode(_email);
              await widget.auth.sendRecoveryWithCode(_phoneNumber, verifCode, userId, 'email');
              print('Recovery with email: $userId');
              await _goNext(verifCode,userId);
              //await _goNextFromEmail(verifCode, userId);
            }
          } else {
            var errorMessage = "The user doesn't exist ";
              throw new Exception(errorMessage);
          }

          setState(() {
            _isLoading = false;
          });

          
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            _errorMessage = e.message ?? e.message;
            _formKey.currentState.reset();
          });
        }
      } else {
        setState(() {
            _isLoading = false;
          });
        Fluttertoast.showToast(
            msg: "You have to select one option",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0
        );
      }
  }

  dynamic checkUserExist (String userValue) async {
    
    //dynamic checkResult = usersProvider.getUserWithEmailOrNumber(dataValue: userValue);
    dynamic checkResult = await UsersService.getUserWithEmailOrNumber(dataValue: userValue);
    return checkResult;
  }

  void adaptPhoneNumberValues () {
    if(_phoneNumber.startsWith('0') )
    {
      _phoneNumber = '+' + _phonenumberCountryCode +  _phoneNumber.substring(1);
    }
    if(_phoneNumber.startsWith('00') )
    {
      _phoneNumber = '+' + _phonenumberCountryCode +  _phoneNumber.substring(2);
    }
    if(!_phoneNumber.startsWith('+'))
    {
      _phoneNumber = '+' + _phonenumberCountryCode +  _phoneNumber;
    }
    if(_phoneNumber.startsWith('+00'))
    {
      _phoneNumber = '+' + _phonenumberCountryCode +  _phoneNumber.substring(3);
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _email = "";
    _phoneNumber = "";
    _errorMessage = "";
    _isLoading = false;
    _smsOptionSelectd = false;
    _emailOptionSelectd = false;


    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode(bool _smsOptionSelectd, bool _emailOptionSelectd ) {
    resetForm();
    setState(() {
      _smsOptionSelectd = _smsOptionSelectd;
      _emailOptionSelectd = _emailOptionSelectd;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
      //bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 7'),
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
              showPageHeader(),
              showErrorMessage(),
              showRecoveryTextField(),
              showActionButton()
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
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
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 70.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );

  }


Widget showPasswordRecoveryLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 0.0),
      child: new Column(
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
           new Text('Password', style: new TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w600)),
           new Text('Recovery', style: new TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w600))
         ]
      ),
    );
  }



  Widget showPageHeader() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new Column (
          children : <Widget>[
            new Row(
              children: <Widget>[
                showPasswordRecoveryLabel(),
                showLogo()
              ],
          )
          ]
        )
        );
  }


 


  Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new Column(
            children: <Widget>[
              showSMSButton(),
              showEmailButton(),
              showContinueButton()
            ],
          )
        );
  }



 Widget showSMSButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 80.0,
          width: 200.0,
          child: new RaisedButton(
            elevation: 10.0,
            highlightElevation: 5.0,
            highlightColor: Colors.black,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: Colors.grey[300],
            child: new Row(
              children: <Widget>[
                Icon(Icons.perm_phone_msg, size: 30.0, color: Colors.grey, ),  // Based on passwordVisible state choose the icon 
                new Column( 
                  children : <Widget>[
                    new Text('', style: new TextStyle(fontSize: 20.0, color: Colors.transparent)),
                    new Text('  Via SMS ', style: new TextStyle(fontSize: 15.0, color: Colors.grey)),
                    //new Text('  +1 (404) 555-6699', style: new TextStyle(fontSize: 13.0, color: Colors.grey))
                    new Text('   +(###) ### - 1234', style: new TextStyle(fontSize: 13.0, color: Colors.grey))
                  ]
                )
              ],
            ),
            onPressed: selectSMSOption
          ),
        ));
  }



  Widget showEmailButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 80.0,
          width: 200.0,
          child: new RaisedButton(
            elevation: 10.0,
            highlightElevation: 5.0,
            highlightColor: Colors.black,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: Colors.grey[300],
            child: new Row(
              children: <Widget>[
                Icon(Icons.email, size: 30.0, color: Colors.grey, ),  // Based on passwordVisible state choose the icon 
                new Column( 
                  children : <Widget>[
                    new Text('', style: new TextStyle(fontSize: 20.0, color: Colors.transparent)),
                    new Text('  Via Email ', style: new TextStyle(fontSize: 15.0, color: Colors.grey)),
                    new Text('   ######@email.com', style: new TextStyle(fontSize: 13.0, color: Colors.grey))
                  ]
                )
              ],
            ),
            onPressed: selectEmailOption
          ),
        ));
  }


  Widget showContinueButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: 150.0,
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

  Widget showRecoveryTextField() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: _smsOptionSelectd ? 
          showNumberInput() : _emailOptionSelectd ? showEmailInput() : new Container(height: 0.0,)
        ));
  }

  Widget showEmailInput() {
    double inputWidth = MediaQuery.of(context).size.width * 0.3;
    return Padding(
      padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
      child: SizedBox(
        width: 200,
        child: Center(
          widthFactor: inputWidth,
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: 'john.doe@mail.com ',
            ),
            validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
            onSaved: (value) => _email = value.trim(),
          ),
        ),
      ),
    );
  }

Widget showNumberInput() {
  double inputWidth = MediaQuery.of(context).size.width * 0.3;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: SizedBox(
        width: inputWidth,
        child: Center(
          widthFactor: inputWidth,
          child: _buildCountryPickerDropdown( hasSelectedItemBuilder: true),
        ),
      ),
    );
  }

Widget showNumberInputOld() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '+1 (404) 555-6699 ',
            ),
        validator: (value) => value.isEmpty ? 'Number can\'t be empty' : null,
        onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  _goNext(String verifCode, String _userId) async {
    try {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              RecoverCodePage(auth: widget.auth,verifCode : verifCode, userId: _userId)
              )
            );
    } catch (e) {
      print(e);
    }
  }

  _goNextFromEmail(String verifCode, String _userId) async {
    try {
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              PasswordConfirmationEmailPage(auth: widget.auth)
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

  
  _buildCountryPickerDropdown(
      {bool filtered = false,
      bool sortedByIsoCode = false,
      bool hasPriorityList = false,
      bool hasSelectedItemBuilder = false}) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.3;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            icon:  Icon(
                // Based on passwordVisible state choose the icon
                Icons.arrow_drop_down,
                size: 30.0,
                color: Colors.black,
            ),
            /* underline: Container(
              height: 2,
              color: Colors.red,
            ),*/
            //show'em (the text fields) you're in charge now
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            //if you have menu items of varying size, itemHeight being null respects
            //that, IntrinsicHeight under the hood ;).
            itemHeight: null,
            //itemHeight being null and isDense being true doesn't play along
            //well together. One is trying to limit size and other is saying
            //limit is the sky, therefore conflicts.
            //false is default but still keep that in mind.
            isDense: false,
            //if you want your dropdown button's selected item UI to be different
            //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
            selectedItemBuilder: (Country country) => _buildDropdownSelectedItemBuilder(
                    country, dropdownSelectedItemWidth),
            //initialValue: 'AR',
            itemBuilder: (Country country) => _buildDropdownItemWithLongText(country, dropdownItemWidth),
            initialValue: 'AR',
            itemFilter: filtered
                ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
                : null,
            //priorityList is shown at the beginning of list
            priorityList: hasPriorityList
                ? [
                    CountryPickerUtils.getCountryByIsoCode('GB'),
                    CountryPickerUtils.getCountryByIsoCode('CN'),
                  ]
                : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              _phonenumberCountryCode = country.phoneCode;
              print("${country.name}");
            },
          ),
        ),
        SizedBox(
          width: 6.0,
        ),
        Expanded(
            child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.phone,
            autofocus: false,
            decoration: new InputDecoration(
                hintText: '### ####-1234 ',
                border: new OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                ),
            validator: (value) => value.isEmpty ? 'Number can\'t be empty' : null,
            onSaved: (value) => _phoneNumber = value.trim(),
          ),
        )
      ],
    );
  }


  Widget _buildDropdownItemWithLongText(
          Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth + 15,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text("(${country.isoCode})")),
            ],
          ),
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(
          Country country, double dropdownItemWidth) =>
      SizedBox(
          width: dropdownItemWidth,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
              child: Row(
                children: <Widget>[
                  //CountryPickerUtils.getDefaultFlagImage(country),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(child: Text("+${country.phoneCode}")),
                ],
              )));

}