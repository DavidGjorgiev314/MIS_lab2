import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/meal_detail.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail mealDetail;
  const MealDetailScreen({super.key, required this.mealDetail});

  Future<void> _openYoutube(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) return;

    final normalized = url.startsWith('http') ? url : 'https://$url';

    try {
      await launchUrlString(
        normalized,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Could not launch $normalized — error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не се отвара: $normalized')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFEBEE),
      appBar: AppBar(
        backgroundColor: Color(0xFFC62828),
        title: Text(mealDetail.strMeal),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: mealDetail.strMealThumb,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 12),

              Text(
                'Категорија: ${mealDetail.strCategory}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text(
                'Инструкции:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(mealDetail.strInstructions),
              const SizedBox(height: 12),

              const Text(
                'Состојки:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...mealDetail.ingredients.entries.map(
                    (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${e.key} — ${e.value}'),
                ),
              ),
              const SizedBox(height: 20),

              if (mealDetail.strYoutube != null &&
                  mealDetail.strYoutube!.isNotEmpty)
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          _openYoutube(context, mealDetail.strYoutube),
                      icon: const Icon(Icons.video_library),
                      label: const Text('Отвори YouTube'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}