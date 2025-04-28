import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';
import '../../../core/utils/enums.dart';
import '../controller/predict_bloc.dart';
import '../controller/predict_event.dart';
import '../controller/predict_state.dart';

class FloatingActionButtonComponent extends StatelessWidget {
  const FloatingActionButtonComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictBloc,PredictState>(
      buildWhen: (previous, current) => previous.predictedResultState!=current.predictedResultState,
      builder: (context, state) {
        switch(state.predictedResultState) {
          case PredictedResultState.initial:
          case PredictedResultState.loading:
          case PredictedResultState.error:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'f1',
                  onPressed: () async {
                    final isOnline=await NetworkChecker.isConnected();
                    if(!isOnline){
                      showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                    }else{
                      BlocProvider.of<PredictBloc>(context).add(TakePictureFromGalleryToClassificationEvent());
                    }
                  },
                  backgroundColor: Colors.amberAccent[700],
                  child: Icon(
                    Icons.image,
                    size: 25,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: FloatingActionButton(
                    heroTag: 'f2',
                    onPressed: () async {
                      final isOnline=await NetworkChecker.isConnected();
                      if(!isOnline){
                        showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                      }else{
                        BlocProvider.of<PredictBloc>(context)
                            .add(TakePictureFromCameraToClassificationEvent());
                      }
                    },
                    backgroundColor: Colors.amberAccent[700],
                    child: Icon(
                      Icons.add_a_photo,
                      size: 25,
                    ),
                  ),
                ),
              ],
            );
          case PredictedResultState.loaded:
            return Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      heroTag: 'f3',
                      onPressed: () async {
                        final isOnline=await NetworkChecker.isConnected();
                        if(!isOnline){
                          showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                        }else {
                          BlocProvider.of<PredictBloc>(context).add(
                              ResetHomeEvent());
                        }

                      },
                      backgroundColor: Colors.amberAccent[700],
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 29,
                      ),
                    ),
                  ),
                ],
              ),
            );

        }

      },
    );
  }
}
