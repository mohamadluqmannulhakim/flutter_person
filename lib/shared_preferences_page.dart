import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPage extends StatefulWidget {
  @override
  _SharedPreferencesPageState createState() => _SharedPreferencesPageState();
}

class _SharedPreferencesPageState extends State<SharedPreferencesPage> {
  Future sharedPreferences = SharedPreferences.getInstance();
  var data;
  var textController = TextEditingController();
  final AppBar appBar = AppBar(
    title: Text(
      'Shared Preferences',
    ),
  );

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  loadPreferences() async {
    sharedPreferences.then((pref) {
      setState(() {
        data = pref.getString("simpan_data") ?? "Data: ";
      });
    });
  }

  submitForm() async {
    setState(() {
      data += textController.text;
      sharedPreferences.then((pref) {
        pref.setString("simpan_data", data);
      });
    });
  }

  clearSharedPreference() async {
    setState(() {
      sharedPreferences.then((pref) {
        pref.clear();
      });
    });
    loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      data = "Data: ";
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autocorrect: true,
                      controller: textController,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        submitForm();
                      },
                      child: Text("Submit"),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        clearSharedPreference();
                      },
                      child: Text("Clear Shared Preferences"),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 80,
              child: Text(data),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
