import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PedidosArrozTab extends StatefulWidget {
  final DocumentSnapshot order;
  final GlobalKey<ScaffoldState> scaffoldKey;

  PedidosArrozTab(this.order, this.scaffoldKey);

  @override
  _PedidosArrozTabState createState() => _PedidosArrozTabState();
}

class _PedidosArrozTabState extends State<PedidosArrozTab> {
  bool confirmed = false;

  clean(String orderId, String userId) async {
    Firestore.instance
        .collection('PedidosArroz')
        .document(orderId)
        .delete()
        .then((_) async {
      Firestore.instance
          .collection('users')
          .document(userId)
          .collection('ordersR')
          .document(orderId)
          .delete();
    });
  }

  _orderConfirmed(String orderId, String userId) async {
    await Firestore.instance
        .collection('PedidosArroz')
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
    if (widget.order != null)
      return Padding(
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.pink,
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
                  widget.order.data['nome'],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.order.documentID,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  widget.order.data['hora'],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Checkbox(
                  onChanged: (bool value) async {
                    setState(() {
                      confirmed = value;
                    });
                    if (confirmed == true) {
                      _orderConfirmed(
                          widget.order.documentID, widget.order.data['userId']);
                      Future.delayed(Duration(microseconds: 50)).then((_) {
                        widget.scaffoldKey.currentState.showSnackBar(SnackBar(
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
                    clean(widget.order.documentID, widget.order.data['userId']);
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
  }
}
