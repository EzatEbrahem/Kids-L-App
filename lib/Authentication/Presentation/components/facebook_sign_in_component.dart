import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_state.dart';
import 'package:kids_learning/Predicting/Presentation/Screens/home_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/cache_helpher.dart';
import '../../../core/network/check_network.dart';
import '../../../core/utils/enums.dart';

class FacebookSignInComponent extends StatelessWidget {
  const FacebookSignInComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthenticationBloc,AuthenticationState>(
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
        buildWhen:(previous, current) => previous.signInAuthenticationState!=current.signInAuthenticationState ,
        builder: (context, state) => InkWell(
            onTap: () async {
              final isOnline=await NetworkChecker.isConnected();
              if(!isOnline){
                showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
              }else{
                BlocProvider.of<AuthenticationBloc>(context).add(FacebookSignInAuthenticationEvent());

              }
            },child: ClipOval(child: Image(image: AssetImage('assets/Facebook_Logo.png'),width: 40,))),
      ),
    );
  }
}
