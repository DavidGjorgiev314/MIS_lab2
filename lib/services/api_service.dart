import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$base/categories.php');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final list = data['categories'] as List<dynamic>;
      return list.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$base/filter.php?c=${Uri.encodeComponent(category)}');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final list = data['meals'] as List<dynamic>? ?? [];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load meals by category');
    }
  }

  Future<List<Meal>> searchMeals(String query) async {
    final url = Uri.parse('$base/search.php?s=${Uri.encodeComponent(query)}');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final list = data['meals'] as List<dynamic>? ?? [];
      return list.map((e) => Meal.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search meals');
    }
  }

  Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$base/lookup.php?i=${Uri.encodeComponent(id)}');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final list = data['meals'] as List<dynamic>;
      return MealDetail.fromJson(list.first);
    } else {
      throw Exception('Failed to load meal detail');
    }
  }

  Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$base/random.php');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final list = data['meals'] as List<dynamic>;
      return MealDetail.fromJson(list.first);
    } else {
      throw Exception('Failed to load random meal');
    }
  }
}