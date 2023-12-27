import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionCheckBox extends StatelessWidget {
  final EQAuthController authController;
  final bool fromSignUp;
  const ConditionCheckBox({Key? key, required this.authController, this.fromSignUp = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: fromSignUp ? MainAxisAlignment.start : MainAxisAlignment.center, children: [

      fromSignUp ? Checkbox(
        activeColor: Theme.of(context).primaryColor,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        value: authController.acceptTerms,
        onChanged: (bool? isChecked) => authController.toggleTerms(),
      ) : const SizedBox(),

      fromSignUp ? const SizedBox() : Text( '* ', style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),
      Text('by_login_i_agree_with_all_the'.tr, style: robotoRegular.copyWith(color: fromSignUp ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).hintColor)),

      InkWell(
        onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
        child: Padding(
          padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Text('terms_conditions'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
        ),
      ),
    ]);
  }
}
