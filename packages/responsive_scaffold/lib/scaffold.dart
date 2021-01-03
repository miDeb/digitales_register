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
  final Widget home;
  final DrawerBuilder<T> drawerBuilder;
  final T homeId;
  final GlobalKey<NavigatorState>? navKey;

  ResponsiveScaffold({
    Key? key,
    required this.home,
    required this.drawerBuilder,
    required this.homeId,
    this.navKey,
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
      Navigator.pop(context);
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
          InheritedWidgetWidget(
            widget.home,
            Material(
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
                      child: Scaffold(
                        key: scaffoldKey,
                        drawer: !tabletMode
                            ? widget.drawerBuilder(selectContentWidget, goHome,
                                currentSelected, false)
                            : null,
                        body: _Body(
                          navKey: navigatorKey,
                          navObserver: PopObserver(wentHome),
                        ),
                        drawerEnableOpenDragGesture:
                            currentSelected == widget.homeId,
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

class InheritedWidgetWidget extends InheritedWidget {
  final Widget widget;
  final Widget child;

  InheritedWidgetWidget(this.widget, this.child) : super(child: child);

  static InheritedWidgetWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedWidgetWidget>();
  }

  @override
  bool updateShouldNotify(InheritedWidgetWidget oldWidget) {
    return oldWidget.widget != widget;
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
      leading: isHomePage && !tabletMode
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => context
                  .findAncestorStateOfType<ResponsiveScaffoldState>()
                  ?.scaffoldKey
                  .currentState
                  ?.openDrawer())
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InheritedWidgetWidget.of(context)!.widget;
  }
}
