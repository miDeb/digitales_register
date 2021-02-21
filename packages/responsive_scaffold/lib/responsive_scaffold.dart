library responsive_scaffold;

import 'package:flutter/material.dart' hide SizeTransition;
import 'package:flutter/scheduler.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:responsive_scaffold/size_transition.dart';

const tabletLayoutBreakpoint = 720.0;
const drawerWidth = 304.0;

class _PopObserver extends NavigatorObserver {
  final VoidCallback onReturnedToRoot;

  _PopObserver(this.onReturnedToRoot);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.isFirst == true) {
      onReturnedToRoot();
    }
  }
}

/// A widget that provides a responsive scaffold implementation.
///
/// Concepts:
/// - There is one home page, and zero or more sub pages.
/// - On mobile, the drawer can be opened by tapping on the hamburger menu on
///   the home page, where a sub page can be selected to navigate to. Navigating
///   back is possible by tapping the back button in the AppBar of each sub
///   page. The home page is not shown in the drawer.
/// - On tablets, the drawer is always expanded on the side. Sub pages and the
///   home page are listed in the sidebar. After navigating to a sub page, it is
///   possible to navigate back to the main page by selecting it in the sidebar.
///
/// Usage:
/// Replace the scaffold on the home page with this widget. This widget is
/// generic over the id associated to each page. To select a sub page, i.e. make
/// this widget push it to its internal navigator, either use the
/// [WidgetSelectedCallback] passed to the [drawerBuilder], or obtain the
/// enclosing instance of the [ResponsiveScaffoldState] by calling
/// [ResponsiveScaffold.of(context)] and call
/// [ResponsiveScaffoldState.selectContentWidget]. Similarly, to select the home
///  page, either call the callback passed to [drawerBuilder] or
/// [ResponsiveScaffoldState.goHome].
/// Make sure to handle back presses correctly! See the example for an example.
class ResponsiveScaffold<T> extends StatefulWidget {
  /// Similar to [Scaffold.body].
  /// Specifies the body of the home page.
  final Widget homeBody;

  /// Similar to [Scaffold.appBar].
  /// Specifies the appBar of the home page.
  final PreferredSizeWidget homeAppBar;

  /// Similar to [Scaffold.floatingActionButton].
  /// Specifies the floatingActionButton of the home page.
  final Widget? homeFloatingActionButton;

  /// The id of the home page
  final T homeId;

  /// [DrawerBuilder] callback.
  final DrawerBuilder<T> drawerBuilder;

  /// The navigator key that will be used for the internal navigator.
  /// As back events will be fired to the root navigator, you have to intercept
  /// them and pass them to this navigator manually.
  final GlobalKey<NavigatorState> navKey;

  const ResponsiveScaffold({
    Key? key,
    required this.homeBody,
    required this.drawerBuilder,
    required this.homeId,
    required this.navKey,
    required this.homeAppBar,
    this.homeFloatingActionButton,
  }) : super(key: key);

  @override
  ResponsiveScaffoldState<T> createState() => ResponsiveScaffoldState<T>();

  ResponsiveScaffoldState<T>? of(BuildContext context) {
    return context.findAncestorStateOfType<ResponsiveScaffoldState<T>>();
  }
}

class ResponsiveScaffoldState<T> extends State<ResponsiveScaffold<T>>
    with SingleTickerProviderStateMixin {
  late final GlobalKey<NavigatorState> navigatorKey;

  late final AnimationController _drawerAnimationController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late bool tabletMode;
  // This is required in order not to show an opening animation
  // right when the app is opened
  bool isInitialized = false;
  late T currentSelected;

  @override
  void initState() {
    currentSelected = widget.homeId;
    navigatorKey = widget.navKey;
    _drawerAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    super.initState();
  }

  void closeDrawerIfOpen() {
    if (scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
  }

  /// Pushes [content] to the body of the scaffold, associating [data] with it.
  void selectContentWidget(Widget content, T data) {
    closeDrawerIfOpen();
    final route = tabletMode
        ? PageRouteBuilder(
            settings: RouteSettings(arguments: data),
            pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
              opacity: animation,
              child: content,
            ),
            transitionDuration: const Duration(milliseconds: 250),
            reverseTransitionDuration: const Duration(milliseconds: 250),
          )
        : MaterialPageRoute(
            settings: RouteSettings(arguments: data),
            builder: (context) => content,
          );
    // Make sure that there are no other routes pushed on our navigator
    navigatorKey.currentState!
        .popUntil((route) => route.settings.arguments == currentSelected);
    if (currentSelected == widget.homeId) {
      navigatorKey.currentState!.push(route);
    } else {
      navigatorKey.currentState!.pushReplacement(route);
    }
    setState(() {
      currentSelected = data;
    });
  }

  /// Pops all routes and resets the body of this scaffold to [widget.homeBody].
  /// [currentSelected] will be accordingly set to [widget.homeId].
  void goHome() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    _wentHome();
  }

  void _wentHome() {
    setState(() {
      currentSelected = widget.homeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool? previousTabletMode;
    return Portal(
      child: LayoutBuilder(
        builder: (context, constraints) {
          tabletMode = constraints.maxWidth > tabletLayoutBreakpoint;
          if (tabletMode != previousTabletMode) {
            if (tabletMode) {
              if (isInitialized) {
                if (_drawerAnimationController.value != 1) {
                  _drawerAnimationController.fling();
                }
              } else {
                _drawerAnimationController.value = 1;
              }
            } else if (_drawerAnimationController.value != 0) {
              _drawerAnimationController.fling(velocity: -1);
            }
          }
          previousTabletMode = tabletMode;
          isInitialized = true;
          return _InheritedTabletMode(
            tabletMode: tabletMode,
            child: _InheritedHomePage(
              fab: widget.homeFloatingActionButton,
              scaffoldKey: scaffoldKey,
              body: widget.homeBody,
              appBar: widget.homeAppBar,
              drawer: !tabletMode
                  ? widget.drawerBuilder(
                      selectContentWidget, goHome, currentSelected, false)
                  : null,
              child: Material(
                child: Row(
                  children: [
                    SizeTransition(
                      axis: Axis.horizontal,
                      sizeFactor: _drawerAnimationController,
                      axisAlignment: 1,
                      child: _Drawer(
                        drawerAnimationController: _drawerAnimationController,
                        child: widget.drawerBuilder(
                            selectContentWidget, goHome, currentSelected, true),
                      ),
                    ),
                    Expanded(
                      child: _Body<T>(
                        navKey: navigatorKey,
                        navObserver: _PopObserver(_wentHome),
                        homeId: widget.homeId,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Drawer extends StatefulWidget {
  const _Drawer({
    Key? key,
    required AnimationController drawerAnimationController,
    required this.child,
  })   : _drawerAnimationController = drawerAnimationController,
        super(key: key);

  final AnimationController _drawerAnimationController;
  final Widget child;

  @override
  __DrawerState createState() => __DrawerState();
}

class __DrawerState extends State<_Drawer> {
  late bool visible;
  @override
  void initState() {
    widget._drawerAnimationController.addStatusListener((status) {
      final shouldBeVisible = status != AnimationStatus.dismissed;
      if (shouldBeVisible != visible && mounted) {
        setState(() {
          visible = shouldBeVisible;
        });
      }
    });
    visible =
        widget._drawerAnimationController.status != AnimationStatus.dismissed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: visible,
      portalAnchor: Alignment.topLeft,
      childAnchor: Alignment.topRight,
      // The following is a hacky way to draw a shadow divider
      portal: Stack(
        children: [
          Positioned(
            left: 0,
            top: -4,
            bottom: -4,
            child: ClipRect(
              child: Container(
                width: 5,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(-7, 0),
                      blurRadius: 4,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      child: widget.child,
    );
  }
}

class _InheritedTabletMode extends InheritedWidget {
  final bool tabletMode;

  const _InheritedTabletMode({required this.tabletMode, required Widget child})
      : super(child: child);

  static _InheritedTabletMode? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedTabletMode>();
  }

  @override
  bool updateShouldNotify(_InheritedTabletMode oldWidget) {
    return oldWidget.tabletMode != tabletMode;
  }
}

class _InheritedHomePage extends InheritedWidget {
  final Widget body;
  final Widget? drawer;
  final PreferredSizeWidget appBar;
  final Widget? fab;
  final Key scaffoldKey;

  const _InheritedHomePage({
    required this.body,
    required Widget child,
    required this.appBar,
    required this.drawer,
    required this.scaffoldKey,
    this.fab,
  }) : super(child: child);

  static _InheritedHomePage? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedHomePage>();
  }

  @override
  bool updateShouldNotify(_InheritedHomePage oldWidget) {
    // Comparing the widgets this class holds is not meaningful because they'd
    // have to be the exact same objects to compare equal.
    return true;
  }
}

class _Body<T> extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final NavigatorObserver navObserver;
  final T homeId;

  const _Body(
      {Key? key,
      required this.navKey,
      required this.navObserver,
      required this.homeId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Navigator(
        observers: [navObserver],
        key: navKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case "/":
              return MaterialPageRoute(
                settings: RouteSettings(arguments: homeId),
                builder: (context) {
                  return _HomePage();
                },
              );
          }
        },
      ),
    );
  }
}

typedef WidgetSelectedCallback<T> = void Function(Widget content, T data);
typedef DrawerBuilder<T> = Widget Function(
  WidgetSelectedCallback<T>,
  VoidCallback goHome,
  T currentSelected,
  bool tabletMode,
);

/// An Appbar that will not show a back button if not appropriate.
///
/// The back button will not be shown if we are in tablet mode.
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const ResponsiveAppBar({Key? key, required this.title, this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tabletMode = _InheritedTabletMode.of(context)?.tabletMode ?? false;
    return AppBar(
      actions: actions,
      title: title,
      automaticallyImplyLeading: !tabletMode,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widgets = _InheritedHomePage.of(context)!;
    return Scaffold(
      appBar: widgets.appBar,
      drawer: widgets.drawer,
      body: widgets.body,
      key: widgets.scaffoldKey,
      floatingActionButton: widgets.fab,
    );
  }
}
