import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'Entry.dart';

class JournalEntry extends StatefulWidget {
  const JournalEntry({Key? key}) : super(key: key);

  @override
  _JournalEntryState createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntry> {
  TextEditingController entryController = TextEditingController();
  final date = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';


  Future createEntry(Entry entry) async {
    final docEntry = FirebaseFirestore.instance.collection('journal_entries').doc('${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}');
    entry.id = docEntry.id;

    final json = entry.toJson();
    await docEntry.set(json);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('New Braindump'),
      ),
      body:
      Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Text('--- ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year} ---',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 90.0),
                child: ElevatedButton.icon(
                  //onPressed: _addEntry,
                  onPressed: () {
                    final date = '${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
                    final body = entryController.text;
                    final entry = Entry(
                      date: date,
                      body: body,
                    );

                    createEntry(entry);

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Dump'),
                ),
              ),
            ], //children
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: entryController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Write your journal entry here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } //Widget
} //Journal Entry State

