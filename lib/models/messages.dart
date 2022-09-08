// messages.dart

import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:kicks_trade/constants/constants.dart';
import 'package:kicks_trade/utils/utils.dart';


class Messages {
  final String _accountSid;
  final String _authToken;

  const Messages(this._accountSid, this._authToken);

  Future<Map> create(data) async {
    var client = http.Client();

    var url =
        '$TWILIO_SMS_API_BASE_URL/Accounts/$_accountSid/Messages.json';

    try {
      var bodyText = data['body'];
      var fromText = data['from'];
      var toText = data['to'];
      var response = await client.post(url, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ' + toAuthCredentials(_accountSid, _authToken)
      }, body: {
        'From': fromText,
        'To': toText,
        'Body': bodyText
      });

      return (json.decode(response.body));
    } catch (e) {
      return ({'Runtime Error': e});
    } finally {
      client.close();
    }
  }
}