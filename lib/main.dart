import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/controllers/Auth.dart';
import 'package:marche_social_webapp/controllers/deliver/deliver_controller.dart';
import 'package:marche_social_webapp/controllers/seller/seller_order_controller.dart';
import 'package:marche_social_webapp/core/constants/color_constants.dart';
import 'package:marche_social_webapp/core/init/provider_list.dart';
import 'package:marche_social_webapp/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'controllers/buyer/buyer_profile_controller.dart';
import 'controllers/seller/seller_profile_controller.dart';
import 'controllers/seller/seller_store_controller.dart';
import 'core/local_storage/sharedPrefs.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesServices.init();
  Get.put(SellerOrderController());
  Get.put(SellerProfileController());
  Get.put(BuyerProfileController());
  Get.put(SellerStoreController());
  Get.put(AuthController());
  Get.put(DeliverController());
  runApp(MyApp());
}

Widget build(BuildContext context) {
  return MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: ResponsiveSizer(
        builder: (context, orientation, screenType) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Dashboard - Admin Panel v0.1 ',
          theme: ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(backgroundColor: bgColor, elevation: 0),
            scaffoldBackgroundColor: bgColor,
            primaryColor: greenColor,
            dialogBackgroundColor: secondaryColor,
            buttonTheme: const ButtonThemeData(
              buttonColor: greenColor,
            ),
            textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white),
            canvasColor: secondaryColor,
          ),
          home: Login(title: "Wellcome to the Admin & Dashboard Panel"),
        ),
      ),
    );
  }
}
