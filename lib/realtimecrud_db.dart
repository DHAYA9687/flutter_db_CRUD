// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class RealTimeCRUDDB extends StatefulWidget {
  const RealTimeCRUDDB({super.key});

  @override
  State<RealTimeCRUDDB> createState() => _RealTimeCRUDDBState();
}

final databaseref = FirebaseDatabase.instance.ref();
final db = FirebaseDatabase.instance.ref("users");

class _RealTimeCRUDDBState extends State<RealTimeCRUDDB> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "RealTime Database",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
            query: db,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(10),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(
                    snapshot.child("name").value.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  subtitle: Text(
                    snapshot.child("address").value.toString(),
                  ),
                ),
              );
            },
          ))
          //For store data in realTime Database from app or
          //create Operation
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return myDialogBox(
                    context: context,
                    name: "Create Items",
                    address: "Add",
                    onPressed: () {
                      final newref = databaseref.child('users').push();
                      newref.set(
                        {
                          'name': nameController.text.toString(),
                          'address': addressController.text.toString()
                        },
                      ).then((_) {
                        // ignore: _print
                        print("success");
                      }).catchError((err) {
                        print("$err");
                      });
                      nameController.clear();
                      addressController.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    });
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Dialog myDialogBox({
    required BuildContext context,
    required String name,
    required String address,
    required VoidCallback onPressed,
  }) {
    return Dialog(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Enter the Name", hintText: "eg . John "),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                  labelText: "Enter the Address", hintText: "eg . India "),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              child: Text(address),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
