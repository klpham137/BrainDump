import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Entry.dart';
import 'EntryView.dart';

class JournalDrawer extends StatefulWidget {
  const JournalDrawer({super.key});

  @override
  _JournalDrawerState createState() => _JournalDrawerState();
}

class _JournalDrawerState extends State<JournalDrawer> {
  TextEditingController entryController = TextEditingController();
  final date = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

  Stream<List<Entry>> readEntries() => FirebaseFirestore.instance
      .collection('journal_entries')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs .map((doc) => Entry.fromJson(doc.data())).toList());


  Widget buildEntry(Entry entry) => ListTile(
    leading: const CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage('https://i.pinimg.com/736x/db/70/71/db70714ac3f4131b53db70cf3c2e6f64.jpg'),
      //Text('${entry.date}')
    ),
    title: Text(entry.date),
    subtitle: Text('${entry.body.substring(0, 6)}...'),
    trailing: entry.id == '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}' ? IconButton(
      icon: const Icon(Icons.delete_forever),
      onPressed: () {
        final docEntry = FirebaseFirestore.instance
            .collection('journal_entries')
            .doc(date);

        //Delete entry forever
        docEntry.delete();
      },
    ): IconButton(
      icon: const Icon(Icons.visibility),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryView(date: entry.id),
            )
        );
      },
    ),
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EntryView(date: entry.id),
          )
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      child: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25, left: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'All Braindumps',
                style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Entry>>(
                  stream: readEntries(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('something went wrong! ${snapshot.error}');
                    }
                    else if (snapshot.hasData) {
                      final entries = snapshot.data!;

                      return ListView(
                        children: entries.map(buildEntry).toList(),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}