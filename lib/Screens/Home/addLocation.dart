import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddLocation extends StatelessWidget{

  final address;
  final latitude;
  final longitude;
  AddLocation(this.address,this.latitude,this.longitude);

  TextEditingController notes = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('notes');


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: (){
            ref.add({
              'address': address,
              'latitude': latitude,
              'longitude': longitude,
              'notes': notes.text
            }).whenComplete(() => Navigator.pop(context));
          },
          style: TextButton.styleFrom(primary: Color(0xFF0F0F0F)),
              child: Text('Save'))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:Column(
          children:[
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Column(
                  children:[
                    Text(address),
                    Text(latitude),
                    Text(longitude)
                  ],
            )),
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  controller: notes,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(hintText:'Notes'),
                ),
              ),
            ),
          ],
        )

      )
    );
  }
}
