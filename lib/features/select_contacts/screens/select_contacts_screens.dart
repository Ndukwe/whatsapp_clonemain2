import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/error.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const String routeName='/select-contact';
  const SelectContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(onPressed: () {  }, icon: const Icon(
              Icons.search
          ),),
          IconButton(onPressed: () {  }, icon: const Icon(
              Icons.more_vert
          ),)
        ],
      ),
      body: ref.watch(getContactsProvider).
      when(data: (contactList) =>ListView.builder(
        itemCount: contactList?.length,
        itemBuilder:(context,index) {
          final contact=contactList[index];
          return ListTile(
            title: Text(
              contact.displayName,
            ),
          );
        },),
          error: (err,trace)=>
          ErrorScreen(error: err.toString()), loading: ()=>const Loader()),
    );
  }
}
