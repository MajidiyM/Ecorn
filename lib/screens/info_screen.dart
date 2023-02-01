import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ecorn/widgets/nav.dart';
import 'package:ecorn/widgets/info_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

List points = [
  {
    "image": "http://ecorn.uz/images/content/slide-s-1.jpg",
    "lat": 41.309708,
    "long": 69.292308,
    "name": "Ecorn Ц-1 (ул. Азимова)",
    "phone1": "+99895 146 00 92",
    "phone2": "+99871 215 51 79"
  },
  {
    "image": "http://ecorn.uz/images/content/slide-m-1.jpg",
    "lat": 41.297791,
    "long": 69.267748,
    "name": "Ecorn (ул. Мирабад)",
    "phone1": "+99895 146 00 91",
    "phone2": "+99871 236 15 76"
  },
  {
    "image": "http://ecorn.uz/images/content/slide-m-2.jpg",
    "lat": 41.306850,
    "long": 69.270927,
    "name": "Ecorn (ул. Чимкентской)",
    "phone1": "+99895 146 0090",
    "phone2": ""
  }
];

class InfoScreen extends StatefulWidget {
  static final routeName = 'infoScreen';

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'О нас',
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: 'Rubik',
          ),
        ),
      ),
      drawer: NavDrawer(),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                child: _buildContainer(),
              ),
              divider,
              Container(
                height: 400.0,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    _buildGoogleMap(context),
                  ],
                ),
              ),
              divider,
              Container(
                color: Color(0xFF00633E),
                height: 150.0,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AutoSizeText(
                      'Мы в социальных сетях',
                      maxLines: 1,
                      minFontSize: 0,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27.0,
                        fontFamily: 'GoogleSans',
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      thickness: 3,
                      color: Colors.white60,
                      indent: 25,
                      endIndent: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.only(
                            right: 15.0,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: () async {
                            await launch("https://www.facebook.com/ecornuz/");
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.only(
                            right: 15.0,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: () async {
                            await launch(
                                "https://www.instagram.com/ecorn_tashkent/");
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.only(
                            right: 15.0,
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.tripadvisor,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onPressed: () async {
                            await launch(
                                "https://www.tripadvisor.ru/Restaurant_Review-g293968-d7147876-Reviews-Ecorn-Tashkent_Tashkent_Province.html");
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          height: 250.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: points.length,
              itemBuilder: (BuildContext ctxt, int i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _boxes(points[i]),
                );
              })),
    );
  }

  Widget _boxes(Map data) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(data['lat'], data['long']);
      },
      child: Container(
        child: FittedBox(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color.fromRGBO(0, 0, 0, 0.65),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 320.0,
                    height: 200.0,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(data['image']),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Text(
                            data['name'],
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 24.0,
                            ),
                          )),
                          Container(
                              child: Text(
                            "Рабочее Время: 8:00 - 22:00",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          )),
                          Container(
                              child: Text(
                            data["phone1"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          )),
                          Container(
                              child: Text(
                            data["phone2"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(41.3094991, 69.2716149), zoom: 13),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {azimovaEcornMarker, mirabadEcornMarker, chimkentEcornMarker},
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

Marker azimovaEcornMarker = Marker(
  markerId: MarkerId('EcornAzimova'),
  position: LatLng(41.309708, 69.292308),
  infoWindow: InfoWindow(title: 'Ecorn ул.Азимова'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
Marker mirabadEcornMarker = Marker(
  markerId: MarkerId('Ecorn'),
  position: LatLng(41.297791, 69.267748),
  infoWindow: InfoWindow(title: 'Ecorn ул.Мирабад'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
Marker chimkentEcornMarker = Marker(
  markerId: MarkerId('ecornChimkent'),
  position: LatLng(41.306850, 69.270927),
  infoWindow: InfoWindow(title: 'Ecorn на Чимкентской'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
