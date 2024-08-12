// import 'package:flutter/material.dart';
// import 'package:intellij_tourism_designer/route_utils.dart';
// import 'package:intellij_tourism_designer/constants/theme.dart';
// import 'package:intellij_tourism_designer/widgets/detail_view.dart';
//
// //编辑行程
//
// class ItiEditWidget extends StatefulWidget {
//   final Itinerary curIti;
//   const ItiEditWidget({required this.curIti,super.key});
//
//   @override
//   State<ItiEditWidget> createState() => _ItiEditWidgetState();
// }
//
// class _ItiEditWidgetState extends State<ItiEditWidget> {
//   int curDay=0;
//   _ItiEditWidgetState();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Row(
//           children:[
//             Flexible(
//               flex:1,
//               child: _days(),
//             ),
//             Flexible(
//               flex:5,
//               child: Column(
//                 crossAxisAlignment:CrossAxisAlignment.center,
//                 children:[
//                   const SizedBox(height:5),
//                   SizedBox(
//                     height:100,
//                     child: weatherView(widget.curIti.weathers[curDay])
//                   ),
//                   const SizedBox(height:5),
//                   SizedBox(
//                       height:500,
//                       child: ListView(
//                         children:List.generate(widget.curIti.days[curDay].length,(index)=>
//                           ActCard(curAct: widget.curIti.days[curDay][index])
//                         )
//                       ),
//                     ),
//                   TextButton(
//                       onPressed:(){
//                         widget.curIti.days[curDay].add(sampleAct);
//                         setState((){});
//                       },
//                       style:AppButton.button1,
//                       child:const Icon(Icons.add),
//                     )
//                   ]
//                 )
//               )
//
//           ]
//         ),
//       ),
//     );
//   }
//
//   Widget _days(){
//     return Container(
//         color:AppColors.primary,
//         child:Column(
//           children: [
//             GestureDetector(
//               onTap: (){RouteUtils.pop(context);},
//               child: Container(
//                 child: Icon(Icons.arrow_back_ios),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemBuilder: (context, index){
//                   return TextButton(
//                       onPressed:(){setState(() {curDay=index;});},
//                   style:curDay==index?AppButton.button2:AppButton.button1,
//                   child:Text("Day${index+1}")
//                   );
//                 },
//                 itemCount: widget.curIti.days.length,
//               )
//             ),
//             TextButton(
//               onPressed:(){
//                 widget.curIti.days.add([]);
//                 widget.curIti.weathers.add(sampleWeather);
//                 setState(() {curDay=widget.curIti.days.length-1;});
//               },
//               style:AppButton.button1,
//               child:const Text("Add"),
//             )
//           ],
//         )
//     );
//   }
//
//   Widget weatherView(Weather curWea){
//     return const Row(
//       children:[
//         Flexible(
//           flex:3,
//           child:Icon(Icons.sunny,color:AppColors.primary),
//         ),
//         Flexible(
//           flex:5,
//           child:Column(
//             children:[
//               Text("时间",style: AppText.Head2),
//               Text("天气",style: AppText.Head2),
//               Text("温度",style: AppText.Head2),
//             ]
//           )
//         )
//       ]
//     );
//   }
// }
