import 'package:screensee/user.dart';

class Room {
  final String id;
  final List<User> participants;
  final String videoLink;
  final String pseudonym;

  Room(this.id, this.participants, this.videoLink, this.pseudonym);
}
