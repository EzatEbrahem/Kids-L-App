import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Domain/Entities/predict_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';
import '../Screens/history_details_screen.dart';
import '../controller/predict_bloc.dart';
import '../controller/predict_event.dart';

class HistoryItemComponent extends StatelessWidget {
  final List<PredictData> listPredictedData;
   final int CurrentIndex;
  const HistoryItemComponent({super.key, required this.CurrentIndex, required this.listPredictedData});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(listPredictedData[CurrentIndex].predictId),
      direction: DismissDirection.endToStart,
      background: Padding(
        padding: const EdgeInsets.only(top:10),
        child: ClipRRect(
          borderRadius:
          const BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            color: Colors.red,
            child: Icon(Icons.delete, color: Colors.white,size: 40,),
          ),
        ),
      ),
      onDismissed: (direction) async {
        final isOnline=await NetworkChecker.isConnected();
        if(!isOnline){
          showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
        }else{
        BlocProvider.of<PredictBloc>(context).add(DeleteSelectedPredictedDataEvent(listPredictedData[CurrentIndex].predictId));
        listPredictedData.removeAt(CurrentIndex);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only( top:10),
        child: ClipRRect(
          borderRadius:
          const BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            color:Colors.black12,
            child: InkWell(
              onTap: () async {
                final isOnline=await NetworkChecker.isConnected();
                if(!isOnline){
                  showTopSnackBar(Overlay.of(context),
                      CustomSnackBar.error(message: "No internet connection. Please try again"));
                }else {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (builder) =>
                          HistoryDetailsScreen(
                              nameImage: listPredictedData[CurrentIndex]
                                  .predictingName,
                              image: listPredictedData[CurrentIndex]
                                  .predictingImage)), (Rote) => true);
                }
              },
              child: ClipRRect(
                borderRadius:
                const BorderRadius.all(Radius.circular(8.0)),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            child:Image.network(listPredictedData[CurrentIndex].predictingImage,
                              width: 170,
                              height: 165, fit: BoxFit.fill,
                              loadingBuilder: (context, child, loadingProgress){
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[850]!,
                                    highlightColor: Colors.grey[800]!,
                                    child: Container(
                                      width: 170,
                                      height: 165,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  );
                                }
                              },
                            )
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 11.0,right: 8),
                          child: SizedBox(
                            height: 160,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:5,bottom: 10),
                                  child: Text(
                                      listPredictedData[CurrentIndex].predictingName,style: TextStyle( fontSize: 19,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.amberAccent[700]),overflow:TextOverflow.ellipsis ,maxLines:2 ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all( 6.0),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4.0),
                                          child: Container(color: Colors.white24,child: Padding(
                                            padding: const EdgeInsets.only(left: 9.0,right:9 ,top:3 ,bottom:3 ),
                                            child: Text(listPredictedData[CurrentIndex].uploadedAt.toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                          ),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:  5.0),
                                          child: IconButton( icon:Icon( Icons.delete_rounded,color: Colors.black,size: 30), onPressed: () async {
                                            final isOnline=await NetworkChecker.isConnected();
                                            if(!isOnline){
                                              showTopSnackBar(Overlay.of(context), CustomSnackBar.error(message: "No internet connection. Please try again"));
                                            }else {
                                              BlocProvider.of<PredictBloc>(
                                                  context).add(
                                                  DeleteSelectedPredictedDataEvent(
                                                      listPredictedData[CurrentIndex]
                                                          .predictId));}
                                            },),
                                        ),

                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      )

                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
