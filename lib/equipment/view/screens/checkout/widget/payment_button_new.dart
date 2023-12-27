import 'package:customer/equipment/controller/order_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentButtonNew extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final Function onTap;
  const PaymentButtonNew({Key? key, required this.isSelected, required this.icon, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQOrderController>(builder: (orderController) {
      return Padding(
        padding:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
            ),
            padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Row(children: [
              Image.asset(
                icon, width: 20, height: 20,
                color: isSelected ? Theme.of(context).cardColor : Theme.of(context).disabledColor,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Text(
                  title,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: isSelected ? Theme.of(context).cardColor : Theme.of(context).disabledColor),
                ),
              ),
            ]),

          ),
        ),
      );
    });
  }
}
