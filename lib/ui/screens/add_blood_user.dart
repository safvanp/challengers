import 'package:challengers/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:challengers/service/firestore_provider.dart';

class AddBloodUser extends StatefulWidget {
  @override
  _AddBloodUserState createState() => _AddBloodUserState();
}

class _AddBloodUserState extends State<AddBloodUser> {
  String selectedvalue;
  bool isLoading = false;
  UserModel user = UserModel(
      id: "",
      name: "",
      age: "",
      blood: "",
      contact: "",
      email: "",
      location: "");
  static const blood = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  final List<DropdownMenuItem<String>> _bloodgroups = blood
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Donate blood save life')),
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
//                      CircleAvatar(
//                        radius: 40,
//                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            user.name = value;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            hintText: 'Enter your name',
                            filled: true),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            user.age = value;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.nature_people),
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                            hintText: 'Enter your age',
                            filled: true),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            prefixIcon: Icon(MdiIcons.water)),
                        value: selectedvalue,
                        hint: Text('Blood Group'),
                        items: _bloodgroups,
                        onChanged: ((String newvalue) {
                          setState(() {
                            selectedvalue = newvalue;

                            user.blood = selectedvalue;
                          });
                        }),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            user.location = value;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                            labelText: 'Location',
                            hintText: 'Enter your location',
                            filled: true),
                      ),
//                      Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(color: Colors.grey),
//                          color: Colors.grey.shade100,
//                        ),
//                        height: 55,
//                        child: RaisedButton(
//                          child: Row(
//                            children: <Widget>[
//                              Icon(Icons.location_on),
//                              Text(locationName)
//                            ],
//                          ),
//                          onPressed: () async {
////                        var loc = await Navigator.push(context,
////                            MaterialPageRoute(builder: (context) => Maps()));
////                        if (loc != null) {
////                          setState(() {
////                            locationName = "${loc.latitude},${loc.longitude}";
////                          });
////                          user.latitude = loc.latitude;
////                          user.longitude = loc.longitude;
////                        }
//                          },
//                        ),
//                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            user.contact = value;
                          });
                        },
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            prefixText: '+91',
                            labelText: 'Contact',
                            hintText: 'xxxxxxxxxx',
                            filled: true),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        child: RaisedButton(
                          color: Colors.red.shade900,
                          child: isLoading
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                )
                              : Text(
                                  'Donate',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () async {
                            if (user.name.isNotEmpty &&
                                user.age.isNotEmpty &&
                                user.blood.isNotEmpty &&
                                user.contact.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              FirestoreProvider()
                                  .addUser(user)
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
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text('Details submitted',
                  style: TextStyle(color: Colors.green)),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Success'));
        });
  }
}
