import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/screens/sign_up_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';
import '../components/email_password_sign_in_component.dart';
import '../components/facebook_sign_in_component.dart';
import '../components/forget_password_component.dart';
import '../components/google_sign_in_component.dart';
import '../contoller/authentication_bloc.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController=TextEditingController();

   SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.orange,
      body: Padding(
        padding: const EdgeInsets.only(top:40),
        child: Column(
          children: [
            Container(
              color:Colors.orange ,
              width:double.infinity ,
              child:Padding(
                padding: const EdgeInsets.only( bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 5.0),
                      child: Text('Sign in',style: TextStyle(fontSize: 50,fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 5,
                              offset: const Offset(0, 3),)
                          ]),),
                    ),
                    Text('Learn more with us',style:TextStyle(fontSize: 25,fontStyle: FontStyle.italic,color: Colors.white),)
                  ],
                ),
              ) ,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(80),topLeft: Radius.circular(80))),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      child: Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              EmailAndPasswordSignInComponent(emailController),
                              ForgetPasswordComponent(emailController),
                            ],
                          ),
                          Container(
                            child:Column(
                              children: [
                                Text('Sign in by'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Container(width: 150,height: 70,decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(50) ),child:
                                  Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FacebookSignInComponent(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Container(color: Colors.white,child: SizedBox(width: 2,height: double.infinity,)),
                                        ),
                                        GoogleSignInComponent(),
                                      ],
                                    ),
                                  ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final isOnline=await NetworkChecker.isConnected();
                                    if(!isOnline){
                                      showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                                    }else{
                                      BlocProvider.of<AuthenticationBloc>(context).add(ResetSignUpEvent());
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignUpScreen()), (Rote)=>true);

                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                                    child: Text('Create free account..!',style: TextStyle(color: Colors.orange,fontSize: 18),),
                                  ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
