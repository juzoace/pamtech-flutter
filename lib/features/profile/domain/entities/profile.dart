class Profile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? preference;
  final String? description;
  final String? gender;
  final String country;
  final String? state;
  final String? city;
  final String? dob; // or DateTime if you parse it
  final String? address;
  final String referralId;
  final String referralBy;
  final String role;
  final String? garagePosition;
  final int? garageId;
  final String status;
  final String registerStatus;
  final String allowPush;
  final String terms;
  final String? expoToken;
  final String? deviceId;
  final String platform;
  final String? googleId;
  final String? emailVerifiedAt;
  final String avatar;
  final String createdAt;
  final String updatedAt;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.preference,
    required this.description,
    required this.gender,
    required this.country,
    required this.state,
    required this.city,
    required this.dob,
    required this.address,
    required this.referralId,
    required this.referralBy,
    required this.role,
    required this.garagePosition,
    required this.garageId,
    required this.status,
    required this.registerStatus,
    required this.allowPush,
    required this.terms,
    required this.expoToken,
    required this.deviceId,
    required this.platform,
    required this.googleId,
    required this.emailVerifiedAt,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });
}