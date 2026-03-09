import 'dart:convert';
import 'package:http/http.dart' as http;

class CsgoApiService {
  // ✅ SANS le /fr/ à la fin!
  static const String _baseUrl = 'https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api';

  final String language;

  CsgoApiService({this.language = 'en'});
  // Helper that attempts language-specific path, then falls back to 'en' if missing.
  Future<List<dynamic>> _fetchJson(String filename) async {
    final urlLang = '$_baseUrl/$language/$filename';
    final urlEn = '$_baseUrl/en/$filename';

    final respLang = await http.get(Uri.parse(urlLang));
    if (respLang.statusCode == 200) {
      try {
        return jsonDecode(respLang.body);
      } catch (e) {
        throw Exception('Failed to parse $filename for language "$language": $e');
      }
    }

    // If not found (404) and language isn't English, try English fallback
    if (respLang.statusCode == 404 && language != 'en') {
      final respEn = await http.get(Uri.parse(urlEn));
      if (respEn.statusCode == 200) {
        try {
          return jsonDecode(respEn.body);
        } catch (e) {
          throw Exception('Failed to parse $filename for fallback "en": $e');
        }
      }
      throw Exception('Resource not found for "$language" and fallback "en" (status: ${respEn.statusCode})');
    }

    // Other HTTP errors: include status and body to help debugging
    throw Exception('Failed to load $filename (status: ${respLang.statusCode}): ${respLang.body}');
  }

  Future<List<dynamic>> getSkins() async {
    return _fetchJson('skins.json');
  }

  Future<List<dynamic>> getCases() async {
    return _fetchJson('crates.json');
  }

  Future<List<dynamic>> getHighlights() async {
    return _fetchJson('highlights.json');
  }
}