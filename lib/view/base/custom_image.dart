import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../util/styles.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeholder;
  CustomImage({@required this.image, this.height, this.width, this.fit = BoxFit.cover, this.placeholder = Images.placeholder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image, height: height, width: width, fit: fit,
      placeholder: (context, url) {
        return Shimmer(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 3,
                  spreadRadius: 3,
                  offset: Offset(0, 0)
                )
              ]
            ),
            padding: EdgeInsets.all(15),
            child: Center(
              child: Text(
                "مشہور",
                style: robotoRegular.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                    overflow:
                    TextOverflow.ellipsis),
              ),
            ),
          ),
          duration: Duration(seconds: 3),
          interval: Duration(seconds: 5),
          color: Colors.white,
          colorOpacity: 0.3,
          enabled: true,
          direction: ShimmerDirection.fromLeftToRight(),
        );
      },
      // placeholder: (context, url) => Image.asset(Images.placeholder, height: height, width: width, fit: fit),
      errorWidget: (context, url, error) => Image.asset(placeholder, height: height, width: width, fit: fit),
    );
  }
}
