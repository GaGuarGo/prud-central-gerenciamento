import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class MessageBloc extends BlocBase {
  Firestore _firestore = Firestore.instance;

  final _messageController = BehaviorSubject<List>();
  Stream get outMessages => _messageController.stream;

  final _usersController = BehaviorSubject<List>();
  Stream get outUser => _usersController.stream;

  final _notificationController = BehaviorSubject<bool>();
  Stream get outNotification => _notificationController.stream;

  List<DocumentSnapshot> _messages = [];
  List<DocumentSnapshot> _users = [];
  bool notification = false;

  MessageBloc({String userId}) {
    _messageNotification(uid: userId);
    _addMessageListener(userId: userId);
    _addUserListener();
  }
  void onChangedSearch(String search) {
    if (search.trim().isEmpty) {
      _usersController.add(_users.asMap().values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<DocumentSnapshot> _filter(String search) {
    List<DocumentSnapshot> filteredOrders =
        List.from(_users.asMap().values.toList());
    filteredOrders.retainWhere((order) {
      return order['nome'].toUpperCase().contains(search.toUpperCase());
    });
    return filteredOrders;
  }

  void _addUserListener() {
    _firestore
        .collection('users')
        .orderBy('nome')
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _users.add(change.document);
            break;
          case DocumentChangeType.modified:
            _users.removeWhere((user) => user.documentID == uid);
            _users.add(change.document);
            break;
          case DocumentChangeType.removed:
            _users.removeWhere((user) => user.documentID == uid);
        }
      });
      _usersController.add(_users);
    });
  }

  void _addMessageListener({String userId}) {
    _firestore
        .collection('users')
        .document(userId)
        .collection('messages')
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;

        switch (change.type) {
          case DocumentChangeType.added:
            _messages.add(change.document);

            break;
          case DocumentChangeType.modified:
            _messages.removeWhere((message) => message.documentID == uid);
            _messages.add(change.document);
            break;
          case DocumentChangeType.removed:
            _messages.removeWhere((message) => message.documentID == uid);
        }
      });
    });
  }

  void _messageNotification({String uid}) {
    _firestore
        .collection('users')
        .document(uid)
        .collection('messages')
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (snapshot.documentChanges.length != snapshot.documents.length) {
              notification = true;
            } else {
              notification = false;
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
        }
      });
      _notificationController.add(notification);
    });
  }

  @override
  void dispose() {
    _messageController.close();
    _usersController.close();
    _notificationController.close();
  }
}
