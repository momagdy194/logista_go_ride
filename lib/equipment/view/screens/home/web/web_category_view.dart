import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WebCategoryView extends StatelessWidget {
  final EQCategoryController categoryController;
  const WebCategoryView({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 200]!, blurRadius: 5, spreadRadius: 1)]
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Padding(
          padding:   EdgeInsets.only(top: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeExtraSmall),
          child: Text('categories'.tr, style: robotoMedium.copyWith(fontSize: 24)),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        categoryController.categoryList != null ? ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categoryController.categoryList!.length > 10 ? 11 : categoryController.categoryList!.length,
          itemBuilder: (context, index) {

            if(index == 10) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getCategoryRoute()),
                child: Container(
                  padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: Row(children: [

                    Container(
                      height: 65, width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(Icons.arrow_downward, color: Theme.of(context).cardColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Text(
                      'view_all'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),

                  ]),
                ),
              );
            }

            return InkWell(
              onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
              )),
              child: Container(
                padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Row(children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                      image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                      height: 65, width: 70, fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: Text(
                    categoryController.categoryList![index].name!,
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  )),

                ]),
              ),
            );
          },
        ) : WebCategoryShimmer(categoryController: categoryController),

      ]),
    );
  }
}

class WebCategoryShimmer extends StatelessWidget {
  final EQCategoryController categoryController;
  const WebCategoryShimmer({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          margin:   EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: categoryController.categoryList == null,
            child: Row(children: [

              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), color: Colors.grey[300]),
                height: 65, width: 70,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Container(height: 15, width: 150, color: Colors.grey[300]),

            ]),
          ),
        );
      },
    );
  }
}

