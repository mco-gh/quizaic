class Generator {
  final String id;
  final String timeCreated;
  final String updated;
  final String selfLink;
  final String name;
  final List<String> answerFormats;
  final List<String> topics;

  const Generator({
    required this.id,
    required this.timeCreated,
    required this.updated,
    required this.selfLink,
    required this.name,
    required this.answerFormats,
    required this.topics,
  });

  factory Generator.fromJson(Map<String, dynamic> json) {
    List<String> answerFormats =
        List<String>.from(json['answerFormats'] as List);
    List<String> topics = List<String>.from(json['topics'] as List);

    return Generator(
      id: json['id'],
      timeCreated: json['timeCreated'],
      updated: json['updated'],
      selfLink: json['selfLink'],
      name: json['name'],
      answerFormats: answerFormats,
      topics: topics,
    );
  }
}
