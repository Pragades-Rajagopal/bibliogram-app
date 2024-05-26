import 'package:bibliogram_app/presentations/app_screens/pages/global.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/my_activities.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:bibliogram_app/presentations/utils/themes.dart';
import 'package:flutter/material.dart';

class AppBasePage extends StatefulWidget {
  const AppBasePage({super.key});

  @override
  State<AppBasePage> createState() => _AppBasePageState();
}

class _AppBasePageState extends State<AppBasePage> {
  late PageController _pageController = PageController();
  var _currentIndex = 0;

  // App pages as widgets
  static final List<Widget> _widget = [
    const GlobalAppPage(),
    const GlobalAppPage(),
    const MyActivitiesPage(),
    const GlobalAppPage(),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentIndex = 0;
      _pageController = PageController(initialPage: _currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      // extendBodyBehindAppBar: true,
      body: PageView(
        physics: const BouncingScrollPhysics(),
        controller: _pageController,
        children: _widget,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          textTheme: textTheme,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
          iconSize: 26.0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14.0,
          unselectedFontSize: 14.0,
          items: bottomNavBar,
        ),
      ),
    );
  }
}
