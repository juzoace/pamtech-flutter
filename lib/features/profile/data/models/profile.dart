import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.preference,
    super.description,
    super.gender,
    required super.country,
    super.state,
    super.city,
    super.dob,
    super.address,
    required super.referralId,
    required super.referralBy,
    required super.role,
    super.garagePosition,
    super.garageId,
    required super.status,
    required super.registerStatus,
    required super.allowPush,
    required super.terms,
    super.expoToken,
    super.deviceId,
    required super.platform,
    super.googleId,
    super.emailVerifiedAt,
    required super.avatar,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String asString(dynamic value, {String fallback = ''}) {
      final text = value?.toString();
      if (text == null || text.trim().isEmpty || text == 'null') {
        return fallback;
      }
      return text;
    }

    int asInt(dynamic value, {int fallback = 0}) {
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    return ProfileModel(
      id: asInt(json['id']),
      name: asString(json['name'], fallback: 'Guest User'),
      email: asString(json['email'], fallback: 'guest@example.com'),
      phone: asString(json['phone'], fallback: 'N/A'),
      preference: asString(json['preference']).isEmpty
          ? null
          : asString(json['preference']),
      description: asString(json['description']).isEmpty
          ? null
          : asString(json['description']),
      gender:
          asString(json['gender']).isEmpty ? null : asString(json['gender']),
      country: asString(json['country'], fallback: 'Unknown'),
      state: asString(json['state']).isEmpty ? null : asString(json['state']),
      city: asString(json['city']).isEmpty ? null : asString(json['city']),
      dob: asString(json['dob']).isEmpty ? null : asString(json['dob']),
      address:
          asString(json['address']).isEmpty ? null : asString(json['address']),
      referralId: asString(json['referral_id'], fallback: 'N/A'),
      referralBy: asString(json['referral_by'], fallback: 'N/A'),
      role: asString(json['role'], fallback: 'user'),
      garagePosition: asString(json['garage_position']).isEmpty
          ? null
          : asString(json['garage_position']),
      garageId:
          asString(json['garage_id']).isEmpty ? null : asInt(json['garage_id']),
      status: asString(json['status'], fallback: 'inactive'),
      registerStatus: asString(json['register_status'], fallback: 'new'),
      allowPush: asString(json['allow_push'], fallback: '0'),
      terms: asString(json['terms'], fallback: '0'),
      expoToken: asString(json['expo_token']).isEmpty
          ? null
          : asString(json['expo_token']),
      deviceId: asString(json['device_id']).isEmpty
          ? null
          : asString(json['device_id']),
      platform: asString(json['platform'], fallback: 'unknown'),
      googleId: asString(json['google_id']).isEmpty
          ? null
          : asString(json['google_id']),
      emailVerifiedAt: asString(json['email_verified_at']).isEmpty
          ? null
          : asString(json['email_verified_at']),
      avatar: asString(json['avatar']),
      createdAt: asString(json['created_at'], fallback: 'N/A'),
      updatedAt: asString(json['updated_at'], fallback: 'N/A'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'preference': preference,
      'description': description,
      'gender': gender,
      'country': country,
      'state': state,
      'city': city,
      'dob': dob,
      'address': address,
      'referral_id': referralId,
      'referral_by': referralBy,
      'role': role,
      'garage_position': garagePosition,
      'garage_id': garageId,
      'status': status,
      'register_status': registerStatus,
      'allow_push': allowPush,
      'terms': terms,
      'expo_token': expoToken,
      'device_id': deviceId,
      'platform': platform,
      'google_id': googleId,
      'email_verified_at': emailVerifiedAt,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
