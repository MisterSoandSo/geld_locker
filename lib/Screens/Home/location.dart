// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geld2/screens/home/addLocation.dart';
import 'package:geld2/screens/home/editLocacation.dart';
import 'package:geld2/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  String currentAddress = 'Obtaining Current Location ...';
  Position currentposition;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);

    }
  }

  final ref = FirebaseFirestore.instance.collection('notes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocation Data Locker'),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder:(context,AsyncSnapshot<QuerySnapshot> snapshot){
          return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.hasData?snapshot.data.docs.length:0,
              itemBuilder: (_,index){
                var temp = snapshot.data.docs[index];
                return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          EditLocation(
                            docToEdit: snapshot.data.docs[index]
                          )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(17),
                      height: 150,
                      color: Colors.grey[200],
                      child:Column(
                        children: [
                          Text(temp['address']),
                          Text(temp['latitude']),
                          Text(temp['longitude']),
                          Text(temp['notes']),
                        ],
                      ),
                    )
                );

              });
        }
      ),


     
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
            backgroundColor: kPrimaryColor,
            onPressed:() async {
              await _determinePosition();
              Navigator.push(context, MaterialPageRoute(builder: (_)=>AddLocation(
                currentAddress,
                currentposition.latitude.toString(),
                currentposition.longitude.toString())

              ));

        }),

    );
  }
}






