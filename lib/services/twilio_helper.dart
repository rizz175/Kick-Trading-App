import 'package:kicks_trade/models/messages.dart';


class TwilioHelper {
  final String _accountSid ;
  final String _authToken ;

  const TwilioHelper(this._accountSid, this._authToken);

  Messages get messages => Messages(_accountSid, _authToken);
}