import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intellij_tourism_designer/constants/constants.dart';
import 'package:intellij_tourism_designer/constants/theme.dart';
import 'package:intellij_tourism_designer/helpers/Iti_data.dart';
import 'package:intellij_tourism_designer/helpers/record_list_data.dart';
import 'package:intellij_tourism_designer/helpers/weather_data.dart';
import 'package:intellij_tourism_designer/http/Api.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/poi_list_view_data.dart';


class POIListItem extends StatelessWidget {

  const POIListItem({super.key, required this.poi, required this.height});
  final PoiListViewData poi;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: height,
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
                    const Expanded(child: SizedBox()),
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

  final PlanListViewData data;
  const ItiCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 120,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: AppColors.highlight
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
                  Text(data.name??"新建行程", style: AppText.Head2,),
                  Text(data.edittime??"2024-8-11 0:00:00.0000",
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
              data.pic??"https://gd-hbimg.huaban.com/feeb8703425ac44d7260017be9b67e08483199c06699-i8Tdqo_fw1200webp",
              fit: BoxFit.cover,
              width: double.infinity, height: double.infinity,
            )
          )
        ],
      ),
    );
  }
}

class RecordCard extends StatelessWidget {

  final RecordListViewData data;
  const RecordCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.highlight
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
                  Text(data.name??"", style: AppText.Head2,
                    overflow: TextOverflow.clip, // 裁剪超出部分
                    maxLines: 2,),
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

  const ActCard({super.key, required this.itiData});
  final ItiData itiData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.secondary
      ),
      margin: EdgeInsets.only(top: 20, bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Text(itiData.pname??"未知点"),
                Text(itiData.pintroduceShort??"")
              ],
            ),
          ),
          Flexible(
              flex: 2,
              child: Image.network(itiData.pphoto ??
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



class WeatherText extends StatefulWidget {

  final LatLng location;
  final double width;
  final double height;

  const WeatherText({super.key, required this.location, required this.width, required this.height});

  @override
  State<WeatherText> createState() => _WeatherTextState();
}

class _WeatherTextState extends State<WeatherText> {

  late Future<WeatherData> weatherData;

  Future<WeatherData> fetchWeather() async {
    WeatherData weatherData = await Api.instance.getWeather(location: widget.location, date: DateTime.now())??WeatherData();
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



class WeatherCard extends StatefulWidget {

  final DateTime date;

  const WeatherCard({super.key, required this.date});

  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {

  late Future<WeatherData> weatherData;

  Future<WeatherData> fetchWeather() async {
    WeatherData weatherData = await Api.instance.getWeather(location: const LatLng(30.5,114.3), date: widget.date)??WeatherData();
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
      child: FutureBuilder<WeatherData>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _weather(snapshot.data!);
          } else {
            return Center(
                child: SizedBox(
                  width: 36, height: 36,
                    child: const CircularProgressIndicator(color: AppColors.primary,)));
          }
        },
      ),
    );
  }

  Widget _weather(WeatherData weather){
    Random random = Random();
    int randomNumber = random.nextInt(4);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" ${widget.date.year}.${widget.date.month}.${widget.date.day}, ${ConstantString.weekDay[widget.date.weekday-1]}",
                style: const TextStyle(fontSize: 26, color: AppColors.detail),),
              const SizedBox(height: 6,),
              Container(
                width: 240, height: 36,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.primary
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("天气：", style: TextStyle(fontSize: 14, color: Colors.white),),
                    const Icon(Icons.cloud, color: Colors.white,),
                    const SizedBox(width: 14),
                    Text("温度：  ${weather.now?.temp} ", style: const TextStyle(fontSize: 16, color: Colors.white),),

                  ],
                ),
              ),
            ],
          ),
          Image.network(ConstantString.weather_icon[randomNumber],
              fit: BoxFit.contain, width: 140, height: 140,),
        ],
      ),
    );

  }


}
