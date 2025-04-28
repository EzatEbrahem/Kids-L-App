import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/components/see_more_component.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';
import '../../../core/utils/enums.dart';
import '../controller/predict_bloc.dart';
import '../controller/predict_state.dart';

class GetSeeMoreResultComponent extends StatelessWidget {
  const GetSeeMoreResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictBloc,PredictState>(
      buildWhen: (previous, current) => previous.predictedResultState!=current.predictedResultState,
      builder: (context, state) {
        switch(state.predictedResultState) {
          case PredictedResultState.initial:
          case PredictedResultState.loading:
          case PredictedResultState.error:
            return Container();
          case PredictedResultState.loaded:
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final isOnline=await NetworkChecker.isConnected();
                          if(!isOnline){
                            showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                          }else{
                            final searchTerm = Uri.encodeComponent(state.predictName);
                            final finalUrl = "https://www.pinterest.com/search/pins/?q=$searchTerm";
                            showModalBottomSheet(
                              backgroundColor: Colors.amberAccent[700],
                              showDragHandle: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              isScrollControlled: true,
                              builder: (_) => SizedBox(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: SeeMoreComponent(url: finalUrl),
                              ),
                            );
                          }
                        },
                        child: Text("See More"),
                      )
                  ),
                  Container(
                    height: 2,
                    width: 90,
                    color: Colors.amberAccent[700],
                  )
                ],
              ),
            );

        }

      },
    );
  }
}
