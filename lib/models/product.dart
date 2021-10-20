enum ProductCardSize { Small, Medium, Large }

class ProductInfo {
  const ProductInfo(
      {required this.brand,
      required this.title,
      required this.imgPath,
      required this.categories,
      required this.consumerPrice,
      required this.salesPrice,
      required this.reviewCount,
      required this.productId});
  final String productId;
  final String brand;
  final String title;
  final String imgPath;
  final List<String> categories;
  final String consumerPrice;
  final String salesPrice;
  final int reviewCount;
}

const RankProducts = [
  'assets/images/store_rank_1.png',
  'assets/images/store_rank_2.png',
  'assets/images/store_rank_3.png',
  'assets/images/store_rank_4.png',
];
const GridProducts = [
  'assets/images/store_rank_1.png',
  'assets/images/store_rank_2.png',
  'assets/images/store_rank_3.png',
  'assets/images/store_rank_4.png',
  'assets/images/store_rank_4.png',
  'assets/images/store_rank_4.png',
];
const StoreBannerImgs = [
  "assets/images/store_banner_2000x1500.png",
  "assets/images/store_banner_2000x1500.png",
  "assets/images/store_banner_2000x1500.png",
  "assets/images/store_banner_2000x1500.png",
];

const _storeProductOne = ProductInfo(
    productId: 'sr1',
    brand: '코펠코펠',
    title: "다용도 코펠 세트",
    categories: ['부품', '조리', '코펠'],
    consumerPrice: '69,000',
    salesPrice: '49,000',
    reviewCount: 200,
    imgPath: 'assets/images/store_rank_1.png');
const _storeProductTwo = ProductInfo(
    productId: 'sr2',
    brand: '램프나라',
    title: "캠핑램프",
    categories: ['부품', '조리', '코펠'],
    consumerPrice: '39,000',
    salesPrice: '25,000',
    reviewCount: 150,
    imgPath: 'assets/images/store_rank_2.png');
const _storeProductThree = ProductInfo(
    productId: 'sr3',
    brand: '코펠리어',
    title: "라이트 코펠 세트",
    categories: ['부품', '조리', '코펠'],
    consumerPrice: '49,000',
    salesPrice: '39,000',
    reviewCount: 3500,
    imgPath: 'assets/images/store_rank_3.png');
const _storeProductFour = ProductInfo(
    productId: 'sr4',
    brand: '옐로우 텐트',
    title: "옐로우 시그니처 텐트",
    categories: ['부품', '조리', '코펠'],
    consumerPrice: '109,000',
    salesPrice: '89,000',
    reviewCount: 322,
    imgPath: 'assets/images/store_rank_4.png');
const _StoreProducts = [
  _storeProductOne,
  _storeProductTwo,
  _storeProductThree,
  _storeProductFour
];

Iterable<ProductInfo> getProds(int count) {
  return Iterable.generate(count).map((i) {
    var idx = i % _StoreProducts.length;
    return _StoreProducts[idx];
  });
}
