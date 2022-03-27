import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_movieapp_module/model/movie_detail_model.dart';
import 'package:riverpod_movieapp_module/provider/favourite_state_notifier.dart';
import 'package:riverpod_movieapp_module/provider/providers.dart';
import 'package:riverpod_movieapp_module/widget/common_component.dart';
import 'package:riverpod_movieapp_module/widget/styles.dart';

class DescriptionScreen extends ConsumerStatefulWidget {
  final int? movieID;
  final FavouriteStateNotifier favouriteStateNotifier;
  final dynamic favouriteNotifierProvider;
  const DescriptionScreen({
    Key? key,
    this.movieID,
    required this.favouriteStateNotifier,
    required this.favouriteNotifierProvider,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends ConsumerState<DescriptionScreen> {

  

  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2340),
      body: _body(context),
    );
    
  }

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      child: ref.watch(movieDetailFutureProvider(widget.movieID)).when(
      data: (data) => _movieContent(context, data),
      loading:() => _loading(context),
      error: (e,s)=> Center(child: Text(e.toString()))
      ),
    );
  }

  SizedBox _loading(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: const Center(child: CircularProgressIndicator()));
  }

  Column _movieContent(BuildContext context, MovieDetail data) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.35,
              width: double.infinity,
              child: ClipRRect(
                                    child: Image.network(
                                      data.fullImageUrl,
                                      fit: BoxFit.fill,),
                                  ),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top,),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10, top: 15 ,bottom: 35),
            child: _customAppbar(context),
          ),
              ],
            ),
            Positioned(
              top: MediaQuery.of(context).size.height*0.35/2,
              left: MediaQuery.of(context).size.width/2 - 30,
              child:const Icon(Icons.play_circle,color: Colors.white,size: 60,))
          ],
        ),
        const SizedBox(height: 15,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Row(
              children: [
               SizedBox(
                 width: MediaQuery.of(context).size.width-140,
                 child: _headerTextWidget(context,data.originalTitle.toString())),
               const Spacer(),
               SizedBox(
                 width: 110,
                 child: Row(
                   children: List.generate(6,
                                            (index1) {
                                          double  rating =  (5*data.voteAverage!*10)/100;
                                                  return CommonComponent.getRating(context,index1,rating);
                                              }
                                          ),
                  ),
               ),
               ],
            ),
            Text(
                            data.genres!.map((e) => e.name).toList().join(', ')+' | Runtime : '+data.runtime.toString()+' min',
                            maxLines: null,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.style8
                ),
            Padding(
                 padding: const EdgeInsets.only(top:20,bottom: 15,right: 20),
                 child: Text(
                              data.overview.toString(),
                              maxLines: null,
                              style: Styles.style9
                  ),
               ),
            _headerTextWidget(context, 'The cast'),
                ]),),
            _movieCast(data),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: _headerTextWidget(context, 'Reviews'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 8),
              child: data.reviews!.results!.isEmpty?
              CommonComponent.notFound(context):
              Column(
                children: List.generate(data.reviews!.results!.length,
                                            (index) {
                                                  return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _reviewCard(context,data.reviews!.results![index],index),
              );
                                              }
                                          ),
              ),
            ),
            
          ],
        )
      ],
    );
  }

  SizedBox _movieCast(MovieDetail data) {
    return SizedBox(
                height: 175,
                child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          scrollDirection: Axis.horizontal,
          itemCount: data.credits!.cast!.length,
          itemBuilder: (BuildContext context,int index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 70,
                      height:70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image:data.credits!.cast![index].profilePath!=null? 
                          NetworkImage( data.credits!.cast![index].fullImageUrl.toString()):
                          const NetworkImage('https://img.tpng.net/detail/500x0_202-2024792_profile-icon-png.png'),
                          fit: BoxFit.fill
                        ),
                      ),
                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: 80,
                    child: Text(
                              data.credits!.cast![index].originalName.toString(),
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: Styles.style10
                    ),
                  ),
                ],
              ),
            );
          },),
        );
  }

  Card _reviewCard(BuildContext context,Results data,int index) {
    return Card(
                    color:const Color(0xFF12172E),
                    shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[
                          Row(
                            children: [
                              CommonComponent.iconCard(context, Icons.person,data: data,color: const Color(0xFF1F2340)),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.authorDetails!.name!=''?data.authorDetails!.name!:
                                      data.authorDetails!.username![0].toString().toUpperCase()+
                                      data.authorDetails!.username!.toString().substring(1),
                                      style: Styles.style11
                                      ),
                                    Text(
                                      data.createdAt.toString(),
                                      style: Styles.style12
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height:10),
                          Text(
                            data.content.toString(),
                            style : Styles.style13
                          ),
                    
                        ]
                      ),
                    ),
                  );
  }

  Row _customAppbar(BuildContext context) {
    return Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child:const Icon(Icons.arrow_back,color: Colors.white,
                  ),
                ),
                const Spacer(),
               GestureDetector(
                                                                                                    onTap: (){
                                                                                                      widget.favouriteStateNotifier.onTap();
                                                                                                    },
                                                                                                    child: Icon(
                                                                                                      Icons.favorite,
                                                                                                      color: ref.watch(widget.favouriteNotifierProvider).favouriteFlag?
                                                                                                      Colors.red:
                                                                                                      Colors.white,),
                                                                                                  ),
              ],
            );
  }

  Text _headerTextWidget(BuildContext context,String text) {
    return Text(
                                      text,
                                      maxLines: null,
                                      style: Styles.style7
                                      );
  }

}