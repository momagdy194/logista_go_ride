import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:customer/equipment/helper/responsive_helper.dart';
import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';

import '../../theme/light_theme.dart';
import 'code_picker_widget.dart';

class CustomTextField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final Function? onChanged;
  final Function? onSubmit;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final String? prefixImage;
  final IconData? prefixIcon;
  final double prefixSize;
  final TextAlign textAlign;
  final bool isAmount;
  final bool isNumber;
  final bool showTitle;
  final bool showBorder;
  final double iconSize;
  final bool isPhone;
  final String? countryDialCode;
  final Function(CountryCode countryCode)? onCountryChanged;

  const CustomTextField({
    Key? key,
    this.titleText = 'Write something...',
    this.hintText = '',
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSubmit,
    this.onChanged,
    this.prefixImage,
    this.prefixIcon,
    this.capitalization = TextCapitalization.none,
    this.isPassword = false,
    this.prefixSize = Dimensions.paddingSizeSmall,
    this.textAlign = TextAlign.start,
    this.isAmount = false,
    this.isNumber = false,
    this.showTitle = false,
    this.showBorder = true,
    this.iconSize = 18,
    this.isPhone = false,
    this.countryDialCode,
    this.onCountryChanged,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showTitle
            ? Text(widget.titleText,
            style:
            robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
            : const SizedBox(),
        SizedBox(
            height: widget.showTitle
                ? ResponsiveHelper.isDesktop(context)
                ? Dimensions.paddingSizeDefault
                : Dimensions.paddingSizeExtraSmall
                : 0),
        TextField(
          maxLines: widget.maxLines,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign,
          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
          textInputAction: widget.inputAction,
          keyboardType:
          widget.isAmount ? TextInputType.number : widget.inputType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: widget.capitalization,
          enabled: widget.isEnabled,
          autofocus: false,
          obscureText: widget.isPassword ? _obscureText : false,
          inputFormatters: widget.inputType == TextInputType.phone
              ? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ]
              : widget.isAmount
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
              : widget.isNumber
              ? [FilteringTextInputFormatter.allow(RegExp(r'\d'))]
              : null,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(
                    style: widget.showBorder
                        ? BorderStyle.solid
                        : BorderStyle.none,
                    width: .9,
                    color: AppColor.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(
                    style: widget.showBorder
                        ? BorderStyle.solid
                        : BorderStyle.none,
                    width: 1,
                    color: Theme.of(context).primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide(
                    style: widget.showBorder
                        ? BorderStyle.solid
                        : BorderStyle.none,
                    width: .9,
                    color: Theme.of(context).primaryColor),
              ),
              isDense: true,
              hintText: widget.hintText.isEmpty ||
                  !ResponsiveHelper.isDesktop(context)
                  ? widget.titleText
                  : widget.hintText,
              fillColor: Theme.of(context).cardColor,
              hintStyle: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).hintColor),
              filled: true,
              prefixIcon: widget.isPhone
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:   EdgeInsets.symmetric(horizontal: 5.0),
                    child: Container(
                      width: 0,
                      height: 45,
                      color: AppColor.borderColor,
                    ),
                  ),
                  Padding(
                    padding:   EdgeInsets.symmetric(horizontal: 0),
                    child: CodePickerWidget(
                      boxDecoration: BoxDecoration(color: Theme.of(context).cardColor),
                      flagWidth: 20,
                      hideMainText: true,
                      padding: EdgeInsets.zero,
                      onChanged: widget.onCountryChanged,
                      initialSelection: widget.countryDialCode,
                      favorite: [widget.countryDialCode!],
                      textStyle: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding:   EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: .7,
                      height: 50,
                      color: AppColor.borderColor,
                    ),
                  )
                ],
              )
                  :  Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding:   EdgeInsets.symmetric(horizontal: 5.0),
                      child: Container(
                        width: 0,
                        height: 45,
                        color: AppColor.borderColor,
                      ),
                    ),

                    Padding(
                        padding:   EdgeInsets.symmetric(horizontal: 5),
                        child:widget.prefixImage != null && widget.prefixIcon == null
                            ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.prefixSize),
                          child: Image.asset(widget.prefixImage!,
                              height: 20, width: 20),
                        )
                            : widget.prefixImage == null && widget.prefixIcon != null
                            ? Icon(widget.prefixIcon, size: widget.iconSize,color: Theme.of(context).primaryColor ,)
                            : null )
                    ,
                    Padding(
                      padding:   EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        width: .7,
                        height: 45,
                        color: AppColor.borderColor,
                      ),
                    )

                  ]),
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                    _obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Theme.of(context).hintColor.withOpacity(0.3)),
                onPressed: _toggle,
              )
                  : null,
              contentPadding: EdgeInsets.zero),
          onSubmitted: (text) => widget.nextFocus != null
              ? FocusScope.of(context).requestFocus(widget.nextFocus)
              : widget.onSubmit != null
              ? widget.onSubmit!(text)
              : null,
          onChanged: widget.onChanged as void Function(String)?,
        ),
      ],
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
