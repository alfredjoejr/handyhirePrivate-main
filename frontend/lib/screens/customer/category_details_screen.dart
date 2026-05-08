import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'job_request_screen.dart';
import 'provider_profile_screen.dart';
import 'chat_screen.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  static const Map<String, List<Map<String, dynamic>>> _providerData = {
    "Plumbing": [
      {"name": "John Doe", "rating": 4.8, "mins": 15, "price": 25},
      {"name": "Mike Pipe", "rating": 4.5, "mins": 20, "price": 20},
    ],
    "Electrical": [
      {"name": "Sparky Steve", "rating": 4.9, "mins": 10, "price": 40},
    ],
    "Cleaning": [
      {"name": "John Nolan", "rating": 4.2, "mins": 16, "price": 30},
    ],
  };

  const CategoryDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> providers = _providerData[category["name"]] ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: providers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: providers.length,
                    itemBuilder: (context, index) =>
                        _buildProviderCard(context, providers[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const JobRequestScreen()));
        },
        label: const Text("Create Job Request", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accent,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: AppColors.secondary,
          child: Icon(category["icon"], size: 50, color: AppColors.accent),
        ),
        const SizedBox(height: 15),
        Text(category["name"],
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        const Text("Available professionals nearby",
            style: TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }

  Widget _buildProviderCard(BuildContext context, Map<String, dynamic> provider) {
    return Card(
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.background,
          child: Text(provider["name"][0],
              style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
        ),
        title: Text(provider["name"],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "${provider["rating"]} * ${provider["mins"]} mins * \$${provider["price"]}/hr",
            style: const TextStyle(color: AppColors.accent, fontSize: 13),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white70),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChatScreen(providerName: provider["name"])),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white70),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProviderProfileScreen(provider: provider)));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No providers found for this category yet.",
          style: TextStyle(color: Colors.white54)),
    );
  }
}
