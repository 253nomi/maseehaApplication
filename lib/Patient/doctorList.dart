import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maseeha_update/Assistants/firestore_assitant.dart';
import 'package:maseeha_update/Patient/newAppointmentdata.dart';
import 'package:maseeha_update/localization/demo_localization.dart';
import 'package:provider/provider.dart';
import '../doctorsdata.dart';
import '../lang_selector.dart';
import 'loginPatientData.dart';
import 'newAppointment.dart';
//import 'package:path/path.dart';

class DoctorList extends StatelessWidget {
  static const String id = 'doctors_list';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final patientEmail =
        context.read<LoginPatientData>().getCurrentPatientData();

    final firestoreAssitant = FirestoreAssitant();
    final newApponitmentData =
        Provider.of<NewAppointmentData>(context, listen: false);

    void takeAnAppointment(BuildContext context) => showDialog(
        context: context,
        builder: (_) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Container(
                child: Center(
                  child: Text(
                    DemoLocalization.of(context).getTranslatedValue('fillform'),
                    style: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              content: NewAppointment(),
              actions: [
                FlatButton(
                    child: Text(
                      DemoLocalization.of(context).getTranslatedValue('submit'),
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      try {
                        print('Uploading data');
                        firestoreAssitant.sendAppointment(newApponitmentData);
                        Navigator.pop(context);
                      } catch (_) {
                        print('Failed to upload');
                      }
                    }),
                FlatButton(
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    }),
              ],
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            right: size.width / 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: size.width * 0.28,
                child: Center(
                  child: Text(
                    DemoLocalization.of(context).getTranslatedValue('title'),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                left: size.width / 30,
                right: size.width / 30,
              ),
              child: LangSelector()),
        ],
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width / 8,
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('doctors').snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final doctors = snapshot.data.docs;
                print(doctors.length);

                List<Widget> doctorCards = [];
                for (var doctor in doctors) {
                  Doctor doc = Doctor.fromJson(doctor.data());
                  print(doc.fullName);
                  doctorCards.add(Container(
                    padding: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Card(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          children: [
                            Container(
                              height: size.height / 10,
                              width: 120,
                              margin: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                /* image: DecorationImage(
                                      image: NetworkImage(
                                          'https://www.google.com/url?sa=i&url=https://flutterappworld.com/a-high-performance-flutter-widget-to-render-bottts-svg-avatars/&psig=AOvVaw0pbd2aLdtAYDPZSY8ZCbFK&ust=1605966714142000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCODx_sSike0CFQAAAAAdAAAAABAJ'),
                                    ), */
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                            Container(
                              height: 180,
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(size.width / 30),
                                    child: Text(
                                      doc.fullName ?? 'No data',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    doc.hospital ?? 'No data',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    doc.docEmail ?? 'No data',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    doc.specialization ?? 'No data',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  FlatButton(
                                    child: Text(
                                      'Click Here ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    onPressed: () {
                                      try {
                                        context
                                            .read<NewAppointmentData>()
                                            .doctorName = doc.fullName;
                                        context
                                            .read<NewAppointmentData>()
                                            .docEmail = doc.docEmail;
                                        context
                                            .read<NewAppointmentData>()
                                            .patientEmail = patientEmail;
                                        takeAnAppointment(context);
                                      } catch (err) {
                                        print(err.toString());
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
                }
                return ListView(
                  children: doctorCards,
                );
              },
            )),
      ),
    );
  }
}