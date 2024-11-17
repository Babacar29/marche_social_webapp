import 'package:marche_social_webapp/controllers/MenuAppController.dart';
import 'package:marche_social_webapp/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      //drawer: SideMenu(),
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
              flex: 9,
              child: DashboardScreen(),
            ),
          ],
        ),*/
      ),
    );
  }
}
