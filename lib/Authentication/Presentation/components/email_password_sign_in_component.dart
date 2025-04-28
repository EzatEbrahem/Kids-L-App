import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_state.dart';
import 'package:kids_learning/Predicting/Presentation/Screens/home_screen.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/cache_helpher.dart';
import '../../../core/network/check_network.dart';

class EmailAndPasswordSignInComponent extends StatelessWidget {
   TextEditingController emailController;
  final TextEditingController passController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
   EmailAndPasswordSignInComponent(this.emailController, {super.key });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc,AuthenticationState>(
      listenWhen:(previous, current) =>previous.signInAuthenticationState!=current.signInAuthenticationState  ,
      listener: (context, state) {
        switch(state.signInAuthenticationState) {
          case SignInAuthenticationState.initial:
          case SignInAuthenticationState.loading:
          break;
          case SignInAuthenticationState.loaded:
            CacheHelper.saveData(key: "userId", value: state.userId);
            CacheHelper.saveData(key: "signIn", value: true);
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                message: "Sign in successfully",
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
            );
            break;
          case SignInAuthenticationState.error:
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.errorSignInMessage,
              ),
            );
            break;
        }

      },
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        buildWhen:(previous, current) => previous.signInAuthenticationState!=current.signInAuthenticationState||
        previous.obscurePassword!=current.obscurePassword,
        builder: (context, state) =>  Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0,right: 30),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: emailFocusNode,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(
                        passwordFocusNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'E-mail',
                    helperText: 'Enter your email',
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
                padding: const EdgeInsets.only(left: 30.0,right: 30,top: 30),
                child: TextFormField(
                  controller: passController,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: passwordFocusNode,
                  obscureText: state.obscurePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(color: Colors.orange),
                    hintText: 'Password',
                    helperText: 'Enter your password',
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child:state.signInAuthenticationState==SignInAuthenticationState.loading?
                  Center(child: CircularProgressIndicator(color: Colors.orange,)):
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
                        }else {
                          BlocProvider.of<AuthenticationBloc>(context).add(EmailAndPasswordSignInAuthenticationEvent(emailController.text, passController.text));
                        }
                      }
                    },
                    child: Text('Sign in', style: TextStyle(fontSize: 18,color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
