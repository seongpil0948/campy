import 'package:flutter/material.dart';

int priceToInt(String price) => int.parse(price.replaceAll(r",", ""));

TextStyle? tagTextSty(String tag, BuildContext ctx) {
  return tag.startsWith("#")
      ? Theme.of(ctx).primaryTextTheme.bodyText2
      : tag.startsWith("@")
          ? Theme.of(ctx).primaryTextTheme.bodyText1
          : TextStyle(color: Theme.of(ctx).errorColor);
}
