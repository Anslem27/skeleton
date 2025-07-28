import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:skeleton/app/helpers/constants.dart';
import 'dart:convert';

import '../logger.dart';

class HttpHelper extends ChangeNotifier {
  HttpHelper._();
  static final HttpHelper httpHelper = HttpHelper._();

  String webHost = kDebugMode
      ? "http://54.243.89.55:8034/"
      : "https://api.myapp.com/";

  // Replace with your TMDb API key
  static final String tmdbApiKey = Constants.tmdbApiKey;

  Map<String, dynamic> genericCatchResponse = {
    "success": false,
    "status": "FAILED",
    "message": "An error occurred, please try again",
    'error': 'Request failed, please check your internet',
  };

  Map<String, dynamic> genericUnauthorizedResponse = {
    "success": false,
    "status": "FAILED",
    "message": "Unauthorized access, please login again",
    'error': 'Unauthorized',
  };

  // Fetch quotes from ZenQuotes API
  Future<Map<String, dynamic>> fetchQuotes() async {
    try {
      var response = await get(Uri.parse('https://zenquotes.io/api/quotes'));

      logger.t(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 'SUCCESS',
          'results': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'status': 'FAILED',
          'message': 'Failed to fetch quotes',
          'error': 'Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      logger.e(e);
      return genericCatchResponse;
    }
  }

  // Fetch popular movies from TMDb API
  Future<Map<String, dynamic>> fetchMovies() async {
    try {
      var response = await get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=$tmdbApiKey',
        ),
      );

      logger.t(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status': 'SUCCESS',
          'results': jsonDecode(response.body)['results'],
        };
      } else {
        return {
          'success': false,
          'status': 'FAILED',
          'message': 'Failed to fetch movies',
          'error': 'Status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      logger.e(e);
      return genericCatchResponse;
    }
  }
}
