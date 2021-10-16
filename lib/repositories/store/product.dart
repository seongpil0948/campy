import 'package:campy/models/product.dart';
import 'package:flutter/material.dart';

class InheritProduct extends InheritedWidget {
  InheritProduct(
      {required this.child,
      required this.prodInfo,
      required this.size,
      this.imgHeight})
      : super(child: child);
  final ProductInfo prodInfo;
  final ProductCardSize size;
  final double? imgHeight;
  final Widget child;

  static InheritProduct of(BuildContext context) {
    InheritProduct? result =
        context.dependOnInheritedWidgetOfExactType<InheritProduct>();
    assert(result != null, 'No InheritProduct found in context');
    return result!;
  }

  // either rebuild or not
  @override
  bool updateShouldNotify(InheritProduct oldWidget) {
    return true;
  }
}
