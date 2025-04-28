import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/contoller/authentication_event.dart';
import 'package:kids_learning/Authentication/Presentation/screens/sign_in_screen.dart';
import 'package:kids_learning/Predicting/Presentation/Screens/help_screen.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Authentication/Presentation/contoller/authentication_bloc.dart';
import '../../../Authentication/Presentation/contoller/authentication_state.dart';
import '../../../core/network/cache_helpher.dart';
import '../../../core/network/check_network.dart';

class ProfileDataComponent extends StatelessWidget {
  const ProfileDataComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc,AuthenticationState>(
      listenWhen: (previous, current) => previous.logoutAuthenticationState!=current.logoutAuthenticationState,
      listener: (context, state) {
        switch(state.logoutAuthenticationState) {
          case LogoutAuthenticationState.initial:
            break;
          case LogoutAuthenticationState.loading:
            break;
          case LogoutAuthenticationState.loaded:
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.success(message: state.logoutMessage));
            break;
          case LogoutAuthenticationState.error:
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.error(message: state.logoutMessage));
            break;
        }

      },
      child: BlocBuilder<AuthenticationBloc,AuthenticationState>(
          buildWhen: (previous, current) => previous.loadUserDataState!=current.loadUserDataState,
          builder: ( context,  state) =>  Drawer(
              backgroundColor: Colors.white,
              width: 260,
              child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 15),
                        color: Colors.amberAccent[700],
                        child: SizedBox(
                          height: 50,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.dehaze_rounded,
                              size: 35,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 230,
                      child: DrawerHeader(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(state.profileUrl)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 130.0),
                          child: Container(
                              color: Colors.black38,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0,top: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.userName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic)),
                                    Text(state.email,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontStyle: FontStyle.italic)),

                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    ListTile(
                      iconColor: Colors.amberAccent[700],
                      leading: Icon(
                        Icons.home,
                        size: 30,
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(fontSize: 17),
                      ),
                      onTap: () {
                        BlocProvider.of<PredictBloc>(context).add(ResetHomeEvent());
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                          color: Colors.black,
                          child: SizedBox(
                            height: 1.5,
                          )),
                    ),
                    ListTile(
                      iconColor: Colors.amberAccent[700],
                      leading: Icon(
                        Icons.help_outline_outlined,
                        size: 30,
                      ),
                      title: Text(
                        "Help",
                        style: TextStyle(fontSize: 17),
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HelpScreen(from: 'home',)), (route)=>true);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                          color: Colors.black,
                          child: SizedBox(
                            height: 1.5,
                          )),
                    ),
                    ListTile(
                      iconColor: Colors.amberAccent[700],
                      leading: Icon(
                        Icons.logout_outlined,
                        size: 30,
                      ),
                      title: Text(
                        "Log out",
                        style: TextStyle(fontSize: 17),
                      ),
                      onTap: () async {
                        final isOnline=await NetworkChecker.isConnected();
                        if(!isOnline){
                          showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                        }else {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              LogOutAuthenticationEvent());
                          CacheHelper.removeData(key: 'userId');
                          CacheHelper.saveData(key: 'signIn', value: false);
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()), (
                                  route) => false);
                        }
                      },
                    ),
                  ]
              ),
            ),

      ),
    );
  }
}
