import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MaterialApp(
      home: MainScreen(),
    ));

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String url = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FireStore Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var response = await http.get(url);
          List l = jsonDecode(response.body);
          l.forEach((e) {
            Firestore.instance.collection('/post').document().setData(e);
          });
        },
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('/post')?.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          List<DocumentSnapshot> docs = snapshot.data.documents;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = docs[index];
              return InkWell( child: ListTile(
                title: Text(doc['title']),
                subtitle: Text(doc['body']),
              ),onTap: (){
                Firestore.instance.collection('/post').document(doc.documentID).delete();
              },);
            },
          );
        },
      ),
    );
  }
}
