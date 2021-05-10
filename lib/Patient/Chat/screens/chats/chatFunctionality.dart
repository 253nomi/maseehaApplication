import 'package:maseeha_update/classes/doctor.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ChatFunctionality extends StatefulWidget {
  @override
  
  _ChatFunctionalityState createState() => _ChatFunctionalityState();
}

class _ChatFunctionalityState extends State<ChatFunctionality> {

 // final FirebaseAuth _auth = FirebaseAuth.instance;
 // final _firestore = FirebaseFirestore.instance;
 
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

 
  @override
  Widget build(BuildContext context) {
     final doctorName = context.read<Doctor>().chatDoctorName;
    return Scaffold(
        appBar: AppBar(
          title: Text(doctorName,
          style: TextStyle(
            fontSize: 14
          ),),
          actions: [
        IconButton(
          icon: Icon(Icons.video_call),
          onPressed: () {
             
          },
        ),
      ],
        ),
              
    );
  }
}