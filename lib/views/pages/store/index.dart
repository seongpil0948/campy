import 'package:campy/models/product.dart';
import 'package:campy/repositories/store/product.dart';
import 'package:campy/views/components/assets/carousel.dart';
import 'package:campy/views/components/buttons/pyffold.dart';
import 'package:campy/views/components/structs/store/product.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:provider/provider.dart';

class StoreCategoryView extends StatelessWidget {
  StoreCategoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext ctx) {
    final mq = MediaQuery.of(ctx);
    final headLineStyle = Theme.of(ctx).textTheme.headline6;
    final headLineLeftW = SizedBox(width: mq.size.width / 20);
    // final rankProducts = RankProducts.map((e) => Image.asset(e)).toList();
    // final gridProducts = GridProducts.map((e) => Image.asset(e)).toList();
    final prodInfos = getProds(15).toList();

    return Pyffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: PyDotCorousel(
            imgs: StoreBannerImgs.map((path) => Image.asset(
                  path,
                  width: mq.size.width,
                  fit: BoxFit.cover,
                )).toList(),
          ),
        ),
        // Container(
        //     height: mq.size.height / 1.65,
        //     padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        //     child: GridView.builder(
        //         itemCount: 2 * 2,
        //         physics: NeverScrollableScrollPhysics(),
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2,
        //           crossAxisSpacing: 10,
        //           mainAxisSpacing: 10,
        //           // childAspectRatio: 3 / 2
        //         ),
        //         itemBuilder: (ctx, idx) =>
        //             Stack(fit: StackFit.expand, children: [
        //               rankProducts[idx],
        //               Positioned(
        //                   top: -5,
        //                   left: 10,
        //                   child: Container(
        //                     height: 50,
        //                     width: 22,
        //                     color: Theme.of(ctx).primaryColor,
        //                     child: Center(
        //                       child: Text(
        //                         "\n ${idx + 1}",
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                   ))
        //             ]))),
        _HeadLine(
          headLineLeftW: headLineLeftW,
          headLineStyle: headLineStyle,
          title: "BEST",
        ),
        Container(
          width: mq.size.width - 10,
          height: mq.size.height / 4,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) => Container(
              width: mq.size.width / 3,
              margin: EdgeInsets.only(right: 10),
              child: InheritProduct(
                  prodInfo: prodInfos[index],
                  size: ProductCardSize.Small,
                  child: ProductCard()),
            ),
          ),
        ),
        // Divider(),
        // Container(
        //     height: mq.size.height / 2.2,
        //     padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        //     child: GridView.builder(
        //         itemCount: 6,
        //         physics: NeverScrollableScrollPhysics(),
        //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 3,
        //           crossAxisSpacing: 20,
        //           mainAxisSpacing: 20,
        //           // childAspectRatio: 3 / 2
        //         ),
        //         itemBuilder: (ctx, idx) => gridProducts[idx])),
        _HeadLine(
          headLineLeftW: headLineLeftW,
          headLineStyle: headLineStyle,
          title: "캠핑 페스타 핫딜",
        ),
        GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: prodInfos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6
                // childAspectRatio: 3 / 2
                ),
            itemBuilder: (ctx, idx) => InheritProduct(
                prodInfo: prodInfos[idx],
                size: ProductCardSize.Medium,
                child: ProductCard()))
      ]),
    )));
  }
}

class _HeadLine extends StatelessWidget {
  const _HeadLine({
    Key? key,
    required this.headLineLeftW,
    required this.headLineStyle,
    required this.title,
  }) : super(key: key);

  final SizedBox headLineLeftW;
  final TextStyle? headLineStyle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            headLineLeftW,
            Text(title, style: headLineStyle),
            Spacer(),
            Text("+더보기")
          ],
        ),
        Divider()
      ],
    );
  }
}
