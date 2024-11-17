import 'package:marche_social_webapp/core/constants/color_constants.dart';

import 'package:marche_social_webapp/screens/dashboard/components/recent_users.dart';
import 'package:flutter/material.dart';

import 'components/header.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
          child: ListView(
            //padding: EdgeInsets.all(defaultPadding),
            //scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  const Header(),
                  //SizedBox(height: defaultPadding),
                  //MiniInformation(),
                  SizedBox(height: defaultPadding),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 1.5,
                    height: MediaQuery.sizeOf(context).height/2,
                    child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: RecentUsers()
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
