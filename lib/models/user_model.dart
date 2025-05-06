import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  bool? phoneNumberVerified;
  bool? profileCompleted;
  bool? isOnline;
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
    this.isOnline,
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
      'isOnline': isOnline ?? false,
    };
  }

  // Create a UserModel object from a map
  factory UserModel.fromMap(DocumentSnapshot map) {
    // Récupérer les données du document
    final documentData = map.data() as Map<String, dynamic>?;

    // Si les données sont null, retourner un UserModel avec des valeurs par défaut
    if (documentData == null) {
      return UserModel(
        name: '',
        email: '',
        phoneNumber: '',
        userId: '',
        fcmToken: '',
        profilePic: '',
        bio: '',
        country: '',
        countryCode: '',
        state: '',
        city: '',
        address: '',
        language: '',
        currentRole: '',
        addAddress: '',
        phoneNumberVerified: false,
        profileCompleted: false,
        postalCode: '',
        accessCodeAndInstructions: '',
        isOnline: false,
      );
    }

    // Fonction helper pour récupérer un String en toute sécurité
    String safeString(String key) {
      return documentData.containsKey(key) ? (documentData[key] as String? ?? '') : '';
    }

    // Fonction helper pour récupérer un booléen en toute sécurité
    bool safeBool(String key) {
      return documentData.containsKey(key) ? (documentData[key] as bool? ?? false) : false;
    }

    // Construire et retourner l'instance de UserModel
    return UserModel(
      name: safeString('name'),
      email: safeString('email'),
      phoneNumber: safeString('phoneNumber'),
      userId: documentData['userId'] as String? ?? '', // Cas spécial pour userId
      fcmToken: safeString('fcmToken'),
      profilePic: safeString('profilePic'),
      bio: safeString('bio'),
      country: safeString('country'),
      countryCode: safeString('countryCode'),
      state: safeString('state'),
      city: safeString('city'),
      address: safeString('address'),
      language: safeString('language'),
      currentRole: safeString('currentRole'),
      addAddress: safeString('addAddress'),
      phoneNumberVerified: safeBool('phoneNumberVerified'),
      profileCompleted: safeBool('profileCompleted'),
      postalCode: safeString('postalCode'),
      accessCodeAndInstructions: safeString('accessCodeAndInstructions'),
      isOnline: safeBool('isOnline'),
    );
  }
}
