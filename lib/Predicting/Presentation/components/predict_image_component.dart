import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_state.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PredictImageComponent extends StatelessWidget {
  const PredictImageComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PredictBloc,PredictState>(
      listenWhen:(previous, current) => previous.predictedResultState!=current.predictedResultState ,
      listener:(context, state) {
        switch(state.predictedResultState) {
          case PredictedResultState.initial:
            break;
          case PredictedResultState.loading:
          showTopSnackBar(Overlay.of(context),
              CustomSnackBar.info(message: "Waiting for Predicting"));
          break;
          case PredictedResultState.loaded:
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.success(message: "Predicting successfully"));
            break;
          case PredictedResultState.error:
            showTopSnackBar(Overlay.of(context),
                CustomSnackBar.info(message: "Predicting tray again later"));
            break;
        }
      } ,
      child: BlocBuilder<PredictBloc,PredictState>(
        buildWhen:(previous, current) => previous.predictedResultState!=current.predictedResultState ,
          builder: (context, state) {
          switch(state.predictedResultState) {
            case PredictedResultState.initial:
            case PredictedResultState.error:
             return Lottie.asset("assets/take-photo.json", fit: BoxFit.fill,height: 350, width: 380,);
            case PredictedResultState.loading:
             return Lottie.asset("assets/wait.json", fit: BoxFit.fill,height: 350, width: 380,);
            case PredictedResultState.loaded:
             return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.orange,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange,
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(18),child: Image.file(state.imageFile!,fit: BoxFit.fill,height: 350,
                    width: 270,)));
          }

          },),
    );
  }
}
