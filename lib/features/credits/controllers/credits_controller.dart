import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/credit_entry.dart';

class CreditsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxList<CreditEntry> credits = <CreditEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCredits();
  }

  Future<void> _loadCredits() async {
    try {
      final content = await rootBundle.loadString('assets/data/credits.jsonl');
      final parsedCredits = content
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .map(
            (line) =>
                CreditEntry.fromJson(jsonDecode(line) as Map<String, dynamic>),
          )
          .toList(growable: false);

      credits.assignAll(parsedCredits);
    } catch (_) {
      errorMessage.value = 'Unable to load credits.';
    } finally {
      isLoading.value = false;
    }
  }

  List<MapEntry<String, List<CreditEntry>>> get groupedCredits {
    final grouped = <String, List<CreditEntry>>{};
    for (final credit in credits) {
      grouped.putIfAbsent(credit.category, () => <CreditEntry>[]).add(credit);
    }

    final entries = grouped.entries.toList();
    entries.sort((a, b) {
      final categoryComparison = _categoryRank(
        a.key,
      ).compareTo(_categoryRank(b.key));
      if (categoryComparison != 0) return categoryComparison;
      return a.key.compareTo(b.key);
    });
    return entries;
  }

  int _categoryRank(String category) {
    switch (category) {
      case 'audio':
        return 0;
      default:
        return 99;
    }
  }

  String formatCategory(String category) {
    return category.isEmpty
        ? 'Uncategorized'
        : '${category[0].toUpperCase()}${category.substring(1)}';
  }
}
