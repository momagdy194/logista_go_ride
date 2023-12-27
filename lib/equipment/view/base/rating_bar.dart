import 'package:customer/equipment/util/dimensions.dart';
import 'package:customer/equipment/util/styles.dart';
import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double? rating;
  final double size;
  final int? ratingCount;
  final IconData? icon;
  final Color? iconColor;
  final String ?title;
  final Color? color;


  const RatingBar({Key? key, required this.rating, required this.ratingCount, this.size = 18 , this.icon , this.color, this.iconColor , this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    int realNumber = rating!.floor();
    int partNumber = ((rating! - realNumber) * 10).ceil();
    ratingCount != null ? starList.add(Padding(
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
      child:title!=null&&(title=="true"||title=="false")?(title=="true" ?
      Icon(Icons.check, color: Colors.grey, size: size):Icon(Icons.close, color: Colors.grey, size: size)  ):
      Text(title??'($rating)${ratingCount}', style: robotoRegular.copyWith(fontSize: size*0.8),
          textDirection: TextDirection.ltr),
    )) : const SizedBox();

    for (int i = 0; i < 1; i++) {
      if (i < realNumber) {
        starList.add(Icon(Icons.star, color:iconColor?? Theme.of(context).primaryColor, size: size));
      } else if (i == realNumber) {
        starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(icon??Icons.star, color: iconColor??Theme.of(context).primaryColor, size: size),
           
            ],
          ),
        ));
      } else {
        starList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
    } 

    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color:color  ),
        child: Row( 
          mainAxisSize: MainAxisSize.min,
          children: starList,
        ),
      ),
    );
  }
}
class RatingBar2 extends StatelessWidget {
  final double? rating;
  final double size;
  final int? ratingCount;
  final IconData? icon;
  final Color? iconColor;
  final String ?title;
  final Color? color;


  const RatingBar2({Key? key, required this.rating, required this.ratingCount, this.size = 18 , this.icon , this.color, this.iconColor , this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> starList = [];

    int realNumber = rating!.floor();
    int partNumber = ((rating! - realNumber) * 10).ceil();
    ratingCount != null ? starList.add(Padding(
      padding:   EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
      child:title!=null&&(title=="true"||title=="false")?(title=="true" ?
      Icon(Icons.check, color: Colors.grey, size: size):Icon(Icons.close, color: Colors.grey, size: size)  ):
      Text(rating?.toString()??"0" , style: robotoRegular.copyWith(fontSize: size*0.8,color: Colors.white),
          textDirection: TextDirection.ltr),
    )) : const SizedBox();

    for (int i = 0; i < 1; i++) {
      if (i < realNumber) {
        starList.add(Icon(Icons.star, color:iconColor?? Theme.of(context).primaryColor, size: size));
      } else if (i == realNumber) {
        starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(icon??Icons.star, color: iconColor??Theme.of(context).primaryColor, size: size),

            ],
          ),
        ));       starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(icon??Icons.star, color: iconColor??Theme.of(context).primaryColor, size: size),

            ],
          ),
        ));       starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(icon??Icons.star, color: iconColor??Theme.of(context).primaryColor, size: size),

            ],
          ),
        ));       starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(icon??Icons.star, color: iconColor??Theme.of(context).primaryColor, size: size),

            ],
          ),
        ));
      } else {
        starList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(borderRadius:BorderRadius.circular(5),color:color  ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: starList,
        ),
      ),
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part;

  _Clipper({required this.part});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(
      (size.width / 10) * part,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
