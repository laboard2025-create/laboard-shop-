import 'package:cloud_firestore/cloud_firestore.dart';

enum RoomStatus {
  recruiting,
  full,
  started;

  static RoomStatus fromLabel(String label) {
    switch (label) {
      case 'full':
        return RoomStatus.full;
      case 'started':
        return RoomStatus.started;
      default:
        return RoomStatus.recruiting;
    }
  }

  String get label => name;

  String get displayLabel => switch (this) {
        RoomStatus.recruiting => '招募中',
        RoomStatus.full => '已滿員',
        RoomStatus.started => '已開始',
      };
}

class MeetupRoom {
  final String id;
  final String title;
  final String gameName;
  final String hostId;
  final String hostName;
  final String hostAvatar;
  final int maxPlayers;
  final DateTime date;
  final String time;
  final String location;
  final String description;
  final RoomStatus status;
  final int currentPlayerCount;
  final DateTime? createdAt;

  const MeetupRoom({
    required this.id,
    required this.title,
    required this.gameName,
    required this.hostId,
    required this.hostName,
    required this.hostAvatar,
    required this.maxPlayers,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
    required this.status,
    required this.currentPlayerCount,
    this.createdAt,
  });

  factory MeetupRoom.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MeetupRoom(
      id: doc.id,
      title: data['title'] as String? ?? '',
      gameName: data['gameName'] as String? ?? '',
      hostId: data['hostId'] as String? ?? '',
      hostName: data['hostName'] as String? ?? '',
      hostAvatar: data['hostAvatar'] as String? ?? '',
      maxPlayers: data['maxPlayers'] as int? ?? 0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: data['time'] as String? ?? '',
      location: data['location'] as String? ?? '',
      description: data['description'] as String? ?? '',
      status: RoomStatus.fromLabel(data['status'] as String? ?? 'recruiting'),
      currentPlayerCount: data['currentPlayerCount'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'gameName': gameName,
        'hostId': hostId,
        'hostName': hostName,
        'hostAvatar': hostAvatar,
        'maxPlayers': maxPlayers,
        'date': Timestamp.fromDate(date),
        'time': time,
        'location': location,
        'description': description,
        'status': status.label,
        'currentPlayerCount': currentPlayerCount,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      };
}
