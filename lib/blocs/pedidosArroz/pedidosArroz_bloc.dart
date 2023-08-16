import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class PedidosArrozBloc extends BlocBase {
  final _ordersController = BehaviorSubject<List>();
  Stream get outOrders => _ordersController.stream;

  Firestore _firestore = Firestore.instance;

  List<DocumentSnapshot> _orders = [];

  PedidosArrozBloc() {
    _addOrderListener();
  }

  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _ordersController.add(_orders.asMap().values.toList());
    } else {
      _ordersController.add(_filter(search.trim()));
    }
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredOrders =
        List.from(_orders.asMap().values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void _addOrderListener() {
    _firestore.collection('PedidosArroz').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _orders.add(change.document);
            break;
          case DocumentChangeType.modified:
            _orders.removeWhere((order) => order.documentID == uid);
            _orders.add(change.document);
            break;
          case DocumentChangeType.removed:
            _orders.removeWhere((order) => order.documentID == uid);
            break;
        }
      });
      _ordersController.add(_orders);
    });
  }

  @override
  void dispose() {
    _ordersController.close();
  }
}
