import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //  mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: StreamBuilder(
          stream: Firestore.instance
              .collection('Cardápio')
              .document('menus')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    child: Image.network(snapshot.data['url1']),
                  ),
                  Container(
                    child: Image.network(snapshot.data['url2']),
                  ),
                ],
              );
          },
        )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Change();
                    });
              },
              child: Container(
                height: 200,
                width: 300,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 40, left: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Mudar Cardápio',
                      style: TextStyle(
                          color: Colors.blueAccent.shade700,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.blueAccent.shade700,
                      size: 70,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Change extends StatefulWidget {
  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _url1 = TextEditingController();
  TextEditingController _url2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Url's das Imagens do Menu:",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
      backgroundColor: Colors.grey[900],
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
            save();
            clear();
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
      content: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.only(top: 6, bottom: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Imagem inválida';
                  }
                },
                controller: _url1,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Url1',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: 'Endereço da Imagem 1'),
              ),
              TextFormField(
                validator: (text) {
                  if (text.isEmpty) {
                    return 'Imagem inválida';
                  }
                },
                controller: _url2,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelText: 'Url2',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    hintText: 'Endereço da Imagem 2'),
              )
            ],
          ),
        ),
      ),
    );
  }

  save() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> data = {
        "url1": _url1.text,
        "url2": _url2.text,
      };
      await Firestore.instance
          .collection('Cardápio')
          .document('menus')
          .updateData(data);
    }
  }

  clear() {
    setState(() {
      _url1.clear();
      _url2.clear();
    });
  }
}
