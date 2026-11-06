import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_content.dart';
import '../models/models.dart';

class LocalStore {
  static const _usersKey = 'users';
  static const _sessionKey = 'current_user_email';
  static const _adminSessionKey = 'remembered_admin';
  static const _authMigrationKey = 'auth_remember_choice_initialized';
  static const _historyKey = 'bmi_history';
  static const _feedbackKey = 'feedback';
  static const _articlesKey = 'articles';
  static const _faqsKey = 'faqs';
  static const _aboutKey = 'about';
  static const _favoritesKey = 'favorite_articles';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<void> seed() async {
    final prefs = await _prefs;
    // Prior app versions always saved user sessions; require login once
    // after upgrading, then only persist logins when "Ingat saya" is on.
    if (!(prefs.getBool(_authMigrationKey) ?? false)) {
      await prefs.remove(_sessionKey);
      await prefs.remove(_adminSessionKey);
      await prefs.setBool(_authMigrationKey, true);
    }
    if (!prefs.containsKey(_articlesKey)) {
      await saveArticles(defaultArticles);
    }
    if (!prefs.containsKey(_faqsKey)) {
      await saveFaqs(defaultFaqs);
    }
    if (!prefs.containsKey(_aboutKey)) {
      await saveAbout(defaultAbout);
    }
  }

  Future<List<AppUser>> getUsers() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    return (jsonDecode(raw) as List)
        .map((e) => AppUser.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveUsers(List<AppUser> users) async {
    final prefs = await _prefs;
    await prefs.setString(_usersKey, jsonEncode(users.map((e) => e.toJson()).toList()));
  }

  Future<String?> register(AppUser user) async {
    final users = await getUsers();
    if (users.any((u) => u.email.toLowerCase() == user.email.toLowerCase())) {
      return 'Email sudah terdaftar. Silakan login.';
    }
    users.add(user);
    await saveUsers(users);
    return null;
  }

  /// Remember user login only when the checkbox is checked.
  Future<AppUser?> loginUser(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    final users = await getUsers();
    for (final user in users) {
      if (user.email.toLowerCase() == email.toLowerCase() &&
          user.password == password) {
        final prefs = await _prefs;
        if (rememberMe) {
          await prefs.setString(_sessionKey, user.email);
        } else {
          await prefs.remove(_sessionKey);
        }
        await prefs.remove(_adminSessionKey);
        return user;
      }
    }
    return null;
  }

  Future<AppUser?> currentUser() async {
    final prefs = await _prefs;
    final email = prefs.getString(_sessionKey);
    if (email == null) return null;
    final users = await getUsers();
    for (final user in users) {
      if (user.email == email) return user;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await _prefs;
    await prefs.remove(_sessionKey);
    await prefs.remove(_adminSessionKey);
  }

  Future<void> updateUser(AppUser updated) async {
    final users = await getUsers();
    final index = users.indexWhere((u) => u.email == updated.email);
    if (index >= 0) {
      users[index] = updated;
      await saveUsers(users);
    }
  }

  Future<List<BmiResult>> getHistory() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List)
        .map((e) => BmiResult.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<void> addBmi(BmiResult result) async {
    final prefs = await _prefs;
    final items = await getHistory();
    items.add(result);
    await prefs.setString(_historyKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<List<BmiResult>> historyFor(String email) async {
    final all = await getHistory();
    return all.where((e) => e.userEmail == email).toList();
  }

  Future<List<FeedbackItem>> getFeedback() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_feedbackKey);
    if (raw == null || raw.isEmpty) return [];
    final items = (jsonDecode(raw) as List)
        .map((e) => FeedbackItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> addFeedback(FeedbackItem item) async {
    final prefs = await _prefs;
    final items = await getFeedback();
    items.add(item);
    await prefs.setString(_feedbackKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<List<ArticleItem>> getArticles() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_articlesKey);
    if (raw == null || raw.isEmpty) return List.of(defaultArticles);
    return (jsonDecode(raw) as List)
        .map((e) => ArticleItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveArticles(List<ArticleItem> items) async {
    final prefs = await _prefs;
    await prefs.setString(_articlesKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }

  Future<List<FaqItem>> getFaqs() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_faqsKey);
    if (raw == null || raw.isEmpty) return List.of(defaultFaqs);
    return (jsonDecode(raw) as List)
        .map((e) => FaqItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveFaqs(List<FaqItem> items) async {
    final prefs = await _prefs;
    await prefs.setString(_faqsKey, jsonEncode(items.map((e) => e.toJson()).toList()));
  }
  Future<AboutContent> getAbout() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_aboutKey);
    if (raw == null || raw.isEmpty) return defaultAbout;
    return AboutContent.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
  }

  Future<void> saveAbout(AboutContent content) async {
    final prefs = await _prefs;
    await prefs.setString(_aboutKey, jsonEncode(content.toJson()));
  }


  Future<Set<String>> getFavoriteArticleIds() async {
    final prefs = await _prefs;
    return (prefs.getStringList(_favoritesKey) ?? const <String>[]).toSet();
  }

  Future<void> saveFavoriteArticleIds(Set<String> ids) async {
    final prefs = await _prefs;
    await prefs.setStringList(_favoritesKey, ids.toList());
  }

  Future<void> deleteUser(String email) async {
    final users = await getUsers();
    users.removeWhere((u) => u.email == email);
    await saveUsers(users);
  }

}

