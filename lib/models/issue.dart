class Issue {
  final int number;
  final String title;
  final String body;
  final bool isOpen;
  final String htmlUrl;

  const Issue({
    required this.number,
    required this.title,
    required this.body,
    required this.isOpen,
    required this.htmlUrl,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      number: json['number'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      isOpen: (json['state'] as String?) == 'open',
      htmlUrl: json['html_url'] as String? ?? '',
    );
  }
}
