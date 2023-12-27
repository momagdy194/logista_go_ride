import 'package:customer/equipment/controller/category_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_image.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Get.find<EQCategoryController>().getCategoryList(false);

    return Scaffold(
      appBar: CustomAppBar(title: 'categories'.tr),
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: Scrollbar(child: SingleChildScrollView(child: FooterView(child: SizedBox(
        width: Dimensions.webMaxWidth,
        child: GetBuilder<EQCategoryController>(builder: (catController) {
          return catController.categoryList != null ? catController.categoryList!.isNotEmpty ? GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 4 : 3,
              childAspectRatio: (1/1),
              mainAxisSpacing: Dimensions.paddingSizeSmall,
              crossAxisSpacing: Dimensions.paddingSizeSmall,
            ),
            padding:   EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemCount: catController.categoryList!.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => Get.toNamed(RouteHelper.getCategoryItemRoute(
                  catController.categoryList![index].id, catController.categoryList![index].name!,
                )),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200]!, blurRadius: 5, spreadRadius: 1)],
                  ),
                  alignment: Alignment.center,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      child: CustomImage(
                        height: 50, width: 50, fit: BoxFit.cover,
                        image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.categoryImageUrl}/${catController.categoryList![index].image}',
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      catController.categoryList![index].name!, textAlign: TextAlign.center,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),

                  ]),
                ),
              );
            },
          ) : NoDataScreen(text: 'no_category_found'.tr) : const Center(child: CircularProgressIndicator());
        }),
      ))))),
    );
  }
}
