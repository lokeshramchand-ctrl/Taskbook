/// The taskbook always points at exactly one repository. There is no
/// repository picker and no settings screen for this — it is fixed by design.
class GithubConfig {
  static const String owner = 'lokeshramchand-ctrl';
  static const String repo = 'Docs';

  static const String apiBase = 'https://api.github.com';
  static String get repoApiUrl => '$apiBase/repos/$owner/$repo';
  static String get repoWebUrl => 'https://github.com/$owner/$repo';
}
