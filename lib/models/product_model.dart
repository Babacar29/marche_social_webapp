import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? type;
  String? name;
  List<String>? categories;
  String? description;
  String? specs;
  String? price;
  String? discount;
  String? shippingFee;
  List<String>? colors;
  List<String>? size;
  String? quantity;
  String? brand;
  String? productId;
  String? publisherId;
  String? storeId;
  String? condition;
  String? city;
  List<String>? tags;
  List<String>? images;
  List<String>? shippingOptions;
  List<Map<String, dynamic>>? deliveryDelayOptions;
  DateTime? postedAt;
  bool isFavorite;
  bool canBeInLetterBox;

  ProductModel(
      {this.type,
      this.name,
      this.categories,
      this.description,
      this.specs,
      this.price,
      this.discount,
      this.shippingFee,
      this.colors,
      this.size,
      this.quantity,
      this.brand,
      this.condition,
      this.city,
      this.tags,
      this.images,
      this.shippingOptions,
      this.deliveryDelayOptions,
      this.postedAt,
      this.storeId,
      this.productId,
      this.publisherId,
      this.isFavorite = false,
      this.canBeInLetterBox = false,
      });

  // Convert ProductModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'type': type ?? '',
      'name': name ?? '',
      'categories': categories ?? [],
      'description': description ?? '',
      'specs': specs ?? '',
      'price': price ?? '',
      'discount': discount ?? '',
      'shippingFee': shippingFee ?? '',
      'colors': colors ?? [],
      'size': size ?? [],
      'quantity': quantity ?? '',
      'brand': brand ?? '',
      'condition': condition ?? '',
      'city': city ?? '',
      'storeId': storeId ?? '',
      'productId': productId ?? '',
      'publisherId': publisherId ?? '',
      'tags': tags ?? [],
      'images': images ?? [],
      'shippingOptions': shippingOptions ?? [],
      'deliveryDelayOptions': deliveryDelayOptions ?? [],
      'postedAt': postedAt ?? DateTime.now(),
      'isFavorite': isFavorite,
      'canBeInLetterBox': canBeInLetterBox,
    };
  }

  // Create a ProductModel object from a map
  factory ProductModel.fromMap(DocumentSnapshot map) {
    Timestamp? createdTimestamp = map['postedAt'] as Timestamp?;
    DateTime? createdDate =
        createdTimestamp != null ? createdTimestamp.toDate() : null;
    var documentData = map.data() as Map<String, dynamic>;
    bool canBeInLetterBox = documentData.containsKey("canBeInLetterBox") ? map["canBeInLetterBox"] : false;
    return ProductModel(
      type: map['type'] ?? '',
      name: map['name'] ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      description: map['description'] ?? '',
      specs: map['specs'] ?? '',
      price: map['price'] ?? '',
      storeId: map['storeId'] ?? '',
      productId: map['productId'] ?? '',
      publisherId: map['publisherId'] ?? '',
      discount: map['discount'] ?? '',
      city: map['city'] ?? '',
      shippingFee: map['shippingFee'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      size: List<String>.from(map['size'] ?? []),
      quantity: map['quantity'] ?? '',
      brand: map['brand'] ?? '',
      condition: map['condition'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      shippingOptions: List<String>.from(map['shippingOptions'] ?? []),
      //deliveryDelayOptions: List<Map<String, dynamic>>.from(map['deliveryDelayOptions'] ?? []),
      postedAt: createdDate,
      isFavorite: map["isFavorite"] ?? false,
      canBeInLetterBox: canBeInLetterBox,
    );
  }
}
