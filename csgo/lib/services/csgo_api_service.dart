import 'dart:convert';
import 'package:http/http.dart' as http;

class CsgoApiService {
  static const String _baseUrl = 'https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api';

  final String language;

  CsgoApiService({this.language = 'en'});

  Future<List<dynamic>> getSkins() async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/$language/skins.json'),
    );

    if (reponse.statusCode == 200) {
      return jsonDecode(reponse.body);
    } else {
      throw Exception('Failed to load skins');
    }
  }

  Future<List<dynamic>> getCases() async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/$language/crates.json'),
    );

    if (reponse.statusCode == 200) {
      return jsonDecode(reponse.body);
    } else {
      throw Exception('Failed to load cases');
    }
  }

  Future<List<dynamic>> getHighlights() async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/$language/highlights.json'),
    );

    if (reponse.statusCode == 200) {
      return jsonDecode(reponse.body);
    } else {
      throw Exception('Failed to load highlight');
    }
  }
}