const String SplashPath = '/splash';
const String FeedPath = '/feed';
const String PlacePath = '/place';
const String StorePath = '/store';
const String LoginPath = '/store';

enum PageState { none, addPage, addAll, pop, replace, replaceAll }

enum Views {
  FeedCategory,
  FeedDetail,
  PlaceCategory,
  StoreCategory,
  ProductDetail,
  PlaceDetail,
  UnknownPage,
  SplashPage,
  LoginPage,
}

class PageAction {
  late PageState state;
  late PyPathConfig page;
  late List<PyPathConfig> pages;
  PageAction.feed() {
    state = PageState.addPage;
    page = feedPathConfig;
    pages = [feedPathConfig];
  }
  PageAction.place() {
    state = PageState.addPage;
    page = placePathConfig;
    pages = [placePathConfig];
  }
  PageAction.store() {
    state = PageState.addPage;
    page = storePathConfig;
    pages = [storePathConfig];
  }
  PageAction.productDetail(productId) {
    state = PageState.addPage;
    page = PyPathConfig.productDetail(productId: productId);
    pages = [PyPathConfig.productDetail(productId: productId)];
  }
  PageAction.feedDetail(feedId) {
    state = PageState.addPage;
    page = PyPathConfig.feedDetail(feedId: feedId);
    pages = [PyPathConfig.feedDetail(feedId: feedId)];
  }
  PageAction.placeDetail(placeId) {
    state = PageState.addPage;
    page = PyPathConfig.placeDetail(placeId: placeId);
    pages = [PyPathConfig.placeDetail(placeId: placeId)];
  }
}

class PyPathConfig {
  final String key;
  final String path;
  final Views uiCtgr;
  PageAction? currentPageAction;
  String? productId;
  String? feedId;
  String? placeId;

  PyPathConfig(
      {required this.key,
      required this.path,
      required this.uiCtgr,
      this.productId,
      this.currentPageAction});

  PyPathConfig.feedDetail({required this.feedId})
      : this.key = 'FeedDetail',
        this.path = FeedPath + '/$feedId',
        this.uiCtgr = Views.FeedDetail;

  PyPathConfig.productDetail({required this.productId})
      : this.key = 'ProductDetail',
        this.path = StorePath + '/products/$productId',
        this.uiCtgr = Views.ProductDetail;

  PyPathConfig.placeDetail({required this.placeId})
      : this.key = 'PlaceDetail',
        this.path = '/place/$placeId',
        this.uiCtgr = Views.PlaceDetail;
}

PyPathConfig feedPathConfig = PyPathConfig(
    key: 'Feed',
    path: FeedPath,
    uiCtgr: Views.FeedCategory,
    currentPageAction: null);

PyPathConfig placePathConfig = PyPathConfig(
    key: 'Place',
    path: PlacePath,
    uiCtgr: Views.PlaceCategory,
    currentPageAction: null);

PyPathConfig storePathConfig = PyPathConfig(
    key: 'Store',
    path: StorePath,
    uiCtgr: Views.StoreCategory,
    currentPageAction: null);

PyPathConfig splashPathConfig = PyPathConfig(
    key: 'Splash',
    path: SplashPath,
    uiCtgr: Views.SplashPage,
    currentPageAction: null);

PyPathConfig loginPathConfig = PyPathConfig(
    key: 'Login',
    path: LoginPath,
    uiCtgr: Views.LoginPage,
    currentPageAction: null);
