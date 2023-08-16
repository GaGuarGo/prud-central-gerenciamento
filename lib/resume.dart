import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Resume extends StatefulWidget {
  @override
  _ResumeState createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('resume').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        else
          return Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.all(12),
                child: Text(
                  'Número de Pedidos de hoje: ${snapshot.data.documents.length.toString()} ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: Colors.grey[500],
                ),
              ),
              Expanded(
                  child: ListView(
                children: snapshot.data.documents
                    .map((resumeOrder) => OrderResumed(
                          orderId: resumeOrder.documentID,
                        ))
                    .toList(),
              )),
            ],
          );
      },
    );
  }
}

// ignore: must_be_immutable
class OrderResumed extends StatelessWidget {
  String orderId;
  OrderResumed({@required this.orderId});

  final _style =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('resume').document(orderId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
        else
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Text(
                '${snapshot.data['nome']}',
                style: _style,
              ),
              Text(
                '${snapshot.data['orderId']}',
                style: _style,
              ),
            ]),
          );
      },
    );
  }
}
