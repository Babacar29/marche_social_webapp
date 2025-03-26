import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/controllers/buyer/buyer_profile_controller.dart';
import 'package:marche_social_webapp/controllers/seller/seller_store_controller.dart';
import 'package:marche_social_webapp/models/order_model.dart';
import 'package:flutter/material.dart';

import '../../../controllers/seller/seller_order_controller.dart';
import '../../../controllers/seller/seller_profile_controller.dart';


class DeliverySetting extends StatefulWidget {
  const DeliverySetting({
    super.key,
    this.orders
  });
  final List<OrderModel>? orders;

  @override
  State<DeliverySetting> createState() => _DeliverySettingState();
}

class _DeliverySettingState extends State<DeliverySetting> {
  SellerOrderController soController = Get.find<SellerOrderController>();
  SellerProfileController suController = Get.find<SellerProfileController>();
  SellerStoreController sellerStoreController = Get.find<SellerStoreController>();
  BuyerProfileController buController = Get.find<BuyerProfileController>();
  List<OrderModel> orders = [];
  List<OrderModel> selectedOrders = [];

  getData(){
    soController.onInit();
    soController.getOrders();
    if(!mounted) return;
    /*setState(() {
      orders = soController.instantDeliveryOrders;
    });
    if(widget.orders.isEmpty){
      setState(() {
        orders = soController.instantDeliveryOrders;
      });
    }
    else{
      setState(() {
        orders = widget.orders;
      });
    }*/

    setState(() {
      orders = soController.instantDeliveryOrders;
    });
  }

  List<DeliveryZone> zones = [
    DeliveryZone("75019", [
      BuyerZone("75020", ["4h", "6h"]),
      BuyerZone("93200", ["6h", "24h"])
    ]),
  ];

  Future<void> saveToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'availability': {
        'zones': zones.map((z) => {
          'seller_zone': z.sellerZone,
          'buyer_zones': z.buyerZones.map((bz) => {'code': bz.code, 'slots': bz.slots}).toList(),
        }).toList(),
      },
    });
  }

  @override
  void initState() {
    //getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: height,
      width: width,
      child: ListView.builder(
        itemCount: zones.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text("Zone vendeur: ${zones[index].sellerZone}"),
            children: zones[index].buyerZones.map((bz) {
              return SizedBox(
                width: width/2,
                child: ListTile(
                  title: Text("Zone acheteur: ${bz.code}"),
                  subtitle: Text("Créneaux: ${bz.slots.join(', ')}"),
                  hoverColor: Colors.white.withValues(alpha: 0.4),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Modifier les créneaux
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }


}

//error: The argument type 'Color' can't be assigned to the parameter type 'MaterialStateProperty<Color?>?'.  (argument_type_not_assignable at [marche_social_webapp] lib/screens/dashboard/components/recent_users.dart:113)

class DeliveryZone {
  String sellerZone;
  List<BuyerZone> buyerZones;
  DeliveryZone(this.sellerZone, this.buyerZones);
}

class BuyerZone {
  String code;
  List<String> slots;
  BuyerZone(this.code, this.slots);
}