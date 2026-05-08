import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'job_details_screen.dart';
import 'negotiate_screen.dart';

class JobRequestDetailScreen extends StatelessWidget {
  final Map<String, String> job;
  final int jobIndex;

  const JobRequestDetailScreen(
      {super.key, required this.job, required this.jobIndex});

  IconData _getJobIcon(String imageKey) {
    switch (imageKey) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'ac':
        return Icons.ac_unit;
      case 'painting':
        return Icons.format_paint;
      default:
        return Icons.home_repair_service;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Job Details',
            style: TextStyle(
                color: AppColors.text, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(job['title']!,
                style: const TextStyle(
                    color: AppColors.text, fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 28),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 2),
              ),
              child:
                  Icon(_getJobIcon(job['image']!), size: 60, color: AppColors.accent),
            ),
            const SizedBox(height: 28),
            _buildDetailRow(icon: Icons.person, label: 'Customer', value: job['customerName']!),
            const SizedBox(height: 12),
            _buildDetailRow(icon: Icons.description, label: 'Description', value: job['description']!),
            const SizedBox(height: 12),
            _buildDetailRow(icon: Icons.location_on, label: 'Location', value: job['location']!),
            const SizedBox(height: 12),
            _buildDetailRow(icon: Icons.attach_money, label: 'Budget', value: job['price']!, valueColor: AppColors.accent),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const JobDetailsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.text,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Accept',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          NegotiateScreen(job: job, jobIndex: jobIndex),
                    ),
                  );
                  if (result != null && result['action'] == 'remove') {
                    if (context.mounted) Navigator.pop(context, result);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.text,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.accent, width: 2),
                  ),
                  elevation: 0,
                ),
                child: const Text('Negotiate',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {'action': 'remove', 'index': jobIndex});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: AppColors.text,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Reject',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: AppColors.text.withOpacity(0.6), fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        color: valueColor ?? AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
