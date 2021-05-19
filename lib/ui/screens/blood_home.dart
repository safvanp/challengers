import 'package:challengers/ui/screens/BloodLogin.dart';
import 'package:challengers/ui/screens/add_blood_user.dart';
import 'package:challengers/ui/screens/blood_doner.dart';
import 'package:challengers/service/secession.dart';
import 'package:flutter/material.dart';
import 'package:challengers/models/settings.dart';

class BloodHome extends StatefulWidget {
  Settings settings;
  BloodHome({this.settings});
  @override
  _BloodHomeState createState() => _BloodHomeState();
}

class _BloodHomeState extends State<BloodHome> {
  var _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  showSnackbar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.purple,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'Blood Book',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[SizedBox()],
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            // This is our main page
            children: <Widget>[
              Expanded(
                child: Material(
                  color: Colors.green.shade500,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BloodDonor()));
                    },
                    child: Center(
                      child: Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.white, width: 5.0)),
                        padding: new EdgeInsets.all(20.0),
                        child: Text('Need',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 3),
              Expanded(
                child: Material(
                  color: Colors.redAccent.shade400,
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBloodUser()));
                    },
                    child: Center(
                      child: Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.white, width: 5.0)),
                        padding: new EdgeInsets.all(20.0),
                        child: Text('Donate',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ),
                ),
              ),
              if (!Secession.login)
                InkWell(
                  onTap: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BloodLogin()));
                  },
                  child: Text('Login',
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)),
                ),
              if (Secession.login)
                InkWell(
                  onTap: () async {
                    Secession.login = false;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BloodLogin()));
                  },
                  child: Text('Logout',
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
