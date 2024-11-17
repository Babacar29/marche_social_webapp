import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/constants/app_collections.dart';
import '../../models/cart_model.dart';



class BuyerCartController extends GetxController {
  RxList<CartModel> cartItems = <CartModel>[].obs;
  RxList<String> deliveryMethods = <String>[].obs;
  StreamSubscription<QuerySnapshot<Object?>>? buyerCartStream;

  getAllCartItems() async {
    buyerCartStream = AppCollections.cartCollection
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('bought', isEqualTo: false)
        .snapshots()
        .listen((event) {
      List<CartModel> temp = [];
      for (var element in event.docs) {
        CartModel c = CartModel.fromMap(element);
        temp.add(c);
      }
      cartItems.value = temp;
      log('All cart items are:${cartItems.length}');
    });
  }

/*  addProductInCart({
      required ProductModel productModel,
      required String selectedColor,
      required String selectedSize,
      required List<String> storeDeliveryMethods,
      bool isPrimaryQuantity = false
  }) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final service = SharedPrefs();

    if (userId == productModel.publisherId) {
      Utils.showFailureSnackbar(
          title: 'Could not add product in cart',
          msg: 'You cannot order your own products');
      return;
    }
    if (productModel.colors!.isNotEmpty && selectedColor.isEmpty) {
      Utils.showFailureSnackbar(
          title: 'Select Color',
          msg: 'Please select color to add product in cart');
      return;
    }
    if (productModel.size!.isNotEmpty && selectedSize.isEmpty) {
      Utils.showFailureSnackbar(
          title: 'Select size',
          msg: 'Please select size to add product in cart');
      return;
    }

    debugPrint("store deliveries methods ========>$storeDeliveryMethods");
    QuerySnapshot snap = await AppCollections.cartCollection
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('productId', isEqualTo: productModel.productId)
        .where('bought', isEqualTo: false)
        .get();
    if (snap.docs.isEmpty) {
      String cartId = Uuid().v4();
      CartModel cartModel = CartModel(
        productId: productModel.productId ?? '',
        bought: false,
        cartId: cartId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        discountPrice: productModel.discount ?? '',
        maxQuantity: int.parse(productModel.quantity ?? '0'),
        productName: productModel.name ?? '',
        productImage:
            productModel.images != null && productModel.images!.isNotEmpty
                ? productModel.images!.first
                : emptyProfileImg,
        productPrice: productModel.price ?? '',
        storeId: productModel.storeId ?? '',
        shippingPrice: productModel.shippingFee ?? '',
        storeOwnerId: productModel.publisherId ?? '',
        size: selectedSize,
        color: selectedColor,
        selectedQuantity: 1,
        deliveriesMethods: storeDeliveryMethods,
        canBeInLetterBox: productModel.canBeInLetterBox
      );
      await AppCollections.cartCollection
          .doc(cartModel.cartId)
          .set(cartModel.toMap());
      if(isPrimaryQuantity){
        service.setLastAddedCartInSharedPref(cartModel);
      }
      sendNotification(productName: productModel.name ?? "");
      Utils.showSuccessSnackbar(
          title: 'Product Added', msg: 'Product added in cart');
    } else {
      Utils.showFailureSnackbar(
          title: 'Product Already Added',
          msg: 'Product is already added in cart');
    }
  }

  void sendNotification({required String productName}) async{
    DocumentSnapshot snap = await AppCollections.userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    UserModel buyerModel = UserModel.fromMap(snap);
    LocalNotificationService.instance.sendFCMNotification(
        deviceToken: buyerModel.fcmToken ?? '',
        title: 'You added $productName in your Cart',
        body: "",
        type: 'message-notification',
        sentBy: FirebaseAuth.instance.currentUser!.uid,
        sentTo: FirebaseAuth.instance.currentUser!.uid,
        savedToFirestore: true
    );
  }

  Future makePayment({
    required String amount,
    required String currency,
    bool? shouldBeDeliveredInLetterBox,
    String? preferredDeliveryDelay,
    String? shippingFee,
  }) async {
    try {
      Map<String, dynamic>? paymentIntentData;
      paymentIntentData = await createPaymentIntent(amount, currency);

      log("Payment intent data map: $paymentIntentData");

      *//*if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Line By Line Quiz',
          customerId: paymentIntentData['customer'],
          googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US', testEnv: true, currencyCode: 'USD'),
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
        ));
        await displayPaymentSheet();
      }*//*
      await displayPaymentSheet(
          shouldBeDeliveredInLetterBox: shouldBeDeliveredInLetterBox,
          preferredDeliveryDelay: preferredDeliveryDelay,
        shippingFee: shippingFee
      );
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet({bool? shouldBeDeliveredInLetterBox, String? preferredDeliveryDelay, shippingFee}) async {
    var paymentDone = false.obs;
    try {
      //await Stripe.instance.presentPaymentSheet();
      paymentDone.value = true;
      String userId = FirebaseAuth.instance.currentUser!.uid.toString();
      List<OrderModel> orders = [];
      //var carts = groupBy(cartItems, (CartModel cartModel) => cartModel.storeOwnerId);
      //debugPrint("grouped carts ===========+>$carts");

      Utils.showProgressDialog();
      for (var element in cartItems) {
        OrderModel orderModel = OrderModel(
            cartItem: element,
            customerId: userId,
            orderDate: DateTime.now(),
            orderId: Uuid().v4(),
            orderStatus: pending,
            storeId: element.storeId,
            totalPrice: "€ ${calculateTotalPrice(productPrice: calculateTotalProductsAmount(), shipPrice: double.parse(shippingFee ?? "0"))}",
            shouldBeDeliveredInLetterBox: shouldBeDeliveredInLetterBox ?? false,
            preferredDeliveryDelay: preferredDeliveryDelay ?? "",
        );
        orders.add(orderModel);
      }

      for (var element in orders) {
        //debugPrint("order =============++>$orders");
        await AppCollections.ordersCollection
            .doc(element.orderId)
            .set(element.toMap());
      }

      String storeOwnerId = orders.first.cartItem != null
          ? orders.first.cartItem!.storeOwnerId ?? ''
          : '';
      String storeId= orders.first.storeId??'';
      for (var element in cartItems) {
        await AppCollections.cartCollection.doc(element.cartId).update({
          'bought': true,
        });

        try{
          debugPrint("update quantity exception ========>${element.productId}");
          await AppCollections.productCollection.doc(element.productId).update({
            "quantity": "${element.maxQuantity!.toInt() - element.selectedQuantity!.toInt()}"
          });
        }
        catch (e){
          debugPrint("update quantity exception ========>$e");
        }
      }

      DocumentSnapshot snap = await AppCollections.userCollection.doc(storeOwnerId).get();
      UserModel userModel = UserModel.fromMap(snap);
      LocalNotificationService.instance.sendFCMNotification(
          deviceToken: userModel.fcmToken ?? '',
          title: userModel.name ?? '',
          body: "places you an order",
          type: 'order-notification',
          sentBy: storeId,
          sentTo: storeOwnerId,
          savedToFirestore: true
      );
      Utils.hideProgressDialog();

      Get.offAll(() => SuccessConfirmation());
    } on Exception catch (e) {
      Utils.hideProgressDialog();
      if (e is StripeException) {
        Utils.showFailureSnackbar(
            title: 'Payment Issue', msg: e.error.localizedMessage.toString());
        print(" ${e.error.localizedMessage}");
        paymentDone.value = false;
      } else {
        Utils.showFailureSnackbar(title: 'Error', msg: 'There is some error');
        print("Unforeseen error: ${e}");
        paymentDone.value = false;
      }
    } catch (e) {
      Utils.hideProgressDialog();
      print("exception:$e");
      Utils.showFailureSnackbar(title: 'Error', msg: 'There is some error');
      paymentDone.value = false;
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        // 'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51LITAZDdms1A12S9jHNhpm2QyxptYrYHcJZ8LpiYY6FF4RYESuXsz6AbIu5JyqJtw3IavrSTVqcRn43ixA6NRMfn005FLX0TF7'
            //sk_test_51Psk2FP1iwsDljPg2qOQOeiNkYaJnj5BkIVkLnfR7ZyFEl46O0UdQfVmxqDWvTynwGV2j8PawMOQipgWV4AduBwx00mDXb86ft
          });
      // log("Payment intent response: ${response.body}");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  static calculateAmount(String amount) {
    if (int.tryParse(amount) != null) {
      final a = (int.parse(amount)) * 100;
      return a.toString();
    } else if (double.tryParse(amount) != null) {
      final a = (double.parse(amount)) * 100;
      return a.toString().split('.')[0];
    }
  }

  double calculateTotalProductsAmount() {
    List<CartModel> tempCart = List.from(cartItems);
    double totalAmount = 0.0;
    for (var element in tempCart) {
      String prodPrice = element.productPrice?.replaceAll("€", "") ?? '0';
      int selectedQ = element.selectedQuantity ?? 0;
      double? price = double.tryParse(prodPrice);
      if (price != null) {
        totalAmount += price * selectedQ;
      }
    }
    return totalAmount;
  }

  double calculateTotalShippingAmount() {
    List<CartModel> tempCart = List.from(cartItems);
    double totalAmount = 0.0;
    for (var element in tempCart) {
      String shipAmount = element.shippingPrice?.replaceAll("€", "") ?? '0';
      double? price = double.tryParse(shipAmount);
      if (price != null) {
        totalAmount += price;
      }
    }
    return totalAmount;
  }

  double calculateTotalPrice(
      {required double productPrice, required double shipPrice}) {
    return productPrice + shipPrice;
  }*/

  Future<List<String>> getStoreDeliveryMethods(String storeId) async{
    List<String> temp = [];
    AppCollections.storeCollection
        .where('storeId', isEqualTo: storeId)
        .snapshots()
        .listen((event) {


      debugPrint("store delivery methods ===========> $storeId");
      for (var element in event.docs) {
        //CartModel c = CartModel.fromMap(element);
        var elt = element.data() as Map<String, dynamic>;

        if(elt["deliveryMethods"] != null){
          elt["deliveryMethods"].forEach((i){
            temp.add(i);
          });
        }

      }
      deliveryMethods.value = temp;
    });
    return temp;
  }

  updateCart({required String deliveryMethod, required String cartId}) async {
    final ref = AppCollections.cartCollection;

    QuerySnapshot querySnapshot = await ref
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("cartId", isEqualTo: cartId)
        .get();

    try{
      for (var doc in querySnapshot.docs) {
        doc.reference.update({
          "deliveryMethod": deliveryMethod,
        });
      }
    }
    catch(e){
      debugPrint("update exception ===========>$e");
    }
  }


  @override
  void onInit() {
    getAllCartItems();
    super.onInit();
  }

  @override
  void onClose() {
    if (buyerCartStream != null) {
      buyerCartStream!.cancel();
    }
    super.onClose();
  }
}
