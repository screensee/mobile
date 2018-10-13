class Message {
  final String id;
  final int timestamp;
  final String author;
  final String text;

  Message(this.id, this.timestamp, this.author, this.text);
}

Message readFromJson(dynamic json) {
  return Message(
    json["id"],
    json["timestamp"],
    json["author"],
    json["text"],
  );
}

List<Message> readArrayFromJson(dynamic json) {
  return (json as List).map((item) => readFromJson(item)).toList();
}