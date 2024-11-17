import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  bool? phoneNumberVerified;
  bool? profileCompleted;
  String? userId;
  String? gender;
  String? fcmToken;
  String? address;
  String? addAddress;
  String? postalCode;
  List<String>? images;
  String? bio;
  String? country;
  String? state;
  String? city;
  String? profilePic;
  String? currentRole;
  String? language;
  String? accessCodeAndInstructions;
  double? latitude;
  double? longitude;

  UserModel({
    this.name,
    this.email,
    this.phoneNumber,
    this.addAddress,
    this.phoneNumberVerified,
    this.profileCompleted,
    this.postalCode,
    this.userId,
    this.fcmToken,
    this.profilePic,
    this.bio,
    this.country,
    this.state,
    this.city,
    this.address,
    this.language,
    this.currentRole,
    this.countryCode,
    this.accessCodeAndInstructions,
  });

  // Convert UserModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name ?? '',
      'email': email ?? '',
      'phoneNumber': phoneNumber ?? '',
      'userId': userId ?? '',
      'fcmToken': fcmToken ?? '',
      'profilePic': profilePic ?? '',
      'bio': bio ?? '',
      'country': country ?? '',
      'countryCode': countryCode ?? '+1',
      'state': state ?? '',
      'city': city ?? '',
      'language': language ?? '',
      'address': address ?? '',
      'currentRole': currentRole ?? 'buyer',
      'phoneNumberVerified': phoneNumberVerified ?? false,
      'profileCompleted': profileCompleted ?? false,
      'postalCode': postalCode ?? '',
      'addAddress': addAddress ?? '',
      'accessCodeAndInstructions': accessCodeAndInstructions ?? '',
    };
  }

  // Create a UserModel object from a map
  factory UserModel.fromMap(DocumentSnapshot map) {
    late UserModel user = UserModel();
    var documentData;
    //debugPrint("map ===========++>${map.data()}");
    if(map.data().toString() != "null"){
      documentData = map.data() as Map<String, dynamic>;
      String accessCodeAndInstructions = documentData.containsKey("accessCodeAndInstructions") ? map["accessCodeAndInstructions"] : "";
      user = UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        userId: map['userId'] ?? '',
        fcmToken: map['fcmToken'] ?? '',
        profilePic: map['profilePic'] ?? '',
        bio: map['bio'] ?? '',
        country: map['country'] ?? '',
        countryCode: map['countryCode'] ?? '',
        state: map['state'] ?? '',
        city: map['city'] ?? '',
        address: map['address'] ?? '',
        language: map['language']??'',
        currentRole: map['currentRole'] ?? '',
        addAddress: map['addAddress'] ?? '',
        phoneNumberVerified: map['phoneNumberVerified'] ?? false,
        profileCompleted: map['profileCompleted'] ?? false,
        postalCode: map['postalCode'] ?? '',
        accessCodeAndInstructions: accessCodeAndInstructions,
      );
    }
    return user;
  }
}
