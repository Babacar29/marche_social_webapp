import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/constants/app_collections.dart';
import '../../core/utils/Utils.dart';
import '../../models/product_model.dart';
import '../../models/store_model.dart';


class SellerStoreController extends GetxController {
  var storeModel = Rxn<StoreModel>();
  Rx<File?> selectedFile = Rx<File?>(null);
  TextEditingController storeName = TextEditingController();
  TextEditingController storeWeb = TextEditingController();
  TextEditingController storeEmail = TextEditingController();
  TextEditingController storePhone = TextEditingController();
  TextEditingController storeCountry = TextEditingController();
  TextEditingController storeCity = TextEditingController();
  TextEditingController storeAddress = TextEditingController();
  TextEditingController storeDesc = TextEditingController();
  TextEditingController storePostalCode = TextEditingController();
  RxList<String> storeCats = <String>[].obs;
  final storeFormKey = GlobalKey<FormState>();
  RxString storeCountryCode = ''.obs;

  //product
  RxString productType = 'Single Product'.obs;
  TextEditingController productName = TextEditingController();
  RxList<String> productCats = <String>[].obs;
  TextEditingController productDesc = TextEditingController();
  TextEditingController productSpecs = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productDiscount = TextEditingController();
  TextEditingController productShippingFee = TextEditingController();
  RxList<String> productColors = <String>[].obs;
  RxList<String> productSizes = <String>[].obs;
  RxList<String> shippingOptions = <String>[].obs;
  RxList<Map<String, dynamic>> deliveryDelayOptions = <Map<String, dynamic>>[].obs;
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productBrand = TextEditingController();
  RxString productCondition = ''.obs;
  RxList<String> productTags = <String>[].obs;
  RxList<String> productAttributes = <String>[].obs;
  RxList<String> productImages = <String>[].obs;
  RxList<File> productFileImages = <File>[].obs;
  RxList<bool> canDoInstantDelivery = <bool>[].obs;
  final productKey = GlobalKey<FormState>();
  StreamSubscription<QuerySnapshot<Object?>>? sellerProductStream;
  StreamSubscription<QuerySnapshot<Object?>>? sellerStoreOrdersStream;
  RxList<ProductModel> myProducts = <ProductModel>[].obs;

  void clearProductFunction() {
    productType.value = '';
    productName.clear();
    productCats.clear();
    productDesc.clear();
    productSpecs.clear();
    productPrice.clear();
    productDiscount.clear();
    productShippingFee.clear();
    productColors.clear();
    productSizes.clear();
    productQuantity.clear();
    productBrand.clear();
    productCondition.value = '';
    productTags.clear();
    productAttributes.clear();
    productImages.clear();
    productFileImages.clear();
    shippingOptions.clear();
    deliveryDelayOptions.clear();
    canDoInstantDelivery.clear();
  }

 /* validateAndUploadProduct(List attributes, bool canBeInLetterBox) async {
    if (productKey.currentState!.validate()) {
      if (productName.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Name Missing', msg: 'Please enter product name');
        return;
      }
      if (productCats.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Category Missing', msg: 'Please enter product category');
        return;
      }
      if (productDesc.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Description Missing',
            msg: 'Please enter product description');
        return;
      }
      if (productSpecs.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Description Missing',
            msg: 'Please enter product description');
        return;
      }
      if (productPrice.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Price Missing', msg: 'Please enter product price');
        return;
      }
      *//*if (productShippingFee.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Shipping Fee Missing',
            msg: 'Please enter product shipping fee');
        return;
      }*//*
      *//*if (productColors.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Color Missing', msg: 'Please enter product color');
        return;
      }
      if (productSizes.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Size Missing', msg: 'Please enter product size');
        return;
      }*//*
      if (productCondition.value.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Condition Missing', msg: 'Please enter product condition');
        return;
      }
      if (productTags.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Tags Missing',
            msg:
                'Please add some products tags. It will help you in getting product reach');
        return;
      }
      if (shippingOptions.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Shipping options Missing',
            msg: 'Please select shipping methods');
        return;
      }
      if (productFileImages.isEmpty || productFileImages.length < 1) {
        debugPrint("product images =======++++>${productFileImages.length}");
        Utils.showFailureSnackbar(
            title: 'Images Missing',
            msg: 'Please provide at-least 1 product image');
        return;
      }
      try {
        Utils.showProgressDialog();
        List<String> temp = await addListOfImagesToFirebase(productFileImages);
        productImages.value = temp;

        ProductModel productModel = ProductModel(
            type: productType.value,
            name: productName.text,
            categories: productCats,
            description: productDesc.text,
            specs: productSpecs.text,
            price: productPrice.text,
            discount: productDiscount.text,
            shippingFee: productShippingFee.text,
            //colors: productColors,
            //size: productSizes,
            city: storeModel.value!.city??'',
            quantity: productQuantity.text.isEmpty ? "1" : productQuantity.text,
            brand: productBrand.text,
            condition: productCondition.value,
            images: productImages,
            tags: productTags,
            //attributes: productAttributes,
            postedAt: DateTime.now(),
            shippingOptions: shippingOptions,
            deliveryDelayOptions: deliveryDelayOptions,
            storeId: storeModel.value != null ? storeModel.value!.storeId ?? '' : '',
            productId: Uuid().v4().toString(),
            publisherId: FirebaseAuth.instance.currentUser!.uid,
            canBeInLetterBox: canBeInLetterBox
        );

        Map<String, dynamic> data = productModel.toMap();
        debugPrint(" Map data ===========>$data");
        if(attributes.isNotEmpty){
          attributes.forEach((elt) async{
            Map<String, dynamic> value = await SharedPrefs().getAddedAttributesFromSharedPref(elt);
            debugPrint("data ===========>$value");
            data.addAll(value);
            await AppCollections.productCollection
                .doc(productModel.productId)
                .set(data);
          });
        }
        else{
          await AppCollections.productCollection
              .doc(productModel.productId)
              .set(data);
        }


        *//*await AppCollections.productCollection
            .doc(productModel.productId)
            .set(data);*//*
        Utils.hideProgressDialog();
        Utils.hideProgressDialog();
        Utils.showSuccessSnackbar(title: 'Product Added', msg: 'Your product has been added');
      } on FirebaseException catch (e) {
        Utils.hideProgressDialog();
        Utils.showFailureSnackbar(
            title: 'Server Error', msg: e.message.toString());
      }
    } else {
      return;
    }
  }

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
      final _img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
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

  //on gallery pick
  Future multiImagePicker() async {
    try {
      List<XFile> _images = await ImagePicker().pickMultiImage();
      for (int i = 0; i < _images.length; i++) {
        productFileImages.add(File(_images[i].path));
      }
      print("Picked images list: $productFileImages");
    } on PlatformException catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    } catch (e) {
      log("$e", name: "Image picker exception on gallery pick");
    }
  }*/

  void removePickedImage(int index) {
    productFileImages.removeWhere(
      (element) => element == productFileImages[index],
    );
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

  Future getStoreInfo({required String ownerId}) async {
    StoreModel? temp = await getStoreByOwnerId(ownerId: ownerId);
    if (temp != null) {
      storeModel.value = temp;
      //debugPrint("store data ===========>${temp.minTimeSchedule}");
      //getProducts();
    } else {
      storeModel.value = null;
    }
  }

  Future<StoreModel?> getStoreByOwnerId({required String ownerId}) async {
    try {
      if (ownerId.isEmpty) {
        return null;
      }
      QuerySnapshot snap = await AppCollections.storeCollection
          .where('ownerId', isEqualTo: ownerId)
          .get();
      if (snap.docs.isEmpty) {
        return null;
      }
      if (snap.docs.first.exists == false) {
        return null;
      }
      StoreModel storeModel = StoreModel.fromMap(snap.docs.first);
      return storeModel;
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }


  Future<List<StoreModel>> getInstantDeliveryStores() async {
    try {
      List<StoreModel>? storeModels = [];
      QuerySnapshot snap = await AppCollections.storeCollection
          //.where('ownerId', isEqualTo: ownerId)
          .get();
      if (snap.docs.isEmpty) {
        return [];
      }

      for(var doc in snap.docs){
        StoreModel storeModel = StoreModel.fromMap(doc);

        if(Utils.isValidPostalCode(storeModel.postalCode ?? "")){
          storeModels.add(storeModel);
        }
      }
      return storeModels;
    } on FirebaseException catch (e) {
      //print(e);
      return [];
    }
  }

  Future<void> getStoreByStoreId({required String storeId}) async {
    try {
      if (storeId.isEmpty) {
        return null;
      }
      QuerySnapshot snap = await AppCollections.storeCollection
          .where('storeId', isEqualTo: storeId)
          .get();
      if (snap.docs.isEmpty) {
        return null;
      }
      if (snap.docs.first.exists == false) {
        return null;
      }
      StoreModel temp = StoreModel.fromMap(snap.docs.first);
      if(temp.storeId != null){
        storeModel.value = temp;
      }
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> addListOfImagesToFirebase(List<File> images) async {
    List<String> downloadUrls = [];
    final storage = FirebaseStorage.instance;
    for (var image in images) {
      String fileName = image.path.split('/').last;
      Reference reference = storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }
    return downloadUrls;
  }

 /* validateAndCreateStore() async {
    if (storeFormKey.currentState!.validate()) {
     *//* if (storeCountryCode.value.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Check Country Code ',
            msg: 'Please also choose your country code for phone number');
        return;
      }*//*
      *//*if (storePostalCode.value.text.isEmpty) {
        Utils.showFailureSnackbar(
            title: 'Postal Code Missing',
            msg: 'Please provide the postal code of the store area');
        return;
      }*//*



      try {
        Utils.showProgressDialog();
        String? temp = selectedFile.value != null ? await uploadFileToFirebase(selectedFile.value!) : "";
        StoreModel storeModel = StoreModel(
            storeName: storeName.text,
            categories: storeCats,
            website: storeWeb.text,
            email: storeEmail.text,
            phoneNumber: storePhone.text,
            country: storeCountry.text,
            city: storeCity.text,
            address: storeAddress.text,
            description: storeDesc.text,
            createdDate: DateTime.now(),
            storeImg: temp ?? '',
            storeId: Uuid().v4().toString(),
            state: '',
            ownerId: FirebaseAuth.instance.currentUser!.uid,
            postalCode: storePostalCode.text,
            canDoInstantDelivery: Utils.isValidPostalCode(storePostalCode.text),
            deliveryMethods: canDoInstantDelivery == true ? specialShippingOptions : classicsShippingOptions,
            maxTimeSchedule: "",
            minTimeSchedule: "",
            isInstantDeliveryScheduleSet: false,
            available: false,
            daysSchedule: []
        );

        debugPrint("delivery method ========+> ${storeModel.toMap()}");

        await AppCollections.storeCollection
            .doc(storeModel.storeId)
            .set(storeModel.toMap());
        getStoreInfo();
        Utils.hideProgressDialog();
        Utils.hideProgressDialog();
      } on FirebaseException catch (e) {
        Utils.hideProgressDialog();
        print(e);
        Utils.showFailureSnackbar(
            title: 'Server Error', msg: e.message.toString());
      }
    } else {
      return;
    }
  }

  switchToBuyer() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid.toString();
      await AppCollections.userCollection.doc(userId).update({
        'currentRole': 'buyer',
      });
      Get.offAll(() => BottomNavBar(),binding: BottomNavBarBinding());
    }
  }*/

  getProducts() async {
    if (storeModel.value != null) {
      sellerProductStream = AppCollections.productCollection
          .where('storeId', isEqualTo: storeModel.value!.storeId)
          .snapshots()
          .listen((event) {
        List<ProductModel> temp = [];
        for (var element in event.docs) {
          ProductModel p = ProductModel.fromMap(element);
          temp.add(p);
        }
        myProducts.value = temp;
        log('My products are:${myProducts.length}');
      });
    }
  }

  Future<void> updateStoreFollowers({required bool mustAdd, required String storeId}) async {
    //debugPrint("send data  ====>");
    try {
      QuerySnapshot snapshot = await AppCollections.storeCollection
          .where("storeId", isEqualTo: storeId)
          .get();


      for(var doc in snapshot.docs){
        var _doc = doc.data() as Map<String, dynamic>;
        bool hasThisUser = _doc["followers"].contains(FirebaseAuth.instance.currentUser!.uid);

        if(mustAdd && !hasThisUser){
          _doc["followers"].add(FirebaseAuth.instance.currentUser!.uid);
          doc.reference.update({
            "followers": _doc["followers"]
          });
        }
        else{
          _doc["followers"].remove(FirebaseAuth.instance.currentUser!.uid);
          doc.reference.update(
              {
                "followers": _doc["followers"]
              }
          );
        }
      }
    } on FirebaseException catch (e) {
      debugPrint("send data execption ====>$e");
      return null;
    }
  }

  deleteProduct({required productId}) async {
    QuerySnapshot querySnapshot = await AppCollections.productCollection
        .where("productId", isEqualTo: productId)
        .get();

    try {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    }
    catch (e) {
      debugPrint("delete exception ===========>$e");
    }
  }

  updateProduct({required String productId, required List attributes}) async {
    final ref = AppCollections.productCollection;
    QuerySnapshot querySnapshot = await ref
        .where("productId", isEqualTo: productId)
        .get();
    List<String> temp = await addListOfImagesToFirebase(productFileImages);
    productImages.value = temp;


    Map<String, dynamic> data = {
      "type": productType.value,
      "name": productName.text,
      "categories": productCats,
      "description": productDesc.text,
      "specs": productSpecs.text,
      "price": productPrice.text,
      //discount: productDiscount.text,
      //shippingFee: productShippingFee.text,
      //colors: productColors,
      //size: productSizes,
      //city: storeModel.value!.city??'',
      "quantity": productQuantity.text.isEmpty ? "1" : productQuantity.text,
      "brand": productBrand.text,
      "condition": productCondition.value,
      "images": productImages,
      "tags": productTags,
      //"attributes": productAttributes,
      //postedAt: DateTime.now(),
      "shippingOptions": shippingOptions,
      "deliveryDelayOptions": deliveryDelayOptions,
    };

    try{

      for (var doc in querySnapshot.docs) {
        doc.reference.update(data);
      }
    }
    catch(e){
      debugPrint("update exception ===========>$e");
    }
  }

  updateStore(Map<Object, Object> data) async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid.toString();
      QuerySnapshot querySnapshot = await AppCollections.storeCollection.where("ownerId", isEqualTo: userId).get();

      try{
        for (var doc in querySnapshot.docs) {
          doc.reference.update(data);
        }
      }
      catch(e){
        debugPrint("update exception ===========>$e");
        Utils.showFailureSnackbar(
            title: 'Oops !',
            msg: "Something went wrong"
        );
      }
    }
  }

  @override
  void onInit() {
    //getStoreInfo();
    super.onInit();
  }

  @override
  void onClose() {
    if (sellerProductStream != null) {
      sellerProductStream!.cancel();
    }

    super.onClose();
  }
}
