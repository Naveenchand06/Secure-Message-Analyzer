import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safe_messages/repo/all_list_repo.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            Contact contact = contacts[index];
            return Column(children: [
              ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
                title: Text(contact.displayName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(getPhone(contact)),
                    Text(getEmail(contact)),
                  ],
                ),
              ),
              const Divider()
            ]);
          },
        ),
      ),
    );
  }

  String getPhone(Contact con) {
    if (con.phones.isNotEmpty) {
      return con.phones.first.number;
    }
    return '-';
  }

  String getEmail(Contact con) {
    if (con.emails.isNotEmpty) {
      return con.emails.first.address;
    }
    return '-';
  }
}
