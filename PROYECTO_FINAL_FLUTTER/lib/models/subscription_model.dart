import 'package:flutter/material.dart';

enum BillingCycle {
  monthly,
  annual,
}

class Subscription {
  final String id;
  final String name;
  final String platform;
  final double cost;
  final BillingCycle billingCycle;
  final DateTime renewalDate;
  final bool isFreeTrial;
  final DateTime? freeTrialEndDate;
  final bool isActive;

  Subscription({
    required this.id,
    required this.name,
    required this.platform,
    required this.cost,
    this.billingCycle = BillingCycle.monthly,
    required this.renewalDate,
    this.isFreeTrial = false,
    this.freeTrialEndDate,
    this.isActive = true,
  });

  /// Costo equivalente mensual para sumar al contador de gastos recolectados
  double get monthlyEquivalentCost {
    if (!isActive) return 0.0;
    if (billingCycle == BillingCycle.annual) {
      return cost / 12.0;
    }
    return cost;
  }

  /// Días restantes si es una prueba gratuita
  int get daysUntilTrialEnds {
    if (!isFreeTrial || freeTrialEndDate == null) return -1;
    final now = DateTime.now();
    final difference = freeTrialEndDate!.difference(now).inDays;
    return difference < 0 ? 0 : difference;
  }

  /// Indica si la prueba gratuita está próxima a vencer (≤ 5 días)
  bool get isTrialExpiringSoon {
    if (!isFreeTrial || freeTrialEndDate == null || !isActive) return false;
    return daysUntilTrialEnds <= 5;
  }

  Subscription copyWith({
    String? id,
    String? name,
    String? platform,
    double? cost,
    BillingCycle? billingCycle,
    DateTime? renewalDate,
    bool? isFreeTrial,
    DateTime? freeTrialEndDate,
    bool? isActive,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      platform: platform ?? this.platform,
      cost: cost ?? this.cost,
      billingCycle: billingCycle ?? this.billingCycle,
      renewalDate: renewalDate ?? this.renewalDate,
      isFreeTrial: isFreeTrial ?? this.isFreeTrial,
      freeTrialEndDate: freeTrialEndDate ?? this.freeTrialEndDate,
      isActive: isActive ?? this.isActive,
    );
  }

  static Color getPlatformColor(String platform) {
    final p = platform.toLowerCase();
    if (p.contains('netflix')) return const Color(0xFFE50914);
    if (p.contains('spotify')) return const Color(0xFF1DB954);
    if (p.contains('prime') || p.contains('amazon')) return const Color(0xFF00A8E1);
    if (p.contains('apple') || p.contains('icloud')) return const Color(0xFF555555);
    if (p.contains('hbo') || p.contains('max')) return const Color(0xFF7F00FF);
    if (p.contains('disney')) return const Color(0xFF113CCF);
    if (p.contains('youtube')) return const Color(0xFFFF0000);
    if (p.contains('chatgpt') || p.contains('openai')) return const Color(0xFF10A37F);
    return const Color(0xFF06B6D4);
  }

  static IconData getPlatformIcon(String platform) {
    final p = platform.toLowerCase();
    if (p.contains('spotify') || p.contains('music')) return Icons.library_music_outlined;
    if (p.contains('netflix') || p.contains('hbo') || p.contains('disney') || p.contains('prime') || p.contains('video')) {
      return Icons.tv_outlined;
    }
    if (p.contains('apple') || p.contains('icloud') || p.contains('cloud')) return Icons.cloud_outlined;
    if (p.contains('chatgpt') || p.contains('ai')) return Icons.auto_awesome_outlined;
    if (p.contains('game') || p.contains('play') || p.contains('xbox') || p.contains('psn')) {
      return Icons.sports_esports_outlined;
    }
    return Icons.subscriptions_outlined;
  }
}
