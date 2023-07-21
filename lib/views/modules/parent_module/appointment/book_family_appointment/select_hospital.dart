import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../reusable_widgets/custom_appbar.dart';

class SelectHospital extends StatelessWidget {
  const SelectHospital({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> hospitalsStream = FirebaseFirestore.instance.collection('hospitals').snapshots();

    return Scaffold(
        appBar: const CustomAppBar(title: "Select Hospital"),
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
                  return InkWell(
                    // onTap: ()=>Get.back(result: hospitalData["id"]),
                    onTap: () => Get.back(result: {
                      "hostpitalName": hospitalData['name'],
                      "hospitalId":hospitalData['id'],
                    }),
                    child: Card(
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
                                  Text("Hospital Name: ${hospitalData['name']}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text("Address: ${hospitalData['address']}",
                                      style: const TextStyle(color: Colors.black, fontSize: 14)),
                                  Text("Phone: ${hospitalData['phone']}",
                                      style: const TextStyle(color: Colors.black, fontSize: 14)),
                                  Text("Private/Govt: ${hospitalData['privateGovt']}",
                                      style: const TextStyle(color: Colors.black, fontSize: 14)),
                                  Text("Timings: ${hospitalData['timingsFrom']} - ${hospitalData['timingsTo']}",
                                      style: const TextStyle(color: Colors.black, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        )),
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
        ));
  }
}
