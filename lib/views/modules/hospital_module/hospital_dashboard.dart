import 'package:child_vaccination_system/controllers/hospital_dashboard_controller.dart';
import 'package:child_vaccination_system/views/modules/hospital_module/update_hospital_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/local_storage.dart';
import '../../../controllers/auth_controller.dart';

class HospitalDashboard extends StatefulWidget {
  const HospitalDashboard({Key? key}) : super(key: key);

  @override
  State<HospitalDashboard> createState() => _HospitalDashboardState();
}

class _HospitalDashboardState extends State<HospitalDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AuthController authController = AuthController();
  final controller = Get.put(HospitalDashboardController());

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            "Hospital Dashboard",
          ),
          actions: [
            IconButton(onPressed: () => {Get.to(UpdateHospitalProfile())}, icon: const Icon(Icons.person_outline)),
            IconButton(onPressed: () => authController.logoutUser(), icon: const Icon(Icons.logout))
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "All Appointments"),
              Tab(text: "Approved Appointments"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            AppointmentTab(),
            ApprovedAppointmentTab(),
          ],
        )
    );
  }
}

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({Key? key}) : super(key: key);

  @override
  _AppointmentTabState createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  final controller = Get.put(HospitalDashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.appointmentsStream,
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
                return  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Hospital: $hospitalName",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                              ElevatedButton(
                                onPressed: () {
                                  controller.toggleIsApproved();
                                  controller.updateAppointmentStatus();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: Obx(() {
                                  String buttonText = controller.isApproved.value ? 'Cancel' : 'Approve';
                                  if (status == 'approved') {
                                    buttonText = 'Cancel';
                                  }
                                  return Text(buttonText);
                                }),
                              ),
                            ],
                          ),
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
                          Text("Date: $appointmentDate", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          Text("Booked by: $email", style: const TextStyle(color: Colors.black, fontSize: 14)),
                        ],
                      ),
                    ));
              },
            );
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return const Center(child: Text('Error Loading Appointments', style: TextStyle(color: Colors.black)));
          } else {
            // Data is still loading
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>controller.toggleSortOrder(),
        backgroundColor: AppColors.primaryColor,
        icon: Icon(Icons.sort),
        label: Text(
          controller.isSortingAscending.value ? 'Sort Ascending' : 'Sort Descending',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


// class AppointmentTab extends StatelessWidget {
//   const AppointmentTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(HospitalDashboardController());
//
//     String id = LocalStorage.getString("id");
//     Stream<QuerySnapshot> appointmentsStream =
//         FirebaseFirestore.instance.collection('appointments').where('hospitalId', isEqualTo: id).snapshots();
//
//     return Scaffold(
//         backgroundColor: Colors.black12,
//         body: StreamBuilder<QuerySnapshot>(
//           stream: appointmentsStream,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               // Data is available
//               List<DocumentSnapshot> appointments = snapshot.data!.docs;
//               if (appointments.isEmpty) {
//                 // No appointments available
//                 return const Center(
//                   child: Text(
//                     'No Appointments yet',
//                     style: TextStyle(color: Colors.black, fontSize: 16),
//                   ),
//                 );
//               }
//               return ListView.builder(
//                 itemCount: appointments.length,
//                 itemBuilder: (context, index) {
//                   // Extract the appointment data from the snapshot
//                   Map<String, dynamic> appointmentData = appointments[index].data() as Map<String, dynamic>;
//
//                   // Access the specific fields you need
//                   String hospitalId = appointmentData['hospitalId'];
//                   String hospitalName = appointmentData['hospitalName'];
//                   String name = appointmentData['name'];
//                   String patientCNIC = appointmentData['patientCNIC'];
//                   String phone = appointmentData['phone'];
//                   String appointmentDate = appointmentData['appointmentDate'];
//                   String vaccination = appointmentData['vaccineName'];
//                   String email = appointmentData['email'];
//                   String status = appointmentData['appointmentStatus'];
//
//                   // Display the appointment data
//                   return Card(
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                           side: const BorderSide(color: AppColors.primaryColor, width: 1)),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Hospital: $hospitalName",
//                                     style: const TextStyle(
//                                         color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     controller.toggleIsApproved();
//                                     controller.updateAppointmentStatus();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: AppColors.primaryColor,
//                                   ),
//                                   child: Obx(() {
//                                     String buttonText = controller.isApproved.value ? 'Cancel' : 'Approve';
//                                     if (status == 'approved') {
//                                       buttonText = 'Cancel';
//                                     }
//                                     return Text(buttonText);
//                                   }),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5.0),
//                               child: Text("appointment Status: $status",
//                                   style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(vertical: 8.0),
//                               child: Text("Details:",
//                                   style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
//                             ),
//                             Text("Patient Name: $name", style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             Text("Phone: $phone", style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             Text("Patient CNIC: $patientCNIC",
//                                 style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             Text("VaccineName: $vaccination",
//                                 style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             Text("Date: $appointmentDate", style: const TextStyle(color: Colors.black, fontSize: 14)),
//                             Text("Booked by: $email", style: const TextStyle(color: Colors.black, fontSize: 14)),
//                           ],
//                         ),
//                       ));
//                 },
//               );
//             } else if (snapshot.hasError) {
//               // Error occurred while fetching data
//               return const Center(child: Text('Error Loading Appointments', style: TextStyle(color: Colors.black)));
//             } else {
//               // Data is still loading
//               return const CircularProgressIndicator();
//             }
//           },
//         ));
//   }
// }

class ApprovedAppointmentTab extends StatelessWidget {
  const ApprovedAppointmentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HospitalDashboardController());

    String id = LocalStorage.getString("id");
    Stream<QuerySnapshot> appointmentsStream = FirebaseFirestore.instance
        .collection('appointments')
        .where('hospitalId', isEqualTo: id)
        .where('appointmentStatus', isEqualTo: 'approved')
        .snapshots();

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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hospital: $hospitalName",
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
                            Text("Date: $appointmentDate", style: const TextStyle(color: Colors.black, fontSize: 14)),
                            Text("Booked by: $email", style: const TextStyle(color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              // Error occurred while fetching data
              return const Center(child: Text('Error Loading Appointments', style: TextStyle(color: Colors.black)));
            } else {
              // Data is still loading
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
