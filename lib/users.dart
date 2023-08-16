import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_bloc.dart';

class User extends StatelessWidget {
  final _userBloc = MessageBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: _userBloc.outUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          );
        else
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Número de usuários: ${snapshot.data.length.toString()}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Pesquisar',
                      hintStyle: TextStyle(color: Colors.white),
                      icon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none),
                  onChanged: _userBloc.onChangedSearch,
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return UserLayout(snapshot.data[index]);
                },
              )),
            ],
          );
      },
    );
  }
}

class UserLayout extends StatelessWidget {
  DocumentSnapshot userId;

  UserLayout(this.userId);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 2, bottom: 2, right: 18, left: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userId.data['nome']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  userId.documentID,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return UserDialog(userId.documentID);
                            });
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return DeleteUserDialog(userId.documentID);
                            });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ],
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Divider(
            thickness: 0.25,
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}

class DeleteUserDialog extends StatelessWidget {
  String userId;

  DeleteUserDialog(this.userId);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.redAccent,
          color: Colors.white,
          child: Text('Cancelar',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
        RaisedButton(
          onPressed: () async {
            await Firestore.instance
                .collection('users')
                .document(userId)
                .delete();
            Navigator.of(context).pop();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.redAccent,
          child: Text(
            'Excluir',
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      title: Text(
        'Deseja excluir esse usuário?',
        style: TextStyle(
            color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Ao remover esse usuário, todos seus dados \n'
        'serão excluídos junto com todos seus \n pedidos, '
        'para sempre.',
        style: TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }
}

class UserDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String userId;

  UserDialog(this.userId);

  TextEditingController _photo = TextEditingController();
  TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 10,
      backgroundColor: Colors.grey[900],
      content: Padding(
        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Form(
                key: _formKey,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Informações do Usuário:',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 0),
                      child: FutureBuilder(
                        future: Firestore.instance
                            .collection('users')
                            .document(userId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else if (snapshot.data['foto'] == null)
                            return CircleAvatar(
                              child: Image.asset(
                                'images/user.png',
                                height: 120,
                                width: 120,
                              ),
                              radius: 50,
                            );
                          else
                            return ClipOval(
                              child: Image.network(
                                snapshot.data['foto'],
                                fit: BoxFit.cover,
                                height: 110,
                                width: 110,
                              ),
                            );
                        },
                      ),
                    ),
                    if (snapshot.data["foto"] != null)
                      TextFormField(
                        validator: (text) {
                          if (text.isEmpty && text.contains('null')) {
                            return text = null;
                          }
                        },
                        controller: _photo,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: snapshot.data['foto'],
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                      )
                    else
                      TextFormField(
                        validator: (text) {
                          if (text.contains('null')) {
                            return text = null;
                          }
                        },
                        controller: _photo,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Foto: null',
                            labelStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    TextFormField(
                      validator: (text) {
                        if (text.isEmpty) {
                          return;
                        }
                      },
                      controller: _name,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        labelText: 'Nome: ${snapshot.data['nome']}',
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
          },
        ),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.white,
          //color: Colors.blueAccent,
          child: Text(
            'Cancelar',
            style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
        FlatButton(
          onPressed: () {
            if (_photo.text.isEmpty && _name.text.isEmpty)
              return;
            else if (_photo.text.isNotEmpty && _name.text.isNotEmpty) {
              if (_formKey.currentState.validate()) {
                saveBoth();
                clear();
              }
            } else if (_photo.text.isNotEmpty && _name.text.isEmpty) {
              if (_formKey.currentState.validate()) {
                savePhoto();
                clear();
              }
            } else if (_photo.text.isEmpty && _name.text.isNotEmpty) {
              if (_formKey.currentState.validate()) {
                saveName();
                clear();
              }
            } else
              return;
          },
          textColor: Colors.white,
          //color: Colors.blueAccent,
          child: Text(
            'Salvar',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  saveBoth() async {
    if (_formKey.currentState.validate()) {
      if (_photo.text.contains('null')) {
        _photo = null;
      }

      if (_name.text.isEmpty) return;
      if (_photo.text.isEmpty) return;

      Map<String, dynamic> data = {
        "foto": _photo.text,
        "nome": _name.text,
      };

      await Firestore.instance
          .collection('users')
          .document(userId)
          .updateData(data)
          .then((_) {})
          .catchError((e) {});
    }
  }

  savePhoto() async {
    if (_formKey.currentState.validate()) {
      if (_photo.text.isEmpty) return;

      if (_photo.text.contains('null')) {
        _photo = null;
        Map<String, dynamic> data = {
          "foto": _photo,
        };
        await Firestore.instance
            .collection('users')
            .document(userId)
            .updateData(data)
            .then((_) {})
            .catchError((e) {});
      } else {
        Map<String, dynamic> data = {
          "foto": _photo.text,
        };
        await Firestore.instance
            .collection('users')
            .document(userId)
            .updateData(data)
            .then((_) {})
            .catchError((e) {});
      }
    }
  }

  saveName() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "nome": _name.text,
      };

      await Firestore.instance
          .collection('users')
          .document(userId)
          .updateData(data)
          .then((_) {})
          .catchError((e) {});
    }
  }

  clear() {
    _name.clear();
    _photo.clear();
  }
}
