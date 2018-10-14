import 'package:screensee/user.dart';

class Room {
  final String id;
  final List<User> participants;
  final String videoLink;
  final String pseudonym;
  final bool isMaster;

  Room(this.id, this.participants, this.videoLink, this.pseudonym, this.isMaster);
}

Room parseFromJson(dynamic json) {
  return Room(
    json["data"]["id"],
    (json["data"]["participants"] as List).map((item) => User(item)).toList(),
    json["data"]["videoLink"],
    json["data"]["pseudonym"],
    json["data"]["isMaster"],
  );
}
