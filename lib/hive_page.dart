import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_third_project/hive/hive_person.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HivePage extends StatefulWidget {
  @override
  _HivePageState createState() => _HivePageState();
}

class _HivePageState extends State<HivePage> {
  var textController = TextEditingController();
  Box box;

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
    Hive.registerAdapter(HivePersonAdapter());

    box = await Hive.openBox("box_person");
  }

  listPerson() {
    if (box == null || box.length == null)
      return Container();
    else {
      print(box.length);
      return ListView.builder(
        itemCount: box.length,
        itemBuilder: (context, index) {
          final item = box.getAt(index);
          return Card(
            child: ListTile(
              title: Text(item.name),
            ),
          );
        },
      );
    }
  }

  submitForm() async {
    var newName = textController.text;
    HivePerson hivePerson = new HivePerson(1, newName);
    // "data" + box.length.toString() -> create unique id
    box.put("data" + box.length.toString(), hivePerson);
    setState(() {});
  }

  clearSharedPreference() async {
    box.clear();
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
    Hive.close();
    super.dispose();
  }
}
