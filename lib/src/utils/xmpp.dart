import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:async';

import 'package:flutter_xmpp/flutter_xmpp.dart';

//set your host like 103.4.100.214
const hostIP = "";

class XMPP {

  //user1
  String receiver2 = "u15@xmpp.apigate.pro/Smack";
  String receiver1 = "u12@xmpp.apigate.pro/Smack";

  String status = 'diconnected';

  var flutterXmpp;

  Random random = Random(10);

  String user;
  String pass;

  //var _socket;
  Function()? onOpen;
  Function(dynamic msg)? onMessage;
  Function(int code, String reaso)? onClose;

  XMPP(this.user, this.pass);

  connect() async {
    var auth = {
      "user_jid": user,
      "password": pass,
      "host": hostIP,
      "port": 5222
    };

    flutterXmpp = new FlutterXmpp(auth);

    // login
    await flutterXmpp.login();

    // start listening receive message
    await flutterXmpp.start(_onReceiveMessage, _onError);

    sleep(const Duration(seconds: 2)); // just sample wait for get current state

    print(await flutterXmpp.currentState());

    onOpen?.call(); // get current state

    status = await flutterXmpp.currentState(); // get current state

  }

  send(data) async {
    if (flutterXmpp != null) {
      await flutterXmpp.sendMessage(
          user == receiver1 ? receiver2 : receiver1, data, user);
      //print('send: $data');
    }
  }

  close() {
    if (flutterXmpp != null) flutterXmpp.logout();
  }

  void _onReceiveMessage(dynamic event) {
    print("event:: " + event.toString());


    if (event["type"] == "incoming") {
      onMessage?.call(event);

    //rerceiveMessageBody = event['id']; // chat ID
    } else {
    if(event.toString().contains("bye")){
    onMessage?.call(event);
    }

    }
  }

  void _onError(Object error) {
    print(error);
  }

}
