import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_collections.dart';
import '../../core/utils/Utils.dart';
import '../../models/user_model.dart';
import '../../../core/models/Zone.dart';

class DeliverController extends GetxController{
  RxList<Zone> sellerZones = <Zone>[].obs;
  RxList<Zone> buyerZones = <Zone>[].obs;
  StreamSubscription? userDataStream;
  final buyerFormKey = GlobalKey<FormState>();

  /*getUserDataStream() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      userDataStream = await AppCollections.userCollection
          .doc(userId)
          .snapshots()
          .listen((event) {
        UserModel temp = UserModel.fromMap(event);
        sellerUserModel.value = temp;
      });
    }
  }*/

  disposeStream() async {
    if (userDataStream != null) {
      await userDataStream!.cancel();
    }
  }

  Rx<File?> selectedFile = Rx<File?>(null);


  Future<UserModel?> getSellerById({required String userId}) async {
    try {
      if (userId.isEmpty) {
        return null;
      }
      QuerySnapshot snap = await AppCollections.userCollection
          .where('userId', isEqualTo: userId)
          .where('currentRole', isEqualTo: "seller")
          .get();
      if (snap.docs.isEmpty) {
        return null;
      }
      if (snap.docs.first.exists == false) {
        return null;
      }
      UserModel storeModel = UserModel.fromMap(snap.docs.first);
      return storeModel;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> saveDeliverAgentSchedulesToFirestore({required List<Zone> sellerZones, required List<Zone> buyerZones}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try{
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(user.uid);

      // Vérifier si le document existe
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Le document existe, on fait un update
        await userDocRef.update({
          'role': 'delivery_agent',
          'availability': {
            'zones': {
              'seller_zone': sellerZones.map((z) => {
                'code': z.code,
                'slots': z.slots,
              }).toList(),
              'buyer_zone': buyerZones.map((z) => {
                'code': z.code,
                'slots': z.slots,
              }).toList(),
            },
          },
        }).then((_){
          Utils().showCustomSnackBar("Top !!!", "Vos modifications ont été sauvegardées avec succès");
        });
      } else {
        // Le document n'existe pas, on le crée avec set
        await userDocRef.set({
          'role': 'delivery_agent',
          'availability': {
            'zones': {
              'seller_zone': sellerZones.map((z) => {
                'code': z.code,
                'slots': z.slots,
              }).toList(),
              'buyer_zone': buyerZones.map((z) => {
                'code': z.code,
                'slots': z.slots,
              }).toList(),
            },
          },
        }).then((_){
          Utils().showCustomSnackBar("Top !!!", "Vos modifications ont été sauvegardées avec succès");
        });
      }
    }
    catch (e){
      debugPrint("Upload data Exception ============>$e");
    }
  }

  Future<void> fetchDeliveryZones() async {
    // Vérifier si un utilisateur est connecté
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Référence au document de l'utilisateur dans Firestore
    final firestore = FirebaseFirestore.instance;
    final userDocRef = firestore.collection('users').doc(user.uid);

    try {
      // Récupérer le document de l'utilisateur
      final docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        // Extraire les données du document
        final data = docSnapshot.data();
        final availability = data?['availability'] as Map<String, dynamic>?;
        final zones = availability?['zones'] as Map<String, dynamic>?;

        if (zones != null) {
          // Récupérer et convertir les sellerZones
          final sellerZonesData = zones['seller_zone'] as List<dynamic>? ?? [];
          final sellerZonesList = sellerZonesData.map((zone) {
            return Zone(
              zone['code'] as String,
              List<String>.from(zone['slots'] ?? []),
            );
          }).toList();

          // Récupérer et convertir les buyerZones
          final buyerZonesData = zones['buyer_zone'] as List<dynamic>? ?? [];
          final buyerZonesList = buyerZonesData.map((zone) {
            return Zone(
              zone['code'] as String,
              List<String>.from(zone['slots'] ?? []),
            );
          }).toList();

          sellerZones.value = sellerZonesList;
          buyerZones.value = buyerZonesList;
        }
      } else {
        debugPrint("Le document de l'utilisateur n'existe pas.");
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération des données : $e");
    }
  }


  @override
  void onInit() {
    fetchDeliveryZones();
    super.onInit();
  }
}