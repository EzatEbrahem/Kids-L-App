import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_state.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/network/check_network.dart';

class PredictNameComponent extends StatelessWidget {
  const PredictNameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictBloc,PredictState>(
      buildWhen: (previous, current) => previous.predictedResultState!=current.predictedResultState,
        builder: (context, state) {
        switch(state.predictedResultState) {
          case PredictedResultState.initial:
          case PredictedResultState.loading:
          case PredictedResultState.error:
            return Center(child: Container());
          case PredictedResultState.loaded:
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade700,
                        Colors.amber.shade700,
                        Colors.yellowAccent,
                        Colors.amber.shade700,
                        Colors.orange.shade700,


                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Expanded(
                        child: Container(width: 100,padding: EdgeInsets.only(left: 20),
                          child: Text(
                            state.predictName,overflow:TextOverflow.ellipsis ,maxLines: 1,
                            style: TextStyle(
                                fontSize: 25,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor: Colors.black12,
                        radius: 25,
                        child: IconButton(
                            onPressed: () async {
                              final isOnline=await NetworkChecker.isConnected();
                              if(!isOnline){
                                showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                              }else{
                                BlocProvider.of<PredictBloc>(context).add(SpeakPredictedImageNameEvent(state.predictName));
                              }
                            },
                            icon: Icon(
                              Icons.volume_up,
                              size: 25,
                              color: Colors.black87,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );

        }

        },
    );
  }
}
