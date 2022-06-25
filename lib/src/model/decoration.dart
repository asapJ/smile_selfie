import 'package:flutter/material.dart';

class SmileSelfieDecoration {
  ///A widget that sits at the footer of the screen
  final Widget footer;

  ///A widget that sits above the camera preview
  final Widget header;

  ///Size of the camera preview
  final double previewSize;

  ///Pass your own custom clipper
  final CustomClipper<Rect>? clipper;

  final PreferredSizeWidget? appBar;

  final Color? backgroundColor;

  final Color? foregroundColor;

  const SmileSelfieDecoration(
      {this.footer = const SizedBox(),
      this.header = const SizedBox(),
      this.appBar,
      this.backgroundColor,
      this.foregroundColor,
      this.clipper,
      this.previewSize = 400});
}
