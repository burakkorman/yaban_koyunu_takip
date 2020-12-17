import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Locations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Get Locations'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = Firestore.instance;
  List<LatLng> latlng = List();
  List<Map<String, dynamic>> locateList=new List<Map<String, dynamic>>();
  Set<Polyline> pline=Set<Polyline>();
  void getData() {

    databaseReference
        .collection("locates").orderBy("date")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
          List<LatLng> latlnglist=new List<LatLng>();
          setState(() {
            snapshot.documents.forEach((f){ //);
              locateList.add(f.data);
              latlnglist.add(LatLng(double.parse(f.data["latitude"]), double.parse(f.data["longtitude"])));
              print(locateList);
            });
            pline=new Set<Polyline>();
            pline.add(Polyline(polylineId: PolylineId("1"), points: latlnglist));
            });
        });
    }

@override
  void initState() {
    super.initState();
    pline.add(Polyline(polylineId: PolylineId("1"),width: 2,color: Colors.red));
    getData();
  }
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: LatLng(38.0034631, 32.5120886)),
        minMaxZoomPreference: MinMaxZoomPreference(12.0,100.0),
        polylines: pline,
      )

    );
  }
}

