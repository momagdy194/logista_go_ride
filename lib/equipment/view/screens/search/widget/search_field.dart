import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isReadOnly;

  final IconData suffixIcon;
  final Function iconPressed;
  final Color? filledColor;
  final Function(String)? onSubmit;
  final Function? onChanged;
  final Function? onTap;
  const SearchField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.isReadOnly = false,
      required this.suffixIcon,
      required this.iconPressed,
      this.filledColor,
      this.onTap,
      this.onSubmit,
      this.onChanged})
      : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // enabled: !widget.isReadOnly,
      readOnly: widget.isReadOnly,
      onTap: widget.onTap as void Function()?,
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: widget.filledColor ?? Theme.of(context).cardColor,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: widget.iconPressed as void Function()?,
          icon: Icon(widget.suffixIcon,
              color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
      onSubmitted: widget.onSubmit,
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
