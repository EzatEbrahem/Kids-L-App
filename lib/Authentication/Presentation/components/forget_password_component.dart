import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_state.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgetPasswordComponent extends StatelessWidget {
  final TextEditingController emailController;

   ForgetPasswordComponent(this.emailController,{super.key});


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc,AuthenticationState>(
      listenWhen:(previous, current) => previous.forgetPasswordMessage!=current.forgetPasswordMessage ,
      listener: (context, state) {
        if(state.forgetPasswordMessage.isNotEmpty){
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.info(
              message: state.forgetPasswordMessage,
            ),
          );
        }

      },
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
        buildWhen: (previous, current) =>previous.forgetPasswordMessage!=current.forgetPasswordMessage ,
        builder: (context, state) =>  InkWell(
          onTap: ()async {
            final email = emailController.text.trim();
            BlocProvider.of<AuthenticationBloc>(context).add(ForgetPasswordAuthenticationEvent(email));
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Text('Forget password ?',style: TextStyle(color: Colors.orange,fontSize: 15),),
          ),
        ),
      ),
    );
  }
}
