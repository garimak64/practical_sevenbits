// import 'dart:async';

// import 'package:flutter/material.dart';

// class ResendOtpButton extends StatefulWidget {
//    static const _timerDuration = 30;

//   @override
//   _ResendOtpButtonState createState() => _ResendOtpButtonState();
// }

// class _ResendOtpButtonState extends State<ResendOtpButton> {
//   StreamController _timerStream = new StreamController<int>();
//   int timerCounter;
//   Timer _resendCodeTimer;

//   @override
//   void initState() {
//     super.initState();
//     activeCounter();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//             stream: _timerStream.stream,
//             builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//               return SizedBox(
//                   width: 300,
//                   height: 30,
//                   child: FlatButton(
//                     textColor: Colors.white,
//                     color: Colors.blue,
//                     child: Center(
//                         child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         snapshot.hasData && snapshot.data > 0
//                             ? Text(
//                                 'Resend OTP after ${snapshot.data.toString()}s')
//                             : Text('Resend OTP'),
//                       ],
//                     )),
//                     onPressed: snapshot.data == 0
//                         ? () {
//                             resendToken != -1
//                                 ? _loginUser(resendToken: resendToken)
//                                 : _loginUser();
//                             _timerStream.sink.add(30);
//                             activeCounter();
//                           }
//                         : null,
//                   ));
//             },
//           );
//   }

//     activeCounter() {
//     _resendCodeTimer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       if (ResendOtpButton._timerDuration - timer.tick > 0)
//         _timerStream.sink.add(ResendOtpButton._timerDuration - timer.tick);
//       else {
//         _timerStream.sink.add(0);
//         _resendCodeTimer.cancel();
//       }
//     });
//   }
// }