import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_state.dart';
import 'package:kids_learning/core/utils/enums.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'history_item_component.dart';

class LoadHistoryComponent extends StatelessWidget {
  const LoadHistoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocListener<PredictBloc,PredictState>(
      listenWhen:(previous, current) => previous.loadAllOldPredictedDataState!=current.loadAllOldPredictedDataState ,
      listener:(context, state) {
       switch(state.deletePredictedDataState) {
         case DeletePredictedDataState.initial:
           break;
         case DeletePredictedDataState.loading:
          break;
         case DeletePredictedDataState.loaded:
           showTopSnackBar(Overlay.of(context),
               CustomSnackBar.success(message: "Deleted Successfully"));
           break;
         case DeletePredictedDataState.error:
           showTopSnackBar(Overlay.of(context),
               CustomSnackBar.error(message: state.errorLoadAllOldPredictedDataMessage));
       }

      } ,
      child: BlocBuilder<PredictBloc,PredictState>(
        buildWhen:(previous, current) => previous.loadAllOldPredictedDataState!=current.loadAllOldPredictedDataState ,
        builder: (context, state) {
          if(state.listPredictedData.isNotEmpty){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical:  10.0,horizontal: 10),
              child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => HistoryItemComponent(CurrentIndex: index, listPredictedData: state.listPredictedData),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 0,),
                  itemCount: state.listPredictedData.length),
            );
          }else{
            return Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Image.asset('assets/notFoundData.gif',fit: BoxFit.fill,),
            );
          }
        }
      ),
    );
  }
}
