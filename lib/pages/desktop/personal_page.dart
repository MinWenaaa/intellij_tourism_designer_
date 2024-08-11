import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/pages/mobile/iti_list_page.dart';
import 'package:intellij_tourism_designer/pages/login_page.dart';
import 'package:intellij_tourism_designer/pages/mobile/memory_list_page.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:intellij_tourism_designer/widgets/detail_view.dart';
import '../../widgets/calendar.dart';

/*
  个人主页
*/

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: _ItiList()
        ),
        Flexible(
          flex: 5,
          child: _MemoryList()
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 5,
          child: _UserCard(context)
        ),
      ],
    );
  }

  Widget _UserCard(BuildContext context){
    return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            RouteUtils.push(context, LoginPage());
          },
          child: ClipOval(
            child: Image.network("https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                width:180,height:180,
                fit:BoxFit.cover
            ),
          ),
        ),
        SizedBox(height: 20,),
        Text("UserName"),
        SizedBox(height: 50,)
      ],
    )
    );
  }

  Widget _MemoryList(){
    return Column(
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
              itemBuilder: (context, index) => GestureDetector(
                  onTap: (){},
                  child: ItiCard(),
              ),
              itemCount: 10,
            ),
          )
        ]
    );
  }

  Widget _ItiList(){
    return Column(
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
                  onTap: () {},
                  child: ItiCard(),
                );;
              },
              itemCount: 10,
            ),
          )
        ]
    );
  }

}