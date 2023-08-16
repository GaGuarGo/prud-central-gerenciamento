import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prud_gerenciamento/blocs/mensagens/message_screen.dart';

import 'package:prud_gerenciamento/drawer.dart';
import 'package:prud_gerenciamento/login_screen.dart';

import 'package:prud_gerenciamento/menu.dart';
import 'package:prud_gerenciamento/model.dart';
import 'package:prud_gerenciamento/orders_screen.dart';
import 'package:prud_gerenciamento/resume.dart';
import 'package:prud_gerenciamento/users.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //primaryColor: Colors.grey,
            // ignore: deprecated_member_use
            textSelectionColor: Colors.white,
            // ignore: deprecated_member_use
            cursorColor: Colors.white,
            focusColor: Colors.white,
            // ignore: deprecated_member_use
            textSelectionHandleColor: Colors.white,
            hintColor: Colors.white,
            hoverColor: Colors.white,
          ),
          home: Login()),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController = PageController();

  int hora = Timestamp.now().microsecondsSinceEpoch;
  String resumeDate;

  var dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    //var format = DateFormat('dd/MM/yyyy');
    //var date = new DateTime.fromMicrosecondsSinceEpoch(hora);
    //var diaHora = format.format(date);

    setState(() {
      resumeDate = dateTime.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent.shade700,
            centerTitle: true,
            title: Text(
              'Usuários',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          backgroundColor: Colors.grey[900],
          body: User(),
        ),
        OrderScreen(_pageController),
        Scaffold(
          drawer: CustomDrawer(_pageController),
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            actions: [
              IconButton(
                tooltip: 'Limpar Lista',
                onPressed: () async {
                  Firestore.instance
                      .collection('resume')
                      .getDocuments()
                      .then((snapshot) {
                    for (DocumentSnapshot ds in snapshot.documents) {
                      ds.reference.delete();
                    }
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
            backgroundColor: Colors.blueAccent.shade700,
            centerTitle: true,
            title: Text(
              'Resumo do dia - ${dateTime.toString()}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Resume(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent.shade700,
            centerTitle: true,
            title: Text(
              'Mensagens',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          backgroundColor: Colors.grey[900],
          body: ChatScreen(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent.shade700,
            centerTitle: true,
            title: Text(
              'Cardápio',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: CustomDrawer(_pageController),
          backgroundColor: Colors.grey[900],
          body: Menu(),
        ),
      ],
    );
  }
}