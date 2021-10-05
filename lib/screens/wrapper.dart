import 'package:flutter/material.dart';
import 'package:pick_a_pill_pub/authenticate/authenticate.dart';
import 'package:pick_a_pill_pub/models/fire_user.dart';

import 'package:provider/provider.dart';
import 'home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FireUser>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
