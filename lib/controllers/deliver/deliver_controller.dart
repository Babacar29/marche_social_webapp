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

  Future<void> saveDeliverAgentSchedulesToFirestore({required List<Zone> sellerZones}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(user.uid);

      // Vérifier si le document existe
      final docSnapshot = await userDocRef.get();

      // Préparer les données à sauvegarder
      final availabilityData = {
        'zones': {
          'seller_zone': sellerZones.map((z) => {
            'code': z.code,
            'slots': z.slots,
            'buyer_zones': z.buyerZones.map((bz) => {
              'code': bz.code,
              'slots': bz.slots,
            }).toList(),
          }).toList(),
        },
      };

      if (docSnapshot.exists) {
        // Le document existe, on fait un update
        await userDocRef.update({
          'role': 'delivery_agent',
          'availability': availabilityData,
        }).then((_) {
          Utils().showCustomSnackBar("Top !!!", "Vos modifications ont été sauvegardées avec succès");
        });
      } else {
        // Le document n'existe pas, on le crée avec set
        await userDocRef.set({
          'role': 'delivery_agent',
          'availability': availabilityData,
        }).then((_) {
          Utils().showCustomSnackBar("Top !!!", "Vos modifications ont été sauvegardées avec succès");
        });
      }
    } catch (e) {
      debugPrint("Upload data Exception ============>$e");
    }
  }

 Future<void> fetchDeliveryZones() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final userDocRef = firestore.collection('users').doc(user.uid);

    try {
      final docSnapshot = await userDocRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final availability = data?['availability'] as Map<String, dynamic>?;
        final zones = availability?['zones'] as Map<String, dynamic>?;

        if (zones != null) {
          final sellerZonesData = zones['seller_zone'] as List<dynamic>? ?? [];
          sellerZones.value = sellerZonesData.map((zone) {
            final buyerZonesData = zone['buyer_zones'] as List<dynamic>? ?? [];
            final buyerZonesList = buyerZonesData.map((bz) {
              return BuyerZone(
                bz['code'] as String,
                List<String>.from(bz['slots'] ?? []),
              );
            }).toList();
            return Zone(
              zone['code'] as String,
              List<String>.from(zone['slots'] ?? []),
              buyerZonesList,
            );
          }).toList();
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