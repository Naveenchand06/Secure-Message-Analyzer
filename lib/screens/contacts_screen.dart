import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
      ),
      body: SizedBox(
        height: double.infinity,
        child: FutureBuilder(
          future: getContacts(),
          builder: (context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Contacts List are empty',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Contact contact = snapshot.data[index];

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
                    });
              default:
                return const Text('Something Went wrong');
            }
          },
        ),
      ),
    );
  }

  Future<List<Contact>> getContacts() async {
    bool isGranted = await Permission.contacts.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.contacts.request().isGranted;
    }
    if (isGranted) {
      return await FastContacts.getAllContacts();
    }
    return [];
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
