import 'package:flutter/material.dart';
import '../../widgets/detail_view.dart';

/*
用户的出行记录列表
 */

class MemoryListPage extends StatefulWidget {

  final Function changeNavigate;
  const MemoryListPage({required this.changeNavigate, super.key});

  @override
  State<MemoryListPage> createState() => _MemoryListPageState();
}

class _MemoryListPageState extends State<MemoryListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView.builder(
          itemBuilder: (context, index){
            return _Item();
          },
          itemCount: 10,
        ),

    );
  }

  Widget _Item(){
    return GestureDetector(
      onTap: () => widget.changeNavigate.call(),
      child: ItiCard(),
    );
  }
}
