import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Authentication/Presentation/contoller/authentication_bloc.dart';
import '../../../Authentication/Presentation/contoller/authentication_event.dart';
import '../../../core/network/check_network.dart';
import '../../../core/utils/enums.dart';
import '../components/floating_action_button_component.dart';
import '../components/get_see_more_result_component.dart';
import '../components/predict_image_component.dart';
import '../components/predict_name_component.dart';
import '../components/profile_data_component.dart';
import '../controller/predict_bloc.dart';
import '../controller/predict_event.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fabLocation = context.select<PredictBloc, FloatingActionButtonLocation>(
          (bloc) => bloc.state.predictedResultState==PredictedResultState.loaded
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
    BlocProvider.of<AuthenticationBloc>(context).add(LoadUserDataEvent());
    return Scaffold(
    backgroundColor: Colors.white,
    floatingActionButtonLocation:fabLocation,
    appBar: AppBar(
      backgroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () async {
              final isOnline=await NetworkChecker.isConnected();
              if(!isOnline){
                showTopSnackBar(Overlay.of(context),
                    CustomSnackBar.error(message: "No internet connection. Please try again"));
              }else{
                BlocProvider.of<PredictBloc>(context).add(GetAllOldPredictedDataEvent());
               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (build)=>HistoryScreen()), (Route)=>true);
              }
            },
            icon: Icon(
              Icons.history_outlined,
              color: Colors.amberAccent[700],
              size: 30,
            )),
      ],
    ),
    drawer: ProfileDataComponent(),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Let's ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Know more about the things ..! ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: PredictImageComponent(),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          PredictNameComponent(),
          SizedBox(
            height: 25,
          ),
          GetSeeMoreResultComponent(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButtonComponent(),
        );
  }
}
