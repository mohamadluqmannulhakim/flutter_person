import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HivePage extends StatefulWidget {
  @override
  _HivePageState createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  var data;
  var textController = TextEditingController();
  Box box;
  var newId = 5;

  final AppBar appBar = AppBar(
    title: Text(
      'Hive',
    ),
  );

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  loadPreferences() async {
    // Get Directory
    final directory = await getApplicationDocumentsDirectory();

    // initialize Hive
    Hive.init(directory.path);

    box = await Hive.openBox("box_person");
    setState(() {
      Hive.openBox("box_person");
      data = box.get("data") ?? "Data: ";
    });
  }

  submitForm() async {
    var newName = textController.text;
    box.put("data", newName);
    setState(() {
      data = newName;
    });
  }

  clearSharedPreference() async {
    setState(() {
      /* personDao.then((pref) {
        pref.clear();
      }); */
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
