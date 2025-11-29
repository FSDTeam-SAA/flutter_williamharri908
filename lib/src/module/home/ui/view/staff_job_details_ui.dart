import 'package:flutter/material.dart';

class StaffJobDetailsUi extends StatelessWidget {
  const StaffJobDetailsUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Job Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Real estate agent",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 12),

            Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),

            SizedBox(height: 12),

            Text(
              "Lorem ipsum dolor sit amet consectetur. Lectus sed in egestas ultricies a odio eget varius sit. Vivamus senectus egestas nisl vel adipiscing. Nunc quis lacus senectus lectus cursus vel nulla quis. Aenean purus integer ut leo nullam tellus lorem cursus. Commodo tempus arcu turpis congue fermentum aliquam duis. Id augue cras cursus sed eget augue. Sed cursus leo nec faucibus semper elementum felis integer id. Pellentesque ut nascetur aenean integer facilisis cursus mauris nullam. Purus sodales suspendisse et id amet tellus tortor platea arcu. Proin pharetra arcu aliquet mattis in suscipit vivamus. Vulputate posuere elit bibendum nisl dictum turpis euismod cursus consectetur.l vel adipiscing. Nunc quis lacus senectus lectus cursus vel nulla quis. Aenean purus integer ut leo nullam tellus lorem cursus. Commodo tempus arcu turpis congue fermentum aliquam duis. Id augue cras cursus sed eget augue. Sed cursus leo nec faucibus semper elementum felis integer id. Pellentesque ut nascetur aenean integer facilisis cursus mauris nullam. Purus sodales suspendisse et id amet tellus tortor platea arcu. Proin pharetra arcu aliquet mattis in suscipit vivamus. Vulputate posuere elit bibendum nisl dictum turpis euismod cursu Requirements",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),

            SizedBox(height: 12),

            Text(
              "Photos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),

            SizedBox(height: 12),

            SizedBox(
              height: 200, // required for GridView
              child: GridView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://via.placeholder.com/150",
                        fit: BoxFit.cover,
                      ),
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
