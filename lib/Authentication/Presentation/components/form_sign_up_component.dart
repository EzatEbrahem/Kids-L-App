import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_state.dart';
import 'package:kids_learning/Authentication/Presentation/screens/sign_in_screen.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';


class FormSignUpComponent extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final profile=null;
  final _formKey = GlobalKey<FormState>();
   FormSignUpComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc,AuthenticationState>(
      listenWhen: (previous, current) =>previous.signUpAuthenticationState!=current.signUpAuthenticationState ,
      listener: (context, state) {
        switch(state.signUpAuthenticationState) {
          case SignUpAuthenticationState.initial:
          case SignUpAuthenticationState.loading:
            break;
          case SignUpAuthenticationState.loaded:
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "Sign up successfully",
            ),
          );
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.info(
              message: "Check your email to activate your account",
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
                (route) => false,
          );
         break;
          case SignUpAuthenticationState.error:
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorSignUpMessage,
              ),
            );
            break;
        }
      },
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        buildWhen:(previous, current) => previous.signUpAuthenticationState!=current.signUpAuthenticationState||previous.profileFile!=current.profileFile||
            previous.obscurePassword!=current.obscurePassword ,
        builder: (context, state) =>  Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(onPressed: (){
                          BlocProvider.of<AuthenticationBloc>(context).add(SelectPictureFromGalleryEvent());
                        }, child:Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text('Choose image',style: TextStyle(color: Colors.grey),),
                            ),
                            Icon(Icons.image_rounded,size: 25,color: Colors.orange,)
                          ],
                        )),
                        TextButton(onPressed: (){
                          BlocProvider.of<AuthenticationBloc>(context).add(TakePictureFromCameraEvent());
                        }, child:Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text('Take image',style: TextStyle(color: Colors.grey),),
                            ),
                            Icon(Icons.camera_alt_rounded,size: 25,color: Colors.orange)
                          ],
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 50,left: 30),
                    child: CircleAvatar(
                      child: ClipOval(child: state.profileFile==null? Image(image:
                      AssetImage('assets/person.png'),width: 125,height: 125,fit: BoxFit.fill,):Image.file(state.profileFile!,width: 125,height: 125,fit: BoxFit.fill,)),
                      radius: 65,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 50,top: 30),
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  focusNode: nameFocusNode,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocusNode),
                  decoration: InputDecoration(
                    labelText: 'User name',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'Full name',
                    helperText: 'User name should be more than 5 characters',
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        nameController.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter your name';
                    } else if (value.length <= 5) {
                      return 'name is short. Length Must be more than 5';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 50,top: 30),
                child: TextFormField(
                  controller: emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(
                        passwordFocusNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'E-mail',
                    helperText: 'Should be valid Gmail and contain \'@gmail.com\'',
                    prefixIcon: Icon(Icons.email_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        emailController.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty||value.length < 12) {
                      return 'Invalid E-mail';
                    } else if (!value.contains('@gmail.com')) {
                      return 'Should be contain \'@gmail.com\'';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 50,top: 30),
                child: TextFormField(
                  controller: passController,
                  focusNode: passwordFocusNode,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: state.obscurePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocusNode),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'Password',
                    helperText: 'Password should be more than 5 characters',
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(state.obscurePassword ? Icons.visibility_off : Icons.visibility,),
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(TogglePasswordVisibilityEvent());
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter password';
                    } else if (value.length <= 5) {
                      return 'Password is short';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 50,top: 30),
                child: TextFormField(
                  controller: phoneController,
                  focusNode: phoneFocusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'Phone',
                    helperText: 'Phone number should be 11 number',
                    prefixIcon: Icon(Icons.phone_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        phoneController.clear();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter your Phone number';
                    } else if (value.length < 11||value.length>11) {
                      return 'Invalid Phone number ';
                    }
                    return null;
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child:state.signUpAuthenticationState==SignUpAuthenticationState.loading?
                  CircularProgressIndicator(color: Colors.orange):
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final isOnline=await NetworkChecker.isConnected();
                        if(!isOnline){
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message: "No internet connection. Please try again.",
                            ),
                          );

                        }else{

                          BlocProvider.of<AuthenticationBloc>(context).add(SignUpAuthenticationEvent(state.profileFile, nameController.text, emailController.text, passController.text, phoneController.text));
                        }
                      }
                    },
                    child: Text('Sign Up', style: TextStyle(fontSize: 18,color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
