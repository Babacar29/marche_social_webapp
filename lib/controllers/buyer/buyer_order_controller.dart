import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


import '../../core/constants/app_collections.dart';
import '../../models/order_model.dart';

class BuyerOrderController extends GetxController {
  RxList<OrderModel> allOrder = <OrderModel>[].obs;
  RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  RxList<OrderModel> onGoingOrders = <OrderModel>[].obs;
  StreamSubscription<QuerySnapshot<Object?>>? buyerOrderStream;

  getOrders() async {

    buyerOrderStream = AppCollections.ordersCollection
        .where('customerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .listen((event) {
      List<OrderModel> tempAllOrders = [];
      for (var element in event.docs) {
        tempAllOrders.add(OrderModel.fromMap(element));
      }
      allOrder.value = tempAllOrders;
      sortOrders();
    });
  }

  sortOrders() {
    List<OrderModel> tempOrder = List.from(allOrder);
    List<OrderModel> tempCompletedOrders = [];
    List<OrderModel> tempOnGoingOrder = [];
    for (var element in tempOrder) {
      if (element.orderStatus == "Delivered") {
        tempCompletedOrders.add(element);
      }
      if(element.orderStatus == "Pending" || element.orderStatus == "OnTheWay"
          || element.orderStatus == "Confirmed" || element.orderStatus == "SellerUnavailable" || element.orderStatus == "BuyerUnavailable"){
        tempOnGoingOrder.add(element);
      }
    }
    onGoingOrders.value=tempOnGoingOrder;
    completedOrders.value=tempCompletedOrders;
  }

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  @override
  void onClose() {
    if (buyerOrderStream != null) {
      buyerOrderStream!.cancel();
    }
    super.onClose();
  }
}
