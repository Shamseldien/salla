import 'package:flutter/material.dart';
import 'package:salla/shared/style/colors.dart';
import 'package:salla/shared/style/styles.dart';
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Expanded(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10),
           child: ListView.separated(
             physics: BouncingScrollPhysics(),
               itemBuilder: (context,index)=>Padding(
                 padding: const EdgeInsets.symmetric(vertical: 10),
                 child: Container(
                   child: Row(
                     children: [
                       Container(
                           height:120,
                           width: 110,
                           child: Image(image: NetworkImage('https://student.valuxapps.com/storage/uploads/products/1615440322npwmU.71DVgBTdyLL._SL1500_.jpg'))),
                       Expanded(
                         child: Column(
                           children: [
                             Text('Apple iPhone 12 Pro Max 256GB 6 GB RAM, Pacific Blue',),
                             SizedBox(height: 10,),
                             Row(
                               children: [
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Row(
                                       children: [
                                         Text('25000 ',style: black14().copyWith(color: Colors.blue),),
                                         Text('SAR',style: black12().copyWith(color: Colors.blue),),
                                       ],
                                     ),
                                     Row(
                                       children: [
                                         Text('26000',style: black12().copyWith(

                                           color: Colors.grey,
                                           fontSize: 12,
                                           decoration: TextDecoration.lineThrough
                                         ),),
                                         Padding(
                                           padding: const EdgeInsets.symmetric(
                                             horizontal: 5.0,
                                           ),
                                           child: Container(
                                             width: 1.0,
                                             height: 10.0,
                                             color: Colors.grey,
                                           ),
                                         ),

                                         Text('2%',style: black12().copyWith(color: Colors.red),),

                                       ],
                                     ),
                                   ],
                                 ),
                                 Spacer(),
                                 IconButton(icon: Icon(Icons.remove), onPressed: (){}),
                                 Text('2'),
                                 IconButton(icon: Icon(Icons.add), onPressed: (){}),

                               ],
                             )
                           ],
                         ),
                       )
                     ],
                   ),

                 ),
               ),
               separatorBuilder: (context,index)=>Container(height: 1,width: double.infinity,color: Colors.grey[200],),
             itemCount: 10,
           ),
         ),
       ),
        Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          color: Colors.grey[200],
          child: Center(child: Text('Total 546455 SAR')),
        ),
        Container(
            width: double.infinity,
            color: btnColor,
            height: 40,
            child: MaterialButton(
              onPressed: (){},child: Text('Check out'),))

      ],
    );
  }
}
