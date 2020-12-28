import 'package:flutter/material.dart';

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

class ResponsiveScaffoldState<T> extends State<ResponsiveScaffold<T>> {
  late final GlobalKey<NavigatorState> navKey;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late bool tabletMode;
  late T currentSelected;
  OverlayEntry? _shadowOverlay;

  @override
  void initState() {
    currentSelected = widget.homeId;
    navKey = widget.navKey ?? GlobalKey();
    super.initState();
  }

  void addShadowOverlay() {
    if (_shadowOverlay != null) return;
    // this is just a hacky way to construct a single "shadow-line"
    // that acts as a divider
    final overlay = OverlayEntry(
      builder: (ctx) => Positioned(
        left: drawerWidth,
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
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    goHome();
    final route = tabletMode
        ? PageRouteBuilder(
            pageBuilder: (_, __, ___) => content,
            transitionDuration: const Duration(),
            reverseTransitionDuration: const Duration())
        : MaterialPageRoute(
            builder: (context) => content,
          );
    navKey.currentState!.push(route);
    setState(() {
      currentSelected = data;
    });
  }

  void goHome() {
    navKey.currentState!.popUntil((route) => route.isFirst);
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
        } else {
          removeShadowOverlay();
        }
        final drawer = widget.drawerBuilder(
            selectContentWidget, goHome, currentSelected, tabletMode);
        return TabletMode(
          tabletMode,
          tabletMode
              ? Material(
                  child: Row(
                    children: [
                      IntrinsicWidth(
                        child: drawer != null ? Drawer(child: drawer) : null,
                      ),
                      Expanded(
                        child: _Body(
                          navKey: navKey,
                          child: widget.home,
                          navObserver: PopObserver(wentHome),
                        ),
                      ),
                    ],
                  ),
                )
              : Scaffold(
                  key: scaffoldKey,
                  drawer: drawer != null ? Drawer(child: drawer) : null,
                  body: _Body(
                    navKey: navKey,
                    child: widget.home,
                    navObserver: PopObserver(wentHome),
                  ),
                ),
        );
      },
    );
  }
}

class TabletMode extends InheritedWidget {
  final bool tabletMode;
  final Widget child;

  TabletMode(this.tabletMode, this.child) : super(child: child);

  static TabletMode? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabletMode>();
  }

  @override
  bool updateShouldNotify(TabletMode oldWidget) {
    return oldWidget.tabletMode != tabletMode;
  }
}

class _Body extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final Widget child;
  final NavigatorObserver navObserver;

  const _Body(
      {Key? key,
      required this.navKey,
      required this.child,
      required this.navObserver})
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
                  return child;
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
typedef DrawerBuilder<T> = Widget? Function(WidgetSelectedCallback<T>,
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
    final tabletMode = TabletMode.of(context)?.tabletMode ?? false;
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
