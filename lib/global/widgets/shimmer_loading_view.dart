
import 'package:dozen_diamond/global/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingView {
  static Widget loadingContainer(
      double width,
      double height,
      ) {
    return Shimmer.fromColors(
      baseColor: Color(0xff2c2c31), //Colors.grey[300]!,
      highlightColor: Color(0xff141414), //Colors.grey[100]!,
      child: CustomContainer(
        width: width,
        height: height,
        backgroundColor: Color(0xff2c2c31), //Colors.grey,
        elevation: 0,
        child: Container(),
      ),
      direction: ShimmerDirection.ltr,
      enabled: true,
      loop: 0,
      period: Duration(milliseconds: 1000),
    );
  }

  static Widget loadingContainerDark(
      double width,
      double height,
      ) {
    return Shimmer.fromColors(
      baseColor: Color(0xffcccccc), //Colors.grey[400]!,
      highlightColor: Color(0xffe0e0e0), //Colors.grey[100]!,
      child: CustomContainer(
        width: width,
        height: height,
        backgroundColor: Color(0xffcccccc), // Colors.grey,
        elevation: 0,
        child: Container(),
      ),
      direction: ShimmerDirection.ltr,
      enabled: true,
      loop: 0,
      period: Duration(milliseconds: 1000),
    );
  }

  static Widget circularLoadingView(double radius) {
    return Shimmer.fromColors(
      baseColor: Color(0xff2c2c31), //Colors.grey[300]!,
      highlightColor: Color(0xff141414), //Color(0xffe0e0e0), //Colors.grey[100]!,
      child: CircleAvatar(
        backgroundColor: Color(0xff2c2c31), //Colors.grey,
        radius: radius,
      ),
      direction: ShimmerDirection.ttb,
      enabled: true,
      loop: 0,
      period: Duration(milliseconds: 1000),
    );
  }

  static Widget circularLoadingViewDark(double radius) {
    return Shimmer.fromColors(
      baseColor: Color(0xffcccccc), //Colors.grey[400]!,
      highlightColor: Color(0xffe0e0e0), //Colors.grey[100]!,
      child: CircleAvatar(
        backgroundColor: Color(0xffcccccc), //Colors.grey,
        radius: radius,
      ),
      direction: ShimmerDirection.ttb,
      enabled: true,
      loop: 0,
      period: Duration(milliseconds: 1000),
    );
  }
}