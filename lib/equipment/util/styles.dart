import 'package:get/get.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final robotoRegular = TextStyle(
  fontFamily: GoogleFonts.cairo().fontFamily,
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoMedium = TextStyle(
  fontFamily: GoogleFonts.cairo().fontFamily,
  fontWeight: FontWeight.w500,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBold = TextStyle(
  fontFamily: GoogleFonts.cairo().fontFamily,
  fontWeight: FontWeight.w700,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoBlack = TextStyle(
  fontFamily: GoogleFonts.cairo().fontFamily,
  fontWeight: FontWeight.w900,
  fontSize: Dimensions.fontSizeDefault,
);


final BoxDecoration riderContainerDecoration = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
    color: Theme.of(Get.context!).primaryColor.withOpacity(0.1), shape: BoxShape.rectangle,
);