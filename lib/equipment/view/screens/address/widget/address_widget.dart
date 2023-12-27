import 'package:customer/equipment/data/model/response/address_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends StatelessWidget {


  final AddressModel? address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function? onRemovePressed;
  final Function? onEditPressed;
  final Function? onTap;
  final bool isSelected;
  final bool fromDashBoard;
  const AddressWidget({Key? key, required this.address, required this.fromAddress, this.onRemovePressed, this.onEditPressed,
    this.onTap, this.fromCheckout = false, this.isSelected = false, this.fromDashBoard = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: fromCheckout ? 0 : Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault
              : Dimensions.paddingSizeSmall),
          decoration: fromDashBoard ? BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: isSelected ? 1 : 0),
          ) : fromCheckout ? const BoxDecoration() : BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor, width: isSelected ? 0.5 : 0),
            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset(
                      address!.addressType == 'home' ? Images.homeIcon : address!.addressType == 'office' ? Images.workIcon : Images.otherIcon,
                      color: Theme.of(context).primaryColor, height: ResponsiveHelper.isDesktop(context) ? 25 : 20, width: ResponsiveHelper.isDesktop(context) ? 25 : 20,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      address!.addressType!.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    address!.address!,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ),


              fromAddress ? IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
                onPressed: onRemovePressed as void Function()?,
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}




class AddressWidget2 extends StatelessWidget {
  
  final AddressModel? address;
  final bool fromAddress;
  final bool fromCheckout;
  final Function? onRemovePressed;
  final Function? onEditPressed;
  final Function? onTap;
  final bool isSelected;
  final bool fromDashBoard;
  const AddressWidget2({Key? key, required this.address, required this.fromAddress, this.onRemovePressed, this.onEditPressed,
    this.onTap, this.fromCheckout = false, this.isSelected = false, this.fromDashBoard = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: fromCheckout ? 0 : Dimensions.paddingSizeSmall),
      child: InkWell(
        onTap: onTap as void Function()?,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault
                : Dimensions.paddingSizeSmall),
            decoration: fromDashBoard ? BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent, width: isSelected ? 1 : 0),
            ) : fromCheckout ? const BoxDecoration() : BoxDecoration(
               borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor, width: isSelected ? 0.5 : 0),
           image:DecorationImage(image:  AssetImage(Images.MapBG),fit: BoxFit.fill)  ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
        
                            Image.asset(
                        address!.addressType == 'home' ? Images.homeIcon : address!.addressType == 'office' ? Images.workIcon : Images.otherIcon,
                        color: Theme.of(context).primaryColor, height: ResponsiveHelper.isDesktop(context) ? 25 : 25, width: ResponsiveHelper.isDesktop(context) ? 25 : 25,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
        
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
          
                      Text(
                        address!.addressType!.tr,
                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Colors.black),
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        
                    Text(
                      address!.address!,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),
        
        
                fromAddress ? IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red, size: ResponsiveHelper.isDesktop(context) ? 35 : 25),
                  onPressed: onRemovePressed as void Function()?,
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}