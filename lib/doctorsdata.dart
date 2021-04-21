import 'package:flutter/foundation.dart';

class Doctor {
  @required
  final int id;
  @required
  final String fullName;
  @required
  final String pmdc;
  @required
  final String hospital;
  @required
  final String specialization;
  @required
  final String docEmail;

  Doctor(
      {this.id,
      this.fullName,
      this.pmdc,
      this.hospital,
      this.specialization,
      this.docEmail});

  factory Doctor.fromJson(Map<String, dynamic> map) {
    return Doctor(
        fullName: map['name'],
        pmdc: map['pmdc'],
        hospital: map['hospital'],
        specialization: map['specialization'],
        docEmail: map['docEmail']);
  }
}