import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iconly/iconly.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/cart_widget.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/veg_filter_widget.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:get/get.dart';

import '../../controller/category_controller.dart';
import '../../data/model/response/care_version.dart';
import 'colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  final bool showCart;
  final Function(String value)? onVegFilterTap;
  final Function(Map value)? versionSearch;
  final String? type;
  final String? leadingIcon;
  CustomAppBar(
      {Key? key,
      required this.title,
      this.backButton = true,
      this.onBackPressed,
      this.versionSearch,
      this.showCart = false,
      this.leadingIcon,
      this.onVegFilterTap,
      this.type})
      : super(key: key);

  String? careVersionId;
  String? careYeat;

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context)
        ? const WebMenuBar()
        : AppBar(
            title: Text(title,
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyLarge!.color)),
            centerTitle: true,
            leading: backButton
                ? IconButton(
                    icon: leadingIcon != null
                        ? Image.asset(leadingIcon!, height: 22, width: 22)
                        : const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed!()
                        : Navigator.pop(context),
                  )
                : const SizedBox(),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: showCart || onVegFilterTap != null
                ? [
                    showCart
                        ? IconButton(
                            onPressed: () =>
                                Get.toNamed(RouteHelper.getCartRoute()),
                            icon: CartWidget(
                                color: Theme.of(Get.context!).primaryColor,
                                size: 25),
                          )
                        : const SizedBox(),
                    onVegFilterTap != null
                        ? VegFilterWidget(
                            type: type,
                            onSelected: onVegFilterTap,
                            fromAppBar: true,
                          )
                        : const SizedBox(),
                    if (versionSearch != null)
                      InkWell(
                        onTap: () {
                          Get.dialog(Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            backgroundColor: Colors.white,
                            child: Container(
                              height: Get.height / 2,
                              child: Center(
                                child: Padding(
                                  padding:   EdgeInsets.all(15.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("تصفية قطع الغيار"),
                                              InkWell(
                                                  onTap: () => Get.back(),
                                                  child: const Icon(
                                                    IconlyLight.close_square,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        DropdownSearch<String>(
                                          dropdownButtonProps: DropdownButtonProps(
                                              icon: Icon(Icons
                                                  .keyboard_arrow_down_sharp)),
                                          // filterFn: (user, filter) =>
                                          //     user,
                                          compareFn: (item1, item2) =>
                                              item1 == item2,
                                          items: [
                                            "2023",
                                            "2022",
                                            "2021",
                                            "2020",
                                            "2019",
                                            "2018",
                                            "2017",
                                            "2016",
                                            "2015",
                                            "2014",
                                            "2013",
                                            "2012",
                                            "2011",
                                            "2010",
                                            "2009",
                                            "2008",
                                            "2007",
                                            "2006",
                                            "2005",
                                            "2004",
                                            "2003",
                                            "2002",
                                            "2001",
                                            "2000",
                                          ],
                                          onChanged: (data) {
                                            careYeat = data;
                                          },
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              hintText: "سنة الصنع",
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                              border: InputBorder.none,
                                            ),
                                          ),

                                          popupProps: PopupProps.dialog(
                                            dialogProps: const DialogProps(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)))),
                                            itemBuilder: (context, item,
                                                    isSelected) =>
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    // osAddSymmetricPaddingSpace(
                                                    //     vertical: 5,
                                                    //     horizontal: 10),
                                                    child: Row(
                                                      children: [
                                                        isSelected
                                                            ? Icon(
                                                                Icons.circle,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                        SizedBox(width: 10),
                                                        Flexible(
                                                            child: Text(
                                                          item ?? "",
                                                          maxLines: 1,
                                                        )),
                                                      ],
                                                    )),
                                            showSearchBox: true,
                                            showSelectedItems: true,
                                            searchDelay: Duration.zero,
                                            title: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("البجث في الاصدارات"),
                                                  InkWell(
                                                      onTap: () => Get.back(),
                                                      child: const Icon(
                                                        IconlyLight
                                                            .close_square,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                  // fillColor: AppColors.lightGrey.withOpacity(.3),
                                                  errorMaxLines: 1,
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  // suffixIcon:  Icon(Icons.close),
                                                  // label:Text( label ),
                                                  hintText: "Search".tr,
                                                  // hintStyle: Constants.isEnglishLang
                                                  //     ? GoogleFonts.poppins(
                                                  //         fontSize: 14,
                                                  //         color: const Color(0xffB4B4B4),
                                                  //       )
                                                  //     : const TextStyle(
                                                  //         fontSize: 14,
                                                  //         color: const Color(0xffB4B4B4),
                                                  //       ),

                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppColors.accent,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      // color: AppColors.lightGrey,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        const BorderSide(
                                                      // color: AppColors.lightGrey,
                                                      width: 0.5,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        DropdownSearch<CarVersion>(
                                          dropdownButtonProps: DropdownButtonProps(
                                              icon: Icon(Icons
                                                  .keyboard_arrow_down_sharp)),
                                          // filterFn: (user, filter) =>
                                          //     user,
                                          compareFn: (item1, item2) =>
                                              item1.id == item2.id,
                                          asyncItems: (String filter) =>
                                              Get.find<EQCategoryController>()
                                                  .getCareVersionList(
                                                      categoryID: null),
                                          itemAsString: (CarVersion u) =>
                                              u.name ?? "",
                                          onChanged: (CarVersion? data) {
                                            careVersionId = data?.id.toString();
                                          },
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              hintText: "الاصدارات",
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .inputDecorationTheme
                                                  .fillColor,
                                              border: InputBorder.none,
                                            ),
                                          ),

                                          popupProps: PopupProps.dialog(
                                            dialogProps: const DialogProps(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)))),
                                            itemBuilder: (context, item,
                                                    isSelected) =>
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    // osAddSymmetricPaddingSpace(
                                                    //     vertical: 5,
                                                    //     horizontal: 10),
                                                    child: Row(
                                                      children: [
                                                        isSelected
                                                            ? Icon(
                                                                Icons.circle,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .circle_outlined,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 20,
                                                              ),
                                                        SizedBox(width: 10),
                                                        Flexible(
                                                            child: Text(
                                                          item.name ?? "",
                                                          maxLines: 1,
                                                        )),
                                                      ],
                                                    )),
                                            showSearchBox: true,
                                            showSelectedItems: true,
                                            searchDelay: Duration.zero,
                                            title: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("البجث في سنة الصنع"),
                                                  InkWell(
                                                      onTap: () => Get.back(),
                                                      child: const Icon(
                                                        IconlyLight
                                                            .close_square,
                                                        color: Colors.red,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            searchFieldProps: TextFieldProps(
                                              decoration: InputDecoration(
                                                  errorMaxLines: 1,
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  hintText: "Search".tr,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: AppColors.accent,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                      // color: AppColors.lightGrey,
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    borderSide:
                                                        const BorderSide(
                                                      // color: AppColors.lightGrey,
                                                      width: 0.5,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        CustomButton(
                                          buttonText: "Search".tr,
                                          onPressed: () {
// careVersionId
// careYeat

                                            versionSearch!({
                                              "id": careVersionId,
                                              "year": careYeat,
                                            });
                                            Get.back();
                                          },
                                        ),
                                        Spacer(),
                                      ]),
                                ),
                              ),
                            ),
                          ));
                        },
                        child: Padding(
                          padding:   EdgeInsets.all(8.0),
                          child: Icon(
                            IconlyLight.filter,
                            color: Theme.of(Get.context!).primaryColor,
                          ),
                        ),
                      )
                  ]
                : [const SizedBox()],
          );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
