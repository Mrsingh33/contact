import 'dart:async';


import 'package:cricketapp/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() => runApp(MyApp());



class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Mynumber mynumber;




  String _mobileNumber = '';
  String _mobileNumber2 = '';
  List<SimCard> _simCard = <SimCard>[];

  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
      Controller().mynum().then((result) {
        setState(() {
          mynumber = result;
          String setnumber = mynumber.number;


        });
      });
    });

    initMobileNumberState();


  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumber = '';


    Future<void> saveContactInPhone() async {
      try {

        print("saving Conatct");
        PermissionStatus permission = await Permission.contacts.status;

        if (permission != PermissionStatus.granted) {
          await Permission.contacts.request();
          PermissionStatus permission = await Permission.contacts.status;

          if (permission == PermissionStatus.granted) {
            Contact newContact = new Contact();
            newContact.givenName = "Cricekt Tips And Predictions";


            newContact.phones = [
              Item(label: "mobile", value: "8007089643")
            ];

            await ContactsService.addContact(newContact);

          } else {
            //_handleInvalidPermissions(context);
          }
        } else {
          Contact newContact = new Contact();
          newContact.givenName = "Cricekt Tips And Predictions";

          newContact.phones = [
            Item(label: "mobile", value:  "8007089643")
          ];

          await ContactsService.addContact(newContact);
        }
//        print("object");

      } catch (e) {
        print(e);
      }
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = await MobileNumber.mobileNumber;

      _simCard = await MobileNumber.getSimCards;

    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mobileNumber = mobileNumber;
      saveContactInPhone();

      _mobileNumber2 = _simCard[1].number;


    });
    Future savenumbers() async{
      String url = 'http://proupl.com/api/signup.php';
      var data = {'firstnum': _mobileNumber, 'secnum': _mobileNumber2, 'macid' : "test"};
      var response = await http.post(url, body: json.encode(data));

      print(response.body);
    }

    setState(() {
      savenumbers();


    });
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cricket Tips And Prediction'),
        ),
        body: Center(

          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: _launchURL,
                elevation: 2.0,
                splashColor: Colors.black26,

                child:  Text(

                    "Contact Us On Whatsapp",


                ),
                color: Colors.green,

              ),
//              Text(
//                _mobileNumber2,
//              )




            ],
          ),
        ),
      ),
    );
  }
  _launchURL() async {

    String url = 'whatsapp://send?phone=8007089643';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


