import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:customer/equipment/controller/auth_controller.dart';
import 'package:customer/equipment/controller/splash_controller.dart';
import 'package:customer/equipment/data/model/body/social_log_in_body.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/images.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    return Get.find<EQSplashControllerEquip>().configModel!.socialLogin!.isNotEmpty &&
            (Get.find<EQSplashControllerEquip>()
                    .configModel!
                    .socialLogin![0]
                    .status! ||
                Get.find<EQSplashControllerEquip>()
                    .configModel!
                    .socialLogin![1]
                    .status!)
        ? Column(children: [
            Center(child: Text('social_login'.tr, style: robotoMedium)),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Get.find<EQSplashControllerEquip>().configModel!.socialLogin![0].status!
                  ? InkWell(
                      onTap: () async {
                        GoogleSignInAccount googleAccount =
                            (await googleSignIn.signIn())!;
                        GoogleSignInAuthentication auth =
                            await googleAccount.authentication;
                        Get.find<EQAuthController>()
                            .loginWithSocialMedia(SocialLogInBody(
                          email: googleAccount.email,
                          token: auth.idToken,
                          uniqueId: googleAccount.id,
                          medium: 'google',
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding:   EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(Images.google),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(
                  width: Get.find<EQSplashControllerEquip>()
                          .configModel!
                          .socialLogin![0]
                          .status!
                      ? Dimensions.paddingSizeSmall
                      : 0),
              // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

              // Get.find<SplashController>().configModel!.socialLogin![1].status! ? InkWell(
              //   onTap: () async{
              //     LoginResult result = await FacebookAuth.instance.login();
              //     if (result.status == LoginStatus.success) {
              //       Map userData = await FacebookAuth.instance.getUserData();
              //       Get.find<AuthController>().loginWithSocialMedia(SocialLogInBody(
              //         email: userData['email'], token: result.accessToken!.token, uniqueId: result.accessToken!.userId, medium: 'facebook',
              //       ));
              //     }
              //   },
              //   child: Container(
              //     height: 40, width: 40,
              //     padding:   EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: const BorderRadius.all(Radius.circular(5)),
              //       boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300]!, spreadRadius: 1, blurRadius: 5)],
              //     ),
              //     child: Image.asset(Images.facebook),
              //   ),
              // ) : const SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Get.find<EQSplashControllerEquip>()
                          .configModel!
                          .appleLogin!
                          .isNotEmpty &&
                      Get.find<EQSplashControllerEquip>()
                          .configModel!
                          .appleLogin![0]
                          .status! &&
                      !GetPlatform.isAndroid &&
                      !GetPlatform.isWeb
                  ? InkWell(
                      onTap: () async {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                          webAuthenticationOptions: WebAuthenticationOptions(
                            clientId: Get.find<EQSplashControllerEquip>()
                                .configModel!
                                .appleLogin![0]
                                .clientId!,
                            redirectUri: Uri.parse(
                                'https://motorey-web.6amtech.com/apple'),
                          ),
                        );
                        Get.find<EQAuthController>()
                            .loginWithSocialMedia(SocialLogInBody(
                          email: credential.email,
                          token: credential.authorizationCode,
                          uniqueId: credential.authorizationCode,
                          medium: 'apple',
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding:   EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                                spreadRadius: 1,
                                blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(Images.appleLogo),
                      ),
                    )
                  : const SizedBox(),
            ]),
            const SizedBox(height: Dimensions.paddingSizeSmall),
          ])
        : const SizedBox();
  }
}
