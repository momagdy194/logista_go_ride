import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/theme/light_theme.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function? onTap;
  const TitleWidget({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
      (onTap != null && !ResponsiveHelper.isDesktop(context)) ? InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding:   EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Row(
            children: [
              Text(
                'view_all'.tr,
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,fontWeight: FontWeight.w400 ),
              ),
              // Icon(Icons.arrow_forward_ios_rounded,color: AppColor.descriptionColor,size:Dimensions.fontSizeSmall ,)
            ],
          ),
        ),
      ) : const SizedBox(),
    ]);
  }
}
