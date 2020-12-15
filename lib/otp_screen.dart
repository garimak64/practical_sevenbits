import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practical_7bits/profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final phoneNumber;

  OtpScreen(this.phoneNumber);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _smsCodeController = TextEditingController();
  static const _timerDuration = 30;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  StreamController _timerStream = new StreamController<int>();
  int timerCounter;
  Timer _resendCodeTimer;
  String verificationCode;
  String errorText;
  int resendToken = -1;

  @override
  void initState() {
    super.initState();
    _loginUser();
    _activateCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("OTP Screen"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: _smsCodeController,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: "OTP",
                    labelStyle: TextStyle(letterSpacing: 1.0),
                    border: OutlineInputBorder(),
                    hintText: "######",
                    focusColor: Colors.blue,
                    errorText: errorText),
                onTap: () {
                  setState(() {
                    errorText = null;
                  });
                },

                keyboardType: TextInputType.number,
                style: TextStyle(
                    letterSpacing: 3.0,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
                maxLength: 6,
                maxLines: 1,
                maxLengthEnforced: true,
                // Only numbers can be entered
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final smsCode = _smsCodeController.text;
                      if (_verifyCode(smsCode)) {
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationCode,
                                smsCode: smsCode);
                        UserCredential userCredential =
                            await _auth.signInWithCredential(credential);
                        User user = userCredential.user;
                        if (user != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        } else {
                          setState(() {
                            errorText = "Invalid Credentials";
                          });
                        }
                      } else {
                        setState(() {
                          errorText = "Code must be of 6 digits";
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: StreamBuilder(
                    stream: _timerStream.stream,
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                      return FlatButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: snapshot.hasData && snapshot.data > 0
                            ? Text(
                                'Resend OTP after ${snapshot.data.toString()}s')
                            : Text('Resend OTP'),
                        onPressed: snapshot.data == 0
                            ? () {
                                resendToken != -1
                                    ? _loginUser(resendToken: resendToken)
                                    : _loginUser();
                                _timerStream.sink.add(30);
                                _activateCounter();
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _activateCounter() {
    _resendCodeTimer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_timerDuration - timer.tick > 0)
        _timerStream.sink.add(_timerDuration - timer.tick);
      else {
        _timerStream.sink.add(0);
        _resendCodeTimer.cancel();
      }
    });
  }

  Future<void> _loginUser({int smsCode, int resendToken}) async {
    _auth.verifyPhoneNumber(
        forceResendingToken: resendToken,
        phoneNumber: widget.phoneNumber,
        timeout: Duration(minutes: 2),
        verificationCompleted: _onVerificationComplete,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackbar('Please manually input code.');
          verificationCode = verificationId;
        });
  }

  bool _verifyCode(String smsCode) {
    return smsCode != null && smsCode.length == 6 && verificationCode != null;
  }

  void showSnackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }


  // Enable this to auto-verify the sms code.
  void _onVerificationComplete(AuthCredential credential) async {
/*    UserCredential result = await _auth.signInWithCredential(credential);
    User user = result.user;
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    }
    showSnackbar(
        "Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");*/
  }

  void _onVerificationFailed(FirebaseAuthException e) {
    setState(() {
      errorText = "Incorrect OTP";
    });
    showSnackbar("Verification failed: $e");
  }

  void _onCodeSent(String verificationId, int resendToken) {
    showSnackbar('Code Sent. Please check your inbox.');
    verificationCode = verificationId;
    this.resendToken = resendToken;
  }

  @override
  void dispose() {
    _smsCodeController.dispose();
    _resendCodeTimer.cancel();
    super.dispose();
  }
}
