import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_third_project/floor/database.dart';
import 'package:flutter_third_project/floor/person.dart';

import 'floor/person_dao.dart';

class FloorPage extends StatefulWidget {
  // final PersonDao personDao;
  // FloorPage(this.personDao);
  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState extends State<FloorPage> {
  var data;
  var textController = TextEditingController();
  var newId = 5;
  PersonDao personDao;

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
  }

  listPerson() {
    if (personDao == null)
      return Container();
    else
      return FutureBuilder<List<Person>>(
          future: personDao.findAllPersons(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
            if (snapshot == null || snapshot.data == null)
              return Container();
            else
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                      ),
                    );
                  });
          });
  }

  submitForm() async {
    var newName = textController.text;
    var person = Person(null, newName);
    await personDao.insertPerson(person);
    setState(() {});
  }

  clearSharedPreference() async {
    await personDao.deleteAllPersons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              child: Container(
                child: listPerson(),
              ),
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
