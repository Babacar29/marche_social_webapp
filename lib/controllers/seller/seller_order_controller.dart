import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/constants/app_collections.dart';
import '../../models/order_model.dart';
import '../../models/store_model.dart';


class SellerOrderController extends GetxController {
  RxList<OrderModel> allOrders = <OrderModel>[].obs;
  RxList<OrderModel> completedOrders = <OrderModel>[].obs;
  RxList<OrderModel> onGoingOrders = <OrderModel>[].obs;
  RxList<OrderModel> pendingOrders = <OrderModel>[].obs;
  RxList<OrderModel> deliveredOrders = <OrderModel>[].obs;
  RxList<OrderModel> cancelledOrders = <OrderModel>[].obs;
  RxList<OrderModel> pendingValidationOrders = <OrderModel>[].obs;
  RxList<OrderModel> instantDeliveryOrders = <OrderModel>[].obs;
  RxList<OrderModel> validatedOrders = <OrderModel>[].obs;
  RxList<MapEntry<String, List<OrderModel>>> ordersWithDate =
      <MapEntry<String, List<OrderModel>>>[].obs;
  var storeModel = Rxn<StoreModel>();
  StreamSubscription<QuerySnapshot<Object?>>? sellerChatStream;

  Future<void> getOrders() async {

    sellerChatStream = AppCollections.ordersCollection
        .snapshots()
        .listen((event) {
      List<OrderModel> temp = [];
      for (var element in event.docs) {

        OrderModel order = OrderModel.fromMap(element);
        if(order.cartItem?.selectedDeliveryMethod == "Instant Delivery" && order.orderStatus != "Cancelled" && order.orderStatus != "Completed" && order.orderStatus != "Delivered"){
          //pendingValidation.add(order);
          temp.add(OrderModel.fromMap(element));
        }
        instantDeliveryOrders.value = temp;
      }
    });

  }

  Future<void> getDeliveredOrders() async {
    sellerChatStream = AppCollections.ordersCollection
        .snapshots()
        .listen((event) {
      List<OrderModel> temp = [];
      for (var element in event.docs) {

        OrderModel order = OrderModel.fromMap(element);
        if(order.cartItem?.selectedDeliveryMethod == "Instant Delivery" && order.orderStatus == "Delivered"){
          temp.add(OrderModel.fromMap(element));
        }
        deliveredOrders.value = temp;
      }
    });
  }

  Future<void> getCancelledOrders() async {
    sellerChatStream = AppCollections.ordersCollection
        .snapshots()
        .listen((event) {
      List<OrderModel> temp = [];
      for (var element in event.docs) {

        OrderModel order = OrderModel.fromMap(element);
        if(order.cartItem?.selectedDeliveryMethod == "Instant Delivery" && order.orderStatus == "Cancelled"){
          temp.add(OrderModel.fromMap(element));
        }
        cancelledOrders.value = temp;
      }
    });
  }

  String getGrossAmount() {
    double total = 0;
    List<OrderModel> temp = List.from(allOrders);
    for (var element in temp) {
      String orderPrice = element.totalPrice?.replaceAll("€", "") ?? '0';
      int quantity = element.cartItem!.selectedQuantity!;
      double? numPrice = double.tryParse(orderPrice)! * quantity;
      total += numPrice;
    }
    return total.toString();
  }

  String getPendingOrdersLength() {
    int total = 0;
    List<OrderModel> temp = List.from(allOrders);
    List<OrderModel> data = [];
    for (var element in temp) {
      if (element.orderStatus == "Pending") {
        total++;
        data.add(element);
      }
    }
    pendingOrders.value = data;
    return total.toString();
  }

  String getCompletedOrderLength() {
    int total = 0;
    List<OrderModel> temp = List.from(allOrders);
    List<OrderModel> data = [];
    for (var element in temp) {
      if (element.orderStatus.toString() == "Completed") {
        data.add(element);
        total++;
      }
    }

    completedOrders.value = data;
    return total.toString();
  }

  void getOnGoingOrders() {
    List<OrderModel> temp = List.from(instantDeliveryOrders);
    List<OrderModel> data = [];
    for (var element in temp) {
      if (element.orderStatus.toString() != "Completed" && element.orderStatus.toString() != "Cancelled") {
        data.add(element);
      }
    }

    onGoingOrders.value = data;
  }

  String getCancelledOrdersLength() {
    int total = 0;
    List<OrderModel> temp = List.from(allOrders);
    for (var element in temp) {
      if (element.orderStatus == "Cancelled") {
        total++;
      }
    }
    return total.toString();
  }

  String getConfirmedOrdersLength() {
    int total = 0;
    List<OrderModel> temp = List.from(allOrders);
    for (var element in temp) {
      if (element.orderStatus == "Confirmed") {
        total++;
      }
    }
    return total.toString();
  }

  String getDeliveredOrdersLength() {
    int total = 0;
    List<OrderModel> temp = List.from(allOrders);
    for (var element in temp) {
      if (element.orderStatus == "Pending") {
        total++;
      }
    }
    return total.toString();
  }

  getStoreInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      StoreModel? temp = await getStoreByOwnerId(
          ownerId: FirebaseAuth.instance.currentUser!.uid.toString());
      if (temp != null) {
        storeModel.value = temp;
        getOrders();
      } else {
        storeModel.value = null;
      }
    }
  }

  Future<StoreModel?> getStoreByOwnerId({required String ownerId}) async {
    try {
      if (ownerId.isEmpty) {
        return null;
      }
      QuerySnapshot snap = await AppCollections.storeCollection
          .where('ownerId', isEqualTo: ownerId)
          .get();
      if (snap.docs.isEmpty) {
        return null;
      }
      if (snap.docs.first.exists == false) {
        return null;
      }
      StoreModel? storeModel = StoreModel.fromMap(snap.docs.first);
      return storeModel;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  void getInstantDeliveryOrders() {
    List<OrderModel> temp = List.from(allOrders);
    List<OrderModel> data = [];
    for (var element in temp) {
      if (element.cartItem?.selectedDeliveryMethod == "Instant Delivery") {
        //total++;
        data.add(element);
      }
    }
    instantDeliveryOrders.value = data;


    //return total.toString();
  }

  @override
  void onInit() {
    getStoreInfo();
    getCompletedOrderLength();
    getPendingOrdersLength();
    getOnGoingOrders();
    super.onInit();
  }
}
