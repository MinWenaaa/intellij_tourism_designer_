import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:intellij_tourism_designer/helpers/comment_list.dart';
import 'package:intellij_tourism_designer/helpers/poi_detail_data.dart';
import 'package:intellij_tourism_designer/models/home_view_model.dart';
import 'package:intellij_tourism_designer/route_utils.dart';
import 'package:provider/provider.dart';

class Poidetailpage extends StatefulWidget {
  final num id;
  const Poidetailpage({super.key, required this.id});

  @override
  State<Poidetailpage> createState() => _PoidetailpageState();
}

class _PoidetailpageState extends State<Poidetailpage> {

  POIDetialViewModel viewModel = POIDetialViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.getPoi(id: widget.id).then((onValue){
      viewModel.getComment(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context){return viewModel;},
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Selector<POIDetialViewModel, PoiDetail?>(
                  selector: (context, vm)=> vm.poi,
                  builder: (context, poi, child)=> Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bannerView(poi?.pphoto),
                      Row(
                        children: [
                          Icon(Icons.photo, size: 50,),
                          Text(poi?.pname??"加载中"),
                          Text(poi?.pclass??"")
                        ],
                      ),
                      Text(poi?.pintroduceLong??""),
                      _TextView(Head: "时间", content: poi?.popenTime??""),
                      _TextView(Head: "地址", content: poi?.paddress??""),
                      _TextView(Head: "推荐时间", content: poi?.precommendedDuration??""),
                      _TextView(Head: "等级", content: poi?.pgrade??""),
                      _TextView(Head: "等级", content: poi?.plevel??""),
                      _TextView(Head: "电话", content: poi?.pphonenumber??"meiyou"),
                      _TextView(Head: "预算", content: poi?.pprice??""),
                      _TextView(Head: "等级", content: poi?.prank??""),
                      SizedBox(height: 50,),
                      _CommentList()
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){RouteUtils.pop(context);},
                  child: Container(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                )
              ]
            ),
          ),
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

  Widget _TextView({required String Head, required String content}){
    return RichText(text: TextSpan(
      children: [
        TextSpan(text: "${Head}：", style: TextStyle(fontSize: 14, color: Colors.black87)),
        TextSpan(text: content, style: TextStyle(fontSize: 14, color: Colors.black54))
      ]
    ));
  }

  Widget _CommentList(){
    return Consumer<POIDetialViewModel>(builder: (context, vm, child) {
      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vm.commentList?.length ?? 0,
          itemBuilder: (context, index) {
            return _CommentView(vm.commentList?[index]);
          });
    });
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
                return Image.network(data!.cphoto?[index]??"",
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
