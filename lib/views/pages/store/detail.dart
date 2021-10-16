import 'package:campy/models/product.dart';
import 'package:campy/models/state.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/components/structs/store/product.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final appState = ctx.read<PyState>();
    final info = appState.selectedProd;
    return Pyffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Text("스토어 > 텐트 > 간이 텐트")),
      PyDotCorousel(
        imgs: RankProducts.map((path) => Image.asset(
              path,
              width: mq.size.width,
              fit: BoxFit.cover,
            )).toList(),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        height: 200,
        width: mq.size.width,
        child: ProductInfoW(iType: ProdInfoType.Detail, prod: info),
      )
    ]));
  }
}
