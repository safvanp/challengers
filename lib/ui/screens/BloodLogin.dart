import 'package:challengers/service/firestore_provider.dart';
import 'package:challengers/service/secession.dart';
import 'package:challengers/ui/screens/blood_home.dart';
import 'package:flutter/material.dart';
import 'package:challengers/models/admin_model.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BloodLogin extends StatefulWidget {
  @override
  _BloodLoginState createState() => _BloodLoginState();
}

class _BloodLoginState extends State<BloodLogin> {
  bool isLoading = false;
  AdminModel admin = AdminModel(name: "", password: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Donate blood save life')),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
//                  CircleAvatar(
//                    radius: 40,
//                  ),
                  Center(
                    child: Icon(
                      MdiIcons.water,
                      size: 70,
                      color: Colors.red.shade800,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        admin.name = value;
                      });
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        labelText: 'UserName',
                        hintText: 'Enter username',
                        filled: true),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        admin.password = value;
                      });
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter password',
                        filled: true),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.red.shade900,
                      child: isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                      onPressed: () async {
                        if (admin.name.isNotEmpty &&
                            admin.password.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          FirestoreProvider()
                              .getAdmins(admin.name)
                              .then((response) => {
                                    setState(() {
                                      isLoading = false;
                                    }),
                                    showSuccessDialog()
                                  });
                        } else {
                          showErrorDialog();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content:
                  Text('Enter the fields', style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Error'));
        });
  }

  showSuccessDialog() {
    Secession.login = true;
    if (Secession.login) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BloodHome()));
    } else {
      showErrorDialog1();
    }
  }

  showErrorDialog1() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text('Something went wrong',
                  style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Error Login failed'));
        });
  }
}
