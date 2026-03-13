import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson_models.dart';

class LessonService {
  static const String _defaultUrl = 'https://raw.githubusercontent.com/BayteTheProtogen/zwolnieni-jubilant-guacamole/refs/heads/cyberspryt-app-11500067339206078208/remote_lessons.json';
  static const String _urlKey = 'lesson_db_url';
  static const String _cacheKey = 'cached_lessons';

  Future<List<Category>> getLessons() async {
    final prefs = await SharedPreferences.getInstance();
    String currentUrl = prefs.getString(_urlKey) ?? _defaultUrl;

    try {
      final response = await http.get(Uri.parse(currentUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle database relocation
        if (data['next_db_url'] != null && data['next_db_url'].toString().isNotEmpty) {
          await prefs.setString(_urlKey, data['next_db_url']);
        }

        // Cache the successful result
        await prefs.setString(_cacheKey, response.body);

        return _parseCategories(data);
      }
    } catch (e) {
      print('Error fetching remote lessons: $e');
    }

    // Fallback to cache
    String? cachedData = prefs.getString(_cacheKey);
    if (cachedData != null) {
      return _parseCategories(json.decode(cachedData));
    }

    return []; // Return empty if everything fails
  }

  List<Category> _parseCategories(Map<String, dynamic> data) {
    if (data['categories'] == null) return [];
    return (data['categories'] as List).map((c) => Category.fromJson(c)).toList();
  }
}
