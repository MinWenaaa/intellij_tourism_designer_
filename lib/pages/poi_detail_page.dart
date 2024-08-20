import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:provider/provider.dart';

import '../http/Api.dart';

class Poidetailpage extends StatefulWidget {
  final num id;
  const Poidetailpage({super.key, required this.id});

  @override
  State<Poidetailpage> createState() => _PoidetailpageState();
}

class _PoidetailpageState extends State<Poidetailpage> {

  late Future<PoiDetail> poi;
  CommentModel commentModel = CommentModel();

  List<String> text = ["CALL", "INFO", "ROUTE"];

  Future<PoiDetail> getPoi() async {
    PoiDetail poi = await Api.instance.getPoiDetail(widget.id)??PoiDetail();
    return poi;
  }

  @override
  void initState() {
    super.initState();
    poi = getPoi();
    commentModel.getComment(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<PoiDetail>(
          future: poi,
          builder: (context, snapshot) {
            return snapshot.hasData ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bannerView(snapshot.data?.pphoto),
                  _Head(snapshot.data),
                  _Icons(),
                  _Text(snapshot.data),
                  const SizedBox(height: 30,),
                  Divider(),
                  _CommentList()
                    ],
                  ),
                ): const Center(child: CircularProgressIndicator(),
            );

            }
            ),
          ),
        );
  }

  Widget _bannerView(List<String?>? photos){
    return SizedBox(
      height:240,
      child: Swiper(
        indicatorLayout: PageIndicatorLayout.COLOR,
        autoplay: true,
        itemCount: photos!.length,
        itemBuilder: (context,index){
          return Image.network(
            photos[index]!,
            fit: BoxFit.cover,
            width: double.infinity, height: double.infinity,
          );
        },
      ),
    );
  }

  Widget _Head(data){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 64.h, horizontal: 96.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data?.pname ?? "加载中", style: AppText.Head1, maxLines: 2, overflow: TextOverflow.clip,
          ),
          Text(data?.paddress ?? "", style: AppText.detail,),
        ],
      ),
    );
  }

  Widget _Icons(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 96.w, vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (index)=>
          Column(
            children: [
              Image.network(ConstantString.Icon_decoration[index], height: 128.r, width: 128.r,),
              Text(text[index], style: AppText.detail,)
            ],
          )),
      ),
    );
  }

  Widget _Text(data){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 96.w, vertical: 48.h),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data?.pintroduceLong ?? "",
              style: AppText.matter,
            ),
            SizedBox(height: 96.h,),
            Divider(),
            _TextView(
                Head: "时间", content: data?.popenTime ?? ""),
            _TextView(Head: "推荐时间",
                content: data?.precommendedDuration ?? ""),
            _TextView(
                Head: "等级", content: data?.pgrade ?? ""),
            _TextView(
                Head: "等级", content: data?.plevel ?? ""),
            _TextView(Head: "电话",
                content: data?.pphonenumber ?? "meiyou"),
            _TextView(
                Head: "预算", content: data?.pprice ?? ""),
            _TextView(Head: "等级", content: data?.prank ??
                ""),
          ]
      ),
    );
  }

  Widget _TextView({required String Head, required String content}){
    return RichText(text: TextSpan(
      children: [
        TextSpan(text: "${Head}：", style: AppText.matter),
        TextSpan(text: content, style: TextStyle(fontSize: 14, color: Colors.black54))
      ]
    ));
  }



  Widget _CommentList(){
    
    return ChangeNotifierProvider<CommentModel>(
      create: (context) => CommentModel(),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: commentModel.commentList?.length ?? 0,
        itemBuilder: (context, index) {
          print(commentModel.commentList);
          return _CommentView(commentModel.commentList?[index]);
          }
      )
    );
  }

  Widget _CommentView(CommentData? data){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network("https://gd-hbimg.huaban.com/0012232547458c7ce4599d0896c6ad5fc2cd8e4f368b7-bK8xeo_fw480webp",
                    width:30,height:30,
                    fit:BoxFit.cover
                ),
              ),
              Text("UserName"),
              Expanded(child: SizedBox()),
              Text(data?.ctime??"")
            ],
          ),
          Text(data?.ccontent??""),
          SizedBox(
            height:100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data!.cphoto?.length??0,
              itemBuilder: (comtext, index){
                return Image.network(data.cphoto?[index]??"",
                    fit:BoxFit.cover
                );
              }
            ),
          )
        ],
      )
    );
  }

}
