import 'package:campy/repositories/auth/auth.dart';
import 'package:campy/models/state.dart';
import 'package:campy/views/pages/chat/list.dart';
import 'package:campy/views/pages/common/login.dart';
import 'package:campy/views/pages/common/my.dart';
import 'package:campy/views/pages/common/splash.dart';
import 'package:campy/views/pages/common/wrong.dart';
import 'package:campy/views/pages/feed/detail.dart';
import 'package:campy/views/pages/feed/index.dart';
import 'package:campy/views/pages/feed/post.dart';
import 'package:campy/views/pages/store/detail.dart';
import 'package:campy/views/pages/store/index.dart';
import 'package:campy/views/router/path.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

// e.key = pageConfig Key
const backDisbles = ['/login', '/unknown', '/splash'];

class PyRouterDelegate extends RouterDelegate<PyPathConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  PyRouterDelegate();

  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  final List<Page> _pages = [];
  List<MaterialPage> get pages => List.unmodifiable(_pages);
  PyPathConfig get currPageConfig => _pages.last.arguments as PyPathConfig;

  List<Page> buildPages(BuildContext ctx) {
    final state = ctx.watch<PyState>();
    final auth = ctx.watch<PyAuth>();
    if (!state.endSplash) {
      _addPageData(SplashView(key: ValueKey("Splash")), splashPathConfig);
    } else if (!auth.isAuthentic) {
      _addPageData(LoginView(key: ValueKey("Login")), loginPathConfig);
    } else {
      rmInBackables();
      switch (state.currPageAction.state) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(state.currPageAction);
          addPage(state.currPageAction.page);
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(state.currPageAction);
          replace(state.currPageAction.page);
          break;
        case PageState.replaceAll:
          _setPageAction(state.currPageAction);
          replaceAll(state.currPageAction.page);
          break;
        case PageState.addAll:
          addAll(state.currPageAction.pages);
          break;
        default:
          state.resetCurrentAction();
          break;
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext ctx) {
    return Navigator(
      key: navigatorKey,
      pages: buildPages(ctx),
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    print("In setNewRoutePath, Configure: $configuration");
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // returns false If the route can???t handle it internally
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // Otherwise, check to see if we can remove the top page
    // and remove the page from the list of pages.
    if (canPop()) {
      pop();
      return true;
    }
    return false;
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);
    }
  }

  bool canPop() => pages.length > 1;
  void rmInBackables() =>
      _pages.removeWhere((element) => backDisbles.contains(element.name));

  // These methods ensure there are at least two pages in the list.
  // Both pop and popRoute will call _removePage to remove a page and
  // return true if it can pop, ottherwise, return false to close the app.
  // If you didn???t add the check here and called
  // _removePage on the last page of the app, you would see a blank screen.
  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);

      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PyPathConfig pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PyPathConfig pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PyPathConfig pageConfig) {
    // final shouldAddPage = _pages.isEmpty ||
    //     (_pages.last.arguments as PyPathConfig).uiCtgr != pageConfig.uiCtgr;

    switch (pageConfig.uiCtgr) {
      case Views.FeedCategory:
        _addPageData(FeedCategoryView(key: ValueKey("Feed")), feedPathConfig);
        break;
      case Views.FeedPost:
        _addPageData(
            FeedPostView(key: ValueKey("FeedPost")), feedPostPathConfig);
        break;
      case Views.FeedDetail:
        _addPageData(FeedDetailView(key: ValueKey("FeedDetail")), pageConfig);
        break;
      case Views.StoreCategory:
        _addPageData(StoreCategoryView(key: ValueKey("Store")), pageConfig);
        break;
      case Views.ProductDetail:
        _addPageData(
            ProductDetailView(key: ValueKey("ProductDetail")), pageConfig);
        break;
      case Views.My:
        _addPageData(MyView(key: ValueKey("My")), pageConfig);
        break;
      case Views.UnknownPage:
        _addPageData(WrongView(key: ValueKey("Unknown")), pageConfig);
        break;
      case Views.ChatPage:
        _addPageData(ChatCategoryView(key: ValueKey("Chat")), pageConfig);
        break;
      default:
        break;
    }
  }

  // Removes the last page, i.e the top-most page of the app, and
  //  replaces it with the new page using the add method
  void replace(PyPathConfig newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  // Clears the entire navigation stack, i.e.
  // the _pages list, and adds all the new pages provided as the argument
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  // This is like the addPage, but
  // with a different name to be in sync with Flutter???s push and pop naming
  void push(PyPathConfig newRoute) {
    addPage(newRoute);
  }

  // Allows adding a new widget using the argument of type Widget.
  // This is what you???ll use for navigating to the Details page.
  void pushWidget(Widget child, PyPathConfig newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PyPathConfig> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  void replaceAll(PyPathConfig newRoute) {
    setNewRoutePath(newRoute);
  }

  // to record the action associated with the page.
  // The _setPageAction method will do that. Add:
  void _setPageAction(PageAction action) {
    switch (action.page.uiCtgr) {
      case Views.FeedCategory:
        feedPathConfig.currentPageAction = action;
        break;
      case Views.StoreCategory:
        storePathConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }
}
