import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:customer/equipment/controller/cart_controller.dart';
import 'package:customer/equipment/controller/item_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/response/cart_model.dart';
import 'package:customer/equipment/data/model/response/item_model.dart';
import 'package:customer/equipment/helper/price_converter.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/helper/route_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/cart_snackbar.dart';
import 'package:customer/equipment/view/base/confirmation_dialog.dart';
import 'package:customer/equipment/view/base/custom_app_bar.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/screens/checkout/checkout_screen.dart';
import 'package:customer/equipment/view/screens/item/widget/details_app_bar.dart';
import 'package:customer/equipment/view/screens/item/widget/details_web_view.dart';
import 'package:customer/equipment/view/screens/item/widget/item_image_view.dart';
import 'package:customer/equipment/view/screens/item/widget/item_title_view.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item? item;
  final bool inStorePage;
  const ItemDetailsScreen(
      {Key? key, required this.item, required this.inStorePage})
      : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final Size size = Get.size;
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  final GlobalKey<DetailsAppBarState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    Get.find<EQItemController>().getProductDetails(widget.item!);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EQItemController>(
      builder: (itemController) {
        int? stock = 0;
        CartModel? cartModel;
        double priceWithAddons = 0;
        if (itemController.item != null &&
            itemController.variationIndex != null) {
          List<String> variationList = [];
          for (int index = 0;
              index < itemController.item!.choiceOptions!.length;
              index++) {
            variationList.add(itemController.item!.choiceOptions![index]
                .options![itemController.variationIndex![index]]
                .replaceAll(' ', ''));
          }
          String variationType = '';
          bool isFirst = true;
          for (var variation in variationList) {
            if (isFirst) {
              variationType = '$variationType$variation';
              isFirst = false;
            } else {
              variationType = '$variationType-$variation';
            }
          }

          double? price = itemController.item!.price;
          Variation? variation;
          stock = itemController.item!.stock ?? 0;
          for (Variation v in itemController.item!.variations!) {
            if (v.type == variationType) {
              price = v.price;
              variation = v;
              stock = v.stock;
              break;
            }
          }

          double? discount =
              (itemController.item!.availableDateStarts != null ||
                      itemController.item!.storeDiscount == 0)
                  ? itemController.item!.discount
                  : itemController.item!.storeDiscount;
          String? discountType =
              (itemController.item!.availableDateStarts != null ||
                      itemController.item!.storeDiscount == 0)
                  ? itemController.item!.discountType
                  : 'percent';
          double priceWithDiscount = PriceConverter.convertWithDiscount(
              price, discount, discountType)!;
          double priceWithQuantity =
              priceWithDiscount * itemController.quantity!;
          double addonsCost = 0;
          List<AddOn> addOnIdList = [];
          List<AddOns> addOnsList = [];
          for (int index = 0;
              index < itemController.item!.addOns!.length;
              index++) {
            if (itemController.addOnActiveList[index]) {
              addonsCost = addonsCost +
                  (itemController.item!.addOns![index].price! *
                      itemController.addOnQtyList[index]!);
              addOnIdList.add(AddOn(
                  id: itemController.item!.addOns![index].id,
                  quantity: itemController.addOnQtyList[index]));
              addOnsList.add(itemController.item!.addOns![index]);
            }
          }

          cartModel = CartModel(
            price,
            priceWithDiscount,
            variation != null ? [variation] : [],
            [],
            (price! -
                PriceConverter.convertWithDiscount(
                    price, discount, discountType)!),
            itemController.quantity,
            addOnIdList,
            addOnsList,
            itemController.item!.availableDateStarts != null,
            stock,
            itemController.item,
          );
          priceWithAddons = priceWithQuantity +
              (Get.find<EQSplashControllerEquip>()
                      .configModel!
                      .moduleConfig!
                      .module!
                      .addOn!
                  ? addonsCost
                  : 0);
        }

        return Scaffold(
          key: _globalKey,
          backgroundColor: Theme.of(context).cardColor,
          appBar: ResponsiveHelper.isDesktop(context)
              ? CustomAppBar(title: '')
              : DetailsAppBar(key: _key),
          body: (itemController.item != null)
              ? ResponsiveHelper.isDesktop(context)
                  ? DetailsWebView(
                      cartModel: cartModel,
                      stock: stock,
                      priceWithAddOns: priceWithAddons,
                    )
                  : Column(children: [
                      Expanded(
                          child: Scrollbar(
                        child: SingleChildScrollView(
                            padding:   EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            physics: const BouncingScrollPhysics(),
                            child: Center(
                                child: SizedBox(
                                    width: Dimensions.webMaxWidth,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ItemImageView(
                                            item: itemController.item),
                                        const SizedBox(height: 20),

                                        Builder(builder: (context) {
                                          return ItemTitleView(
                                            item: itemController.item,
                                            inStorePage: widget.inStorePage,
                                            isCampaign: itemController.item!
                                                    .availableDateStarts !=
                                                null,
                                            inStock:
                                                (Get.find<EQSplashControllerEquip>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .stock! &&
                                                    stock! <= 0),
                                          );
                                        }),
                                        const Divider(height: 20, thickness: 2),

                                        // Variation
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: itemController
                                              .item!.choiceOptions!.length,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      itemController
                                                          .item!
                                                          .choiceOptions![index]
                                                          .title!,
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge)),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  GridView.builder(
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 20,
                                                      mainAxisSpacing: 10,
                                                      childAspectRatio:
                                                          (1 / 0.25),
                                                    ),
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: itemController
                                                        .item!
                                                        .choiceOptions![index]
                                                        .options!
                                                        .length,
                                                    itemBuilder: (context, i) {
                                                      return InkWell(
                                                        onTap: () {
                                                          itemController
                                                              .setCartVariationIndex(
                                                                  index,
                                                                  i,
                                                                  itemController
                                                                      .item);
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          padding:   EdgeInsets
                                                                  .symmetric(
                                                              horizontal: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: itemController
                                                                            .variationIndex![
                                                                        index] !=
                                                                    i
                                                                ? Theme.of(
                                                                        context)
                                                                    .disabledColor
                                                                : Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: itemController.variationIndex![
                                                                        index] !=
                                                                    i
                                                                ? Border.all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    width: 2)
                                                                : null,
                                                          ),
                                                          child: Text(
                                                            itemController
                                                                .item!
                                                                .choiceOptions![
                                                                    index]
                                                                .options![i]
                                                                .trim(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: robotoRegular
                                                                .copyWith(
                                                              color: itemController
                                                                              .variationIndex![
                                                                          index] !=
                                                                      i
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: index !=
                                                              itemController
                                                                      .item!
                                                                      .choiceOptions!
                                                                      .length -
                                                                  1
                                                          ? Dimensions
                                                              .paddingSizeLarge
                                                          : 0),
                                                ]);
                                          },
                                        ),
                                        itemController
                                                .item!.choiceOptions!.isNotEmpty
                                            ? const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeLarge)
                                            : const SizedBox(),

                                        // Quantity
                                        Row(children: [
                                          Text('quantity'.tr,
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeLarge)),
                                          const Expanded(child: SizedBox()),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(children: [
                                              InkWell(
                                                onTap: () {
                                                  if (itemController
                                                          .cartIndex !=
                                                      -1) {
                                                    if (Get.find<
                                                                EQCartController>()
                                                            .cartList[
                                                                itemController
                                                                    .cartIndex]
                                                            .quantity! >
                                                        1) {
                                                      Get.find<EQCartController>()
                                                          .setQuantity(
                                                              false,
                                                              itemController
                                                                  .cartIndex,
                                                              stock);
                                                    }
                                                  } else {
                                                    if (itemController
                                                            .quantity! >
                                                        1) {
                                                      itemController
                                                          .setQuantity(
                                                              false, stock);
                                                    }
                                                  }
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child: Icon(Icons.remove,
                                                      size: 20),
                                                ),
                                              ),
                                              GetBuilder<EQCartController>(
                                                  builder: (cartController) {
                                                return Text(
                                                  itemController.cartIndex != -1
                                                      ? cartController
                                                          .cartList[
                                                              itemController
                                                                  .cartIndex]
                                                          .quantity
                                                          .toString()
                                                      : itemController.quantity
                                                          .toString(),
                                                  style: robotoMedium.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraLarge),
                                                );
                                              }),
                                              InkWell(
                                                onTap: () => itemController
                                                            .cartIndex !=
                                                        -1
                                                    ? Get.find<EQCartController>()
                                                        .setQuantity(
                                                            true,
                                                            itemController
                                                                .cartIndex,
                                                            stock)
                                                    : itemController
                                                        .setQuantity(
                                                            true, stock),
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall,
                                                      vertical: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  child:
                                                      Icon(Icons.add, size: 20),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ]),
                                        const SizedBox(
                                            height:
                                                Dimensions.paddingSizeLarge),

                                        GetBuilder<EQCartController>(
                                            builder: (cartController) {
                                          return Row(children: [
                                            Text('${'total_amount'.tr}:',
                                                style: robotoMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge)),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Text(
                                                PriceConverter.convertPrice(itemController
                                                            .cartIndex !=
                                                        -1
                                                    ? (cartController
                                                            .cartList[
                                                                itemController
                                                                    .cartIndex]
                                                            .discountedPrice! *
                                                        cartController
                                                            .cartList[
                                                                itemController
                                                                    .cartIndex]
                                                            .quantity!)
                                                    : priceWithAddons),
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: robotoBold.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                )),
                                          ]);
                                        }),
                                        const SizedBox(
                                            height: Dimensions
                                                .paddingSizeExtraLarge),

                                        (itemController.item!.description !=
                                                    null &&
                                                itemController.item!
                                                    .description!.isNotEmpty)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('description'.tr,
                                                      style: robotoMedium),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeExtraSmall),
                                                  Text(
                                                      itemController
                                                          .item!.description!,
                                                      style: robotoRegular),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeLarge),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    )))),
                      )),
                      Builder(builder: (context) {
                        return Container(
                          width: 1170,
                          padding:
                                EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CustomButton(
                            buttonText: (Get.find<EQSplashControllerEquip>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .stock! &&
                                    stock! <= 0)
                                ? 'out_of_stock'.tr
                                : itemController.item!.availableDateStarts !=
                                        null
                                    ? 'order_now'.tr
                                    : itemController.cartIndex != -1
                                        ? 'update_in_cart'.tr
                                        : 'add_to_cart'.tr,
                            onPressed: (!Get.find<EQSplashControllerEquip>()
                                        .configModel!
                                        .moduleConfig!
                                        .module!
                                        .stock! ||
                                    stock! > 0)
                                ? () {
                                    if (!Get.find<EQSplashControllerEquip>()
                                            .configModel!
                                            .moduleConfig!
                                            .module!
                                            .stock! ||
                                        stock! > 0) {
                                      if (itemController
                                              .item!.availableDateStarts !=
                                          null) {
                                        Get.toNamed(
                                            RouteHelper.getCheckoutRoute(
                                                'campaign'),
                                            arguments: CheckoutScreen(
                                              storeId: null,
                                              fromCart: false,
                                              cartList: [cartModel],
                                            ));
                                      } else {
                                        if (Get.find<EQCartController>()
                                            .existAnotherStoreItem(
                                                cartModel!.item!.storeId,
                                                Get.find<EQSplashControllerEquip>()
                                                            .module ==
                                                        null
                                                    ? Get.find<
                                                            EQSplashControllerEquip>()
                                                        .cacheModule!
                                                        .id
                                                    : Get.find<
                                                            EQSplashControllerEquip>()
                                                        .module!
                                                        .id)) {
                                          Get.dialog(
                                              ConfirmationDialog(
                                                icon: Images.warning,
                                                title:
                                                    'are_you_sure_to_reset'.tr,
                                                description: Get.find<
                                                            EQSplashControllerEquip>()
                                                        .configModel!
                                                        .moduleConfig!
                                                        .module!
                                                        .showRestaurantText!
                                                    ? 'if_you_continue'.tr
                                                    : 'if_you_continue_without_another_store'
                                                        .tr,
                                                onYesPressed: () {
                                                  Get.back();
                                                  Get.find<EQCartController>()
                                                      .removeAllAndAddToCart(
                                                          cartModel!);
                                                  showCartSnackBar();
                                                },
                                              ),
                                              barrierDismissible: false);
                                        } else {
                                          if (itemController.cartIndex == -1) {
                                            Get.find<EQCartController>()
                                                .addToCart(cartModel,
                                                    itemController.cartIndex);
                                          }
                                          _key.currentState!.shake();
                                          showCartSnackBar();
                                        }
                                      }
                                    }
                                  }
                                : null,
                          ),
                        );
                      }),
                    ])
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int? quantity;
  final bool isCartWidget;
  final int? stock;
  final bool isExistInCart;
  final int cartIndex;
  const QuantityButton({
    Key? key,
    required this.isIncrement,
    required this.quantity,
    required this.stock,
    required this.isExistInCart,
    required this.cartIndex,
    this.isCartWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isExistInCart) {
          if (!isIncrement && quantity! > 1) {
            Get.find<EQCartController>().setQuantity(false, cartIndex, stock);
          } else if (isIncrement && quantity! > 0) {
            if (quantity! < stock! ||
                !Get.find<EQSplashControllerEquip>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .stock!) {
              Get.find<EQCartController>().setQuantity(true, cartIndex, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        } else {
          if (!isIncrement && quantity! > 1) {
            Get.find<EQItemController>().setQuantity(false, stock);
          } else if (isIncrement && quantity! > 0) {
            if (quantity! < stock! ||
                !Get.find<EQSplashControllerEquip>()
                    .configModel!
                    .moduleConfig!
                    .module!
                    .stock!) {
              Get.find<EQItemController>().setQuantity(true, stock);
            } else {
              showCustomSnackBar('out_of_stock'.tr);
            }
          }
        }
      },
      child: Container(
        // padding: EdgeInsets.all(3),
        height: 50, width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor),
        child: Center(
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: isIncrement
                ? Colors.white
                : quantity! > 1
                    ? Colors.white
                    : Colors.white,
            size: isCartWidget ? 26 : 20,
          ),
        ),
      ),
    );
  }
}
