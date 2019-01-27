import 'package:flutter/material.dart';
import 'package:flutter_localization/localizations.dart';

class DashboardPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Center(
          child: new Text(
            AppLocalizations.instance.text('page_one'),
            style: new TextStyle(
              fontSize: 22.00,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}