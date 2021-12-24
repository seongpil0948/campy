const String SplashPath = '/splash';
const String FeedPath = '/feed';
const String FeedPostPath = '/feed/post';
const String StorePath = '/store';
const String LoginPath = '/login';
const String UnKnownPath = '/unknown';
const String RootPath = "/";
const String UserPath = "/users";

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
  My,
}

class PageAction {
  late PageState state = PageState.addPage;
  late PyPathConfig page;
  late List<PyPathConfig> pages;
  PageAction.my(userId) {
    page = PyPathConfig.my();
    pages = [PyPathConfig.my()];
  }
  PageAction.feed() {
    page = feedPathConfig;
    pages = [feedPathConfig];
  }
  PageAction.store() {
    page = storePathConfig;
    pages = [storePathConfig];
  }
  PageAction.productDetail(productId) {
    page = PyPathConfig.productDetail(productId: productId);
    pages = [PyPathConfig.productDetail(productId: productId)];
  }
  PageAction.feedDetail(feedId) {
    page = PyPathConfig.feedDetail(feedId: feedId);
    pages = [PyPathConfig.feedDetail(feedId: feedId)];
  }
  PageAction.feedPost() {
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

  PyPathConfig.feedDetail({required this.feedId})
      : this.key = 'FeedDetail',
        this.path = FeedPath + '/$feedId',
        this.uiCtgr = Views.FeedDetail;

  PyPathConfig.productDetail({required this.productId})
      : this.key = 'ProductDetail',
        this.path = StorePath + '/products/$productId',
        this.uiCtgr = Views.ProductDetail;
  PyPathConfig.my()
      : this.key = 'MyMy',
        this.path = '$UserPath/',
        this.uiCtgr = Views.My;
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
