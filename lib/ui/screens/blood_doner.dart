import 'package:challengers/service/firestore_provider.dart';
import 'package:challengers/service/secession.dart';
import 'package:challengers/models/user_model.dart';
import 'package:challengers/ui/screens/BloodLogin.dart';
import 'package:challengers/ui/screens/blood_profile.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodDonor extends StatefulWidget {
  @override
  _BloodDonorState createState() => _BloodDonorState();
}

class _BloodDonorState extends State<BloodDonor> {
  String number = '';
  bool index = true;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  List<UserModel> donors;
  String selectedValue = 'All';
  List blood = ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  getList() {
    if (donors == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else
      return Column(
        children: <Widget>[
          ListTile(
              leading: selectedValue != null
                  ? Text(
                      selectedValue,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Filter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  getUser();
                },
                itemBuilder: (BuildContext context) => blood
                    .map((b) => PopupMenuItem(
                          child: Text(b),
                          value: b,
                        ))
                    .toList(),
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (context, i) {
                  var donor = donors[i];
                  if (donors.length == 0) {
                    return Center(
                      child: Text(
                        'Oops No donors for this bloodgroup',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else
                    return GestureDetector(
                      onTap: () {
                        if (!Secession.login) {
                          showErrorDialog();
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BloodProfile(
                                        user_uid: donor.id,
                                      )));
                        }
                      },
                      child: Container(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10.0, 4.0, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Name:${donor.name}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    MdiIcons.water,
                                    size: 55,
                                    color: Colors.red.shade800,
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Contact: ${donor.contact}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 16),
                                    child: Text(
                                      ' ${donor.blood}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Location: ${donor.location}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Age: ${donor.age}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: InkWell(
                                        onTap: () {
                                          number = donor.contact;
                                          showCallDialog();
                                        },
                                        child: Icon(
                                          MdiIcons.phone,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        height: 120.0,
                        margin: EdgeInsets.only(top: 12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.red, Colors.teal]),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                      ),
                    );
                },
              ),
            ),
          ),
        ],
      );
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() {
    FirestoreProvider().getUsers(bloodGroup: selectedValue).then((document) {
      setState(() {
        donors = document;
      });
    });
  }

  showSnackbar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  showCallDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text(number, style: TextStyle(color: Colors.green)),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    _launchCaller(number);
                  },
                ),
              ],
              title: Text('Call Now'));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red[900],
        key: _scaffoldkey,
        appBar: AppBar(
          title: Text('Donors'),
          actions: <Widget>[
            IconButton(
              icon: Icon(index ? Icons.map : Icons.list),
              onPressed: () {
                setState(() {
                  index = !index;
                });
              },
            )
          ],
        ),
        body: getList()
//        body: index ? getList() : getMap()
        );
  }

  _launchCaller(String number) async {
    String tel = 'tel:$number';
    if (await canLaunch(tel)) {
      await launch(tel);
    } else {
      throw 'Could not launch $number';
    }
  }

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text('You must Login to continue !',
                  style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BloodLogin()));
                    }),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
              title: Text(
                'Oops',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
        });
  }
}
