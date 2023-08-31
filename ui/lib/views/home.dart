import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizrd/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizrd/models/state.dart';
import 'package:quizrd/views/browse.dart';
import 'package:quizrd/views/create.dart';
import 'package:quizrd/views/play.dart';
import 'package:quizrd/views/settings.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var selectedIndex = 0;
  var selectedPageIndex = 0;
  Widget page = Placeholder();
  var appBarTitle = 'Quizrd';
  var appBarSeperator = ' | ';
  var appBarTitleExtended = 'AI Powered Infinite Trivia';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.getIdTokenResult().then((result) {
          appState.idToken = result.token;
        });
      }
    });

    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    switch (selectedPageIndex) {
      case -1:
        break;
      case 0:
        page = PlayPage();
        break;
      case 1:
        page = BrowsePage();
        break;
      case 2:
        page = CreatePage(quizId: "null");
        break;
      default:
        throw UnimplementedError('no widget for $selectedPageIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

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
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: icon,
              onPressed: () {
                setState(() {
                  selectedPageIndex = -1;
                  page = AuthPage();
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selectedPageIndex = -1;
                  page = SettingsPage();
                });
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
              setState(() {
                appBarSeperator = '';
                appBarTitleExtended = '';
              });
            });
          } else {
            Future.delayed(Duration.zero, () {
              setState(() {
                appBarSeperator = ' | ';
                appBarTitleExtended = 'AI Powered Infinite Trivia';
              });
            });
          }

          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.sports_esports),
                        label: 'Play',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.grid_view),
                        label: 'Browse',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle),
                        label: 'Create',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                        selectedPageIndex = value;
                        appState.cloneQuizId = '';
                        appState.editQuizId = '';
                      });
                    },
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
                        icon: Icon(Icons.sports_esports),
                        label: Text('Play'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.grid_view),
                        label: Text('Browse'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.add_circle),
                        label: Text('Create'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                        selectedPageIndex = value;
                        appState.cloneQuizId = '';
                        appState.editQuizId = '';
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: mainArea,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
