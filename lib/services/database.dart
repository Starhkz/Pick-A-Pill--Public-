import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_a_pill_pub/models/drug.dart';
import 'package:pick_a_pill_pub/models/pharm.dart';
import 'package:pick_a_pill_pub/models/user_model.dart';

class DatabaseService {
  final String uid;
  final String friendUid;

  DatabaseService({this.uid, this.friendUid});
  // Collection reference

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('Public Users');

  final CollectionReference pharmOrdersCollection =
      FirebaseFirestore.instance.collection('Pharm Orders');

  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('Orders');

  final CollectionReference pharmCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('Drug Collection');

  Future updateUserData(String uid, String name, String imageUrl) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name ?? 'Unknown',
      'imageUrl': imageUrl,
    });
  }

  Future uploadDrug(String name, String description, String photoUrl,
      String time, int amount, bool isAvailable) async {
    return await messageCollection
        .doc(uid)
        .collection('Drug Register')
        .doc(time)
        .set({
      'name': name,
      'description': description,
      'time': time,
      'photoUrl': photoUrl,
      'amount': amount,
      'isAvailable': isAvailable
    });
  }

  Future uploadMyOrderList(String name, String imageUrl) async {
    return await ordersCollection
        .doc(uid)
        .collection('Order List')
        .doc(friendUid)
        .set({
      'pharmUid': friendUid,
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  Future uploadPharmOrderList(String name, String imageUrl) async {
    return await pharmOrdersCollection
        .doc(friendUid)
        .collection('Order List')
        .doc(uid)
        .set({
      'customerUid': uid,
      'name': name,
      'imageUrl': imageUrl,
    });
  }

  Future uploadMyorder(String time, String name, String imageUrl) async {
    return await ordersCollection.doc(uid).collection(friendUid).doc(time).set({
      'name': name,
      'imageUrl': imageUrl,
      'time': time,
      'ordered': false,
      'unread': false,
      'accepted': false,
      'rejected': false,
      'replied': false
    });
  }

  Future uploadPharmOrder(String time, String name, String imageUrl, int amount,
      String note) async {
    return await pharmOrdersCollection
        .doc(friendUid)
        .collection(uid)
        .doc(time)
        .set({
      'name': name,
      'imageUrl': imageUrl,
      'time': time,
      'amount': amount,
      'note': note,
      'accepted': false,
      'rejected': false,
    });
  }

  Future updateMyOrder(String time) async {
    return await ordersCollection
        .doc(uid)
        .collection(friendUid)
        .doc(time)
        .update({'ordered': true});
  }

  Future updateMyOrderRead(String time) async {
    return await ordersCollection
        .doc(uid)
        .collection(friendUid)
        .doc(time)
        .update({'unread': false});
  }

  Future updateUser(String uids, String name, String imageUrl) async {
    return await userCollection
        .doc(uid)
        .update({
          'uid': uid,
          'name': name,
          'imageUrl': imageUrl,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future updateDrug(String name, String description, String photoUrl,
      String time, int amount) async {
    return await messageCollection
        .doc(uid)
        .collection('Drug Register')
        .doc(time)
        .update({
      'name': name,
      'description': description,
      'time': time,
      'photoUrl': photoUrl,
      'amount': amount,
    });
  }

  Future druAvailability(String time, bool isAvailable) async {
    return await messageCollection
        .doc(uid)
        .collection('Drug Register')
        .doc(time)
        .update({'isAvailable': isAvailable});
  }

  List<Pharm> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Pharm(
        name: doc.data()['name'] ?? 'No Name',
        uid: doc.data()['uid'] ?? null,
        imageUrl: doc.data()['imageUrl'] ?? '',
        location: doc.data()['location'] ?? null,
      );
    }).toList();
  }

  // Use
  List<Drug> _userDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Drug(
        name: doc.data()['name'] ?? '',
        description: doc.data()['description'] ?? '',
        time: doc.data()['time'] ?? '',
        photoUrl: doc.data()['photoUrl'] ?? '',
        amount: doc.data()['amount'] ?? 0,
        isAvailable: doc.data()['isAvailable'] ?? true,
      );
    }).toList();
  }

  List<OrderPharm> _pharmOrderFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return OrderPharm(
          name: doc.data()['name'] ?? '',
          uid: doc.data()['pharmUid'] ?? '',
          imageUrl: doc.data()['imageUrl'] ?? '');
    }).toList();
  }

  List<Drug> _drugOrderFromSnapShots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Drug(
          name: doc.data()['name'] ?? '',
          photoUrl: doc.data()['imageUrl'] ?? '',
          time: doc.data()['time'] ?? '',
          reply: doc.data()['reply'] ?? '',
          unread: doc.data()['unread'] ?? false,
          ordered: doc.data()['ordered'] ?? false,
          isAvailable: doc.data()['isAvailable'] ?? false,
          accepted: doc.data()['accepted'] ?? false,
          rejected: doc.data()['rejected'] ?? false,
          replied: doc.data()['replied'] ?? false);
    }).toList();
  }

  String _userNameFromUid(DocumentSnapshot snapshot) {
    return snapshot.data()['name'].toString();
  }

  User _currentUserFromSnapshot(DocumentSnapshot snapshot) {
    return User(
        name: snapshot.data()['name'] ?? 'No Name',
        uid: snapshot.data()['uid'] ?? null,
        imageUrl: snapshot.data()['imageUrl'] ?? null);
  }

  // Get brews sstream
  Stream<List<Pharm>> get getPharm {
    return pharmCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<Drug>> get drugList {
    return messageCollection
        .doc(uid)
        .collection('Drug Register')
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Stream<String> get userName {
    return userCollection.doc(friendUid).snapshots().map(_userNameFromUid);
  }

  Stream<User> get myData {
    return userCollection.doc(uid).snapshots().map(_currentUserFromSnapshot);
  }

  Stream<List<OrderPharm>> get pharmOrder {
    return ordersCollection
        .doc(uid)
        .collection('Order List')
        .snapshots()
        .map(_pharmOrderFromSnapshot);
  }

  Stream<List<Drug>> get drugOrder {
    return ordersCollection
        .doc(uid)
        .collection(friendUid)
        .snapshots()
        .map(_drugOrderFromSnapShots);
  }
}
