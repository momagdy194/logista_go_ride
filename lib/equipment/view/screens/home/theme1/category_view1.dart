import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/title_widget.dart';
import 'package:customer/equipment/view/screens/home/widget/category_pop_up.dart';

class CategoryView1 extends StatelessWidget {
  const CategoryView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<EQCategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null && categoryController.categoryList!.isEmpty) ? const SizedBox() : Column(
        children: [
          Padding(
            padding:   EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: TitleWidget(title: Get.find<EQSplashControllerEquip>().module!.themeId == 2?'categories2'.tr:'categories'.tr, onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 30,
                  child: categoryController.categoryList != null ? ListView.builder(
                    controller: scrollController,
                    itemCount: categoryController.categoryList!.length > 15 ? 15 : categoryController.categoryList!.length,
                    padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 1),
                        child: InkWell(
                          onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                          )),
                          child: SizedBox(
                            width: 75,
                            child: Container(
                              height: 30, width: 80,
                              margin: EdgeInsets.only(
                                left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                                right: Dimensions.paddingSizeExtraSmall,
                              ),
                              child: Stack(children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                //   child: CustomImage(
                                //     image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList?[index].image}',
                                //     height: 65, width: 75, fit: BoxFit.cover,
                                //   ),
                                // ),
                                Container(height: 30,
                                  padding:   EdgeInsets.symmetric(vertical: 2),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusSmall)),
                                    color: Color(0xffacd8ff),
                                  ),
                                  child: Center(
                                    child: Text(
                                      categoryController.categoryList![index].name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Colors.black87,fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    },
                  ) : CategoryShimmer(categoryController: categoryController),
                ),
              ),

              ResponsiveHelper.isMobile(context) ? const SizedBox() : categoryController.categoryList != null ? Column(
                children: [
                  InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (con) => Dialog(child: SizedBox(height: 550, width: 600, child: CategoryPopUp(
                        categoryController: categoryController,
                      ))));
                    },
                    child: Padding(
                      padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text('view_all'.tr, style: TextStyle(fontSize: Dimensions.paddingSizeDefault, color: Theme.of(context).cardColor)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,)
                ],
              ): CategoryAllShimmer(categoryController: categoryController)
            ],
          ),

        ],
      );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final EQCategoryController categoryController;
  const CategoryShimmer({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding:   EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding:   EdgeInsets.symmetric(horizontal: 1),
            child: SizedBox(
              width: 75,
              child: Container(
                height: 65, width: 65,
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : Dimensions.paddingSizeExtraSmall,
                  right: Dimensions.paddingSizeExtraSmall,
                ),
                child: Shimmer(
                  duration: const Duration(seconds: 2),
                  enabled: categoryController.categoryList == null,
                  child: Container(
                    height: 65, width: 65,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final EQCategoryController categoryController;
  const CategoryAllShimmer({Key? key, required this.categoryController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding:   EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

