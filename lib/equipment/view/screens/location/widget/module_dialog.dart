import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';

class ModuleDialog extends StatelessWidget {
  final Function callback;
  const ModuleDialog({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding:   EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: PointerInterceptor(child: SingleChildScrollView(child: Container(
        width: 700,
        padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
        color: Theme.of(context).primaryColor.withAlpha(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Text('select_the_type_of_modules_for_your_order'.tr, style: robotoMedium.copyWith(fontSize: 24)),
          ),

          GetBuilder<EQSplashControllerEquip>(builder: (splashController) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                color: Theme.of(context).cardColor,
              ),
              child: splashController.moduleList != null ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1/1),
                  mainAxisSpacing: Dimensions.paddingSizeLarge, crossAxisSpacing: Dimensions.paddingSizeLarge,
                ),
                itemCount: splashController.moduleList!.length,
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                padding:   EdgeInsets.all(Dimensions.paddingSizeLarge),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.find<EQSplashControllerEquip>().setModule(splashController.moduleList![index]);
                      callback();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                        CustomImage(
                          image: '${splashController.configModel!.baseUrls!.moduleImageUrl}/${splashController.moduleList![index].icon}',
                          height: 80, width: 80,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Text(
                          splashController.moduleList![index].moduleName!,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),

                      ]),
                    ),
                  );
                },
              ) : const Center(child: CircularProgressIndicator()),
            );
          }),

        ]),
      ))),
    );
  }
}
