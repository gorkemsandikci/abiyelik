import 'package:flutter/material.dart';
import 'package:abiyelik/bottom_navigation.dart';
import 'package:abiyelik/tab_item.dart';
import 'package:abiyelik/tab_navigator.dart';
import 'KategoriListesi.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  var _currentTab = TabItem.anasayfa;
  final _navigatorKeys = {
    TabItem.anasayfa: GlobalKey<NavigatorState>(),
    TabItem.kategoriler: GlobalKey<NavigatorState>(),
    TabItem.favoriler: GlobalKey<NavigatorState>(),
    TabItem.sepetim: GlobalKey<NavigatorState>(),
    TabItem.hesabim: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.anasayfa) {
            // select 'main' tab
            _selectTab(TabItem.anasayfa);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.anasayfa),
          kategoriler(TabItem.kategoriler),
          _buildOffstageNavigator(TabItem.favoriler),
          _buildOffstageNavigator(TabItem.sepetim),
          _buildOffstageNavigator(TabItem.hesabim),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  Widget kategoriler(TabItem tabItem){
    return Offstage(
      offstage: _currentTab != tabItem,
        child: Center(
            child: KategoriListesi(),
        ),
    );
  }

}
