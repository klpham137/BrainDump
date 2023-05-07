import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      home: JournalHomePage(),
    );
  }
}

class JournalHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      drawer: JournalDrawer(),
      body: Center(
        child: Text('Welcome to your journal!'),
      ),
    );
  }
}

class JournalDrawer extends StatefulWidget {
  @override
  _JournalDrawerState createState() => _JournalDrawerState();
}

class _JournalDrawerState extends State<JournalDrawer> {
  final CollectionReference _journalCollection = FirebaseFirestore.instance.collection('journal_entries');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder<QuerySnapshot>(
        stream: _journalCollection.orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<DocumentSnapshot> entries = snapshot.data!.docs;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              final Map<String, dynamic> data = entries[index].data() as Map<String, dynamic>;
              final DateTime date = data['date'].toDate();
              return ListTile(
                title: Text('${date.month}/${date.day}/${date.year}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JournalEntryScreen(data)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class JournalEntryScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const JournalEntryScreen(this.data);

  @override
  Widget build(BuildContext context) {
    final DateTime date = data['date'].toDate();
    final String title = data['title'];
    final String body = data['body'];
    return Scaffold(
      appBar: AppBar(
        title: Text('${date.month}/${date.day}/${date.year}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(body, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
