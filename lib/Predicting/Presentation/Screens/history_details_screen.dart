import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/components/see_more_component.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/network/check_network.dart';
class HistoryDetailsScreen extends StatelessWidget {
  final String nameImage;
  final String image;
  const HistoryDetailsScreen({super.key, required this.nameImage, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(nameImage,style: TextStyle(fontStyle: FontStyle.italic),),
        ),
        body: Stack(
          children: [
            Lottie.asset('assets/background.json',height: double.infinity,width: double.infinity,fit: BoxFit.fill),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Container(
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
                    child: ClipRRect(borderRadius: BorderRadius.circular(18),child: Image.network(image,fit: BoxFit.fill,)),
                    height: 350,
                    width: 270,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
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
                                  nameImage,overflow:TextOverflow.ellipsis ,maxLines: 1,
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
                                      BlocProvider.of<PredictBloc>(context).add(SpeakPredictedImageNameEvent(nameImage));
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
                    )
                ),
                SizedBox(
                  height: 45,
                ),
                Container(
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
                                  final searchTerm = Uri.encodeComponent(nameImage);
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
                    )
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ],

        ),
      );
  }
}
