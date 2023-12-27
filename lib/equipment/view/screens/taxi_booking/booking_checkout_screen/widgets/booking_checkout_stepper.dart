import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/booking_checkout_controller.dart';
import 'package:customer/equipment/controller/localization_controller.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/view/screens/taxi_booking/booking_checkout_screen/widgets/custom_header_icon.dart';
import 'package:customer/equipment/view/screens/taxi_booking/booking_checkout_screen/widgets/custom_header_line.dart';
import 'package:customer/equipment/view/screens/taxi_booking/booking_checkout_screen/widgets/custom_text.dart';

class BookingCheckoutStepper extends StatelessWidget {
  final String pageState;
  const BookingCheckoutStepper({Key? key,required this.pageState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 426,
      child: GetBuilder<BookingCheckoutController>(
        builder: (controller){
          return Column(
            children: [
              Padding(
                padding:    EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeSmall),
                child:  Stack(
                  children: [
                    SizedBox(
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              controller.updateState(EQPageState.payment,shouldUpdate: true);
                            },
                            child: const CustomHeaderIcon(
                              assetIconUnSelected: Images.bookingDetailsUnselected,
                            ),
                          ),
                          controller.currentPage == EQPageState.orderDetails ?
                           CustomHeaderLine(
                              color:Theme.of(context).primaryColor,
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2:Theme.of(context).disabledColor) :
                           CustomHeaderLine(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor),

                          CustomHeaderIcon(
                            assetIconUnSelected:controller.currentPage == EQPageState.orderDetails ?  Images.paymentUnselectedGrey : Images.paymentUnselected,
                          ),
                          controller.cancelPayment ?
                          const CustomHeaderLine(
                              cancelOrder: true,
                              gradientColor1: Colors.grey,
                              gradientColor2: Colors.grey) :
                          controller.currentPage == EQPageState.payment || controller.currentPage == EQPageState.orderDetails ?
                           CustomHeaderLine(
                              color: Theme.of(context).disabledColor,
                              gradientColor1: Theme.of(context).disabledColor,
                              gradientColor2:Theme.of(context).disabledColor) :
                           CustomHeaderLine(
                              gradientColor1: Theme.of(context).primaryColor,
                              gradientColor2: Theme.of(context).primaryColor),
                          InkWell(
                              onTap: (){
                                controller.updateState(EQPageState.complete,shouldUpdate: true);
                              },
                              child: const CustomHeaderIcon(assetIconUnSelected: Images.completeUnselected,)),
                        ],),),

                    if(controller.currentPage == EQPageState.orderDetails  && EQPageState.orderDetails.name == pageState)
                      Positioned(
                        left: Get.find<EQLocalizationController>().isLtr ? 0: null,
                        right:Get.find<EQLocalizationController>().isLtr ? null: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
                            controller.updateState(EQPageState.payment,shouldUpdate: true);
                          },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage( Images.bookingDetailsSelected,))),
                            )),),
                    if(controller.currentPage == EQPageState.payment  || EQPageState.payment.name == pageState)
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (){
                              controller.updateState(EQPageState.orderDetails,shouldUpdate: true);
                            },
                              child: Container(
                                height: 55,
                                width: 55,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                    image: const DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage( Images.paymentSelected,))),
                              )),
                        ),
                      ), if(controller.currentPage == EQPageState.complete || pageState == 'complete')
                      Positioned(
                        right: Get.find<EQLocalizationController>().isLtr ? 0:null,
                        left: Get.find<EQLocalizationController>().isLtr ? null: 0,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: (){
                            controller.updateState(EQPageState.orderDetails,shouldUpdate: true);
                          },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(50),
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage( Images.completeSelected,))),)),),],
                ),),
              Padding(
                padding:   EdgeInsets.only(bottom: Dimensions.paddingSizeDefault,left: 20.0,right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    CustomText(
                        text: "booking_details".tr,isActive :controller.currentPage == EQPageState.orderDetails
                        && EQPageState.orderDetails.name == pageState),
                    Padding(
                      padding: EdgeInsets.only(
                        right:Get.find<EQLocalizationController>().isLtr ? 25:0,
                        left:Get.find<EQLocalizationController>().isLtr ? 0: 35.0,
                      ),
                      child: CustomText(
                          text: "payment".tr,
                          isActive : controller.currentPage == EQPageState.payment
                          || EQPageState.payment.name == pageState),
                    ),
                    CustomText(text: "complete".tr,isActive : controller.currentPage == EQPageState.complete  || pageState == 'complete'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
