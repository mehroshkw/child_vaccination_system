import 'package:child_vaccination_system/views/reusable_widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReminderScreen extends StatelessWidget {
  final String email;

  const ReminderScreen({required this.email, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reminders'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('email', isEqualTo: email)
            .where('appointmentStatus', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Data is still loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return const Center(child: Text('Error loading reminders', style: TextStyle(
                color: Colors.black,
                fontSize: 15
            )));
          } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            // No reminders available
            return const Center(child: Text('No reminders for today', style: TextStyle(
                color: Colors.black,
                fontSize: 15
            )));
          } else {
            // Data is available
            final reminders = snapshot.data!.docs;

            // Filter appointments for today and future dates
            final todayAndFutureReminders = reminders.where((reminder) {
              final appointmentData = reminder.data() as Map<String, dynamic>;
              final String appointmentDateString = appointmentData['appointmentDate'];
              final appointmentDate = DateFormat('dd/MM/yyyy').parse(appointmentDateString);
              return appointmentDate.isAfter(currentDate) || appointmentDate.isAtSameMomentAs(currentDate);
            }).toList();

            if (todayAndFutureReminders.isEmpty) {
              return const Center(child: Text('No reminders for today', style: TextStyle(
                  color: Colors.black,
                  fontSize: 15
              )));
            }

            return ListView.builder(
              itemCount: todayAndFutureReminders.length,
              itemBuilder: (context, index) {
                final reminderData = todayAndFutureReminders[index].data() as Map<String, dynamic>;
                // You can now access specific fields and display the reminder
                final String hospitalName = reminderData['hospitalName'];
                final String appointmentDate = reminderData['appointmentDate'];
                final String vaccineName = reminderData['vaccineName'];
                final String name = reminderData['name'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Appointment: $hospitalName'),
                    subtitle: Text('Date: $appointmentDate\nVaccine: $vaccineName for $name', style: TextStyle(
                        color: Colors.black,
                        fontSize: 13
                    )),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
