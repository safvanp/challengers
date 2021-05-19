import 'package:challengers/ui/screens/activity.dart';
import 'package:challengers/ui/screens/exercise_screen.dart';
import 'package:challengers/ui/screens/inout.dart';
import 'package:challengers/ui/screens/insideoutside.dart';
import 'package:challengers/ui/screens/main_screen.dart';
import 'package:challengers/ui/screens/nascarresults.dart';
import 'package:challengers/ui/screens/profile.dart';
import 'package:challengers/ui/screens/ready_screen.dart';
import 'package:challengers/ui/screens/report_screen.dart';
import 'package:challengers/ui/screens/reset_password_screen.dart';
import 'package:challengers/ui/screens/root_screen.dart';
import 'package:challengers/ui/screens/settings_screen.dart';
import 'package:challengers/ui/screens/sign_in_screen.dart';
import 'package:challengers/ui/screens/sign_up_screen.dart';
import 'package:challengers/ui/screens/soccerbasics_screen.dart';
import 'package:challengers/ui/screens/totalworkouts.dart';
import 'package:challengers/ui/screens/video_screen.dart';
import 'package:challengers/ui/screens/walk_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firestore.instance.settings(persistenceEnabled: true);
  // Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs: prefs));
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challengers',
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/walkthrough': (BuildContext context) => new WalkthroughScreen(),
        '/root': (BuildContext context) => new RootScreen(),
        '/signin': (BuildContext context) => new SignInScreen(),
        '/signup': (BuildContext context) => new SignUpScreen(),
        '/main': (BuildContext context) => new MainScreen(),
        '/soccerbasics': (BuildContext context) => new SoccerBasics(),
        '/exercise': (BuildContext context) => new Exercise(),
        '/report': (BuildContext context) => new Report(),
        '/resetpassword': (BuildContext context) => new ResetPassword(),
        '/ready': (BuildContext context) => new Ready(),
        '/settings': (BuildContext context) => new SettingsScreen(),
        '/video': (BuildContext context) => new VideoPlayerScreen(),
        '/activity': (BuildContext context) => new ActivityScreen(),
        '/insideoutside': (BuildContext context) => new InsideOutside(),
        '/nascarresults': (BuildContext context) => new NascarResultsScreen(),
        '/profile': (BuildContext context) => new ProfileScreen(),
        '/totalworkouts': (BuildContext context) => new TotalWorkouts(),
        '/inout': (BuildContext context) => new InOut(),
      },
      theme: ThemeData(
        primaryColor: Colors.white,
        // primarySwatch: Colors.grey,
        primarySwatch: Colors.green,
        accentColor: Colors.white,
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    // bool seen = (prefs.getBool('seen') ?? false);
    // if (true) {
    return new RootScreen();
    // } else {
    //   return new WalkthroughScreen(prefs: prefs);
    // }
  }
}
