class BookModel {
  final String id;
  final String thumbnail;
  final String title;
  final List authors;
  final int pageCount;
  final String description;
  final String status;
  int isFavorite;

  BookModel({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.authors,
    required this.pageCount,
    required this.description,
    this.status = 'ยังไม่ได้อ่าน',
    this.isFavorite = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnail': thumbnail,
      'authors': authors.join(', '),
      'pageCount': pageCount,
      'description': description,
      'status': status,
      'isFavorite': isFavorite,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'];
    final imageLinks = volumeInfo?['imageLinks'];

    return BookModel(
      id: json['id'] ?? '',
      thumbnail: imageLinks != null
          ? imageLinks['thumbnail'].toString().replaceAll('http:', 'https:')
          : 'https://iarc-publications-website.s3.eu-west-3.amazonaws.com/media/default/0001/02/thumb_1291_default_publication.jpeg',
      title: volumeInfo['title'] ?? 'ไม่มีข้อมูลชื่อเรื่อง',
      authors:
          (volumeInfo?['authors'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          ['ไม่มีข้อมูลผู้เขียน'],
      pageCount: volumeInfo['pageCount'] ?? 0,
      description: volumeInfo['description'] ?? 'ไม่มีข้อมูลเนื้อเรื่องย่อ',
      status: json['status'] ?? 'ยังไม่ได้อ่าน',
      isFavorite: json['isFavorite'] ?? 0,
    );
  }
  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      title: map['title'] ?? '',
      authors: (map['authors'] as String? ?? 'ไม่ระบุผู้เขียน').split(', '),
      pageCount: map['pageCount'] ?? 0,
      description: map['description'] ?? 'ไม่มีข้อมูลเนื้อเรื่องย่อ',
      status: map['status'] ?? 'ยังไม่ได้อ่าน',
      isFavorite: map['isFavorite'] ?? 0,
    );
  }
}
