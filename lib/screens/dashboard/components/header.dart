import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/core/constants/color_constants.dart';
import 'package:marche_social_webapp/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controllers/seller/seller_order_controller.dart';
import '../../../controllers/seller/seller_store_controller.dart';
import '../../../core/constants/app_collections.dart';
import '../../../models/order_model.dart';
import '../../../models/store_model.dart';
import '../../login/login_screen.dart';


class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);



  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  SellerStoreController stController = Get.find<SellerStoreController>();
  List<StoreModel> stores = [];
  List<bool> storesCanDoInstantDelivery = [];

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

  @override
  void initState() {
    getInstantDeliveryStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Row(
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
            /*if (!Responsive.isMobile(context))
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Deniz 👋",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Wellcome to your dashboard",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),*/
            if (!Responsive.isMobile(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            Expanded(child: SearchField()),
            const SizedBox(width: 30,),
            ProfileCard(),
            const SizedBox(width: 20,),
          ],
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*CircleAvatar(
          backgroundImage: AssetImage("assets/images/profile_pic.png"),
        ),*/
        IconButton(
            onPressed: (){
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login(title: 'Wellcome to the Admin & Dashboard Panel',)),
              );
            },
            icon: Icon(Icons.logout)
        ),
      ],
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String searchQuery = '';
  SellerOrderController soController = Get.find<SellerOrderController>();

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });

    soController.instantDeliveryOrders.value = soController.instantDeliveryOrders.toSet().where((order) =>
    order.cartItem!.productName!.toLowerCase().contains(searchQuery.toLowerCase())
        ||  order.totalPrice!.toString().toLowerCase().contains(searchQuery.toLowerCase())
        || order.orderStatus.toString().toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query){
        if(query.isEmpty){
          setState(() {
            searchQuery = "";
          });
          updateSearchQuery(query);
        }
        updateSearchQuery(query);
      },
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        /*suffixIcon: InkWell(
          onTap: () {
            if(searchQuery.isEmpty){
              setState(() {
                searchQuery = "";
              });
            }
            updateSearchQuery(searchQuery);
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: greenColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              "assets/images/Search.svg",

            ),
          ),
        ),*/
      ),
    );
  }
}
