import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageWidget extends StatelessWidget {
  String userId;
  String messageId;

  MessageWidget({this.userId, this.messageId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('messages')
          .document(messageId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (snapshot.data['nome'] == 'PrudCentral')
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, bottom: 2, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          snapshot.data['message'],
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '- Enviada',
                            style: TextStyle(
                                color: Colors.pinkAccent, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          );
        else
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.only(right: 10, bottom: 2, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data['message'],
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '- Recebida',
                            style: TextStyle(
                                color: Colors.pinkAccent, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          );
      },
    );
  }
}
