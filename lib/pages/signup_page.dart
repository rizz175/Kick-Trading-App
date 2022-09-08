import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';
import 'package:kicks_trade/services/authentication.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';


class SignUpPage extends StatefulWidget {
  SignUpPage({this.auth, this.loginCallback, this.homeCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback homeCallback;

  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _fullname;
  String _email;
  String _password;
  String _phonenumber;
  String _phonenumberCountryCode;
  String _errorMessage;
  bool checkBoxValue = false;
  bool checkBoxValueTristate = false;
  bool passwordVisible = false;

  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true && checkBoxValue;
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
      String userId = "";
      try {

        this.adaptPhoneNumberValues();
        userId = await widget.auth.signUpFunctions(_fullname,_email, _password, _phonenumber);
        //userId = await widget.auth.signUpWithNumber(_email, _password, _phonenumber);
        print('Signed up user: $userId');
        

        if (userId != null && userId.length > 0  ) {
          setState(() {
            _isLoading = false;
          });
          widget.homeCallback();
          //widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unknow Error';
          _errorMessage = e.message ?? e.message ;
          _formKey.currentState.reset();
        });
      }
    } else if (!checkBoxValue) {
        setState(() {
            _isLoading = false;
          });
        Fluttertoast.showToast(
            msg: "Please accept Terms of service",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0
        );
      }
  }

  void adaptPhoneNumberValues () {
    if(_phonenumber.startsWith('0') )
    {
      _phonenumber = '+' + _phonenumberCountryCode +  _phonenumber.substring(1);
    }
    if(_phonenumber.startsWith('00') )
    {
      _phonenumber = '+' + _phonenumberCountryCode +  _phonenumber.substring(2);
    }
    if(!_phonenumber.startsWith('+'))
    {
      _phonenumber = '+' + _phonenumberCountryCode +  _phonenumber;
    }
    if(_phonenumber.startsWith('+00'))
    {
      _phonenumber = '+' + _phonenumberCountryCode +  _phonenumber.substring(3);
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    passwordVisible = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }


  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //bottomNavigationBar: new FooterAdsPage(adsText:'Advertising 8'),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: new AppBar(
            backgroundColor: Colors.white,
            leading: new FlatButton(
              child: Icon(
              // Based on passwordVisible state choose the icon
                Icons.arrow_back,
                size: 30.0,
                color: HexColor.fromHex(APP_COLOR_RED),
              ),
              onPressed: _goBack)
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
    //   return Container(
    //   height: 0.0,
    //   width: 0.0,
    // );
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              showPageHeader(),
              showErrorMessage(),
              showFullNameLabel(),
              showFullNameInput(),
              showEmailLabel(),
              showEmailInput(),
              showPasswordLabel(),
              showPasswordInput(),
              showMobileNumberLabel(),
              showMobileNumberInput(),
              showConditionsButton(),
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
        padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: Image.asset('assets/images/KicksTrade.png'),
        ),
      ),
    );
  }


Widget showSignInLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: new Text('Sign Up ', style: new TextStyle(fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.w600),
    ));
  }

  Widget showPageHeader() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new Column (
          children : <Widget>[
            new Row(
              children: <Widget>[
                showSignInLabel(),
                showLogo()
              ],
          )
          ]
        )
        );
  }


Widget showFullNameLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
      child: new Text('Full Name', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

Widget showEmailLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 6.0, 0.0, 0.0),
      child: new Text('Email', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

  Widget showPasswordLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 6.0, 0.0, 0.0),
      child: new Text('Password', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

  Widget showMobileNumberLabel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 6.0, 0.0, 0.0),
      child: new Text('Mobile Number', style: new TextStyle(fontSize: 20.0, color: HexColor.fromHex(APP_COLOR_RED))),
    );
  }

  Widget showFullNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Your Full Name ',
            ),
        validator: (value) => value.isEmpty ? 'Full Name can\'t be empty' : null,
        onSaved: (value) => _fullname = value.trim(),
      ),
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
            hintText: 'Your Email Address',
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

  Widget showMobileNumberInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: 
              _buildCountryPickerDropdown( hasSelectedItemBuilder: true),
    );
  }

Widget showMobileNumberInput2() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: Column(
        children: <Widget>[
              _buildCountryPickerDropdown( hasSelectedItemBuilder: true),
        ],
      ),
    );
  }

  Widget showMobileNumberInputOld() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
      child: Column(
        children: <Widget>[
          new TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.phone,
                autofocus: false,
                decoration: new InputDecoration(
                    //hintText: '(###) ###-####',
                    hintText: '+1 (404) 555-6699',
                    ),
                validator: (value) => value.isEmpty ? 'Number can\'t be empty' : null,
                onSaved: (value) => _phonenumber = value.trim(),
              ),
        ],
      ),
    );
  }

Widget showConditionsButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Row(
          children : <Widget>[
            showTickBoxButton(),
            showConditionsText()
          ]
        )
        );
  }

Widget showActionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Wrap (
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children : <Widget>[
            showSignUpButton()
          ]
        )
        );
  }


  Widget showSignUpButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: SizedBox(
          height: 60.0,
          width: 140.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0)),
            color: HexColor.fromHex(APP_COLOR_RED),
            child: new Text('Sign Up',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget showTickBoxButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(30.0, 5.0, 0.0, 0.0),
        child: SizedBox(
          height: 30.0,
          width: 30.0,
          child: new Checkbox(
            value:checkBoxValue,
            onChanged: (bool newValue) { 
              setState(() {
                checkBoxValue = newValue;
              });
            }, 
           activeColor: HexColor.fromHex(APP_COLOR_RED),
           checkColor: Colors.white,
           autofocus: false,

           ),
        ));
  }

  Widget showConditionsText() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
        child: new Row (
          children : <Widget>[
            new Text('I agree to the ', style: new TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w400)),
            new Text('Terms of Services ', style: new TextStyle(fontSize: 16.0, color: HexColor.fromHex(APP_COLOR_RED), fontWeight: FontWeight.w700)),
          ]
        )
        );
  }

_goBack() async {
    try {
      Navigator.pop(context);
      //widget.loginCallback();
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
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
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
            selectedItemBuilder: hasSelectedItemBuilder == true
                ? (Country country) => _buildDropdownSelectedItemBuilder(
                    country, dropdownSelectedItemWidth)
                : null,
            //initialValue: 'AR',
            itemBuilder: (Country country) => hasSelectedItemBuilder == true
                ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
                : _buildDropdownItem(country, dropdownItemWidth),
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
          width: 8.0,
        ),
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.phone,
            autofocus: false,
            decoration: new InputDecoration(
              //hintText: '(###) ###-####',
              //hintText: '+1 (404) 555-6699',
              labelText: 'Phone',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            validator: (value) => value.isEmpty ? 'Number can\'t be empty' : null,
            onSaved: (value) => _phonenumber = value.trim(),
          ),
          // child: TextField(
          //   decoration: InputDecoration(
          //     labelText: "Phone",
          //     isDense: true,
          //     contentPadding: EdgeInsets.zero,
          //   ),
          //   keyboardType: TextInputType.number,
          // ),
        )
      ],
    );
  }

  Widget _buildDropdownItem(Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
          ],
        ),
      );

  Widget _buildDropdownItemWithLongText(
          Country country, double dropdownItemWidth) =>
      SizedBox(
        width: dropdownItemWidth + 15,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Expanded(child: Text("(${country.isoCode})")),
              //Expanded(child: Text("+${country.phoneCode}")),
              //Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
              //Expanded(child: Text("${country.name}")),
            ],
          ),
        ),
      );

  Widget _buildDropdownSelectedItemBuilder(
          Country country, double dropdownItemWidth) =>
      SizedBox(
          width: dropdownItemWidth,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  //CountryPickerUtils.getDefaultFlagImage(country),
                  SizedBox(
                    width: 8.0,
                  ),
                  Expanded(child: Text("+${country.phoneCode}")),
                  //Expanded(child: Text("+${country.phoneCode}(${country.isoCode})")),
                  //Expanded( child: Text('${country.name}', style: TextStyle( color: Colors.red, fontWeight: FontWeight.bold),)),
                ],
              )));

}