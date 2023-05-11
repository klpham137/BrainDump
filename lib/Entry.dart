class Entry {
  final String date;
  final String body;
  String id;

  Entry({
    this.id = '',
    required this.date,
    required this.body,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'body': body,
    'date': date,
  };

  static Entry fromJson(Map<String, dynamic> json) => Entry(
    id: json['id'],
    body: json['body'],
    date: json['date'],
  );

}