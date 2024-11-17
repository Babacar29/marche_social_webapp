import 'package:cloud_firestore/cloud_firestore.dart';

class AppCollections {
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference storeCollection =
      FirebaseFirestore.instance.collection('stores');
  static CollectionReference productCollection =
  FirebaseFirestore.instance.collection('products');
  static CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('cart');
  static CollectionReference chatroomCollection =
  FirebaseFirestore.instance.collection('chatrooms');
  static CollectionReference messagesCollection =
  FirebaseFirestore.instance.collection('messages');
  static CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('orders');
  static CollectionReference reviewsCollection =
  FirebaseFirestore.instance.collection('reviews');
  static CollectionReference commentsCollection =
  FirebaseFirestore.instance.collection('comments');
  static CollectionReference notificationsCollection =
  FirebaseFirestore.instance.collection('notifications');
  static CollectionReference reelsCollection =
  FirebaseFirestore.instance.collection('reels');
  static CollectionReference cardsCollection =
  FirebaseFirestore.instance.collection('cards');
  static CollectionReference walletTransactionsCollection =
  FirebaseFirestore.instance.collection('wallet transactions');
  static CollectionReference buyerFavoriteCollection =
  FirebaseFirestore.instance.collection('buyer favorites');
}
