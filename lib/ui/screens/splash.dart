import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mappy/utils/constants/color.consts.dart';

import 'appcolor.dart';
import 'home.screen.dart';

class splash extends StatefulWidget {
  const splash({Key key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
         // color: AppColors.textHighlightColor,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/basic/pp.jpeg"),
              fit: BoxFit.fitHeight,
            ),
          ),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,

             children: [
               SizedBox(height: 10.0,),
               Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left:12.0),
                     child: Align(
                       alignment: Alignment.topLeft,
                       child: Text( "Welcome",
                         style: GoogleFonts.oxanium(
                             fontSize: 32.0,
                             fontWeight: FontWeight.w600,
                             color: AppColors.text1_color
                         ),),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.only(left:12.0),
                     child: Align(
                       alignment: Alignment.topLeft,
                       child: Text( "Mohammed!",
                         style: GoogleFonts.oxanium(
                             fontSize: 45.0,
                             fontWeight: FontWeight.w600,
                             color: AppColors.text1_color
                         ),),
                     ),
                   ),
                 ],
               ),
                // Container(
                //   child: Text(
                //     "Find your routes ",
                //     style: GoogleFonts.oxanium(
                //         fontSize: 22.0,
                //         fontWeight: FontWeight.w600,
                //         color: AppColors.text1_color
                //     ),
                //   ),
                // ),
               SizedBox(height: 0.0,),
               GestureDetector(
                 onTap: (){
                   Navigator.of(context).push(new MaterialPageRoute(
                       builder: (context) => new HomeScreen()));
                 },
                 child: Container(
                   height: 50.0,
                     width: MediaQuery.of(context).size.width -20,

                     decoration: new BoxDecoration(
                       color: AppColors.tradehintColor,
                       borderRadius: new BorderRadius.circular(10.0),
                       // gradient: new LinearGradient(
                       //     colors: [
                       //       AppColors.button1_color,
                       //       AppColors.button12_color
                       //     ],
                       //     begin: Alignment.bottomLeft,
                       //     //const FractionalOffset(0.0, 0.5),
                       //     end: Alignment.topRight,
                       //     //const FractionalOffset(1.0, 0.6),
                       //     stops: [0.0, 1.0],
                       //     tileMode: TileMode.clamp),
                     ),

                     child: Center(
                       child: Text("Start Tracking your way!",
                         style:  GoogleFonts.oxanium(
                             fontSize: 22.0,
                             fontWeight: FontWeight.w600,
                             color: AppColors.security_or_Color
                         ),),
                     )),
               )
             ],
           ),
        ),
      );
  }
}
