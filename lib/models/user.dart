import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String subject;
  bool completed;
  String userId;
  String email;
  String password;
  String newpassword;
  String phonenumber;
  String fullname;
  bool isAdmin;
  bool isUpdating;
  String verifcode;
  String resettype;

  User({this.subject, this.userId, this.completed, this.email, this.password, this.newpassword, this.fullname, 
  this.phonenumber, this.isAdmin, this.isUpdating, this.verifcode, this.resettype});

  User.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    subject = snapshot.value["subject"],
    completed = snapshot.value["completed"],
    email = snapshot.value["email"],
    password = snapshot.value["password"],
    newpassword = snapshot.value["newpassword"],
    fullname = snapshot.value["fullname"],
    phonenumber = snapshot.value["phonenumber"],
    isAdmin = snapshot.value["isAdmin"],
    isUpdating = snapshot.value["isUpdating"],
    verifcode = snapshot.value["verifcode"],
    resettype = snapshot.value["resettype"];


  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
      "email": email,
      "phonenumber": phonenumber,
      "fullname": fullname,
      "isAdmin": isAdmin,
      "isUpdating": isUpdating,
      "resettype": resettype,
    };
  }
  
  factory User.fromFirestore(DocumentSnapshot document) {
    Map data = document.data;
    return User (
      userId: document.documentID,
      email: data['email'] ?? '',
      phonenumber: data['phonenumber'] ?? '',
      fullname: data['fullname'] ?? '',
      isUpdating: data['isUpdating'] ?? '',
      isAdmin: data['isAdmin'] ?? false,
      resettype: data['resettype'] ?? false,
    );
  }

}