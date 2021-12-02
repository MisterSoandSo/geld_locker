import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart ';

class EditLocation extends StatefulWidget {
  DocumentSnapshot docToEdit;
  EditLocation({this.docToEdit});

  @override
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {


  TextEditingController notes = TextEditingController();
  @override
  void initState(){
    notes = TextEditingController(text:widget.docToEdit['notes']);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: (){
                widget.docToEdit.reference.update(
                    {'notes':notes.text}
                    ).whenComplete(() => Navigator.pop(context));},
                style: TextButton.styleFrom(primary: Color(0xFF0F0F0F)),
                child: Text('Update')),
            TextButton(onPressed: (){
              widget.docToEdit.reference.delete().whenComplete(() => Navigator.pop(context));},
                style: TextButton.styleFrom(primary: Color(0xFF0F0F0F)),
                child: Text('Delete')),
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
                        Text(widget.docToEdit['address']),
                        Text(widget.docToEdit['latitude']),
                        Text(widget.docToEdit['longitude']),
                        Text(widget.docToEdit['notes'])
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
