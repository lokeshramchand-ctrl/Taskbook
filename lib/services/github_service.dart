import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/github_config.dart';
import '../models/issue.dart';
import 'token_store.dart';

/// Thrown for any GitHub API failure. Carries a short, user-facing message
/// only — never a stack trace or raw response body.
class GithubApiException implements Exception {
  final String message;
  const GithubApiException(this.message);

  @override
  String toString() => message;
}

/// Talks to the GitHub REST API directly for the one fixed repository.
/// GitHub Issues are the only source of truth — there is no local database.
class GithubService {
  GithubService._();
  static final GithubService instance = GithubService._();

  Future<Map<String, String>> _headers() async {
    final token = await TokenStore.instance.readToken();
    if (token == null || token.isEmpty) {
      throw const GithubApiException('GitHub connection needs attention.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/vnd.github+json',
      'Content-Type': 'application/json',
      'X-GitHub-Api-Version': '2022-11-28',
    };
  }

  Future<List<Issue>> fetchIssues() async {
    final headers = await _headers();
    final uri = Uri.parse(
      '${GithubConfig.repoApiUrl}/issues?state=all&per_page=100',
    );
    final response = await _get(uri, headers);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        // The issues endpoint also returns pull requests; skip those.
        .where((item) => item['pull_request'] == null)
        .map((item) => Issue.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Issue> fetchIssue(int number) async {
    final headers = await _headers();
    final uri = Uri.parse('${GithubConfig.repoApiUrl}/issues/$number');
    final response = await _get(uri, headers);
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Issue> createIssue({required String title, required String body}) async {
    final headers = await _headers();
    final uri = Uri.parse('${GithubConfig.repoApiUrl}/issues');
    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({'title': title, 'body': body}),
    );
    if (response.statusCode != 201) {
      throw _errorFor(response.statusCode);
    }
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Issue> updateIssueBody(int number, String newBody) async {
    final headers = await _headers();
    final uri = Uri.parse('${GithubConfig.repoApiUrl}/issues/$number');
    final response = await http.patch(
      uri,
      headers: headers,
      body: jsonEncode({'body': newBody}),
    );
    if (response.statusCode != 200) {
      throw _errorFor(response.statusCode);
    }
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<http.Response> _get(Uri uri, Map<String, String> headers) async {
    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw _errorFor(response.statusCode);
    }
    return response;
  }

  GithubApiException _errorFor(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      return const GithubApiException('GitHub connection needs attention.');
    }
    return const GithubApiException("Couldn't reach GitHub. Try again.");
  }
}
