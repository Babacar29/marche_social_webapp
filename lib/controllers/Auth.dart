import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marche_social_webapp/screens/home/home_screen.dart';

import '../core/constants/app_collections.dart';
import '../core/utils/Utils.dart';
import '../models/user_model.dart';

class AuthController extends GetxController{
  final signupKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  RxBool loginShowPass = true.obs;

  validateAndLoginWithEmail(BuildContext context) async   {
    try {
      await auth.signInWithEmailAndPassword(
          email: loginEmail.text,
          password: loginPassword.text
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("login exception =====>$e");
      auth.signOut();
      // Utils.hideProgressDialog();
      Utils.showFailureSnackbar(
          title: 'Authentication Error', msg: e.message.toString());
    }

    debugPrint("current user ================>${auth.currentUser}");
    if (auth.currentUser != null) {
      //

      String userId = auth.currentUser!.uid.toString();
      try {
        DocumentSnapshot snap =
        await AppCollections.userCollection.doc(userId).get();
        UserModel userModel = UserModel.fromMap(snap);
        if (userModel.currentRole != null &&
            userModel.currentRole!.isNotEmpty &&
            (userModel.currentRole!) == 'admin') {
          //Utils.hideProgressDialog();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
          //Get.offAll(() => HomeScreen());
        }
        else {
          Utils.showFailureSnackbar(title: "Oops !", msg: "Vous n'avez pas les droits pour accéder à cette page");
        }
      } on FirebaseException catch (e) {
        //Utils.hideProgressDialog();
        auth.signOut();
        Utils.showFailureSnackbar(
            title: 'Server Error', msg: e.message.toString());
      }
    }
  }
}