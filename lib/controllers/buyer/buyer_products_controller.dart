import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../core/constants/app_collections.dart';
import '../../models/product_model.dart';


class BuyerProductsController extends GetxController {
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> seriesProducts = <ProductModel>[].obs;
  RxList<ProductModel> singleProducts = <ProductModel>[].obs;
  RxList<ProductModel> topSelling = <ProductModel>[].obs;
  RxList<ProductModel> othersProducts = <ProductModel>[].obs;
  RxList<ProductModel> instantSelling = <ProductModel>[].obs;
  StreamSubscription<QuerySnapshot<Object?>>? buyerProductStream;


  Future getAllProducts() async {
    buyerProductStream = AppCollections.productCollection.snapshots().listen((event) {
      List<ProductModel> temp = [];

      for (var element in event.docs) {
        ProductModel p = ProductModel.fromMap(element);
        temp.add(p);
      }


      allProducts.value = temp;
      //log('All products are:${allProducts.length}');
      sortProducts();
    });
  }


  sortProducts() {
    topSelling.value = getTopSellingProduct();
    singleProducts.value = getSingleProduct();
    seriesProducts.value = getSeriesProduct();
    instantSelling.value = getInstantProduct();
    othersProducts.value = getOtherProduct();

    //log('instantSelling is :${instantSelling.length}');
  }

  List<ProductModel> getTopSellingProduct() {
    List<ProductModel> temp = List.from(allProducts);
    List<ProductModel> sortedList = [];
    for (var element in temp) {
      if (element.tags!.contains(trendProduct)) {
        sortedList.add(element);
      }

    }
    return sortedList;
  }

  List<ProductModel> getSeriesProduct() {
    List<ProductModel> temp = List.from(allProducts);
    List<ProductModel> sortedList = [];
    for (var element in temp) {
      if (element.type == seriesProduct) {
        sortedList.add(element);
      }
    }
    return sortedList;
  }

  List<ProductModel> getSingleProduct() {
    List<ProductModel> temp = List.from(allProducts);
    List<ProductModel> sortedList = [];
    for (var element in temp) {
      if (element.type == singleProduct) {
        sortedList.add(element);
      }
    }
    return sortedList;
  }

  List<ProductModel> getOtherProduct() {
    List<ProductModel> temp = List.from(allProducts);
    List<ProductModel> sortedList = [];
    for (var element in temp) {
      if (element.type == others) {
        sortedList.add(element);
      }
    }
    return sortedList;
  }

  List<ProductModel> getInstantProduct() {
    /*List<ProductModel> temp = List.from(allProducts);
    String city = Get.find<BuyerProfileController>().userModel.value.city?.trim().toLowerCase() ?? '';
    log('user city is :$city');
    log('temp is :$temp');

    List<ProductModel> sortedList = [];
    for (var element in temp) {
      String productCity = element.city?.trim().toLowerCase() ?? '';
      log('product city is :$productCity (original: ${element.city})');
      if (productCity == city) {
        sortedList.add(element);
      }
    }

    // Log the sorted list
    log('sortedList is :$sortedList');

    return sortedList;*/
    List<ProductModel> temp = List.from(allProducts);
    List<ProductModel> sortedList = [];
    for (var element in temp) {
      if (element.shippingOptions!.contains("Instant Delivery")) {
        sortedList.add(element);
      }
      debugPrint("instant selling ==========> $sortedList");
    }

    return sortedList;
  }

  @override
  void onInit() {
    getAllProducts();
    super.onInit();
  }

  @override
  void onClose() {
    if (buyerProductStream != null) {
      buyerProductStream!.cancel();
    }
    super.onClose();
  }
}
