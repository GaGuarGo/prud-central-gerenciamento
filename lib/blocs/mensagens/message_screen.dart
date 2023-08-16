import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_bloc.dart';
import 'package:prud_gerenciamento/blocs/mensagens/user_tile.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageBloc = MessageBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List>(
      stream: _messageBloc.outUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Pesquisar',
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none),
                  onChanged: _messageBloc.onChangedSearch,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      UserTile(snapshot.data[index]),
                ),
              ),
            ],
          );
      },
    ));
  }
}
