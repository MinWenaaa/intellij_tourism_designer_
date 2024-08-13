import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/weather_data.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/poi_list_view_data.dart';

class POIListItem extends StatelessWidget {

  const POIListItem({super.key, required this.poi});
  final PoiListViewData poi;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: 120,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.detail, width:0.5),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(poi.pname ?? "", style: AppText.Head2,),
                    Text(poi.pintroduceShort ?? "",
                      overflow: TextOverflow.clip, // 裁剪超出部分
                      maxLines: 2,
                      style: AppText.matter,),
                    Text(poi.paddress ?? "",
                      overflow: TextOverflow.clip, // 裁剪超出部分
                      maxLines: 1,
                      style: AppText.detail,
                    )
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 2,
                child: Image.network(poi.pphoto ??
                    "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
                  fit: BoxFit.cover,
                  width: double.infinity, height: double.infinity,
                )
            )
          ],
        )
    );
  }
}


class ItiCard extends StatelessWidget {

  const ItiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 120,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.secondary
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("新建行程", style: AppText.Head2,),
                  Text("2024-8-11 0:00:00.0000",
                    overflow: TextOverflow.clip, // 裁剪超出部分
                    maxLines: 2,
                    style: AppText.detail,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Image.network(
              "https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
              fit: BoxFit.cover,
              width: double.infinity, height: double.infinity,
            )
          )
        ],
      ),
    );
  }
}

class ActCard extends StatelessWidget {

  const ActCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Flexible(
          flex:3,
          child:Column(
            children:[
              Row(
                children:[
                  const Icon(Icons.abc),
                  Text("poiName",style:AppText.matter),
                ]
              ),
              const Text("时间：",style:AppText.matter)
            ]
          )
        ),
        Flexible(
          flex:2,
          child:Image.network("https://gd-hbimg.huaban.com/b0053b05eb42accdcd2a832f26f043d19a5a3809b12-lJacpy_fw1200webp")
        ),
      ]
    );
  }
}



class WeatherCard extends StatefulWidget {

  final LatLng location;
  final double width;
  final double height;

  const WeatherCard({super.key, required this.location, required this.width, required this.height});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {

  late Future<WeatherData> weatherData;

  Future<WeatherData> fetchWeather() async {
    WeatherData weatherData = await Api.instance.getWeather(location: widget.location)??WeatherData();
    return weatherData;
  }

  @override
  void initState() {
    super.initState();
    weatherData = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width, height: widget.height,
      child: FutureBuilder<WeatherData>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _weather(snapshot.data!);
          } else {
            return const CircularProgressIndicator(color: AppColors.primary,);
          }
        },
      ),
    );
  }

  Widget _weather(WeatherData weather){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.cloud, color: Colors.white,size: 28,),
            const SizedBox(width: 10,),
            Text(weather.now?.text??"", style: AppText.matter,),
          ],
        ),
        Text("气压：${weather.now?.pressure??""}", style: AppText.matter,),
        Text("风向：${weather.now?.windDir??""}", style: AppText.matter,),
        Text("风速：${weather.now?.windSpeed??""}", style: AppText.matter,),
        Text("日出：${weather.sunrise??""}", style: AppText.matter,),
        Text("日落：${weather.sunset??""}", style: AppText.matter,),
      ],
    );
  }

}

