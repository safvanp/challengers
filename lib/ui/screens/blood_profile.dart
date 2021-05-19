import 'package:challengers/service/firestore_provider.dart';
import 'package:challengers/models/user_model.dart';
import 'package:challengers/ui/screens/blood_base_screen.dart';
import 'package:challengers/ui/screens/blood_home.dart';
import 'package:challengers/ui/screens/edit_blood_profile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BloodProfile extends StatefulWidget {
  BloodProfile({this.user_uid});
  final String user_uid;
  @override
  _BloodProfileState createState() => _BloodProfileState();
}

class _BloodProfileState extends State<BloodProfile>
    with SingleTickerProviderStateMixin {
  UserModel donor;
  Animation<double> animation;
  AnimationController animaitonController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    FirestoreProvider().getUser(widget.user_uid).then((d) {
      setState(() {
        donor = d;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : BloodBaseScreen(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(context);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    MdiIcons.deleteForever,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => showConfirmationDialog(
                                      title: 'Are you sure ?',
                                      body: 'You will no longer be donor',
                                      onYes: () async {
                                        FirestoreProvider().delete(donor.id);

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BloodHome()),
                                                (predicate) => false);
                                      })),
                              IconButton(
                                icon: Icon(
                                  MdiIcons.accountEdit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditBloodProfile(
                                                userModel: donor,
                                              )));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Your Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic)),
                            SizedBox(width: 0.0, height: 0.0),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(14),
                                child: Text(
                                  'Name: ${donor.name}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      // fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'Phone: ${donor.contact}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 17),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(14),
                                child: Text(
                                  'Location: ${donor.location}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      // fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(14),
                                child: Text(
                                  'Age: ${donor.age}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      // fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    // color: Colors.green,
                                    child: Icon(
                                      MdiIcons.water,
                                      color: Colors.red.shade700,
                                      size: 130,
                                    ),
                                  ),
                                  Text(
                                    '${donor.blood}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  showConfirmationDialog({
    String title,
    String body,
    VoidCallback onYes,
  }) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(title: Text(title), content: Text(body), actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "No",
                style: TextStyle(color: Colors.green),
              ),
            ),
            FlatButton(
              onPressed: onYes,
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ]);
        });
  }
}
