import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String? storeName;
  String? storeImg;
  List<String>? categories;
  String? website;
  String? email;
  String? phoneNumber;
  String? country;
  String? state;
  String? city;
  String? address;
  String? postalCode;
  String? description;
  String? storeId;
  String? ownerId;
  String? minTimeSchedule;
  String? maxTimeSchedule;
  DateTime? createdDate;
  List<String>? followers;
  List<String>? deliveryMethods;
  List<String>? daysSchedule;
  bool? canDoInstantDelivery;
  bool? isInstantDeliveryScheduleSet;
  bool? available;

  StoreModel({
    this.storeName,
    this.storeImg,
    this.categories,
    this.website,
    this.email,
    this.phoneNumber,
    this.country,
    this.state,
    this.city,
    this.address,
    this.postalCode,
    this.description,
    this.storeId,
    this.ownerId,
    this.createdDate,
    this.followers,
    this.canDoInstantDelivery,
    this.deliveryMethods,
    this.isInstantDeliveryScheduleSet,
    this.available = false,
    this.daysSchedule,
    this.maxTimeSchedule,
    this.minTimeSchedule,
  });

  // Convert StoreModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName ?? '',
      'storeImg': storeImg ?? '',
      'categories': categories ?? [],
      'website': website ?? '',
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'country': country ?? '',
      'state': state ?? '',
      'city': city ?? '',
      'address': address ?? '',
      'postalCode': postalCode ?? '',
      'description': description ?? '',
      'storeId': storeId ?? '',
      'ownerId': ownerId ?? '',
      'maxTimeSchedule': maxTimeSchedule ?? '',
      'minTimeSchedule': minTimeSchedule ?? '',
      'followers': followers ?? [],
      'deliveryMethods': deliveryMethods ?? [],
      'daysSchedule': daysSchedule ?? [],
      'createdDate': createdDate ?? Timestamp.now(),
      'canDoInstantDelivery': canDoInstantDelivery ?? false,
      'isInstantDeliveryScheduleSet': isInstantDeliveryScheduleSet ?? false,
      'available': available,
    };
  }

  // Create a StoreModel object from a map
  factory StoreModel.fromMap(DocumentSnapshot map) {
    Timestamp? createdTimestamp = map['createdDate'] as Timestamp?;
    DateTime? createdDate = createdTimestamp != null ? createdTimestamp.toDate() : null;
    var documentData = map.data() as Map<String, dynamic>;
    List<String> _daysSchedule = documentData.containsKey("daysSchedule") ? List<String>.from(map['daysSchedule']) : [];
    return StoreModel(
      storeName: map['storeName'] ?? '',
      storeImg: map['storeImg'] ?? '',
      categories: List<String>.from(map['categories'] ?? []),
      website: map['website'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      postalCode: map['postalCode'] ?? '',
      description: map['description'] ?? '',
      storeId: map['storeId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      maxTimeSchedule: map['maxTimeSchedule'] ?? '',
      minTimeSchedule: map['minTimeSchedule'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      deliveryMethods: List<String>.from(map['deliveryMethods'] ?? []),
      daysSchedule: _daysSchedule,
      createdDate: createdDate,
      canDoInstantDelivery: map["canDoInstantDelivery"] ?? false,
      isInstantDeliveryScheduleSet: map["isInstantDeliveryScheduleSet"] ?? false,
      available: map["available"] != null ? map["available"] : false,
    );
  }
}
