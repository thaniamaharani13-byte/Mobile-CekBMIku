import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
  });

  final String name;
  final String email;
  final String password;
  final int age;
  final String gender;

  AppUser copyWith({
    String? name,
    int? age,
    String? gender,
    String? password,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email,
      password: password ?? this.password,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'age': age,
        'gender': gender,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        password: json['password'] as String? ?? '',
        age: (json['age'] as num?)?.toInt() ?? 0,
        gender: json['gender'] as String? ?? 'L',
      );

  @override
  List<Object?> get props => [name, email, password, age, gender];
}

class BmiResult extends Equatable {
  const BmiResult({
    required this.id,
    required this.userEmail,
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.idealWeight,
    required this.category,
    required this.gender,
    required this.createdAt,
  });

  final String id;
  final String userEmail;
  final double heightCm;
  final double weightKg;
  final double bmi;
  final double idealWeight;
  final String category;
  final String gender;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'bmi': bmi,
        'idealWeight': idealWeight,
        'category': category,
        'gender': gender,
        'createdAt': createdAt.toIso8601String(),
      };

  factory BmiResult.fromJson(Map<String, dynamic> json) => BmiResult(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        heightCm: (json['heightCm'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        bmi: (json['bmi'] as num).toDouble(),
        idealWeight: (json['idealWeight'] as num).toDouble(),
        category: json['category'] as String,
        gender: json['gender'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [
        id,
        userEmail,
        heightCm,
        weightKg,
        bmi,
        idealWeight,
        category,
        gender,
        createdAt,
      ];
}

class FeedbackItem extends Equatable {
  const FeedbackItem({
    required this.id,
    required this.userEmail,
    required this.userName,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String userEmail;
  final String userName;
  final String message;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userEmail': userEmail,
        'userName': userName,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
      };

  factory FeedbackItem.fromJson(Map<String, dynamic> json) => FeedbackItem(
        id: json['id'] as String,
        userEmail: json['userEmail'] as String,
        userName: json['userName'] as String,
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  @override
  List<Object?> get props => [id, userEmail, userName, message, createdAt];
}

class ArticleItem extends Equatable {
  const ArticleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final String image;
  final String category;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
        'category': category,
      };

  factory ArticleItem.fromJson(Map<String, dynamic> json) => ArticleItem(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        image: json['image'] as String,
        category: json['category'] as String,
      );

  @override
  List<Object?> get props => [id, title, description, image, category];
}

class FaqItem extends Equatable {
  const FaqItem({required this.id, required this.question, required this.answer});

  final String id;
  final String question;
  final String answer;

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answer': answer,
      };

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
        id: json['id'] as String,
        question: json['question'] as String,
        answer: json['answer'] as String,
      );

  @override
  List<Object?> get props => [id, question, answer];
}

class AboutContent extends Equatable {
  const AboutContent({
    required this.title,
    required this.opening,
    required this.goal,
    required this.features,
    required this.email,
    this.image = 'assets/images/banner_tentang_kami.jpg',
  });

  final String title;
  final String opening;
  final String goal;
  final String features;
  final String email;
  final String image;

  Map<String, dynamic> toJson() => {
        'title': title,
        'opening': opening,
        'goal': goal,
        'features': features,
        'email': email,
        'image': image,
      };

  factory AboutContent.fromJson(Map<String, dynamic> json) => AboutContent(
        title: json['title'] as String? ?? 'Tentang CekBMIKu',
        opening: json['opening'] as String? ?? '',
        goal: json['goal'] as String? ?? '',
        features: json['features'] as String? ?? '',
        email: json['email'] as String? ?? 'cekbmiku@gmail.com',
        image: json['image'] as String? ?? 'assets/images/banner_tentang_kami.jpg',
      );

  @override
  List<Object?> get props => [title, opening, goal, features, email, image];
}
