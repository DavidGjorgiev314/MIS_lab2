class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strInstructions;
  final String strMealThumb;
  final String? strYoutube;
  final Map<String, String> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strYoutube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingr = {};
    for (int i = 1; i <= 20; i++) {
      final ing = json['strIngredient$i'];
      final meas = json['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        ingr[ing.toString()] = meas?.toString() ?? '';
      }
    }

    return MealDetail(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strYoutube: json['strYoutube'],
      ingredients: ingr,
    );
  }
}
