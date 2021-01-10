import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const tabletLayoutBreakpoint = 720.0;
const drawerWidth = 304.0;

class PopObserver extends NavigatorObserver {
  final VoidCallback onReturnedToRoot;

  PopObserver(this.onReturnedToRoot);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.isFirst == true) {
      onReturnedToRoot();
    }
  }
}

class ResponsiveScaffold<T> extends StatefulWidget {
  final Widget homeBody;
  final PreferredSizeWidget homeAppBar;
  final Widget? homeFloatingActionButton;
  final T homeId;
  final DrawerBuilder<T> drawerBuilder;
  final GlobalKey<NavigatorState>? navKey;

  ResponsiveScaffold({
    Key? key,
    required this.homeBody,
    required this.drawerBuilder,
    required this.homeId,
    this.navKey,
    required this.homeAppBar,
    this.homeFloatingActionButton,
  }) : super(key: key);

  @override
  ResponsiveScaffoldState<T> createState() => ResponsiveScaffoldState<T>();
}

class ResponsiveScaffoldState<T> extends State<ResponsiveScaffold<T>>
    with SingleTickerProviderStateMixin {
  late final GlobalKey<NavigatorState> navigatorKey;
  final LayerLink _shadowDividerOverlayLink = LayerLink();

  late final AnimationController _drawerAnimationController;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late bool tabletMode;
  // This is required in order not to show an opening animation
  // right when the app is opened
  bool isInitialized = false;
  late T currentSelected;
  OverlayEntry? _shadowOverlay;

  @override
  void initState() {
    currentSelected = widget.homeId;
    navigatorKey = widget.navKey ?? GlobalKey();
    _drawerAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    super.initState();
  }

  void addShadowOverlay() {
    if (_shadowOverlay != null) return;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // this is just a hacky way to construct a single "shadow-line"
      // that acts as a divider
      final overlay = OverlayEntry(
        builder: (ctx) => CompositedTransformFollower(
          link: _shadowDividerOverlayLink,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: -4,
                bottom: -4,
                child: ClipRect(
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-7, 0),
                          spreadRadius: 0,
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      Overlay.of(context)!.insert(
        overlay,
      );
      _shadowOverlay = overlay;
    });
  }

  void removeShadowOverlay() {
    _shadowOverlay?.remove();
    _shadowOverlay = null;
  }

  void selectContentWidget(Widget content, T data) {
    if (scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(scaffoldKey.currentContext!).pop();
    }
    final route = tabletMode
        ? PageRouteBuilder(
            pageBuilder: (_, animation, secondaryAnimation) => FadeTransition(
              opacity: animation,
              child: content,
            ),
            transitionDuration: Duration(milliseconds: 250),
            reverseTransitionDuration: Duration(milliseconds: 250),
          )
        : MaterialPageRoute(
            builder: (context) => content,
          );
    if (currentSelected == widget.homeId) {
      navigatorKey.currentState!.push(route);
    } else {
      navigatorKey.currentState!.pushReplacement(route);
    }
    setState(() {
      currentSelected = data;
    });
  }

  void goHome() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    wentHome();
  }

  void wentHome() {
    setState(() {
      currentSelected = widget.homeId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        tabletMode = constraints.maxWidth > tabletLayoutBreakpoint;
        if (tabletMode) {
          addShadowOverlay();
          if (isInitialized) {
            _drawerAnimationController.fling(velocity: 1);
          } else {
            _drawerAnimationController.value = 1;
          }
        } else {
          _drawerAnimationController
              .fling(velocity: -1)
              .whenComplete(() => removeShadowOverlay());
        }
        isInitialized = true;
        return InheritedTabletMode(
          tabletMode,
          InheritedHomePage(
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
                    child: widget.drawerBuilder(
                        selectContentWidget, goHome, currentSelected, true),
                  ),
                  Expanded(
                    child: CompositedTransformTarget(
                      link: _shadowDividerOverlayLink,
                      child: _Body(
                        navKey: navigatorKey,
                        navObserver: PopObserver(wentHome),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InheritedTabletMode extends InheritedWidget {
  final bool tabletMode;
  final Widget child;

  InheritedTabletMode(this.tabletMode, this.child) : super(child: child);

  static InheritedTabletMode? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedTabletMode>();
  }

  @override
  bool updateShouldNotify(InheritedTabletMode oldWidget) {
    return oldWidget.tabletMode != tabletMode;
  }
}

class InheritedHomePage extends InheritedWidget {
  final Widget body;
  final Widget? drawer;
  final PreferredSizeWidget appBar;
  final Widget? fab;
  final Widget child;
  final Key scaffoldKey;

  InheritedHomePage({
    required this.body,
    required this.child,
    required this.appBar,
    required this.drawer,
    required this.scaffoldKey,
    this.fab,
  }) : super(child: child);

  static InheritedHomePage? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHomePage>();
  }

  @override
  bool updateShouldNotify(InheritedHomePage oldWidget) {
    // Comparing the widgets this class holds is not meaningful because they'd
    // have to be the exact same objects to compare equal.
    return true;
  }
}

class _Body extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final NavigatorObserver navObserver;

  const _Body({Key? key, required this.navKey, required this.navObserver})
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

typedef WidgetSelectedCallback<T> = void Function(Widget, T);
typedef GoHomeCallback<T> = void Function(T);
typedef DrawerBuilder<T> = Widget Function(WidgetSelectedCallback<T>,
    VoidCallback goHome, T currentSelected, bool tabletMode);

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final bool isHomePage;

  ResponsiveAppBar(
      {Key? key, required this.title, this.isHomePage = false, this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final tabletMode = InheritedTabletMode.of(context)?.tabletMode ?? false;
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
    final widgets = InheritedHomePage.of(context)!;
    return Scaffold(
      appBar: widgets.appBar,
      drawer: widgets.drawer,
      body: widgets.body,
      key: widgets.scaffoldKey,
      floatingActionButton: widgets.fab,
    );
  }
}
