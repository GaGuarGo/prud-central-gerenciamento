import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prud_gerenciamento/model.dart';
import 'package:prud_gerenciamento/noLogin_screen.dart';
import 'package:prud_gerenciamento/text_composer.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return UserModel.of(context).isLoggedIn()
        ? StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return ListView(
                    children: snapshot.data.documents
                        .map((doc) => UsersM(doc.documentID))
                        .toList());
            },
          )
        : Center(child: NoLogin());
  }
}

// ignore: must_be_immutable
class UsersM extends StatelessWidget {
  String userId;

  UsersM(this.userId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Firestore.instance.collection('users').document(userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MessageUser(userId)));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 6, right: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  )),
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, right: 18, left: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder(
                        stream: Firestore.instance
                            .collection('users')
                            .document(userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else if (snapshot.data['foto'] == null)
                            return CircleAvatar(
                              radius: 10,
                              child: Image.asset('images/user.png'),
                            );
                          else
                            return Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        snapshot.data['foto'],
                                      ))),
                            );
                        },
                      ),
                      Text(
                        '${snapshot.data['nome']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${snapshot.data['email']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 20,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
          );
      },
    );
  }
}

// ignore: must_be_immutable
class MessageUser extends StatelessWidget {
  _sendMessage({String text}) async {
    Map<String, dynamic> data = {
      'nome': "PrudCentral",
      "message": text.toString(),
      'hora': Timestamp.now()
    };

    await Firestore.instance.collection('messages').add(data).then((mssg) {
      Firestore.instance
          .collection('users')
          .document(userId)
          .collection('messages')
          .document(mssg.documentID)
          .setData({'messageId': mssg.documentID, 'hora': Timestamp.now()});
    });
  }

  String userId;

  MessageUser(this.userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          centerTitle: true,
          title: FutureBuilder(
            future:
                Firestore.instance.collection('users').document(userId).get(),
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
                        children: snapshot.data.documents
                            .map((doc) => MessageLayout(doc.documentID, userId))
                            .toList());
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextComposer(_sendMessage)
          ],
        ));
  }
}

// ignore: must_be_immutable
class MessageLayout extends StatelessWidget {
  String userId;
  String messageId;

  MessageLayout(this.messageId, this.userId);

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
          return Container(
              padding: EdgeInsets.only(right: 2, bottom: 2, top: 2, left: 8),
              margin: EdgeInsets.only(top: 5, left: 200, right: 5),
              decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.only(right: 20, bottom: 2, top: 2),
                child: Column(
                  children: [
                    Text(
                      snapshot.data['message'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '- Recebida',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ));
        else
          return Container(
              padding: EdgeInsets.only(right: 2, bottom: 2, top: 2, left: 8),
              margin: EdgeInsets.only(top: 5, left: 5, right: 200),
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.only(right: 10, bottom: 2, top: 2),
                child: Column(
                  children: [
                    Text(
                      snapshot.data['message'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '- Recebida',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ));
      },
    );
  }
}
