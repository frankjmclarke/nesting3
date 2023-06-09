import 'package:flutter/material.dart';
import 'package:flutter_starter/controllers/controllers.dart';
import 'package:flutter_starter/ui/ui.dart';
import 'package:get/get.dart';
import 'category_list_ui.dart';
import 'components/centered_text.dart';
import 'home_menu_ui.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _currentIndex = 1;
  bool isLoading = true;

  final List<Widget> _screens = [
    HomeMenuUI(),
    CategoryListUI(),//    CategoryListUI(),UrlListUI
    SettingsUI(),
  ];

  @override
  void initState() {
    super.initState();
    // Start the timeout mechanism
    startTimeout();
  }

  void startTimeout() {
    // Wait for 5 seconds, then set isLoading to false
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {//the widget is currently in the widget tree.
          isLoading = false;
        });
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (controller) {
        if (isLoading || controller.firestoreUser.value?.uid == null) {
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: CenteredText(text: 'Lining your nest...'),
            ),
          );
        } else {
          return Scaffold(
            body: _screens[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        }
      },
    );
  }

}
