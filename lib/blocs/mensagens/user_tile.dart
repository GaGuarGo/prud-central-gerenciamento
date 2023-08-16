import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_bloc.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_tab.dart';

class UserTile extends StatelessWidget {
  final DocumentSnapshot user;

  UserTile(this.user);

  @override
  Widget build(BuildContext context) {
    final _messageBloc = MessageBloc(userId: user.documentID);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessageTab(user.documentID)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 6, right: 6),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        child: Padding(
            padding: EdgeInsets.only(top: 2, bottom: 2, right: 18, left: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder(
                  stream: Firestore.instance
                      .collection('users')
                      .document(user.documentID)
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
                StreamBuilder<bool>(
                    stream: _messageBloc.outNotification,
                    builder: (context, snapshot) {
                      return Text(
                        '${user.data['nome']}',
                        style: TextStyle(
                          color: snapshot.data == true
                              ? Colors.pinkAccent
                              : Colors.white,
                          fontSize: 14,
                        ),
                      );
                    }),
                Text(
                  '${user.data['email']}',
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
  }
}
