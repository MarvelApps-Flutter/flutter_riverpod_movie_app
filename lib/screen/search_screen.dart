import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_movieapp_module/model/popular_movies_model.dart';
import 'package:riverpod_movieapp_module/provider/providers.dart';
import 'package:riverpod_movieapp_module/screen/description_screen.dart';
import 'package:riverpod_movieapp_module/widget/common_component.dart';
import 'package:riverpod_movieapp_module/widget/search.dart';
import 'package:riverpod_movieapp_module/widget/styles.dart';


class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: const Color(0xFF171A2F),
      body: _body(context),
       
    );
  }

  Stack _body(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: ref.watch(searchMoviesFutureProvider(ref.watch(queryProvider))).when(
            data: (data) => Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top+60,
                ),
                LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height*3,
                  child:  data.results!.isEmpty? 
                   SizedBox(height:MediaQuery.of(context).size.height-150, child: CommonComponent.notFound(context)):
                   ListView.builder(
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemCount: data.results!.length,
                    itemBuilder: (BuildContext context,int index){
                      return  _movieListTile(context, data, index);
                            }),
                ),
              ],
            ),
            error: (e,s) => Center(child: Text(e.toString())),
            loading: () => _loading(context), 
          ),
        ),
        Container(
                height: MediaQuery.of(context).padding.top+60,
                color: const Color(0xFF171A2F),
              ),
        Column(
          children:[
            Padding(
              padding:EdgeInsets.only(top: MediaQuery.of(context).padding.top,left: 15,right: 15),
              child: _customAppbar(context),
            ),
            SearchWidget(
            hintText: 'Search for a movie,genre,etc.',
            onChanged: (text) { 
              ref.watch(queryProvider.notifier).state=text;
            },
            text: ref.watch(queryProvider.notifier).state,
            ),
          ]
        ),
      
      ],
    );
  }

  SizedBox _loading(BuildContext context) {
    return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(child: CircularProgressIndicator()));
  }

  FractionallySizedBox _movieListTile(BuildContext context, Movies data, int index) {
    return FractionallySizedBox(
                      widthFactor: 0.97,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                              MaterialPageRoute(builder: (BuildContext context) => 
                              DescriptionScreen(
                                movieID: data.results![index].id ,
                                favouriteStateNotifier: ref.watch(data.results![index].favouriteNotifierProvider.notifier),
                                favouriteNotifierProvider: data.results![index].favouriteNotifierProvider,
                                )),
                            );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: const Color(0xFF1F2340),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:data.results![index].posterPath==null?Colors.grey.shade400:null,
                                      ),
                                      
                                      width: MediaQuery.of(context).size.width*0.35,
                                      height: 80,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: data.results![index].posterPath==null?
                                        Center(
                                          child: Text(
                                            data.results![index].originalTitle.toString(),
                                            textAlign: TextAlign.center,
                                          ),
                                        ):
                                        Image.network(data.results![index].fullImageUrl,
                                          fit: BoxFit.fill,
                                          ),
                                        ),
                                    ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.45,
                                        child: Text(data.results![index].originalTitle.toString(),
                                        style: Styles.style14
                                        ),
                                      ),
                                    ),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.play_circle_outline_sharp,size: 35,color: Colors.white,),
                                  ),
                                  
                                ],
                              ),
                              ),
                          ),
                          const Divider(thickness: 1,color: Colors.transparent,height: 4,),
                        ],
                      ),
                    );
  }

   Widget _customAppbar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child:const Icon(Icons.arrow_back,color: Colors.white,
                    ),
                  ),
                   const Spacer(),
                   CommonComponent.iconCard(context, Icons.person,color: const Color(0xFF1F2340)),
                              
                ],
              ),
    );
  }

}