import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_model.dart';

class OrderModel {
  CartModel? cartItem;
  String? totalPrice;
  String? orderId;
  String? customerId;
  String? storeId;
  String? orderStatus;
  String? cancellationReason;
  DateTime? orderDate;
  DateTime? cancellationDate;
  DateTime? deliveryDate;
  String? preferredDeliveryDelay;
  bool shouldBeDeliveredInLetterBox;
  bool isSelected;

  OrderModel({
    this.cartItem,
    this.totalPrice,
    this.orderId,
    this.storeId,
    this.customerId,
    this.orderStatus,
    this.orderDate,
    this.cancellationDate,
    this.deliveryDate,
    this.cancellationReason,
    this.preferredDeliveryDelay,
    this.shouldBeDeliveredInLetterBox = false,
    this.isSelected = false,
  });

  // Convert OrderModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'cartItem': cartItem?.toMap(),
      'totalPrice': totalPrice ?? '',
      'orderId': orderId ?? '',
      'storeId': storeId ?? '',
      'customerId': customerId ?? '',
      'orderStatus': orderStatus ?? "Pending",
      'cancellationReason': cancellationReason ?? '',
      'orderDate': orderDate?? DateTime.now(),
      'cancellationDate': cancellationDate,
      'deliveryDate': deliveryDate,
      'shouldBeDeliveredInLetterBox': shouldBeDeliveredInLetterBox,
      'preferredDeliveryDelay': preferredDeliveryDelay,
      'isSelected': isSelected,
    };
  }

  // Create an OrderModel object from a map
  factory OrderModel.fromMap(DocumentSnapshot map) {
    var documentData = map.data() as Map<String, dynamic>;
    bool _shouldBeDeliveredInLetterBox = documentData.containsKey("shouldBeDeliveredInLetterBox") ? map["shouldBeDeliveredInLetterBox"] : false;
    bool _isSelected = documentData.containsKey("isSelected") ? map["isSelected"] : false;
    String _preferredDeliveryDelay = documentData.containsKey("preferredDeliveryDelay") ? map["preferredDeliveryDelay"] : "";
    return OrderModel(
      cartItem: map['cartItem'] != null
          ? CartModel.fromMap1(map['cartItem'])
          : CartModel(),
      totalPrice: map['totalPrice'] ?? '',
      orderId: map['orderId'] ?? '',
      // storeOwnerId: map['storeOwnerId'] ?? '',
      storeId: map['storeId'] ?? '',
      customerId: map['customerId'] ?? '',
      orderStatus: map['orderStatus'] ?? "Pending",
      cancellationReason: map['cancellationReason'] ?? '',
      orderDate: map['orderDate'] != null
          ? (map['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      cancellationDate: map['cancellationDate'] != null
          ? (map['cancellationDate'] as Timestamp).toDate()
          : null,
      deliveryDate: map['deliveryDate'] != null ? (map['deliveryDate'] as Timestamp).toDate() : null,
      shouldBeDeliveredInLetterBox: _shouldBeDeliveredInLetterBox,
      preferredDeliveryDelay: _preferredDeliveryDelay,
      isSelected: _isSelected,
    );
  }
}
