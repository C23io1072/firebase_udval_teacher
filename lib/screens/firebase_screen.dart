import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:g_json/g_json.dart';

class MyFirebaseTeacher extends StatefulWidget {
  const MyFirebaseTeacher({super.key});

  @override
  State<MyFirebaseTeacher> createState() => _MyFirebaseTeacherState();
}

class _MyFirebaseTeacherState extends State<MyFirebaseTeacher> {
  FirebaseDatabase database = FirebaseDatabase.instance;

  String name = '';
  String gender = '';

  List<JSON> data = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference ref = database.ref('students');
    print('firebase test${database.app.name}');

    ref.get().then((snapshot) {
      print(snapshot.value);
      data = snapshot.children.map((e) => JSON(e.value)).toList();
      setState(() {});
    });

    // FB-ruugaa neg l udaa hadgalah bich UI deer uurchilugduh bolgon DB-ruugaa hiij bolno... Bainga chagnana gesen ug.

    // ref.onValue.listen((event) {
    //   data = event.snapshot.children.map((e) => JSON(e.value)).toList();
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase teacher'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'name', border: OutlineInputBorder()),
              onChanged: (value) {
                name = value;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'gender', border: OutlineInputBorder()),
              onChanged: (value) {
                gender = value;
              },
            ),
            Expanded(
                child: ListView(
              children: data
                  .map(
                    (e) => ListTile(
                      title: Text(e['name'].stringValue),
                      onTap: () async {
                        final snapshot = await database
                            .ref('students')
                            .orderByChild('name')
                            .equalTo(e['name'].stringValue)
                            .get();
                        final values = snapshot.value as Map<dynamic, dynamic>;
                        values.forEach((key, value) {
                          database.ref('students/$key').remove();
                        });
                      },
                    ),
                  )
                  .toList(),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('object');
          DatabaseReference ref = database.ref('students').push();
          ref.set({'name': name, 'gender': gender});
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
