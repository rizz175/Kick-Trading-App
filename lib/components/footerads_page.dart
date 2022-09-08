import 'package:flutter/material.dart';
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/extensions/HexColor.dart';

class FooterAdsPage extends StatefulWidget {
  FooterAdsPage({this.adsText});

  final String adsText;


  @override
  State<StatefulWidget> createState() => new _FooterAdsPageState();
}

class _FooterAdsPageState extends State<FooterAdsPage> {
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return displayFooterAd();
  }

  


  Widget displayFooterAd() {
    return new Container(
          alignment: Alignment.center,
          height: 50.0,
          decoration: new BoxDecoration(
              color: HexColor.fromHex(APP_COLOR_YELLOW),
              border: new Border.all(
                  width: 1.0,
                  color: Colors.black
              ),
              borderRadius: new BorderRadius.circular(4.0)
          ),
          child: new Text(
          widget.adsText,
          style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
  }

}