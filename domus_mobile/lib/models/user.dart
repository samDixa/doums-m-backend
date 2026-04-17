class User {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? profileImage;
  final bool isVerified;
  final String? subscriptionStatus;

  final String? gender;
  final String? dob;
  final String? country;
  final String? state;
  final String? district;
  final String? category;
  final String? designation;
  final String? batch;
  final String? ugCollegeState;
  final String? ugCollegeName;
  final String? googleId;

  User({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.profileImage,
    this.isVerified = false,
    this.subscriptionStatus,
    this.gender,
    this.dob,
    this.country,
    this.state,
    this.district,
    this.category,
    this.designation,
    this.batch,
    this.ugCollegeState,
    this.ugCollegeName,
    this.googleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String? ?? '',
      phone: json['mobile'] as String?,
      profileImage: json['profile_image'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      subscriptionStatus: json['subscription_status'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      district: json['district'] as String?,
      category: json['category'] as String?,
      designation: json['designation'] as String?,
      batch: json['batch'] as String?,
      ugCollegeState: json['ug_college_state'] as String?,
      ugCollegeName: json['ug_college_name'] as String?,
      googleId: json['google_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'subscription_status': subscriptionStatus,
      'gender': gender,
      'dob': dob,
      'country': country,
      'state': state,
      'district': district,
      'category': category,
      'designation': designation,
      'batch': batch,
      'ug_college_state': ugCollegeState,
      'ug_college_name': ugCollegeName,
      'google_id': googleId,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? profileImage,
    bool? isVerified,
    String? subscriptionStatus,
    String? gender,
    String? dob,
    String? country,
    String? state,
    String? district,
    String? category,
    String? designation,
    String? batch,
    String? ugCollegeState,
    String? ugCollegeName,
    String? googleId,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      category: category ?? this.category,
      designation: designation ?? this.designation,
      batch: batch ?? this.batch,
      ugCollegeState: ugCollegeState ?? this.ugCollegeState,
      ugCollegeName: ugCollegeName ?? this.ugCollegeName,
      googleId: googleId ?? this.googleId,
    );
  }
}
