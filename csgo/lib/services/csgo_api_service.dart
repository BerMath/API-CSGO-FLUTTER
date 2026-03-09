import 'dart:convert';
import 'package:http/http.dart' as http;

class CsgoApiService {
  // ✅ SANS le /fr/ à la fin!
  static const String _baseUrl = 'https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api';

  final String language;

  CsgoApiService({this.language = 'fr'});

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

  // ✅ gloves.json et pas highlights.json
  Future<List<dynamic>> getHighlights() async {
    final reponse = await http.get(
      Uri.parse('$_baseUrl/$language/gloves.json'),
    );

    if (reponse.statusCode == 200) {
      return jsonDecode(reponse.body);
    } else {
      throw Exception('Failed to load highlight');
    }
  }
}