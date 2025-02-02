import 'package:cook_chef/Screens/Account/AccountSettings.dart';
import 'package:cook_chef/Screens/UploadPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountPage extends StatefulWidget {
  static const String id = 'account_page';
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String name, imageUrl, bio;
  Future<void> gettingInfos() async {
    DocumentSnapshot documentSnapshot;
    String uid = FirebaseAuth.instance.currentUser.uid;
    try {
      documentSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      name = documentSnapshot.data()['username'];
      bio = documentSnapshot.data()['bio'];
      imageUrl = documentSnapshot.data()['imageLink'];
      print(documentSnapshot.data());
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    gettingInfos();
  }

  Container _createPost(
      {String name, String time, String description, Image image}) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 30,
              ),
              SizedBox(
                width: 6.0,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name),
                    Text(time),
                  ],
                ),
              ),
              Icon(Icons.more_horiz),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(description),
          SizedBox(
            height: 10.0,
          ),
          image,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.width;
    //gettingInfos();
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await gettingInfos();

          setState(() {});
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.all(8.0),
                  //   child: Text('account_name'),
                  // ),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Column(
                    children: <Widget>[
                      if (imageUrl != null)
                        CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: _width * 0.15,
                        ),
                      if (name != null)
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: _height * 0.02),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: _height * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (bio != null) Text('$bio'),
                      Container(
                        margin: EdgeInsets.only(top: _height * 0.02),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffC1C1C1)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(_width * 0.05)),
                          color: Color(0xffD7D7D7),
                        ),
                        width: _width * 0.9,
                        height: _height * 0.1,
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AccountSettings.id,
                            );
                          },
                          child: Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: _height * 0.03),
                    height: 1,
                    width: _width,
                    color: Colors.grey[300],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, UploadPage.id);
                    },
                    child: Container(
                      margin: EdgeInsets.all(_width * 0.03),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Upload',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _height * 0.04),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_circle),
                              SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                'What\'s your recipe?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            height: 1,
                            width: _width,
                            color: Colors.grey[300],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: <Widget>[
                          //     Text(
                          //       'Photos',
                          //       style: TextStyle(color: Colors.green),
                          //     ),
                          //     Text('|'),
                          //     Text(
                          //       'Videos',
                          //       style: TextStyle(color: Colors.blue),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                  _createPost(
                      name: 'Tasty with McDonalds.',
                      time: '1 hr · Paid partnership ·',
                      description:
                          'Three burgers, three level of spice - there\'s one '
                          'for everyone. Made with the new McSpicy® burger '
                          'from Macca\'s',
                      image: Image.asset('assets/images/burger.jpg')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
