import 'package:marche_social_webapp/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //key: context.read<MenuController>().scaffoldKey,
      //drawer: SideMenu(),
      //backgroundColor: bgColor,
      body: SafeArea(
        child: DashboardScreen()
        /*Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),*/
      ),
    );
  }
}
