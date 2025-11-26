import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String categoryName;
  const MealsByCategoryScreen({super.key, required this.categoryName});

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  final ApiService api = ApiService();
  List<Meal> meals = [];
  List<Meal> filtered = [];
  final TextEditingController _search = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _search.text.toLowerCase();
    setState(() {
      filtered = meals.where((m) => m.strMeal.toLowerCase().contains(q)).toList();
    });
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final list = await api.fetchMealsByCategory(widget.categoryName);
      setState(() {
        meals = list;
        filtered = list;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Color(0xFFF57C00),
        title: Text(widget.categoryName),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Пребарувај јадења...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final meal = filtered[i];
                return MealCard(
                  meal: meal,
                  onTap: () async {
                    final detail = await api.fetchMealDetail(meal.idMeal);
                    if (!mounted) return;
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailScreen(mealDetail: detail)));
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}