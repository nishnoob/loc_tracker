import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key? key,
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController mapController;
  final destinationDummy = {
    "lat": 37.33429383,
    "long": -122.06600055,
  };
  List<LatLng> polylineCoordinates = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void getPolyPoints() async {
    PolylinePoints linePoints = PolylinePoints();
    PolylineResult result = await linePoints.getRouteBetweenCoordinates(
      "AIzaSyBR0BT2wvOSZns8UWAt8FYoMvKCPHNKAcM",
      PointLatLng(widget.lat, widget.long),
      PointLatLng(destinationDummy["lat"]!, destinationDummy["long"]!),
    );

    if(result.points.isNotEmpty) {
      result.points.forEach((el) => polylineCoordinates.add(LatLng(el.latitude, el.longitude)));
    }
    setState(() {});
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.lat, widget.long),
        zoom: 13,
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
        )
      },
      markers: {
        Marker(
          markerId: MarkerId("source"),
          position: LatLng(widget.lat, widget.long),
        ),
        Marker(
          markerId: MarkerId("destination"),
          position: LatLng(destinationDummy["lat"]!, destinationDummy["long"]!),
        )
      }
    );
  }
}