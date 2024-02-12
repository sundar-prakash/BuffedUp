import 'package:flutter/material.dart';

class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Under Maintenance'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage(
                  'https://assets-v2.lottiefiles.com/a/21950e2e-117f-11ee-9914-5f1b40e278c9/yPSBXJuRNL.gif'), // Provide path to your GIF file
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'We are currently undergoing maintenance.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
