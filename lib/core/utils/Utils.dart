import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Utils{

  static void showSuccessSnackbar(
      {required String title, required String msg, int duration = 5}) {
    Get.snackbar(
      title,
      msg,
      duration: Duration(seconds: duration),
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            ),
      ),
    );
  }

  static void showFailureSnackbar(
      {required String title, required String msg, int duration = 4}) {
    Get.snackbar(
      title,
      msg,
      duration: Duration(seconds: duration),
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      messageText: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      titleText: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
    //fetch res data from firebase
  }

  static String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final orderDate = DateTime(date.year, date.month, date.day);

    if (orderDate == today) {
      return 'Today';
    } else if (orderDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('yyyy-MM-dd').format(orderDate);
    }
  }

  String calculateDeliveryDelay({required String schedule, required DateTime orderDate}) {
    String ret = "";
    final regex = RegExp(r'(\d+)h(\d*)-(\d+)h(\d*)');
    final match = regex.firstMatch(schedule);

    if (match != null) {
      int minHours = int.parse(match.group(1)!);
      int minMinutes = match.group(2)!.isEmpty ? 0 : int.parse(match.group(2)!);
      int maxHours = int.parse(match.group(3)!);

      Duration minDuration = Duration(hours: minHours, minutes: minMinutes);
      Duration maxDuration = Duration(hours: maxHours);

      //DateTime now = DateTime.now();
      DateTime minTime = orderDate.add(minDuration);
      DateTime maxTime = orderDate.add(maxDuration);

      String? formattedOrderDate = DateFormat("dd/MM/yy").format(orderDate);
      //print("order date: $orderDate");
      ret = "$formattedOrderDate ${maxTime.hour}h${maxTime.minute.toString().padLeft(2, '0')}";
      //print("Heure après durée maximale: ${maxTime.hour}h${maxTime.minute.toString().padLeft(2, '0')}");
    } else {
      debugPrint("Format de délai non valide");
    }

    return ret;
  }

  static bool isValidPostalCode(String postalCode) {
    List<String> parisPostalCodes = [
      '75001', '75002', '75003', '75004', '75005', '75006', '75007', '75008',
      '75009', '75010', '75011', '75012', '75013', '75014', '75015', '75016',
      '75017', '75018', '75019', '75020', '75116'
    ];

    List<String> postalCodes91 = [
      '91090', '91000', '91100', '91300', '91380', '91600', '91700', '91350',
      '91130', '91700', '91260', '91210', '91170'
    ];

    List<String> postalCodes92 = [
      '92100', '92000', '92130', '92600', '92700', '92400', '92500', '92160',
      '92110', '92200', '92140', '92120', '92240', '92190', '92800', '92230',
      '92270', '92310', '92320', '92250', '92170', '92260', '92210'
    ];

    List<String> postalCodes93 = [
      '93100', '93170', '93200', '93206', '93210', '93284', '93300', '93310',
      '93700', '93800', '93140', '93270', '93500', '93130', '93120', '93110',
      '93260'
    ];

    List<String> postalCodes94 = [
      '94000', '94010', '94012', '94160', '94400', '94200', '94300', '94800',
      '94700', '94220'
    ];

    List<String> postalCodes95 = ['95100'];

    // Combine all the lists into one for easy searching
    List<String> allPostalCodes = []
      ..addAll(parisPostalCodes)
      ..addAll(postalCodes91)
      ..addAll(postalCodes92)
      ..addAll(postalCodes93)
      ..addAll(postalCodes94)
      ..addAll(postalCodes95);

    if(postalCode.startsWith("75")){
      return true;
    }

    // Check if the given postal code is in the list
    return allPostalCodes.contains(postalCode);
  }
  List<String> allPostalCodes() {
    List<String> parisPostalCodes = [
      '75001', '75002', '75003', '75004', '75005', '75006', '75007', '75008',
      '75009', '75010', '75011', '75012', '75013', '75014', '75015', '75016',
      '75017', '75018', '75019', '75020', '75116'
    ];

    List<String> postalCodes91 = [
      '91090', '91000', '91100', '91300', '91380', '91600', '91700', '91350',
      '91130', '91700', '91260', '91210', '91170'
    ];

    List<String> postalCodes92 = [
      '92100', '92000', '92130', '92600', '92700', '92400', '92500', '92160',
      '92110', '92200', '92140', '92120', '92240', '92190', '92800', '92230',
      '92270', '92310', '92320', '92250', '92170', '92260', '92210'
    ];

    List<String> postalCodes93 = [
      '93100', '93170', '93200', '93206', '93210', '93284', '93300', '93310',
      '93700', '93800', '93140', '93270', '93500', '93130', '93120', '93110',
      '93260'
    ];

    List<String> postalCodes94 = [
      '94000', '94010', '94012', '94160', '94400', '94200', '94300', '94800',
      '94700', '94220'
    ];

    List<String> postalCodes95 = ['95100'];

    // Combine all the lists into one for easy searching
    List<String> allPostalCodes = []
      ..addAll(parisPostalCodes)
      ..addAll(postalCodes91)
      ..addAll(postalCodes92)
      ..addAll(postalCodes93)
      ..addAll(postalCodes94)
      ..addAll(postalCodes95);


    return allPostalCodes;
  }

  void showCustomSnackBar(String title, String? message) {
    Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.blueAccent,
          message: message,
          title: title,
          duration: const Duration(seconds: 3),
          snackStyle: SnackStyle.FLOATING,
          margin: const EdgeInsets.all(20),
          borderRadius: 10,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        )
    );
  }

}