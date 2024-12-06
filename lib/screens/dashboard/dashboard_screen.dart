import 'package:get/get.dart';
import 'package:marche_social_webapp/core/constants/color_constants.dart';

import 'package:marche_social_webapp/screens/dashboard/components/recent_users.dart';
import 'package:flutter/material.dart';

import '../../controllers/seller/seller_order_controller.dart';
import '../../controllers/seller/seller_store_controller.dart';
import '../../core/constants/app_collections.dart';
import '../../models/store_model.dart';
import '../../responsive.dart';
import 'components/header.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SellerStoreController stController = Get.find<SellerStoreController>();
  SellerOrderController soController = Get.find<SellerOrderController>();
  List<StoreModel> stores = [];
  List<bool> storesCanDoInstantDelivery = [];

  Future<void> updateStoresValues() async{
    List<StoreModel> storeModels = await stController.getInstantDeliveryStores();
    if(storeModels.isNotEmpty){
      for(var store in storeModels){
        await AppCollections.storeCollection
            .doc(store.storeId)
            .update({
          'canDoInstantDelivery': !store.canDoInstantDelivery!,
        });
      }
      storesCanDoInstantDelivery.clear();
    }
  }

  getInstantDeliveryStores() async{
    stores = await stController.getInstantDeliveryStores();

    if(stores.isNotEmpty){
      for(var store in stores){
        setState(() {
          storesCanDoInstantDelivery.add(store.canDoInstantDelivery!);
        });
      }
    }
  }

  void searchPending(String status) {
    setState(() {
      soController.instantDeliveryOrders.value = soController.instantDeliveryOrders.where((order){
        return order.orderStatus! == status;
      }).toList();
    });
  }


  @override
  void initState() {
    getInstantDeliveryStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: ListView(
            //padding: EdgeInsets.all(defaultPadding),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  //const Header(),
                  //SizedBox(height: defaultPadding),
                  //MiniInformation(),
                  Row(
                    children: [
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {},
                        ),
                      IconButton(
                          onPressed: () async{
                            await updateStoresValues().then((_){
                              getInstantDeliveryStores();
                              setState;
                            });
                          },
                          icon: Icon(Icons.power_settings_new_outlined, color:  storesCanDoInstantDelivery.contains(true) ? Colors.red : Colors.green, size: 25,)
                      ),
                      Text(
                        storesCanDoInstantDelivery.contains(true) ? "Activé" : "Désactivé",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(),
                      if (!Responsive.isMobile(context))
                        Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
                      //Expanded(child: SearchField()),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildInkWell(
                                text: "En cours",
                                onTap: (){
                                  searchPending("Pending");
                                }
                            ),
                            buildInkWell(
                                text: "Pending",
                                onTap: (){
                                  searchPending("");
                                }
                            ),
                            buildInkWell(
                                text: "Tout",
                                onTap: (){
                                  soController.getOrders();
                                }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30,),
                      const ProfileCard(),
                      const SizedBox(width: 20,),
                    ],
                  ),
                  const SizedBox(height: defaultPadding),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 1.5,
                    height: MediaQuery.sizeOf(context).height,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: RecentUsers(orders: soController.instantDeliveryOrders,)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell({required String text, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10)
        ),
        //width: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 14
            ),
          ),
        ),
      ),
    );
  }
}
