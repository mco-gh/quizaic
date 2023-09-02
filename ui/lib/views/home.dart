import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizrd/models/state.dart';
import 'package:quizrd/views/browse.dart';
import 'package:quizrd/views/create.dart';
import 'package:quizrd/views/play.dart';
import 'package:quizrd/views/host.dart';
import 'package:quizrd/views/settings.dart';
import 'package:quizrd/auth/auth.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class HomePage extends StatefulWidget {
  HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final GoRouter _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/browse',
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return HomePageScaffold(
              child: child,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/browse',
              builder: (BuildContext context, GoRouterState state) {
                return BrowsePage();
              },
            ),
            GoRoute(
              path: '/edit',
              builder: (BuildContext context, GoRouterState state) {
                return CreatePage(quizId: '');
              },
            ),
            GoRoute(
              path: '/clone',
              builder: (BuildContext context, GoRouterState state) {
                return CreatePage(quizId: '');
              },
            ),
            GoRoute(
              path: '/host',
              builder: (BuildContext context, GoRouterState state) {
                return HostPage(quizId: '');
              },
            ),
            GoRoute(
                path: '/create',
                builder: (BuildContext context, GoRouterState state) {
                  return CreatePage(
                    quizId: '',
                  );
                }),
            GoRoute(
                path: '/play',
                builder: (BuildContext context, GoRouterState state) {
                  return PlayPage();
                }),
            GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingsPage();
                }),
            GoRoute(
                path: '/login',
                builder: (BuildContext context, GoRouterState state) {
                  return AuthPage();
                }),
          ],
        )
      ]);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    FirebaseAuth.instance.authStateChanges().listen((event) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((result) {
          appState.idToken = result.token;
        });
      }
    });

    return MaterialApp.router(
      theme: theme,
      routerConfig: _router,
    );
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class HomePageScaffold extends StatelessWidget {
  /// Constructs an [HomePageScaffold].
  HomePageScaffold({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

// The container for the current page, with its background color

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var appBarTitle = 'Quizrd';
    var appBarSeperator = ' | ';
    var appBarTitleExtended = 'AI Powered Infinite Trivia';

    var appBarTextStyle = theme.textTheme.titleLarge!.copyWith(
      color: colorScheme.onPrimary,
      fontSize: 25,
      fontWeight: FontWeight.w500,
    );

    dynamic icon = Icon(Icons.person, color: Colors.white);
    if (appState.photoUrl != '') {
      icon = Image.network(appState.photoUrl, height: 40, headers: {
        "corsImageModified.crossOrigin": "Anonymous",
        "corsImageModified.src": '${appState.photoUrl}?not-from-cache-please',
        'referrerpolicy': 'no-referrer'
      });
    }

    return Scaffold(
        //body: child,
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: icon,
                onPressed: () {
                  //setState(() {
                  //appState.selectedPageIndex = -1;
                  //page = AuthPage();
                  //});
                  GoRouter.of(context).go('/login');
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  GoRouter.of(context).go('/settings');
                  //setState(() {
                  //appState.selectedPageIndex = -1;
                  //page = SettingsPage();
                  //});
                },
              )
            ],
            backgroundColor: Color(0xfff68d2d),
            centerTitle: false,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/quizrd_logo.png',
                  height: 40,
                ),
                Row(
                  children: [
                    Text(
                      appBarTitle,
                      style: appBarTextStyle,
                    ),
                    Text(
                      appBarSeperator,
                      style: appBarTextStyle,
                    ),
                    Text(
                      appBarTitleExtended,
                      style: appBarTextStyle,
                    ),
                  ],
                ),
              ],
            )),
        drawer: Drawer(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              Future.delayed(Duration.zero, () {
                //setState(() {
                appBarSeperator = '';
                appBarTitleExtended = '';
                //});
              });
            } else {
              Future.delayed(Duration.zero, () {
                //setState(() {
                appBarSeperator = ' | ';
                appBarTitleExtended = 'AI Powered Infinite Trivia';
                //});
              });
            }

            if (constraints.maxWidth < 450) {
              // Use a more mobile-friendly layout with BottomNavigationBar
              // on narrow screens.
              return Column(
                children: [
                  Expanded(
                      child: ColoredBox(
                    color: colorScheme.surfaceVariant,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: child,
                    ),
                  )),
                  SafeArea(
                    child: BottomNavigationBar(
                      currentIndex: _calculateSelectedIndex(context),
                      onTap: (int idx) => _onItemSelected(idx, context),
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.grid_view),
                          label: 'Browse',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.add_circle),
                          label: 'Create',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.sports_esports),
                          label: 'Play',
                        ),
                      ],
                      //currentIndex: appState.selectedIndex,
                      //onTap: (value) {
                      //setState(() {
                      //appState.selectedIndex = value;
                      //appState.selectedPageIndex = value;
                      //appState.cloneQuizId = '';
                      //appState.hostQuizId = '';
                      //appState.editQuizId = '';
                      //});
                      //},
                    ),
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  SafeArea(
                    child: NavigationRail(
                      minWidth: 70,
                      minExtendedWidth: 150,
                      extended: constraints.maxWidth >= 600,
                      destinations: [
                        NavigationRailDestination(
                          icon: Icon(Icons.grid_view),
                          label: Text('Browse'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.add_circle),
                          label: Text('Create'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.sports_esports),
                          label: Text('Play'),
                        ),
                      ],
                      //selectedIndex: appState.selectedIndex,
                      selectedIndex: _calculateSelectedIndex(context),
                      onDestinationSelected: (int idx) =>
                          _onItemSelected(idx, context),
                      //(value) {
                      //setState(() {
                      //appState.selectedIndex = value;
                      //appState.selectedPageIndex = value;
                      //appState.cloneQuizId = '';
                      //appState.hostQuizId = '';
                      //appState.editQuizId = '';
                      //});
                      //},
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: ColoredBox(
                      color: colorScheme.surfaceVariant,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: child,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ));
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/browse')) {
      return 0;
    }
    if (location.startsWith('/create')) {
      return 1;
    }
    if (location.startsWith('/play')) {
      return 2;
    }
    return 0;
  }

  void _onItemSelected(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/browse');
        break;
      case 1:
        GoRouter.of(context).go('/create');
        break;
      case 2:
        GoRouter.of(context).go('/play');
        break;
    }
  }
}
