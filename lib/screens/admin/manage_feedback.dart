import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/back_button.dart';

class ManageFeedback extends StatefulWidget {
  const ManageFeedback({super.key});

  @override
  State<ManageFeedback> createState() => _ManageFeedbackState();
}

class _ManageFeedbackState extends State<ManageFeedback> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.feedback, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  'Manage Feedback',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('feedback')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No feedback available'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var feedback = snapshot.data!.docs[index];
                      var data = feedback.data() as Map<String, dynamic>;
                      
                      return Card(
                        color: Color.fromRGBO(16, 56, 127, 0.8),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ExpansionTile(
                          leading: Icon(
                            Icons.star,
                            color: Color(0xFFFF6B00),
                          ),
                          title: Text(
                            'Rating: ${data['rating']}/5',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Status: ${data['status']}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Comment:',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    data['comment'] ?? 'No comment provided',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await _firestore
                                              .collection('feedback')
                                              .doc(feedback.id)
                                              .update({'status': 'reviewed'});
                                        },
                                        child: Text(
                                          'Mark as Reviewed',
                                          style: TextStyle(color: Color(0xFFFF6B00)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            CustomBackButton(),
          ],
        ),
      ),
    );
  }
} 