import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/load_history_component.dart';
import '../controller/predict_bloc.dart';
import '../controller/predict_event.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions:[ IconButton(onPressed: (){
          BlocProvider.of<PredictBloc>(context).add(ClearAllOldPredictedDataEvent());
        }, icon: Icon(Icons.delete_outline_outlined,color: Colors.amberAccent[700],size: 28,))],
        centerTitle: true,
        title: Text("History",style: TextStyle(fontStyle: FontStyle.italic),),
      ),
      body: LoadHistoryComponent(),
    );
  }
}
