import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_collections.dart';
import '../../models/user_model.dart';

class SellerProfileController extends GetxController{
  Rx<UserModel> sellerUserModel = UserModel().obs;
  StreamSubscription? userDataStream;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController bio = TextEditingController();
  RxString profileImageUrl = ''.obs;
  RxString countryCode = ''.obs;
  final buyerFormKey = GlobalKey<FormState>();

  getUserDataStream() async {
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
  }

  disposeStream() async {
    if (userDataStream != null) {
      await userDataStream!.cancel();
    }
  }

  initData() {
    name.text = sellerUserModel.value.name ?? '';
    phone.text = sellerUserModel.value.phoneNumber ?? '';
    countryCode.value=sellerUserModel.value.countryCode??'+1';
    country.text = sellerUserModel.value.country ?? '';
    city.text = sellerUserModel.value.city ?? '';
    address.text = sellerUserModel.value.address ?? '';
    bio.text = sellerUserModel.value.bio ?? '';
    profileImageUrl.value = sellerUserModel.value.profilePic ?? '';
  }

  Rx<File?> selectedFile = Rx<File?>(null);
/*

  //image picker
  Future pickFromCamera() async {
    try {
      final _img = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (_img == null) {
        return;
      } else {
        selectedFile.value = File(_img.path);
        Get.back();
      }
    } on PlatformException catch (e) {
      log("$e", name: "Image picker exception on camera pick");
    } catch (e) {
      log("$e", name: "Image picker exception on camera pick");
    }
  }

  //on gallery pick
  Future pickImageFromGallery() async {
    try {
      final _img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (_img == null) {
        return;
      } else {
        selectedFile.value = File(_img.path);
        Get.back();
      }
    } on PlatformException catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    } catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    }
  }

  Future<String?> uploadFileToFirebase(File file) async {
    try {
      final Reference storageReference =
      FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

      await storageReference.putFile(file);
      final String downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading file to Firebase: $e');
      return null;
    }
  }

  updateUserProfile() async {
    try {
      Utils.showProgressDialog();
      if (selectedFile.value != null) {
        String? url = await uploadFileToFirebase(selectedFile.value!);
        await AppCollections.userCollection.doc(sellerUserModel.value.userId).update({
          'profilePic': url ?? '',
          'name': name.text,
          'phoneNumber': phone.text,
          'country': country.text,
          'city': city.text,
          'address': address.text,
          'bio': bio.text,
        });
      } else {
        await AppCollections.userCollection.doc(sellerUserModel.value.userId).update({
          'name': name.text,
          'phoneNumber': phone.text,
          'country': country.text,
          'city': city.text,
          'address': address.text,
          'bio': bio.text,
        });
      }
      Utils.hideProgressDialog();
      Utils.hideProgressDialog();
      selectedFile.value = null;
    } on FirebaseException catch (e) {
      Utils.hideProgressDialog();
      Utils.showFailureSnackbar(
          title: 'Server Error', msg: e.message.toString());
    }
  }
*/



  // switchToSeller() async {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     String userId = FirebaseAuth.instance.currentUser!.uid.toString();
  //     await AppCollections.userCollection.doc(userId).update({
  //       'currentRole': 'seller',
  //     });
  //     Get.offAll(() => SellerBottomNavBar());
  //   }
  // }

  Future getStoreInfo({required String uid}) async {
    /*if (FirebaseAuth.instance.currentUser != null) {
      UserModel? temp = await getSellerById(userId: uid);
      if (temp != null) {
        sellerUserModel.value = temp;
        //
        //getProducts();
      } else {
        sellerUserModel.value = UserModel();
      }
    }*/

    UserModel? temp = await getSellerById(userId: uid);
    if (temp != null) {
      sellerUserModel.value = temp;
      //
      //getProducts();
    } else {
      sellerUserModel.value = UserModel();
    }

    //debugPrint("store user data ===========>${sellerUserModel.value.name}");
  }

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


  @override
  void onInit() {
    getUserDataStream();
    super.onInit();
  }
}