import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/notification_model.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  const NotificationDialog({Key? key, required this.notificationModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall))),
      insetPadding:   EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child:  SizedBox(
        // width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              (notificationModel.data!.image != null && notificationModel.data!.image!.isNotEmpty) ? Container(
                width: MediaQuery.of(context).size.width,
                margin:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    isNotification: true,
                    image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.notificationImageUrl}/${notificationModel.data!.image}',
                    width: MediaQuery.of(context).size.width, fit: BoxFit.contain,
                  ),
                ),
              ) : const SizedBox(),
              SizedBox(height: (notificationModel.data!.image != null && notificationModel.data!.image!.isNotEmpty)
                  ? Dimensions.paddingSizeLarge : 0),

              Padding(
                padding:   EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  notificationModel.data!.title!,
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),

              Padding(
                padding:   EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  notificationModel.data!.description!,
                  textAlign: TextAlign.start,
                  style: robotoRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
