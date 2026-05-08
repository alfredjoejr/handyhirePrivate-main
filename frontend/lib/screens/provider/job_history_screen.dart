import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class JobHistoryScreen extends StatelessWidget {
  const JobHistoryScreen({super.key});

  final List<Map<String, String>> completedJobs = const [
    {'customerName': 'John Doe', 'title': 'Plumbing Repair', 'price': 'Rs. 2,500', 'date': '14 Mar 2026', 'location': '123 Main St, Colombo 03', 'description': 'Fixed leaking pipes under the kitchen sink.', 'duration': '2 hours', 'status': 'Completed'},
    {'customerName': 'Sarah Williams', 'title': 'Electrical Wiring', 'price': 'Rs. 4,000', 'date': '10 Mar 2026', 'location': '45 Park Road, Kandy', 'description': 'Installed new electrical outlets in the living room.', 'duration': '3 hours', 'status': 'Completed'},
    {'customerName': 'Michael Brown', 'title': 'AC Installation', 'price': 'Rs. 8,500', 'date': '05 Mar 2026', 'location': '78 Lake View, Nugegoda', 'description': 'Installed a 1.5 ton inverter AC unit in the master bedroom.', 'duration': '4 hours', 'status': 'Completed'},
    {'customerName': 'Emily Davis', 'title': 'Painting Work', 'price': 'Rs. 3,200', 'date': '01 Mar 2026', 'location': '22 Hill Street, Gampaha', 'description': 'Painted two rooms including ceiling.', 'duration': '6 hours', 'status': 'Completed'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Job History',
            style: TextStyle(
                color: AppColors.text, fontSize: 22, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text('Last 30 days',
                style: TextStyle(
                    color: AppColors.text.withOpacity(0.5), fontSize: 13)),
          ),
        ),
      ),
      body: completedJobs.isEmpty
          ? const Center(
              child: Text('No completed jobs in last 30 days',
                  style: TextStyle(color: AppColors.text, fontSize: 16)))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: completedJobs.length,
              itemBuilder: (context, index) {
                final job = completedJobs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.15),
                              shape: BoxShape.circle),
                          child: const Icon(Icons.check_circle,
                              color: AppColors.success, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(job['title']!,
                                  style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(job['customerName']!,
                                  style: TextStyle(
                                      color: AppColors.text.withOpacity(0.7),
                                      fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(job['date']!,
                                  style: TextStyle(
                                      color: AppColors.text.withOpacity(0.5),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        Text(job['price']!,
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
