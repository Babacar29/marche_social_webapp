import 'package:get/get.dart';
import 'package:marche_social_webapp/core/constants/color_constants.dart';
import 'package:marche_social_webapp/core/utils/colorful_tag.dart';
import 'package:marche_social_webapp/models/order_model.dart';

import 'package:marche_social_webapp/screens/dashboard/components/instant_delivery_orders.dart';
import 'package:flutter/material.dart';

import '../../controllers/seller/seller_order_controller.dart';
import '../../controllers/seller/seller_store_controller.dart';
import '../../core/constants/app_collections.dart';
import '../../core/local_storage/sharedPrefs.dart';
import '../../models/store_model.dart';
import '../../responsive.dart';
import '../home/components/delivery_setting.dart';
import 'components/header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SellerStoreController stController = Get.find<SellerStoreController>();
  SellerOrderController soController = Get.find<SellerOrderController>();
  List<StoreModel> stores = [];
  List<OrderModel> orders = [];
  List<bool> storesCanDoInstantDelivery = [];
  bool isOnGoingActive = true;
  bool isDeliveredActive = false;
  bool isCancelledActive = false;
  bool isParamsActive = false;
  final SharedPreferencesServices service = SharedPreferencesServices();

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

  void searchDelivered() {
    soController.getDeliveredOrders().then((_){
      setState(() {
        soController.instantDeliveryOrders.value = soController.deliveredOrders;
      });
    });
  }

  void searchCanceled() {
    soController.getCancelledOrders().then((_){
      setState(() {
        soController.instantDeliveryOrders.value = soController.cancelledOrders;
      });
    });
  }

  void searchOnGoing() {
    soController.getOrders();
  }

  /*void getPendingOrders() {
    setState(() {
     orders = soController.instantDeliveryOrders.where((order){
        return (order.orderStatus! != ct.cancelled && order.orderStatus! != ct.delivered);
      }).toList();
     debugPrint("orders =========>$orders");
    });
  }

  void getDefaultPendingOrders() {
    setState(() {
     orders = soController.instantDeliveryOrders.where((order){
        return (order.orderStatus! != ct.cancelled && order.orderStatus! != ct.delivered);
      }).toList();
     debugPrint("orders =========>$orders");
    });
  }*/

  @override
  void initState() {
    getInstantDeliveryStores();
    //getDefaultPendingOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height =  MediaQuery.sizeOf(context).height;
    final width =  MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: SizedBox(
        height: height,
        width: width,
        child: Row(
          children: [
            SizedBox(
              height: height,
              width: width/8,
              child: Container(
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height/10,),
                    buildTextButton(
                        text: "En cours",
                        onPressed: (){
                          searchOnGoing();
                          setState(() {
                            isOnGoingActive = true;
                            isDeliveredActive = false;
                            isParamsActive = false;
                            isCancelledActive = false;
                          });
                        },
                        isActive: isOnGoingActive
                    ),
                    SizedBox(height: height/30,),
                    buildTextButton(
                        text: "Livrées",
                        onPressed: (){
                          searchDelivered();
                          setState(() {
                            isOnGoingActive = false;
                            isDeliveredActive = true;
                            isParamsActive = false;
                            isCancelledActive = false;
                          });
                        },
                        isActive: isDeliveredActive
                    ),
                    SizedBox(height: height/30,),
                    buildTextButton(
                        text: "Annulées",
                        onPressed: (){
                          searchCanceled();
                          setState(() {
                            isOnGoingActive = false;
                            isDeliveredActive = false;
                            isParamsActive = false;
                            isCancelledActive = true;
                          });
                        },
                        isActive: isCancelledActive
                    ),
                    SizedBox(height: height/30,),
                    service.getUserRoleFromSharedPref() != "delivery_agent" ? const SizedBox() : buildTextButton(
                        text: "Paramètres",
                        onPressed: (){
                          setState(() {
                            isOnGoingActive = false;
                            isDeliveredActive = false;
                            isParamsActive = true;
                            isCancelledActive = false;
                          });
                        },
                        isActive: isParamsActive
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
                            /*Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  buildInkWell(
                                      text: "En cours",
                                      onTap: (){
                                        //search("Pending");
                                      }
                                  ),
                                  buildInkWell(
                                      text: "Pending",
                                      onTap: (){
                                        //search("");
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
                            ),*/
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
                              child: isParamsActive ? const DeliverySetupScreen() : const InstantDeliveryOrders()
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton buildTextButton({VoidCallback? onPressed, required String text, required bool isActive}) {
    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isActive ? kBlueColor : Colors.white,
                fontSize: isActive ? 15 : 13
            ),
                ),
        )
    );
  }

  InkWell buildInkWell({required String text, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
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
