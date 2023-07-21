import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import 'admin_deshboard_controller.dart';
import '../../auth_controller.dart';
import '../../../../reusable_widgets/sub_heading.dart';
import '../add_hospital/add_hospital.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthController authController = AuthController();

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          "Admin Dashboard",
        ),
        actions: [
          IconButton(onPressed: () => {}, icon: const Icon(Icons.person_outline)),
          IconButton(onPressed: () => authController.logoutUser(), icon: const Icon(Icons.logout))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Hospitals"),
            Tab(text: "Families"),
            Tab(text: "Appointments"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ HospitalsTab(), ChildTab(), AppointmentTab()],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
          onPressed: () => Get.to(() => const AddHospitalScreen()),
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.add),
          label: const Text('Add Hospital', style: TextStyle(fontWeight: FontWeight.bold)))
          : null,
    );
  }
}

class ChildTab extends StatelessWidget {
  const ChildTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black12,
        body: StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection('family_members').snapshots(),
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
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                          color: AppColors.primaryWhite,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                          child: Padding(
                              padding:  const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(children: const [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primaryColor,
                                    child: Icon(
                                      Icons.person_outline_outlined,
                                      size: 30,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ]),
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                     Subheading(text: "Family of: ${data['email']} ", color: AppColors.primaryColor, fontSize: 18),
                                  Row(children: [
                                    const Subheading(text: "Name: ", color: AppColors.primaryColor, fontSize: 18),
                                    Subheading(text: data['name'], color: AppColors.blackColor, fontSize: 18)]),
                                  Row(children: [
                                    const Subheading(
                                        text: "CNIC/B-Form: ", color: AppColors.primaryColor, fontSize: 16),
                                    Subheading(text: data['cnic_bform'], color: AppColors.blackColor, fontSize: 16)
                                  ]),
                                  Row(children: [
                                    const Subheading(text: "Address: ", color: AppColors.primaryColor, fontSize: 16),
                                    Subheading(text: data['address'], color: AppColors.blackColor, fontSize: 16)
                                  ]),
                                  Row(children: [
                                    const Subheading(text: "DOB: ", color: AppColors.primaryColor, fontSize: 16),
                                    Subheading(text: data['dob'], color: AppColors.blackColor, fontSize: 16)
                                  ]),
                                  Row(children: [
                                    const Subheading(text: "Gender: ", color: AppColors.primaryColor, fontSize: 16),
                                    Subheading(text: data['gender'], color: AppColors.blackColor, fontSize: 16)
                                  ]),
                                  Row(children: [
                                    const Subheading(text: "Relationship: ", color: AppColors.primaryColor, fontSize: 16),
                                    Subheading(text: data['relationship'], color: AppColors.blackColor, fontSize: 16)
                                  ])
                                ])
                              ]))));
                }).toList(),
              );
            }));
  }
}

class HospitalsTab extends StatelessWidget {
  const HospitalsTab({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminDashboardController());

    Stream<QuerySnapshot> hospitalsStream = FirebaseFirestore.instance.collection('hospitals').snapshots();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: StreamBuilder<QuerySnapshot>(
        stream: hospitalsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Data is available
            List<DocumentSnapshot> hospitals = snapshot.data!.docs;
            return ListView.builder(
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                // Extract the hospital data from the snapshot
                Map<String, dynamic> hospitalData = hospitals[index].data() as Map<String, dynamic>;

                // Display the hospital data
                return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${hospitalData['name']}", style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                              ElevatedButton(
                                onPressed: () {
                                  controller.toggleIsApproved();
                                  controller.updateHospitalStatus(hospitalData['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: Obx(() {
                                  String buttonText = controller.isApproved.value ? 'Block' : 'Approve';
                                  if (hospitalData['status'] == 'approved') {
                                    buttonText = 'Block';
                                  }
                                  return Text(buttonText);
                                }),
                              ),

                            ],
                          ),
                          Text("Status: ${hospitalData['status']}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          Text("Address: ${hospitalData['address']}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          Text("Phone: ${hospitalData['phone']}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          Text("Private/Govt: ${hospitalData['privateGovt']}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          Text("Timings: ${hospitalData['timingsFrom']} - ${hospitalData['timingsTo']}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    )
                );
              },
            );
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return Text('Error: ${snapshot.error}');
          } else {
            // Data is still loading
            return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}

class AppointmentTab extends StatelessWidget {
  const AppointmentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> appointmentsStream = FirebaseFirestore.instance
        .collection('appointments')
        .snapshots();

    return Scaffold(backgroundColor: Colors.black12, body: StreamBuilder<QuerySnapshot>(
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
                        const CircleAvatar(radius: 25,
                          backgroundColor: AppColors.primaryColor,
                          child: Icon(Icons.local_hospital_outlined, size: 30, color: AppColors.primaryWhite),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hospitalName, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text("appointment Status: $status", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Details:",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),                            Text("Patient Name: $name", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Phone: $phone", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Patient CNIC: $patientCNIC", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("VaccineName: $vaccination", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Date: $appointmentDate", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Booked by: $email", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  )
              );
            },
          );
        } else if (snapshot.hasError) {
          // Error occurred while fetching data
          return const Center(child: Text('Error Loading Appointments' , style: TextStyle(color: Colors.black)));
        } else {
          // Data is still loading
          return const CircularProgressIndicator();
        }
      },
    )
    );
  }
}
