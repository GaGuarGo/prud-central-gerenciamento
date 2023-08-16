import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prud_gerenciamento/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  final pageController = PageController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    loadCurrentUser();
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user;

      await loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass({
    @required String email,
    @required VoidCallback onSuccess,
  }) async {
    isLoading = true;
    notifyListeners();
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      isLoading = false;
      notifyListeners();
      onSuccess();
    });
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> photo(
      {@required Map<String, dynamic> profile,
      @required VoidCallback onSuccess}) async {
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(profile);
    isLoading = true;
    isLoading = false;
    notifyListeners();
    onSuccess();
  }

  Future<Null> message(
      {@required Map<String, dynamic> message, @required String userId}) async {
    await Firestore.instance
        .collection('messages')
        .add(message)
        .then((mssg) async {
      Firestore.instance
          .collection('users')
          .document(userId)
          .collection('messages')
          .document(mssg.documentID)
          .setData({'messageId': mssg.documentID, 'hora': DateTime.now()});
    });
  }

  Future<Null> sendOrder(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required String name}) async {
    await Firestore.instance
        .collection("Pedidos")
        .document(name)
        .setData(order);
    await Firestore.instance
        .collection("users")
        .document(name)
        .collection("orders")
        .document()
        .setData(order);
    onSuccess();
  }

  Future<Null> sendOrderEgg(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required String name}) async {
    await Firestore.instance
        .collection("PedidosOvo")
        .document(name)
        .setData(order);
    await Firestore.instance
        .collection("users")
        .document(name)
        .collection("orders")
        .document()
        .setData(order);
    onSuccess();
  }

  Future<Null> sendOrderRice(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required String name}) async {
    await Firestore.instance
        .collection("PedidosArroz")
        .document(name)
        .setData(order);
    await Firestore.instance
        .collection("users")
        .document(name)
        .collection("orders")
        .document()
        .setData(order);
    onSuccess();
  }

  Future<Null> sendOrderRaE(
      {@required Map<String, dynamic> order,
      @required VoidCallback onSuccess,
      @required String name}) async {
    await Firestore.instance
        .collection("PedidosOvo")
        .document(name)
        .setData(order);

    await Firestore.instance
        .collection("PedidosArroz")
        .document(name)
        .setData(order);

    await Firestore.instance
        .collection("users")
        .document(name)
        .collection("orders")
        .document()
        .setData(order);
    onSuccess();
  }

  Future<Null> removeOrder(
      {@required orderId, @required VoidCallback onSuccess}) async {
    await Firestore.instance
        .collection("Pedidos")
        .document(firebaseUser.uid)
        .delete();
    await Firestore.instance
        .collection("PedidosArroz")
        .document(firebaseUser.uid)
        .delete();
    await Firestore.instance
        .collection("PedidosOvo")
        .document(firebaseUser.uid)
        .delete();
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .collection("orders")
        .document(orderId)
        .delete();
    isLoading = true;
    isLoading = false;
    notifyListeners();
    onSuccess();
  }

  Future loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["nome"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
  }

  Future savedUser(BuildContext context) async {
    if (firebaseUser != null) {
      loadCurrentUser().then((_) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      });
    }
  }

  notifyListeners();
}
