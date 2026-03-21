import 'package:flutter/material.dart';

import '../models/contact/contact_details.dart';
import '../widgets/contact_card.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    super.key,
    required this.contacts,
  });
  
  final List<ContactDetails> contacts;

  Widget _buildRegular(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactCard(
          contact: contacts[index],
          onTapped: (){},
        );
      },
    );
  }

  Widget _buildCompact(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(4.0),
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return ContactCard(
          contact: contacts[index],
          onTapped: (){},
          isCompact: true,
        );
      },
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 90,
        mainAxisExtent: 70,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxHeight < 500 ?
          _buildCompact(context):
          _buildRegular(context);
      },
    );
  }  
}