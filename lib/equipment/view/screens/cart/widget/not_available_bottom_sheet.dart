import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
class NotAvailableBottomSheet extends StatelessWidget {
  const NotAvailableBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context) ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
            : const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
      ),
      child: SingleChildScrollView(
        padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Column(children: [
          !ResponsiveHelper.isDesktop(context) ? Container(
            height: 4, width: 35,
            margin:   EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
          ) : const SizedBox(),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('if_any_product_is_not_available'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
            IconButton(
              onPressed: ()=> Get.back(),
              icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
            )
          ]),

          GetBuilder<EQCartController>(
            builder: (cartController) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.notAvailableList.length,
                  itemBuilder: (context, index){
                return InkWell(
                  onTap: () => cartController.setAvailableIndex(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cartController.notAvailableIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      border: Border.all(color: cartController.notAvailableIndex == index ? Theme.of(context).primaryColor : Theme.of(context).disabledColor, width: 0.5),
                    ),
                    padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    child: Text(
                      cartController.notAvailableList[index].tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: cartController.notAvailableIndex == index ? Theme.of(context).textTheme.bodyMedium!.color : Theme.of(context).disabledColor),
                    ),
                  ),
                );
              });
            }
          ),

          GetBuilder<EQCartController>(
            builder: (cartController) {
              return CustomButton(
                buttonText: 'apply'.tr,
                onPressed: cartController.notAvailableIndex == -1 ? null : (){
                 Get.back();
                },
              );
            }
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge)
        ]),
      ),
    );
  }
}
