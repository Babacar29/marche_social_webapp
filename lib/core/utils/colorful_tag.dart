import 'dart:ui';

import 'package:flutter/material.dart';

Color getRoleColor(String? role) {
  if (role == "Doctor") {
    return Colors.green;
  } else if (role == "Software Architect") {
    return Colors.red;
  } else if (role == "Software Engineer") {
    return Colors.blueAccent;
  } else if (role == "Solution Architect") {
    return Colors.amberAccent;
  } else if (role == "Project Manager") {
    return Colors.cyanAccent;
  } else if (role == "Business Analyst") {
    return Colors.deepPurpleAccent;
  } else if (role == "UI/UX Designer") {
    return Colors.indigoAccent;
  }
  return Colors.black38;
}

const kPrimaryColor = Color(0xffF5F5F5);
const KSecondaryColor = Color(0xffFF6347);
const KTertiaryColor = Color(0xff000000);
const kQuarternaryColor = Color(0xff9D9D9D);
const kButtonBorderlineColor = Color(0xff747474);
const kWhiteColor = Color(0xffFFFFFF);
const kBlueColor = Color(0xff3498DB);
const kTransparentColor = Colors.transparent;
const kGreenColor = Color(0xff0CE27D);
const kGrey1Color = Color(0xffF2F3F4);
const kGrey2Color = Color(0xffE6E6E8);
const kGrey3Color = Color(0xffCCCDD1);
const kGrey5Color = Color(0xff7D7F88);
const kGrey7Color = Color(0xff676A75);
const kGrey8Color = Color(0xff66666B);
const kGrey9Color = Color(0xff353947);
const kGrey10Color = Color(0xff1B2030);
const kRedColor = Color(0xFFFF6A6A);
const rateColor = Color(0xffFFBA48);
const kMustard = Color(0xffFCB808);
const kPinkColor = Color(0xffFF634726);
const kDeepGrayColor = Color(0xffD5D5D5);
const klightWhiteColor = Color(0xffFFFFFF);
const kYellowColor = Color(0xffFFC107);
const kGrayColor = Colors.grey;
const kBlackColor2 = Color(0xff020202);
const kBlackColor3 = Color(0xff666666);
const Color cardBgColor = Color(0xff363636);
const Color cardBgLightColor = Color(0xff999999);
const Color colorB58D67 = Color(0xffB58D67);
const Color colorE5D1B2 = Color(0xffE5D1B2);
const Color colorF9EED2 = Color(0xffF9EED2);
const Color colorEFEFED = Color(0xffEFEFED);

