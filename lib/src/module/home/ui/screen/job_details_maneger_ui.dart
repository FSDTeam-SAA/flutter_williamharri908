import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';

class JobDetailsUi extends StatelessWidget {
  const JobDetailsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details"),
        backgroundColor: Colors.transparent,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(Assets.edit, height: 24, width: 24),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Image.asset(Assets.amount, height: 24, width: 24),//delete
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(radius: 35),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 15),
                          Text("Sarvesh Shrestha"),
                          SizedBox(width: 100),
                          Text(" \$ ${1000}"),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Icon(Icons.credit_card),
                            ),
                            Text(
                              "Real Estate",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Icon(Icons.location_on_outlined),
                          ),
                          Text(
                            "Remote",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            Text(""),

            Text(
              "Photo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: Image.network(""),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}