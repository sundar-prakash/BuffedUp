import 'package:BuffedUp/const/DataTypes/GymMember.dart';
import 'package:BuffedUp/const/DataTypes/UserProfile.dart';
import 'package:BuffedUp/src/services/firestore/ownerdoc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubscribeScreen extends StatefulWidget {
  final String? message;
  const SubscribeScreen({this.message, super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  List<SubscriptionPlan> subscriptionPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionPlans();
  }

  void _fetchSubscriptionPlans() async {
    var plans = await fetchSubscriptionPlans();
    setState(() {
      subscriptionPlans = plans;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Choose a Subscription',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                if (widget.message != null)
                  Text(
                    widget.message!,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: subscriptionPlans
                        .map((e) => SubscriptionCard(plan: e))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

Future<List<SubscriptionPlan>> fetchSubscriptionPlans({int? id}) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('settings')
        .get();

    if (snapshot.exists) {
      final plansData = snapshot.data()?['plans'] ?? [];

      if (id != null) {
        // Fetch plan by ID
        final planById = plansData.firstWhere(
          (plan) => plan['id'] == id,
          orElse: () => null,
        );

        if (planById != null) {
          return [SubscriptionPlan.fromMap(planById)];
        } else {
          return [];
        }
      }

      return plansData
          .map<SubscriptionPlan>((plan) => SubscriptionPlan.fromMap(plan))
          .toList();
    }
  } catch (e) {
    print('Error fetching subscription plans: $e');
  }
  return [];
}

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionCard({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.purple], // Adjust gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              plan.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            for (var e in plan.description)
              Row(children: [
                Icon(Icons.check),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    e,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ]),
            const SizedBox(height: 10),
            Text(
              '\₹${plan.price.toStringAsFixed(2)} / ${plan.validity.inDays} days',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                void pay() async {
                  PaymentHistory newpayment = PaymentHistory(
                      planID: plan.id,
                      gateway: "cash",
                      expiryDate:
                          CalculateExpireDate(DateTime.now(), plan.validity),
                      paidOn: DateTime.now(),
                      transactionid: "1234");
                  await updateOwner(
                    'subscriptionHistory',
                    FieldValue.arrayUnion([newpayment.toMap()]),
                  );
                }

                pay();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Subscribe'),
            ),
          ],
        ),
      ),
    );
  }
}
