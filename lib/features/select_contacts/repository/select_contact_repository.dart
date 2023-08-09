import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final selectContactRepositoryProvider=Provider(
    (ref)=>SelectContactRepository(
        firestore: FirebaseFirestore.instance)
);
class SelectContactRepository{

  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

 Future<List<Contact>> getContacts() async{
    List<Contact> contacts=[];
    try{
          if(await FlutterContacts.requestPermission()){
         contacts=  await FlutterContacts.getContacts(withProperties: true);
          }
    }catch(e){
      debugPrint(e.toString());
    }
    return  contacts;

  }
}