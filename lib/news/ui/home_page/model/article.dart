class Article {
  const Article(
    this.author,
    this.title,
    this.description,
    this.content,
    this.date,
    this.liked,
  );

  final String? author;
  final String title;
  final String? description;
  final String? content;
  final String date;
  final bool liked;
}
