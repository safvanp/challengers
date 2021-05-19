import 'package:challengers/service/firestore_provider.dart';
import 'package:challengers/models/user_model.dart';
import 'package:challengers/ui/screens/blood_base_screen.dart';
import 'package:challengers/ui/widgets/custom_text_field1.dart';
import 'package:flutter/material.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class EditBloodProfile extends StatefulWidget {
  EditBloodProfile({this.userModel});
  final UserModel userModel;

  @override
  _EditBloodProfileState createState() => _EditBloodProfileState();
}

class _EditBloodProfileState extends State<EditBloodProfile> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _user = TextEditingController();
  var _phone = TextEditingController();
  var _location = TextEditingController();
  var _age = TextEditingController();
  String selectedValue;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  String text = "Edit profile";
  bool index = true;
  bool isLoading = false;
  bool hiddenText = true;
  UserModel user = UserModel(
      id: "", name: "", blood: "", contact: "", location: "", email: "");
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
          child: Text(value,
              style: TextStyle(
                color: Colors.red,
              )),
        ),
      )
      .toList();

  void _update() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
    } else
      return;

    try {
      setState(() {
        isLoading = true;
      });

      await FirestoreProvider().updateUser(user);

      setState(() {
        index = true;
        isLoading = false;
      });
      Navigator.of(context).pop(context);
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackbar(err.message);
    }
  }

  showSnackbar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.userModel != null) {
      _user.text = widget.userModel.name;
      _phone.text = widget.userModel.contact;
      selectedValue = widget.userModel.blood;
      _location.text = widget.userModel.location;
      _age.text = widget.userModel.age;
//      setUser();
      user = widget.userModel;
    }
  }

//  setUser() async {
//    var userr = await FirebaseAuthProvider().getCurrentUser();
//    user.id = userr.uid;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff44130f),
      key: _scaffoldkey,
      resizeToAvoidBottomInset: false,
      body: BloodBaseScreen(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text(
                        text,
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                buildSignupForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSignupForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          CustomTextField1(
            textCapitalization: TextCapitalization.words,
            controller: _user,
            onSaved: (value) {
              user.name = value;
            },
            label: "Fullname",
            hint: "Ex: SAVAD.MM",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField1(
            controller: _phone,
            onSaved: (value) {
              user.contact = value;
            },
            onValidate: (value) {
              if (value.length != 10)
                return 'Phone Number must be of 10 digits';
              else if (value.isEmpty) return 'This field can\'t be empty';
            },
            label: 'Contact',
            hint: 'Ex:xxxxxxxxxx',
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: DropdownButtonFormField(
              value: selectedValue,
              hint: Text(
                'Blood Group',
                style: TextStyle(color: Colors.white),
              ),
              items: _bloodgroups,
              onChanged: ((String newvalue) {
                setState(() {
                  selectedValue = newvalue;
                  print(selectedValue);
                  user.blood = selectedValue;
                });
              }),
            ),
          ),
          SizedBox(height: 20),
          CustomTextField1(
            textCapitalization: TextCapitalization.words,
            controller: _location,
            onSaved: (value) {
              user.location = value;
            },
            label: "Location",
            hint: "Ex: VALLUVANGAD",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
          ),
          SizedBox(height: 20),
          CustomTextField1(
            textCapitalization: TextCapitalization.words,
            controller: _age,
            onSaved: (value) {
              user.age = value;
            },
            label: "Age",
            hint: "Ex: 20",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 90,
                child: ClipPolygon(
                  sides: 6,
                  rotate: 120,
                  borderRadius: 9.0,
                  child: Container(
                    color: Colors.red,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellow)))
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: _update,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
}
