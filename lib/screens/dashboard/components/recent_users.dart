import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marche_social_webapp/constants.dart' as ct;
import 'package:marche_social_webapp/controllers/buyer/buyer_profile_controller.dart';
import 'package:marche_social_webapp/controllers/seller/seller_store_controller.dart';
import 'package:marche_social_webapp/core/constants/color_constants.dart';
import 'package:marche_social_webapp/core/utils/colorful_tag.dart';
import 'package:marche_social_webapp/models/order_model.dart';
import 'package:flutter/material.dart';

import '../../../controllers/seller/seller_order_controller.dart';
import '../../../controllers/seller/seller_profile_controller.dart';
import '../../../core/constants/app_collections.dart';
import '../../../core/utils/Utils.dart';
import '../../../responsive.dart';

class RecentUsers extends StatefulWidget {
  const RecentUsers({
    Key? key,
    required this.orders
  }) : super(key: key);
  final List<OrderModel> orders;

  @override
  State<RecentUsers> createState() => _RecentUsersState();
}

class _RecentUsersState extends State<RecentUsers> {
  SellerOrderController soController = Get.find<SellerOrderController>();
  SellerProfileController suController = Get.find<SellerProfileController>();
  SellerStoreController sellerStoreController = Get.find<SellerStoreController>();
  BuyerProfileController buController = Get.find<BuyerProfileController>();
  List<OrderModel> orders = [];
  List<OrderModel> selectedOrders = [];

  getData(){
    soController.onInit();
    soController.getOrders();
    debugPrint("Orders ========+>${soController.instantDeliveryOrders}");
    if(!mounted) return;
    setState(() {
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
    }

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child:  DataTable(
            horizontalMargin: 10,
            columnSpacing: defaultPadding,
            checkboxHorizontalMargin: 20,
            showCheckboxColumn: true,
            //dataRowColor: isSelected ? WidgetStateProperty.all<Color>(kBlueColor.withOpacity(0.2)) : WidgetStateProperty.all<Color>(Colors.transparent),
            /*isHorizontalScrollBarVisible: true,
                checkboxAlignment: Alignment.centerLeft,*/

            /*onSelectAll: (value){
                  setState(() {
                    isSelected = !isSelected;
                  });
                },*/
            //showHeadingCheckBox: true,
            columns: const[
              DataColumn(
                label: Text("Date & Heure\nde la commande", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Date & Heure\nmax de livraison", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Vendeur/Acheteur\nNom & Téléphone", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Fiche Produit", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Adresse Vendeur", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Code Postal\nVendeur", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Adresse Acheteur", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Code Postal\nAcheteur", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Livraison en\nboite au lettre", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Coùt de la\nlivraison", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Coùt Total\ndu produit", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Numéro de la\n commande", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Horaires livraison\n express", textAlign: TextAlign.center,),
              ),
              DataColumn(
                label: Text("Statut", textAlign: TextAlign.center,),
              ),
            ],
            rows: List.generate(
              orders.length,
                  (index) => recentUserDataRow(orders[index], context, suController, buController, sellerStoreController),
            ),
          ),
        ),
        if (!Responsive.isMobile(context))
          const SizedBox(width: defaultPadding),
        const SizedBox(height: 30,),
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInkWell(
                  text: "Pris en charge",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.confirmed);
                      }
                      Utils.showSuccessSnackbar(
                          title: 'Success',
                          msg: 'Order status successfully updated!'
                      );
                    }
                  }
              ),
              buildInkWell(
                  text: "En cours de livraison",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.onTheWay);
                      }
                      Utils.showSuccessSnackbar(
                          title: 'Success',
                          msg: 'Order status successfully updated!'
                      );
                    }
                  }
              ),
              buildInkWell(
                  text: "Livré",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.delivered);
                      }
                    }
                    Utils.showSuccessSnackbar(
                        title: 'Success',
                        msg: 'Order status successfully updated!'
                    );
                  }
              ),
              buildInkWell(
                  text: "Vendeur Absent",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.sellerUnavailable);
                      }
                      Utils.showSuccessSnackbar(
                          title: 'Success',
                          msg: 'Order status successfully updated!'
                      );
                    }
                  }
              ),
              buildInkWell(
                  text: "Acheteur Absent",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.buyerUnavailable);
                      }
                      Utils.showSuccessSnackbar(
                          title: 'Success',
                          msg: 'Order status successfully updated!'
                      );
                    }
                  }
              ),
              buildInkWell(
                  text: "Annulé",
                  onTap: (){
                    if(selectedOrders.isNotEmpty){
                      for(var selec in selectedOrders){
                        updateOrderStatus(orderId: selec.orderId ?? "", status: ct.cancelled);
                      }
                      Utils.showSuccessSnackbar(
                          title: 'Success',
                          msg: 'Order status successfully updated!'
                      );
                    }
                  }
              ),
            ],
          ),
        )
      ],
    ));
  }

  DataRow recentUserDataRow(OrderModel orderInfo, BuildContext context, SellerProfileController sController, BuyerProfileController buyerController, SellerStoreController sellerStoreController) {
    //debugPrint("uid ==========>${orderInfo.cartItem!.storeOwnerId!}");
    sController.getStoreInfo(uid: orderInfo.cartItem!.storeOwnerId!);
    buyerController.getBuyerInfo(uid: orderInfo.customerId!);
    sellerStoreController.getStoreInfo(ownerId: orderInfo.cartItem!.storeOwnerId ?? "");
    var storeData = sellerStoreController.storeModel.value;
    return DataRow(
      onSelectChanged: (value){
        setState((){
          orderInfo.isSelected = !orderInfo.isSelected;
        });
        if(!selectedOrders.contains(orderInfo)){
          selectedOrders.add(orderInfo);
        }
        else{
          selectedOrders.remove(orderInfo);
        }
      },
      color: orderInfo.isSelected == true ? WidgetStateProperty.all<Color>(kBlueColor.withOpacity(0.2)) : WidgetStateProperty.all<Color>(Colors.transparent),
      selected: orderInfo.isSelected,
      cells: [
        DataCell(
          Text(
            DateFormat("dd/MM/yy HH:mm").format(orderInfo.orderDate!),
            textAlign: TextAlign.center,
          ),
        ),
        DataCell(
          Text(
            Utils().calculateDeliveryDelay(schedule: orderInfo.preferredDeliveryDelay!, orderDate: orderInfo.orderDate!),
            //DateFormat("dd/MM/yy HH:mm").format(orderInfo.orderDate!), textAlign: TextAlign.center,
          ),
        ),
        DataCell(Text("${sController.sellerUserModel.value.name}\n${sController.sellerUserModel.value.phoneNumber}\n\n${buyerController.buyerUserModel.value.name}\n${buyerController.buyerUserModel.value.phoneNumber}", textAlign: TextAlign.center,)),
        DataCell(Text(orderInfo.cartItem!.productName!, textAlign: TextAlign.center,)),
        DataCell(Text("${sController.sellerUserModel.value.address}", textAlign: TextAlign.center,)),
        DataCell(Text("${sController.sellerUserModel.value.postalCode}", textAlign: TextAlign.center,)),
        DataCell(Text("${buyerController.buyerUserModel.value.address}", textAlign: TextAlign.center,)),
        DataCell(Text("${buyerController.buyerUserModel.value.postalCode}", textAlign: TextAlign.center,)),
        DataCell(Text( orderInfo.shouldBeDeliveredInLetterBox == true ? "OUI" : "NON", textAlign: TextAlign.center,)),
        DataCell(Text(orderInfo.totalPrice!, textAlign: TextAlign.center,)),
        DataCell(Text(orderInfo.cartItem!.productPrice!, textAlign: TextAlign.center,)),
        DataCell(Text("Order #${orderInfo.orderId!.substring(0, 10)}", textAlign: TextAlign.center,)),
        DataCell(
            Text("De ${storeData?.minTimeSchedule} à ${storeData?.maxTimeSchedule}\n${storeData?.daysSchedule}" ?? "", textAlign: TextAlign.center,)
        ),
        DataCell(Text(orderInfo.orderStatus!, textAlign: TextAlign.center,)),
      ],
    );
  }

  void updateOrderStatus({required String orderId, status}) async{
    await AppCollections.ordersCollection
        .doc(orderId)
        .update({
      'orderStatus': status,
    });
  }

  InkWell buildInkWell({required String text, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: kBlueColor,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16
            ),
          ),
        ),
      ),
    );
  }
}

//error: The argument type 'Color' can't be assigned to the parameter type 'MaterialStateProperty<Color?>?'.  (argument_type_not_assignable at [marche_social_webapp] lib/screens/dashboard/components/recent_users.dart:113)

