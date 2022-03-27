import 'package:flutter/material.dart';
import 'package:riverpod_movieapp_module/model/movie_detail_model.dart';
import 'package:riverpod_movieapp_module/widget/styles.dart';

class CommonComponent{

  static Widget getRating(BuildContext context,int index1,double rating){
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child:
       index1+1==6?
       Text( rating.toString(),
       style: Styles.style15
       ):
       Icon( rating.ceil()==index1+1?
              Icons.star_half:Icons.star,
              size: 12.0,
              color: 
              index1+1<=rating.floor()||rating.ceil()==index1+1? Colors.yellow: const Color(0xFFE0E0E0),
            ),
    );
  }

  static Card iconCard(BuildContext context,IconData icon,{Results? data,Color color = const Color(0xFF12172E)}) {
    return Card(
                  color: color,
                  shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                  child: data!=null &&
                  data.authorDetails!.avatarPath.toString()[1].toLowerCase()=='h'?
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(data.authorDetails!.avatarPath.toString().substring(1),fit: BoxFit.fill,))):
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(icon,color: Colors.white,),
                  ),);
  }

  static Widget notFound(BuildContext context){
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '(=\'X\'=)',
            style: TextStyle(
              fontSize: 80,
              color: Colors.grey.shade700
            ),
          ),
          Text(
            'Not Found',
            style: TextStyle(
              fontFamily: 'NotoSerif',
              fontSize: 20,
              color: Colors.grey.shade500
            ),
          )
        ],
      ),
    );
  }
 
}