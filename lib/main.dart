import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/call_sample/call_sample.dart';
import 'src/route_item.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum DialogDemoAction {
  cancel,
  connect,
}

class _MyAppState extends State<MyApp> {
  List<RouteItem> items = [];
  String _server = '';
  String _pass = '';
  late SharedPreferences _prefs;

  bool _datachannel = false;
  @override
  initState() {
    super.initState();
    _initData();
    _initItems();
  }

  _buildRow(context, item) {
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('WebRTC'),
          ),
          body: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: items.length,
              itemBuilder: (context, i) {
                return _buildRow(context, items[i]);
              })),
    );
  }

  _initData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
     // _server = _prefs.getString('server') ?? 'https://103.4.144.218:8091';
      _server = 'u15@xmpp.apigate.pro/Smack';
      _pass = '15';
    });
  }

  void showDemoDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        if (value == DialogDemoAction.connect) {
          _prefs.setString('server', _server);
          _prefs.setString('pass', _pass);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => _datachannel
                      ? CallSample(host: _server, pass: _pass,)
                      : CallSample(host: _server, pass: _pass,)));
        }
      }
    });
  }

  _showAddressDialog(context) {
    showDemoDialog<DialogDemoAction>(
        context: context,
        child: AlertDialog(
            title: const Text('Enter user/pass address:'),
            content: Column(
              children: [
                TextFormField(
                  initialValue: _server,
                  onChanged: (String text) {
                    setState(() {
                      _server = text;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: _server,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFormField(
                  initialValue: _pass,
                  onChanged: (String text) {
                    setState(() {
                      _pass = text;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: _pass,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context, DialogDemoAction.cancel);
                  }),
              FlatButton(
                  child: const Text('CONNECT'),
                  onPressed: () {
                    Navigator.pop(context, DialogDemoAction.connect);
                  })
            ]));
  }

  _initItems() {
    items = <RouteItem>[
      RouteItem(
          title: 'P2P Call',
          subtitle: 'P2P Call',
          push: (BuildContext context) {
            _datachannel = false;
            _showAddressDialog(context);
          }),
      /*RouteItem(
          title: 'Data Channel',
          subtitle: 'P2P Data',
          push: (BuildContext context) {
            _datachannel = true;
            _showAddressDialog(context);
          }),*/
    ];
  }
}
