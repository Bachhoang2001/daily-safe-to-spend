import 'package:budget_engine/budget_engine.dart';
import 'package:flutter/foundation.dart';

/// Domain model representing a user's budget profile and preferences.
@immutable
class BudgetProfileModel {
  /// Creates a [BudgetProfileModel].
  const BudgetProfileModel({
    required this.id,
    required this.config,
    this.timezone = 'UTC',
    this.weekStart = 1,
    this.onboardingCompleted = false,
  });

  /// Unique UUID v4 identifying this profile.
  final String id;

  /// Budget calculation configuration for the engine.
  final BudgetConfig config;

  /// IANA timezone identifier (e.g. 'America/New_York').
  final String timezone;

  /// Starting day of week (1 = Monday, ..., 7 = Sunday).
  final int weekStart;

  /// Whether the user has completed the onboarding flow.
  final bool onboardingCompleted;

  /// Creates a copy of this model with the given fields replaced.
  BudgetProfileModel copyWith({
    String? id,
    BudgetConfig? config,
    String? timezone,
    int? weekStart,
    bool? onboardingCompleted,
  }) {
    return BudgetProfileModel(
      id: id ?? this.id,
      config: config ?? this.config,
      timezone: timezone ?? this.timezone,
      weekStart: weekStart ?? this.weekStart,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BudgetProfileModel &&
        other.id == id &&
        other.config == config &&
        other.timezone == timezone &&
        other.weekStart == weekStart &&
        other.onboardingCompleted == onboardingCompleted;
  }

  @override
  int get hashCode =>
      Object.hash(id, config, timezone, weekStart, onboardingCompleted);

  @override
  String toString() =>
      'BudgetProfileModel(id: $id, config: $config, timezone: $timezone, weekStart: $weekStart, onboardingCompleted: $onboardingCompleted)';
}
