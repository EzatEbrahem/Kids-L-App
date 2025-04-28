import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_sign_up_component.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Padding(
        padding: const EdgeInsets.only(top:40),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                color:Colors.orange ,
                width:double.infinity ,
                child:Padding(
                  padding: const EdgeInsets.only( left: 10,bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text('Sign up',style: TextStyle(fontSize: 35,fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.white,
                                blurRadius: 5,
                                offset: const Offset(0, 3),)
                            ]),),
                      ),
                      Text('Create an free account',style:TextStyle(fontSize: 18,fontStyle: FontStyle.italic,color: Colors.white),)
                    ],
                  ),
                ) ,
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(116))),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SingleChildScrollView(
                    child: FormSignUpComponent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
