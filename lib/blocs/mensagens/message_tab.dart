import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_widget.dart';
import 'package:prud_gerenciamento/model.dart';
import 'package:prud_gerenciamento/text_composer.dart';

class MessageTab extends StatelessWidget {
  final String userId;
  MessageTab(this.userId);

  @override
  Widget build(BuildContext context) {
    _sendMessage({String text}) async {
      Map<String, dynamic> data = {
        'nome': "PrudCentral",
        'hora': DateTime.now(),
        "message": text,
      };

      await UserModel.of(context).message(message: data, userId: userId);
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: FutureBuilder(
          future: Firestore.instance.collection('users').document(userId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container();
            else
              return Text(
                snapshot.data['nome'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('messages')
                  .orderBy('hora')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: LinearProgressIndicator(),
                  );
                else
                  return ListView(
                      reverse: true,
                      children: snapshot.data.documents
                          .map((doc) => MessageWidget(
                              userId: userId, messageId: doc.documentID))
                          .toList().reversed.toList());
              },
            ),
          ),
          SizedBox(
            height: 5,
          ),
          TextComposer(_sendMessage)
        ],
      ),
    );
  }
}
