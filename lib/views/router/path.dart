const String SplashPath = '/splash';
const String FeedPath = '/feed';
const String FeedPostPath = '/feed/post';
const String StorePath = '/store';
const String LoginPath = '/login';
const String UnKnownPath = '/unknown';
const String RootPath = "/";

enum PageState { none, addPage, addAll, pop, replace, replaceAll }

enum Views {
  FeedCategory,
  FeedDetail,
  FeedPost,
  StoreCategory,
  ProductDetail,
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
  PageAction.feedPost() {
    state = PageState.addPage;
    page = feedPostPathConfig;
    pages = [feedPostPathConfig];
  }
}

class PyPathConfig {
  final String key;
  final String path;
  final Views uiCtgr;
  PageAction? currentPageAction;
  String? productId;
  String? feedId;

  @override
  String toString() {
    return "PyPathConfig: key: $key,  path: $path, uiCtgr$uiCtgr, currentPageAction: $currentPageAction";
  }

  PyPathConfig(
      {required this.key,
      required this.path,
      required this.uiCtgr,
      this.productId,
      this.currentPageAction});

  PyPathConfig.feedDetail({this.feedId})
      : this.key = 'FeedDetail',
        this.path = FeedPath + '/$feedId',
        this.uiCtgr = Views.FeedDetail;

  PyPathConfig.productDetail({this.productId})
      : this.key = 'ProductDetail',
        this.path = StorePath + '/products/$productId',
        this.uiCtgr = Views.ProductDetail;
}

PyPathConfig feedPathConfig = PyPathConfig(
    key: 'Feed',
    path: FeedPath,
    uiCtgr: Views.FeedCategory,
    currentPageAction: null);

PyPathConfig feedPostPathConfig = PyPathConfig(
    key: 'FeedPost',
    path: FeedPostPath,
    uiCtgr: Views.FeedPost,
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

PyPathConfig unknownPathConfig = PyPathConfig(
    key: 'Unknown',
    path: UnKnownPath,
    uiCtgr: Views.UnknownPage,
    currentPageAction: null);
