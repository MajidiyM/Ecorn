import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

class MapsOrder extends StatefulWidget {
  static final routeName = "MapsOrder";

  @override
  _MapsOrderState createState() => _MapsOrderState();
}

class _MapsOrderState extends State<MapsOrder> {
  @override
  void initState() {
    super.initState();

    Marker position = Marker(
      markerId: MarkerId('Me'),
      position: LatLng(0.0, 0.0),
      infoWindow: InfoWindow(title: 'Ecorn ул.Мирабад'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );

    setState(() {
      if (markers.length == 0) {
        markers[MarkerId('Me')] = position;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          actions: <Widget>[
            MaterialButton(
                child: Text('Выбрать'),
                textColor: Colors.white,
                onPressed: () async {
                  var loc = markers[MarkerId('Me')];
                  Map data = Map();

                  final coordinates = new Coordinates(
                      loc.position.toJson()[0], loc.position.toJson()[1]);
                  var addresses = await Geocoder.local
                      .findAddressesFromCoordinates(coordinates);
                  var first = addresses.first;
//                  print("${first.featureName} : ${first.addressLine}");

                  data['coordinates'] = loc.position.toJson();
                  data['address'] = "${first.addressLine}";

                  Navigator.pop(context, data);
                }),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(41.3094991, 69.2716149), zoom: 13),
                onMapCreated: (GoogleMapController controller) {},
//                markers: Set<Marker>.of(markers.values),
                onCameraMove: (CameraPosition position) {
                  if (markers.length > 0) {
                    MarkerId markerId = MarkerId('Me');
                    Marker marker = markers[markerId];
                    Marker updatedMarker = marker.copyWith(
                      positionParam: position.target,
                    );

                    setState(() {
                      markers[markerId] = updatedMarker;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.room,
                  color: Color(0xFF00633E),
                  size: 40,
                ),
              ),
            ),
          ],
        ));
  }
}
