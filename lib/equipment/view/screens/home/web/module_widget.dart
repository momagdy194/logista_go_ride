import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQSplashControllerEquip>(builder: (splashController) {
      return (ResponsiveHelper.isDesktop(context) && splashController.configModel!.module == null && splashController.moduleList != null
      && splashController.moduleList!.length > 1) ? Container(
        width: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(Dimensions.radiusDefault)),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, spreadRadius: 0.5, blurRadius: 5)],
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: ListView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            itemCount: splashController.moduleList!.length,
            padding:   EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return Padding(
                padding:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Tooltip(
                  message: splashController.moduleList![index].moduleName,
                  padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                  ),
                  textStyle: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                  preferBelow: false,
                  verticalOffset: 20,
                  child: InkWell(
                    onTap: () => splashController.switchModule(index, false),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).primaryColor.withAlpha((splashController.module != null
                          && splashController.moduleList![index].id == splashController.module!.id) ? Get.isDarkMode ? 100 : 70 : Get.isDarkMode ? 70 : 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        child: CustomImage(
                          image: '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].icon}',
                          height: 30, width: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ) : const SizedBox();
    });
  }
}
