import 'package:child_vaccination_system/views/modules/parent_module/appointment/book_family_appointment/book_family_appointment.dart';
import 'package:child_vaccination_system/views/modules/parent_module/reminder/reminder_screen.dart';
import 'package:child_vaccination_system/views/modules/parent_module/update_parent_profile/update_parent_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/local_storage.dart';
import '../../../reusable_widgets/sub_heading.dart';
import '../../auth_controller.dart';
import '../child/add_child/add_family_members.dart';
import '../child/edit_delete_child/update_child.dart';


class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthController authController = AuthController();

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String email = LocalStorage.getString("email");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Parents Dashboard",
        ),
        actions: [
          IconButton(onPressed: () => Get.to(ReminderScreen(email: email)), icon: const Icon(Icons.notifications_active_outlined)),
          IconButton(onPressed: () => Get.to(const UpdateParentProfile()), icon: const Icon(Icons.person_outline)),
          IconButton(onPressed: () => authController.logoutUser(), icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "My Family"),
            Tab(text: "My Appointments"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ChildTab(), AppointmentTab()],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(() => const AddFamilyMembers()),
              backgroundColor: AppColors.primaryColor,
              icon: const Icon(Icons.add),
              label: const Text('Add Family Member', style: TextStyle(fontWeight: FontWeight.bold)))
          : FloatingActionButton.extended(
              onPressed: () => Get.to(const BookFamilyAppointment()),
              backgroundColor: AppColors.primaryColor,
              icon: const Icon(Icons.add),
              label: const Text('Book Appointment', style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}

class ChildTab extends StatelessWidget {
  const ChildTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void deleteUser(String id) async {
      await FirebaseFirestore.instance.collection("family_members").doc(id).delete();
    }

    String email = LocalStorage.getString("email");

    return Scaffold(
        backgroundColor: Colors.black12,
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('family_members').where('email', isEqualTo: email).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading...");
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                    child: Text("No Family Members Yet",
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.black)));
              }
              return Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Swiple Right To Delete Child",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
                    const Icon(Icons.arrow_right_alt)
                  ]),
                  Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Dismissible(
                              onDismissed: (_) {
                                deleteUser(data['id']);
                              },
                              direction: DismissDirection.horizontal,
                              background: const Icon(Icons.delete_forever_rounded),
                              confirmDismiss: (DismissDirection direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text("Confirm"),
                                        content: const Text("Confirm Deletion of Child?"),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                                            child: const Text("Yes"),
                                          ),
                                          ElevatedButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
                                              child: const Text("Cancel"))
                                        ]);
                                  },
                                );
                              },
                              key: UniqueKey(),
                              child: Card(
                                  color: AppColors.primaryWhite,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(UpdateChild(
                                                genderC: data['gender'],
                                                dobC: data['dob'],
                                                relationshipC: data['relationship'],
                                                addressC: data['address'],
                                                nameC: data['name'],
                                                cnic_bFormC: data['cnic_bform'], id: data['id'],
                                              ));
                                            },
                                            child: const CircleAvatar(
                                                radius: 16,
                                                backgroundColor: AppColors.primaryColor,
                                                child: Icon(Icons.edit, size: 20)),
                                          ),
                                        ]),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Row(children: [
                                            const Subheading(
                                                text: "Name: ", color: AppColors.primaryColor, fontSize: 18),
                                            Subheading(text: data['name'], color: AppColors.blackColor, fontSize: 18)
                                          ]),
                                          Row(children: [
                                            const Subheading(
                                                text: "CNIC/B-Form: ", color: AppColors.primaryColor, fontSize: 16),
                                            Subheading(
                                                text: data['cnic_bform'], color: AppColors.blackColor, fontSize: 16)
                                          ]),
                                          Row(children: [
                                            const Subheading(
                                                text: "Address: ", color: AppColors.primaryColor, fontSize: 16),
                                            Subheading(text: data['address'], color: AppColors.blackColor, fontSize: 16)
                                          ]),
                                          Row(children: [
                                            const Subheading(
                                                text: "DOB: ", color: AppColors.primaryColor, fontSize: 16),
                                            Subheading(text: data['dob'], color: AppColors.blackColor, fontSize: 16)
                                          ]),
                                          Row(children: [
                                            const Subheading(
                                                text: "Gender: ", color: AppColors.primaryColor, fontSize: 16),
                                            Subheading(text: data['gender'], color: AppColors.blackColor, fontSize: 16)
                                          ]),
                                          Row(children: [
                                            const Subheading(
                                                text: "Relationship: ", color: AppColors.primaryColor, fontSize: 16),
                                            Subheading(
                                                text: data['relationship'], color: AppColors.blackColor, fontSize: 16)
                                          ])
                                        ])
                                      ]))),
                            ));
                      }).toList(),
                    ),
                  ),
                ],
              );
            }));
  }
}

class AppointmentTab extends StatelessWidget {
  const AppointmentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = LocalStorage.getString("email");
    Query appointmentsQuery = FirebaseFirestore.instance.collection('appointments').where('email', isEqualTo: email);

    Stream<QuerySnapshot> appointmentsStream = appointmentsQuery.snapshots();

    return Scaffold(
        backgroundColor: Colors.black12,
        body: StreamBuilder<QuerySnapshot>(
          stream: appointmentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Data is available
              List<DocumentSnapshot> appointments = snapshot.data!.docs;
              if (appointments.isEmpty) {
                // No appointments available
                return const Center(
                  child: Text(
                    'No Appointments yet',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  // Extract the appointment data from the snapshot
                  Map<String, dynamic> appointmentData = appointments[index].data() as Map<String, dynamic>;

                  // Access the specific fields you need
                  String hospitalId = appointmentData['hospitalId'];
                  String hospitalName = appointmentData['hospitalName'];
                  String name = appointmentData['name'];
                  String patientCNIC = appointmentData['patientCNIC'];
                  String phone = appointmentData['phone'];
                  String appointmentDate = appointmentData['appointmentDate'];
                  String vaccination = appointmentData['vaccineName'];
                  String email = appointmentData['email'];
                  String status = appointmentData['appointmentStatus'];

                  // Display the appointment data
                  return Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(Icons.local_hospital_outlined, size: 30, color: AppColors.primaryWhite),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hospital Name: $hospitalName",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text("appointment Status: $status",
                                      style: const TextStyle(color: Colors.black, fontSize: 14)),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text("Details:",
                                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                Text("Patient Name: $name", style: const TextStyle(color: Colors.black, fontSize: 14)),
                                Text("Phone: $phone", style: const TextStyle(color: Colors.black, fontSize: 14)),
                                Text("Patient CNIC: $patientCNIC",
                                    style: const TextStyle(color: Colors.black, fontSize: 14)),
                                Text("VaccineName: $vaccination",
                                    style: const TextStyle(color: Colors.black, fontSize: 14)),
                                Text("Date: $appointmentDate",
                                    style: const TextStyle(color: Colors.black, fontSize: 14)),
                                Text("Booked by: $email", style: const TextStyle(color: Colors.black, fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              // Error occurred while fetching data
              return Text('Error Loading Appointments: ${snapshot.error}');
            } else {
              // Data is still loading
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
