import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import '../../widgets/calendar.dart';

class ItiListPage extends StatefulWidget {

  final Function changeNavigate;
  const ItiListPage({required this.changeNavigate, super.key});

  @override
  State<ItiListPage> createState() => _ItiListPageState();

}

class _ItiListPageState extends State<ItiListPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 18,),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Calendar(),
          ),
          const Divider(),
          const SizedBox(height: 18,),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){
                return GestureDetector(
                    onTap: () => widget.changeNavigate.call(),
                    child: ItiCard(),
                );;
              },
              itemCount: 10,
            ),
          )
        ]
      )
    );
  }



}
