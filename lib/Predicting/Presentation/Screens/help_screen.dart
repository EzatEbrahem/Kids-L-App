import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kids_learning/Authentication/Presentation/screens/sign_in_screen.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_bloc.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_event.dart';
import 'package:kids_learning/Predicting/Presentation/controller/predict_state.dart';
import 'package:kids_learning/core/network/cache_helpher.dart';


class HelpScreen extends StatelessWidget {
  final String from;
  final CarouselSliderController _controller = CarouselSliderController();
  HelpScreen({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle:true,
        title:  Text('Help',style: TextStyle(fontStyle: FontStyle.italic),),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton(
              onPressed: (){
                if (from == 'home') {
                  Navigator.pop(context);
                } else if (from == 'intro') {
                  CacheHelper.saveData(key: 'intro', value: true);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SignInScreen()),(Route)=>false);
                }
              }, child: Text('Skip',style: TextStyle(fontSize: 16,color: Colors.amberAccent[700]),)),
        )],
      ),
      body: BlocBuilder<PredictBloc,PredictState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: CarouselSlider(
                    carouselController: _controller,
                    items: state.dataHelpScreen.map((path){
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(path,fit: BoxFit.fill,
                          width: double.infinity,),
                      );
                    }).toList(),
                    options: CarouselOptions(height:double.infinity,
                      enableInfiniteScroll: false,
                      pageSnapping: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 2),
                      autoPlayAnimationDuration: const Duration(milliseconds: 900),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      scrollPhysics: const BouncingScrollPhysics(),
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        BlocProvider.of<PredictBloc>(context).add(NavigateHelpScreenEvent(index));
                      },
                    ),),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: state.dataHelpScreen.asMap().entries.map((entry) {
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.currentIndexHelpScreen == entry.key
                        ? Colors.orange
                        : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 40),
                  child: TextButton(
                    onPressed: () {
                      if (state.currentIndexHelpScreen < state.dataHelpScreen.length - 1) {
                        _controller.nextPage();
                      } else {
                        if (from == 'home') {
                          Navigator.pop(context);
                        } else if (from == 'intro') {
                          CacheHelper.saveData(key: 'intro', value: true);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => SignInScreen()),(Route)=>false);
                        }
                      } },
                    child: const Text(
                      "next >",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ),




    );
  }
}
