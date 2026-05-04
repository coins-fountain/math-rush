class CreditEntry {
  const CreditEntry({
    required this.category,
    required this.title,
    required this.sourceUrl,
    required this.authorName,
    required this.licenseName,
    this.assetPath,
  });

  final String category;
  final String title;
  final String sourceUrl;
  final String authorName;
  final String licenseName;
  final String? assetPath;

  factory CreditEntry.fromJson(Map<String, dynamic> json) {
    return CreditEntry(
      category: json['category'] as String? ?? 'uncategorized',
      title: json['title'] as String? ?? 'Untitled',
      sourceUrl: json['source_url'] as String? ?? '',
      authorName: json['author_name'] as String? ?? 'Unknown',
      licenseName: json['license_name'] as String? ?? 'Unknown',
      assetPath: json['asset_path'] as String?,
    );
  }
}
