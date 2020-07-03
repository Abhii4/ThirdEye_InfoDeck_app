import 'package:flutter/material.dart';
import 'package:infodeck/root_page.dart';

import 'auth/auth.dart';
import 'auth/authProvider.dart';


class Main2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        home: RootPage(),
      ),
    );
  }
}
