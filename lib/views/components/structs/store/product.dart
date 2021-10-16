import 'package:campy/models/product.dart';
import 'package:campy/models/state.dart';
import 'package:campy/repositories/store/product.dart';
import 'package:campy/utils/parsers.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

enum ProdCardType { TopImgBottomInfo, Detail }
enum ProdInfoType { Common, Detail }

class ProductCard extends StatelessWidget {
  final ProdCardType cType;
  const ProductCard({Key? key, this.cType = ProdCardType.TopImgBottomInfo})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    switch (cType) {
      case ProdCardType.TopImgBottomInfo:
        return _ProdBottom();
      case ProdCardType.Detail:
        return _ProdBottom(iType: ProdInfoType.Detail);
    }
  }
}

class _ProdBottom extends StatelessWidget {
  final ProdInfoType iType;
  const _ProdBottom({Key? key, this.iType = ProdInfoType.Common})
      : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final I = InheritProduct.of(ctx);
    final size = MediaQuery.of(ctx).size;
    return InkWell(
        onTap: () {
          final state = ctx.read<PyState>();
          state.currPageAction = PageAction.productDetail(I.prodInfo.productId);
          state.selectedProd = I.prodInfo;
        },
        child: Column(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: AssetImage(I.prodInfo.imgPath),
              height: I.imgHeight,
              width: size.width,
            ),
          ),
          ProductInfoW()
        ]));
  }
}

class ProductInfoW extends StatelessWidget {
  final ProdInfoType iType;
  const ProductInfoW({Key? key, this.iType = ProdInfoType.Common})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (iType) {
      case ProdInfoType.Common:
        return _ProdInfoCommon();
      case ProdInfoType.Detail:
        return _ProdInfoCommon();
    }
  }
}

class _ProdInfoCommon extends StatelessWidget {
  const _ProdInfoCommon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final I = InheritProduct.of(ctx);
    final T = Theme.of(ctx).textTheme;
    final isSmall = I.size == ProductCardSize.Small;
    final prodInfo = I.prodInfo;
    final int salePercent = 100 -
        (priceToInt(prodInfo.salesPrice) /
                priceToInt(prodInfo.consumerPrice) *
                100)
            .round();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 3),
              child: Text(prodInfo.brand, style: isSmall ? T.caption : null)),
          Text(prodInfo.title, style: !isSmall ? T.subtitle1 : null),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$salePercent% ",
                style: TextStyle(color: Theme.of(ctx).primaryColor),
              ),
              Text(
                "${prodInfo.salesPrice}원",
                style: !isSmall ? T.headline6 : null,
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("리뷰 ${prodInfo.reviewCount} ",
                style: isSmall ? T.caption : null),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.star, size: isSmall ? 10 : null),
            SizedBox(width: 5),
            Text("4.5", style: isSmall ? T.caption : null)
          ])
        ]);
  }
}
