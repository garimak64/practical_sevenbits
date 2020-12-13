import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:practical_7bits/otp_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [Locale("en", "UK")],
      localizationsDelegates: [
        CountryLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = "Country Code Picker";
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = "+91";
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex:3),
            CountryCodePicker(
              onChanged: _onCountryChange,
              initialSelection: "IN",
              enabled: true,
              showCountryOnly: true,
              showOnlyCountryWhenClosed: true,
              textStyle: TextStyle(fontSize: 18.0),
            ),
         
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(letterSpacing: 1.0),
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      focusColor: Colors.blue,
                      hintText: "Enter your number"),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(letterSpacing: 3.0, fontSize: 18.0, fontWeight: FontWeight.w600),
                  maxLength: 16,
                  maxLines: 1,
                  maxLengthEnforced: true,
                  // Only numbers can be entered
                ),
              ),
            ),
      
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width * 0.40,
              height: 35.0,
                          child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OtpScreen(_phoneNumberController.text.trim()),
                  ));
                },
                child: Text("Send OTP", style: TextStyle(fontSize: 18.0),),
                textColor: Colors.white,
                color: Colors.blue,
              ),
            ),
            Spacer(flex: 3,)
          ],
        )));
  }

  void _onCountryChange(CountryCode countryCode) {
    _phoneNumberController.text = countryCode.dialCode;
  }
}