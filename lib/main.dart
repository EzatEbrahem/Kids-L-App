import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kids_learning/Predicting/Presentation/Screens/home_screen.dart';
import 'package:kids_learning/Predicting/Presentation/Screens/intro_screen.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Authentication/Presentation/contoller/authentication_bloc.dart';
import 'Authentication/Presentation/screens/sign_in_screen.dart';
import 'core/network/cache_helpher.dart';
import 'core/services/services_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
  await CacheHelper.init();
  final intro=CacheHelper().getData(key: 'intro');
  final signIn=CacheHelper().getData(key: 'signIn');
  final Widget screen;
  if(intro==null){
    screen=IntroScreen();
  }else{
    if(intro==true){
      if(signIn==true){
        screen=HomeScreen();
      }else{
        screen=SignInScreen();
      }
    }else{
      screen=IntroScreen();
    }
  }

  runApp( MyApp( StartWidget: screen,));
}

class MyApp extends StatelessWidget {
  final Widget StartWidget;
  const MyApp({super.key, required this.StartWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(lazy:true,create: (BuildContext context) =>sl<PredictBloc>()..add(LoadClassificationModelEvent())),
        BlocProvider(lazy:true,create: (BuildContext context) =>sl<AuthenticationBloc>(),),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kids Learning',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AnimatedSplashScreen(
          duration: 4500,
          splashTransition: SplashTransition.scaleTransition,
          splashIconSize: 500,
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 3),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: value,
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  "assets/Kids-Vector-Logo.png",
                  width: 260,
                  height: 260,
                ),
              ),
              Lottie.asset(
                "assets/splash.json",
                height: 150,
              ),
            ],
          ),
          nextScreen: StartWidget,
        ),
      ),
    );
  }
}
