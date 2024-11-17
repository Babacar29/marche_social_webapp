import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String? productId;
  String? cartId;
  String? storeId;
  String? color;
  String? size;
  String? userId;
  String? productName;
  String? productImage;
  String? productPrice;
  String? shippingPrice;
  String? storeOwnerId;
  String? discountPrice;
  String? selectedDeliveryMethod;
  int? maxQuantity;
  int? selectedQuantity;
  bool? bought;
  bool canBeInLetterBox;
  List<String>? deliveriesMethods;

  CartModel({
    this.productId,
    this.storeId,
    this.color,
    this.size,
    this.cartId,
    this.userId,
    this.productName,
    this.productImage,
    this.productPrice,
    this.discountPrice,
    this.maxQuantity,
    this.selectedQuantity,
    this.bought,
    this.shippingPrice,
    this.storeOwnerId,
    this.deliveriesMethods,
    this.selectedDeliveryMethod,
    this.canBeInLetterBox = false,
  });

  // Convert CartModel object to a map
  Map<String, dynamic> toMap() {
    return {
      "productId": productId ?? '',
      "cartId": cartId ?? '',
      "userId": userId ?? '',
      "storeId": storeId ?? '',
      "color": color ?? '',
      "size": size ?? '',
      "productName": productName ?? '',
      "productImage": productImage ?? '',
      "productPrice": productPrice ?? '',
      "discountPrice": discountPrice ?? '',
      "storeOwnerId": storeOwnerId ?? '',
      "shippingPrice": shippingPrice ?? '',
      "maxQuantity": maxQuantity ?? 0,
      "selectedQuantity": selectedQuantity ?? 0,
      "bought": bought ?? false,
      "deliveriesMethods": deliveriesMethods ?? [],
      "selectedDeliveryMethod": selectedDeliveryMethod ?? '',
      "canBeInLetterBox": canBeInLetterBox,
    };
  }

  // Create a CartModel object from a map
  factory CartModel.fromMap(DocumentSnapshot map) {
    var documentData = map.data() as Map<String, dynamic>;
    return CartModel(
      productId: map['productId'] ?? '',
      cartId: map['cartId'] ?? '',
      userId: map['userId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      productPrice: map['productPrice'] ?? '',
      shippingPrice: map['shippingPrice'] ?? '',
      storeOwnerId: map['storeOwnerId'] ?? '',
      discountPrice: map['discountPrice'] ?? '',
      maxQuantity: map['maxQuantity'] ?? 0,
      selectedQuantity: map['selectedQuantity'] ?? 0,
      bought: map['bought'] ?? false,
      color: map['color']??'',
      storeId: map['storeId']??'',
      size: map['size']??'',
      deliveriesMethods: documentData.containsKey("deliveriesMethods") ? map['deliveriesMethods'].cast<String>() : [],
      selectedDeliveryMethod: documentData.containsKey("selectedDeliveryMethod") ? map['selectedDeliveryMethod'] : '',
      canBeInLetterBox: documentData.containsKey("canBeInLetterBox") ?  map['canBeInLetterBox'] : false,
    );
  }

  // Create a CartModel object from a map
  factory CartModel.fromMap1(Map<String, dynamic> map) {
    return CartModel(
        productId: map['productId'] ?? '',
        cartId: map['cartId'] ?? '',
        userId: map['userId'] ?? '',
        productName: map['productName'] ?? '',
        productImage: map['productImage'] ?? '',
        productPrice: map['productPrice'] ?? '',
        shippingPrice: map['shippingPrice'] ?? '',
        storeOwnerId: map['storeOwnerId'] ?? '',
        discountPrice: map['discountPrice'] ?? '',
        maxQuantity: map['maxQuantity'] ?? 0,
        selectedQuantity: map['selectedQuantity'] ?? 0,
        bought: map['bought'] ?? false,
        color: map['color']??'',
        storeId: map['storeId']??'',
        size: map['size']??'',
      deliveriesMethods: map['deliveriesMethods'].cast<String>(),
      selectedDeliveryMethod: map['selectedDeliveryMethod'] ?? '',
      canBeInLetterBox: map['canBeInLetterBox'] ?? false,
    );
  }
}
