import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class Gmap extends StatefulWidget {
  Gmap();
  @override
  State<Gmap> createState() => GmapState();
}

class GmapState extends State<Gmap> {
  LatLng myLocation = LatLng(23.120207, -82.307595);

  _handleTap(LatLng point) {
    setState(() {
      myLocation = point;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 300,
          child: FlutterMap(
            options:
                MapOptions(center: myLocation, zoom: 11.0, onTap: _handleTap),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: myLocation,
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.place,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 15,
          left: 15,
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search..."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {},
                    splashColor: Colors.grey,
                    icon: Icon(
                      Icons.pin_drop,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
