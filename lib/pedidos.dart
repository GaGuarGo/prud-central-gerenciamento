import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Day extends StatefulWidget {
  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> {
  final _search = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('Pedidos')
                    .orderBy('nome')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            "N° de pedidos: ${snapshot.data.documents.length.toString()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: snapshot.data.documents
                                .map((doc) => DayLayout(
                                    doc.documentID, _search.text, _scaffoldKey))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DayLayout extends StatefulWidget {
  String search;
  String orderId;

  final GlobalKey<ScaffoldState> scaffoldKey;

  DayLayout(this.orderId, this.search, this.scaffoldKey);

  @override
  _DayLayoutState createState() => _DayLayoutState();
}

class _DayLayoutState extends State<DayLayout> {
  bool confirmed = false;

  clean(String orderId, String userId) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('orders')
        .document(orderId)
        .delete()
        .then((_) async {
      Firestore.instance.collection('Pedidos').document(orderId).delete();
    });
  }

  _orderConfirmed(String orderId, String userId) async {
    await Firestore.instance
        .collection('Pedidos')
        .document(orderId)
        .get()
        .then((order) {
      Firestore.instance.collection('resume').document(orderId).setData({
        'nome': order.data['nome'],
        'orderId': order.documentID,
      });
      clean(orderId, userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('Pedidos')
          .document(widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else if (snapshot.data['almoço'].toString().contains('Sim'))
          return Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent.shade700,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 40,
              //color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data['nome'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      widget.orderId,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      snapshot.data['hora'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Checkbox(
                      onChanged: (bool value) async {
                        setState(() {
                          confirmed = value;
                        });
                        if (confirmed == true) {
                          _orderConfirmed(
                              widget.orderId, snapshot.data['userId']);
                          Future.delayed(Duration(microseconds: 50)).then((_) {
                            widget.scaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                'Confirmado!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ));
                          });
                        }
                      },
                      value: confirmed,
                      checkColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                    ),
                    IconButton(
                      onPressed: () {
                        clean(widget.orderId, snapshot.data['userId']);
                        Future.delayed(Duration(seconds: 1)).then((_) {
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.pinkAccent,
                            content: Text(
                              'Pedido Removido!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ));
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        else
          return Container();
      },
    );
  }
}

class Egg extends StatefulWidget {
  @override
  _EggState createState() => _EggState();
}

class _EggState extends State<Egg> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('PedidosOvo')
                    .orderBy('nome')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            "N° de pedidos: ${snapshot.data.documents.length.toString()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: snapshot.data.documents
                                .map((doc) =>
                                    EggLayout(doc.documentID, _scaffoldKey))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EggLayout extends StatefulWidget {
  String orderId;
  final GlobalKey<ScaffoldState> scaffoldKey;

  EggLayout(this.orderId, this.scaffoldKey);

  @override
  _EggLayoutState createState() => _EggLayoutState();
}

bool confirmed = false;

class _EggLayoutState extends State<EggLayout> {
  clean(String orderId, String userId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('ordersE')
        .document(orderId)
        .delete()
        .then((_) {
      Firestore.instance.collection('PedidosOvo').document(orderId).delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('PedidosOvo')
          .document(widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent.shade700,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 40,
              //color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data['nome'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      widget.orderId,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      snapshot.data['hora'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Checkbox(
                      onChanged: (bool value) async {
                        setState(() {
                          confirmed = value;
                        });
                        if (confirmed == true) {
                          clean(widget.orderId, snapshot.data['userId']);
                          Future.delayed(Duration(microseconds: 50)).then((_) {
                            widget.scaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                'Confirmado!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ));
                          });
                        }
                      },
                      value: confirmed,
                      checkColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                    ),
                    IconButton(
                      onPressed: () {
                        clean(widget.orderId, snapshot.data['userId']);
                        Future.delayed(Duration(seconds: 1)).then((_) {
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.pinkAccent,
                            content: Text(
                              'Pedido Removido!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ));
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}

class Rice extends StatefulWidget {
  @override
  _RiceState createState() => _RiceState();
}

class _RiceState extends State<Rice> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('PedidosArroz')
                    .orderBy('nome')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            "N° de pedidos: ${snapshot.data.documents.length.toString()}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: snapshot.data.documents
                                .map((doc) =>
                                    RiceLayout(doc.documentID, _scaffoldKey))
                                .toList(),
                          ),
                        ),
                      ],
                    );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class RiceLayout extends StatefulWidget {
  String orderId;

  final GlobalKey<ScaffoldState> scaffoldKey;

  RiceLayout(this.orderId, this.scaffoldKey);

  @override
  _RiceLayoutState createState() => _RiceLayoutState();
}

class _RiceLayoutState extends State<RiceLayout> {
  bool confirmed = false;

  clean(String orderId, String userId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('ordersR')
        .document(orderId)
        .delete()
        .then((_) {
      Firestore.instance.collection('PedidosArroz').document(orderId).delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('PedidosArroz')
          .document(widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blueAccent.shade700,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              height: 40,
              //color: Colors.pink,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, left: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data['nome'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      widget.orderId,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      snapshot.data['hora'],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Checkbox(
                      onChanged: (bool value) async {
                        setState(() {
                          confirmed = value;
                        });
                        if (confirmed == true) {
                          clean(widget.orderId, snapshot.data['userId']);
                          Future.delayed(Duration(microseconds: 50)).then((_) {
                            widget.scaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.pinkAccent,
                              content: Text(
                                'Confirmado!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ));
                          });
                        }
                      },
                      value: confirmed,
                      checkColor: Colors.white,
                      activeColor: Colors.pinkAccent,
                    ),
                    IconButton(
                      onPressed: () {
                        clean(widget.orderId, snapshot.data['userId']);
                        Future.delayed(Duration(seconds: 1)).then((_) {
                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.pinkAccent,
                            content: Text(
                              'Pedido Removido!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ));
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
