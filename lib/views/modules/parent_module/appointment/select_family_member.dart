import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/local_storage.dart';
import '../../../../reusable_widgets/sub_heading.dart';

class SelectFamilyMember extends StatelessWidget {
  const SelectFamilyMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                        // onTap: ()=> Get.back(result: data["cnic_bform"]),
                        onTap: () => Get.back(result: {
                          "cnic_bform": data["cnic_bform"],
                          "name": data["name"],
                        }),

                        child: Card(
                            color: AppColors.primaryWhite,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(color: AppColors.primaryColor, width: 1)),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Row(children: const [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.primaryColor,
                                        child: Icon(Icons.person_outline_outlined, size: 30)),
                                    SizedBox(width: 10)
                                  ]),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(children: [
                                      const Subheading(text: "Name: ", color: AppColors.primaryColor, fontSize: 18),
                                      Subheading(text: data['name'], color: AppColors.blackColor, fontSize: 18)
                                    ]),
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
                                      const Subheading(
                                          text: "Relationship: ", color: AppColors.primaryColor, fontSize: 16),
                                      Subheading(text: data['relationship'], color: AppColors.blackColor, fontSize: 16)
                                    ])
                                  ])
                                ]))),
                      ));
                }).toList(),
              );
            }));
  }
}
