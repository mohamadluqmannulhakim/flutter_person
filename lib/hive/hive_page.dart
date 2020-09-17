import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_third_project/floor/database.dart';
import 'package:flutter_third_project/floor/person.dart';

import 'floor/person_dao.dart';

class HivePage extends StatefulWidget {
  @override
  _HivePageState createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  PersonDao personDao;
  var data;
  var textController = TextEditingController();
  var newId = 5;

  final AppBar appBar = AppBar(
    title: Text(
      'Floor',
    ),
  );

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  loadPreferences() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    personDao = database.personDao;
    StreamBuilder<Person>(
        stream: personDao.findPersonById(newId),
        builder: (context, snapshot) {
          data = snapshot.data.name == null ? "Data: " : snapshot.data.name;
          return data;
        });
  }

  submitForm() async {
    var newName = textController.text;
    var person = Person(null, newName);
    await personDao.insertPerson(person);
    setState(() {
      data = person.name;
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
