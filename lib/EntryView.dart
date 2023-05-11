import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Entry.dart';

class EntryView extends StatelessWidget {
  final String date;

  EntryView({super.key, required this.date});

  Future<Entry?> readEntry() async{
    final docEntry = FirebaseFirestore.instance.collection('journal_entries').doc(date);
    final snapshot = await docEntry.get();

    if (snapshot.exists) {
      return Entry.fromJson(snapshot.data()!);
    }
    return null;
  }

  Widget buildEntry(Entry entry) => Scaffold(
    resizeToAvoidBottomInset: true,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Image.network('https://i.pinimg.com/736x/94/42/cd/9442cdd915a787750eb718f588de9143.jpg',
                width: 70,
                height: 70,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 15),
              child: Text('Braindump from ${entry.date}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 23,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                    children: <Widget>[Text(entry.body,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 16
                      ),
                    ),
                    ]
                ),
              )
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('back', style: TextStyle(fontSize: 16),)),
        body: FutureBuilder<Entry?>(
          future: readEntry(),
          builder: (context, snapshot){
            if(snapshot.hasError) {
              return Text('Something went wrong ${snapshot.error}');
            }
            else if(snapshot.data!= null) {
              final entry = snapshot.data;

              return entry == null
                  ? const Center(
                  child: Text('No Entry'))
                  : buildEntry(entry);
            } else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}