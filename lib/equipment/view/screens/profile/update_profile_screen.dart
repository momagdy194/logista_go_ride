import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/controller/user_controller.dart';
import 'package:customer/equipment/data/model/response/response_model.dart';
import 'package:customer/equipment/data/model/response/userinfo_model.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:customer/equipment/view/base/custom_button.dart';
import 'package:customer/equipment/view/base/custom_snackbar.dart';
import 'package:customer/equipment/view/base/footer_view.dart';
import 'package:customer/equipment/view/base/image_picker_widget.dart';
import 'package:customer/equipment/view/base/menu_drawer.dart';
import 'package:customer/equipment/view/base/my_text_field.dart';
import 'package:customer/equipment/view/base/not_logged_in_screen.dart';
import 'package:customer/equipment/view/base/web_menu_bar.dart';
import 'package:customer/equipment/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initCall();
  }

  void initCall(){
    if(Get.find<EQAuthController>().isLoggedIn() && Get.find<EQUserController>().userInfoModel == null) {
      Get.find<EQUserController>().getUserInfo();
    }
    Get.find<EQUserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<EQUserController>(builder: (userController) {
        bool isLoggedIn = Get.find<EQAuthController>().isLoggedIn();
        if(userController.userInfoModel != null && _phoneController.text.isEmpty) {
          _firstNameController.text = userController.userInfoModel!.fName ?? '';
          _lastNameController.text = userController.userInfoModel!.lName ?? '';
          _phoneController.text = userController.userInfoModel!.phone ?? '';
          _emailController.text = userController.userInfoModel!.email ?? '';
        }

        return isLoggedIn ? userController.userInfoModel != null ? ProfileBgWidget(
          backButton: true,
          circularImage: ImagePickerWidget(
            image: '${Get.find<EQSplashControllerEquip>().configModel!.baseUrls!.customerImageUrl}/${userController.userInfoModel!.image}',
            onTap: () => userController.pickImage(), rawFile: userController.rawFile,
          ),
          mainWidget: Column(children: [

            Expanded(child: Scrollbar(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero :   EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Center(child: FooterView(
                minHeight: 0.45,
                child: SizedBox(width: Dimensions.webMaxWidth, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    'first_name'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  MyTextField(
                    hintText: 'first_name'.tr,
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    nextFocus: _lastNameFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    'last_name'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  MyTextField(
                    hintText: 'last_name'.tr,
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    nextFocus: _emailFocus,
                    inputType: TextInputType.name,
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text(
                    'email'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  MyTextField(
                    hintText: 'email'.tr,
                    controller: _emailController,
                    focusNode: _emailFocus,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Row(children: [
                    Text(
                      'phone'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error,
                    )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  MyTextField(
                    hintText: 'phone'.tr,
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    inputType: TextInputType.phone,
                    isEnabled: false,
                  ),

                  //
                  ResponsiveHelper.isDesktop(context) ? Padding(
                    padding:   EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                    child: UpdateProfileButton(isLoading: userController.isLoading, onPressed: () {
                      return _updateProfile(userController);
                    }),
                  ) : const SizedBox.shrink() ,

                ])),
              )),
            ))),

            ResponsiveHelper.isDesktop(context) ? const SizedBox.shrink() : UpdateProfileButton(isLoading: userController.isLoading, onPressed: () => _updateProfile(userController)),

          ]),
        ) : const Center(child: CircularProgressIndicator()) :  NotLoggedInScreen(callBack: (value){
          initCall();
          setState(() {});
        });
      }),
    );
  }

  void _updateProfile(EQUserController userController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    if (userController.userInfoModel!.fName == firstName &&
        userController.userInfoModel!.lName == lastName && userController.userInfoModel!.phone == phoneNumber &&
        userController.userInfoModel!.email == _emailController.text && userController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      UserInfoModel updatedUser = UserInfoModel(fName: firstName, lName: lastName, email: email, phone: phoneNumber);
      ResponseModel responseModel = await userController.updateUserInfo(updatedUser, Get.find<EQAuthController>().getUserToken());
      if(responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      }else {
        showCustomSnackBar(responseModel.message);
      }
    }
  }
}

class UpdateProfileButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  const UpdateProfileButton({Key? key, required this.isLoading, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isLoading ? CustomButton(
      onPressed: onPressed,
      margin:   EdgeInsets.all(Dimensions.paddingSizeSmall),
      buttonText: 'update'.tr,
    ) : const Center(child: CircularProgressIndicator());
  }
}
