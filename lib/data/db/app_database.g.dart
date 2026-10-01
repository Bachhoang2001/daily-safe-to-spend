// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BudgetProfilesTableTable extends BudgetProfilesTable
    with TableInfo<$BudgetProfilesTableTable, BudgetProfileData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _incomeModeMeta = const VerificationMeta(
    'incomeMode',
  );
  @override
  late final GeneratedColumn<String> incomeMode = GeneratedColumn<String>(
    'income_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payFrequencyMeta = const VerificationMeta(
    'payFrequency',
  );
  @override
  late final GeneratedColumn<String> payFrequency = GeneratedColumn<String>(
    'pay_frequency',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payAnchorDateMeta = const VerificationMeta(
    'payAnchorDate',
  );
  @override
  late final GeneratedColumn<String> payAnchorDate = GeneratedColumn<String>(
    'pay_anchor_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incomePerPaycheckCentsMeta =
      const VerificationMeta('incomePerPaycheckCents');
  @override
  late final GeneratedColumn<int> incomePerPaycheckCents = GeneratedColumn<int>(
    'income_per_paycheck_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstPeriodBalanceCentsMeta =
      const VerificationMeta('firstPeriodBalanceCents');
  @override
  late final GeneratedColumn<int> firstPeriodBalanceCents =
      GeneratedColumn<int>(
        'first_period_balance_cents',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startingBalanceCentsMeta =
      const VerificationMeta('startingBalanceCents');
  @override
  late final GeneratedColumn<int> startingBalanceCents = GeneratedColumn<int>(
    'starting_balance_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trackingStartDateMeta = const VerificationMeta(
    'trackingStartDate',
  );
  @override
  late final GeneratedColumn<String> trackingStartDate =
      GeneratedColumn<String>(
        'tracking_start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _safetyHorizonDaysMeta = const VerificationMeta(
    'safetyHorizonDays',
  );
  @override
  late final GeneratedColumn<int> safetyHorizonDays = GeneratedColumn<int>(
    'safety_horizon_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(14),
  );
  static const VerificationMeta _bufferPercentMeta = const VerificationMeta(
    'bufferPercent',
  );
  @override
  late final GeneratedColumn<int> bufferPercent = GeneratedColumn<int>(
    'buffer_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rolloverModeMeta = const VerificationMeta(
    'rolloverMode',
  );
  @override
  late final GeneratedColumn<String> rolloverMode = GeneratedColumn<String>(
    'rollover_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('spread'),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<int> weekStart = GeneratedColumn<int>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    currency,
    incomeMode,
    payFrequency,
    payAnchorDate,
    incomePerPaycheckCents,
    firstPeriodBalanceCents,
    startingBalanceCents,
    trackingStartDate,
    safetyHorizonDays,
    bufferPercent,
    rolloverMode,
    timezone,
    weekStart,
    onboardingCompleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetProfileData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('income_mode')) {
      context.handle(
        _incomeModeMeta,
        incomeMode.isAcceptableOrUnknown(data['income_mode']!, _incomeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_incomeModeMeta);
    }
    if (data.containsKey('pay_frequency')) {
      context.handle(
        _payFrequencyMeta,
        payFrequency.isAcceptableOrUnknown(
          data['pay_frequency']!,
          _payFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('pay_anchor_date')) {
      context.handle(
        _payAnchorDateMeta,
        payAnchorDate.isAcceptableOrUnknown(
          data['pay_anchor_date']!,
          _payAnchorDateMeta,
        ),
      );
    }
    if (data.containsKey('income_per_paycheck_cents')) {
      context.handle(
        _incomePerPaycheckCentsMeta,
        incomePerPaycheckCents.isAcceptableOrUnknown(
          data['income_per_paycheck_cents']!,
          _incomePerPaycheckCentsMeta,
        ),
      );
    }
    if (data.containsKey('first_period_balance_cents')) {
      context.handle(
        _firstPeriodBalanceCentsMeta,
        firstPeriodBalanceCents.isAcceptableOrUnknown(
          data['first_period_balance_cents']!,
          _firstPeriodBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('starting_balance_cents')) {
      context.handle(
        _startingBalanceCentsMeta,
        startingBalanceCents.isAcceptableOrUnknown(
          data['starting_balance_cents']!,
          _startingBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('tracking_start_date')) {
      context.handle(
        _trackingStartDateMeta,
        trackingStartDate.isAcceptableOrUnknown(
          data['tracking_start_date']!,
          _trackingStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackingStartDateMeta);
    }
    if (data.containsKey('safety_horizon_days')) {
      context.handle(
        _safetyHorizonDaysMeta,
        safetyHorizonDays.isAcceptableOrUnknown(
          data['safety_horizon_days']!,
          _safetyHorizonDaysMeta,
        ),
      );
    }
    if (data.containsKey('buffer_percent')) {
      context.handle(
        _bufferPercentMeta,
        bufferPercent.isAcceptableOrUnknown(
          data['buffer_percent']!,
          _bufferPercentMeta,
        ),
      );
    }
    if (data.containsKey('rollover_mode')) {
      context.handle(
        _rolloverModeMeta,
        rolloverMode.isAcceptableOrUnknown(
          data['rollover_mode']!,
          _rolloverModeMeta,
        ),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetProfileData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetProfileData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      incomeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_mode'],
      )!,
      payFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_frequency'],
      ),
      payAnchorDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pay_anchor_date'],
      ),
      incomePerPaycheckCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income_per_paycheck_cents'],
      ),
      firstPeriodBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}first_period_balance_cents'],
      ),
      startingBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_balance_cents'],
      ),
      trackingStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_start_date'],
      )!,
      safetyHorizonDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}safety_horizon_days'],
      )!,
      bufferPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}buffer_percent'],
      )!,
      rolloverMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rollover_mode'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_start'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
    );
  }

  @override
  $BudgetProfilesTableTable createAlias(String alias) {
    return $BudgetProfilesTableTable(attachedDatabase, alias);
  }
}

class BudgetProfileData extends DataClass
    implements Insertable<BudgetProfileData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Primary currency code (e.g. 'USD').
  final String currency;

  /// Income calculation mode ('fixed' | 'irregular').
  final String incomeMode;

  /// Paycheck frequency for fixed income ('weekly', 'biweekly', 'semimonthly', 'monthly').
  final String? payFrequency;

  /// Known past paycheck date formatted as ISO string 'YYYY-MM-DD'.
  final String? payAnchorDate;

  /// Income amount per paycheck in integer cents.
  final int? incomePerPaycheckCents;

  /// Initial balance for the first period when onboarding mid-cycle.
  final int? firstPeriodBalanceCents;

  /// Starting liquid balance for irregular income mode.
  final int? startingBalanceCents;

  /// Date tracking started formatted as ISO string 'YYYY-MM-DD'.
  final String trackingStartDate;

  /// Safety horizon in days for irregular mode (default 14).
  final int safetyHorizonDays;

  /// Emergency buffer safety percentage (0-20%).
  final int bufferPercent;

  /// Rollover strategy ('spread', 'tomorrow', 'save').
  final String rolloverMode;

  /// User timezone name (e.g. 'America/New_York').
  final String timezone;

  /// Starting day of week (1 = Monday, ..., 7 = Sunday).
  final int weekStart;

  /// Flag indicating whether onboarding has been completed.
  final bool onboardingCompleted;
  const BudgetProfileData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.currency,
    required this.incomeMode,
    this.payFrequency,
    this.payAnchorDate,
    this.incomePerPaycheckCents,
    this.firstPeriodBalanceCents,
    this.startingBalanceCents,
    required this.trackingStartDate,
    required this.safetyHorizonDays,
    required this.bufferPercent,
    required this.rolloverMode,
    required this.timezone,
    required this.weekStart,
    required this.onboardingCompleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['currency'] = Variable<String>(currency);
    map['income_mode'] = Variable<String>(incomeMode);
    if (!nullToAbsent || payFrequency != null) {
      map['pay_frequency'] = Variable<String>(payFrequency);
    }
    if (!nullToAbsent || payAnchorDate != null) {
      map['pay_anchor_date'] = Variable<String>(payAnchorDate);
    }
    if (!nullToAbsent || incomePerPaycheckCents != null) {
      map['income_per_paycheck_cents'] = Variable<int>(incomePerPaycheckCents);
    }
    if (!nullToAbsent || firstPeriodBalanceCents != null) {
      map['first_period_balance_cents'] = Variable<int>(
        firstPeriodBalanceCents,
      );
    }
    if (!nullToAbsent || startingBalanceCents != null) {
      map['starting_balance_cents'] = Variable<int>(startingBalanceCents);
    }
    map['tracking_start_date'] = Variable<String>(trackingStartDate);
    map['safety_horizon_days'] = Variable<int>(safetyHorizonDays);
    map['buffer_percent'] = Variable<int>(bufferPercent);
    map['rollover_mode'] = Variable<String>(rolloverMode);
    map['timezone'] = Variable<String>(timezone);
    map['week_start'] = Variable<int>(weekStart);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    return map;
  }

  BudgetProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetProfilesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      currency: Value(currency),
      incomeMode: Value(incomeMode),
      payFrequency: payFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(payFrequency),
      payAnchorDate: payAnchorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(payAnchorDate),
      incomePerPaycheckCents: incomePerPaycheckCents == null && nullToAbsent
          ? const Value.absent()
          : Value(incomePerPaycheckCents),
      firstPeriodBalanceCents: firstPeriodBalanceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(firstPeriodBalanceCents),
      startingBalanceCents: startingBalanceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(startingBalanceCents),
      trackingStartDate: Value(trackingStartDate),
      safetyHorizonDays: Value(safetyHorizonDays),
      bufferPercent: Value(bufferPercent),
      rolloverMode: Value(rolloverMode),
      timezone: Value(timezone),
      weekStart: Value(weekStart),
      onboardingCompleted: Value(onboardingCompleted),
    );
  }

  factory BudgetProfileData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetProfileData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      currency: serializer.fromJson<String>(json['currency']),
      incomeMode: serializer.fromJson<String>(json['incomeMode']),
      payFrequency: serializer.fromJson<String?>(json['payFrequency']),
      payAnchorDate: serializer.fromJson<String?>(json['payAnchorDate']),
      incomePerPaycheckCents: serializer.fromJson<int?>(
        json['incomePerPaycheckCents'],
      ),
      firstPeriodBalanceCents: serializer.fromJson<int?>(
        json['firstPeriodBalanceCents'],
      ),
      startingBalanceCents: serializer.fromJson<int?>(
        json['startingBalanceCents'],
      ),
      trackingStartDate: serializer.fromJson<String>(json['trackingStartDate']),
      safetyHorizonDays: serializer.fromJson<int>(json['safetyHorizonDays']),
      bufferPercent: serializer.fromJson<int>(json['bufferPercent']),
      rolloverMode: serializer.fromJson<String>(json['rolloverMode']),
      timezone: serializer.fromJson<String>(json['timezone']),
      weekStart: serializer.fromJson<int>(json['weekStart']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'currency': serializer.toJson<String>(currency),
      'incomeMode': serializer.toJson<String>(incomeMode),
      'payFrequency': serializer.toJson<String?>(payFrequency),
      'payAnchorDate': serializer.toJson<String?>(payAnchorDate),
      'incomePerPaycheckCents': serializer.toJson<int?>(incomePerPaycheckCents),
      'firstPeriodBalanceCents': serializer.toJson<int?>(
        firstPeriodBalanceCents,
      ),
      'startingBalanceCents': serializer.toJson<int?>(startingBalanceCents),
      'trackingStartDate': serializer.toJson<String>(trackingStartDate),
      'safetyHorizonDays': serializer.toJson<int>(safetyHorizonDays),
      'bufferPercent': serializer.toJson<int>(bufferPercent),
      'rolloverMode': serializer.toJson<String>(rolloverMode),
      'timezone': serializer.toJson<String>(timezone),
      'weekStart': serializer.toJson<int>(weekStart),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
    };
  }

  BudgetProfileData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? currency,
    String? incomeMode,
    Value<String?> payFrequency = const Value.absent(),
    Value<String?> payAnchorDate = const Value.absent(),
    Value<int?> incomePerPaycheckCents = const Value.absent(),
    Value<int?> firstPeriodBalanceCents = const Value.absent(),
    Value<int?> startingBalanceCents = const Value.absent(),
    String? trackingStartDate,
    int? safetyHorizonDays,
    int? bufferPercent,
    String? rolloverMode,
    String? timezone,
    int? weekStart,
    bool? onboardingCompleted,
  }) => BudgetProfileData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    currency: currency ?? this.currency,
    incomeMode: incomeMode ?? this.incomeMode,
    payFrequency: payFrequency.present ? payFrequency.value : this.payFrequency,
    payAnchorDate: payAnchorDate.present
        ? payAnchorDate.value
        : this.payAnchorDate,
    incomePerPaycheckCents: incomePerPaycheckCents.present
        ? incomePerPaycheckCents.value
        : this.incomePerPaycheckCents,
    firstPeriodBalanceCents: firstPeriodBalanceCents.present
        ? firstPeriodBalanceCents.value
        : this.firstPeriodBalanceCents,
    startingBalanceCents: startingBalanceCents.present
        ? startingBalanceCents.value
        : this.startingBalanceCents,
    trackingStartDate: trackingStartDate ?? this.trackingStartDate,
    safetyHorizonDays: safetyHorizonDays ?? this.safetyHorizonDays,
    bufferPercent: bufferPercent ?? this.bufferPercent,
    rolloverMode: rolloverMode ?? this.rolloverMode,
    timezone: timezone ?? this.timezone,
    weekStart: weekStart ?? this.weekStart,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
  );
  BudgetProfileData copyWithCompanion(BudgetProfilesTableCompanion data) {
    return BudgetProfileData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      currency: data.currency.present ? data.currency.value : this.currency,
      incomeMode: data.incomeMode.present
          ? data.incomeMode.value
          : this.incomeMode,
      payFrequency: data.payFrequency.present
          ? data.payFrequency.value
          : this.payFrequency,
      payAnchorDate: data.payAnchorDate.present
          ? data.payAnchorDate.value
          : this.payAnchorDate,
      incomePerPaycheckCents: data.incomePerPaycheckCents.present
          ? data.incomePerPaycheckCents.value
          : this.incomePerPaycheckCents,
      firstPeriodBalanceCents: data.firstPeriodBalanceCents.present
          ? data.firstPeriodBalanceCents.value
          : this.firstPeriodBalanceCents,
      startingBalanceCents: data.startingBalanceCents.present
          ? data.startingBalanceCents.value
          : this.startingBalanceCents,
      trackingStartDate: data.trackingStartDate.present
          ? data.trackingStartDate.value
          : this.trackingStartDate,
      safetyHorizonDays: data.safetyHorizonDays.present
          ? data.safetyHorizonDays.value
          : this.safetyHorizonDays,
      bufferPercent: data.bufferPercent.present
          ? data.bufferPercent.value
          : this.bufferPercent,
      rolloverMode: data.rolloverMode.present
          ? data.rolloverMode.value
          : this.rolloverMode,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetProfileData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('currency: $currency, ')
          ..write('incomeMode: $incomeMode, ')
          ..write('payFrequency: $payFrequency, ')
          ..write('payAnchorDate: $payAnchorDate, ')
          ..write('incomePerPaycheckCents: $incomePerPaycheckCents, ')
          ..write('firstPeriodBalanceCents: $firstPeriodBalanceCents, ')
          ..write('startingBalanceCents: $startingBalanceCents, ')
          ..write('trackingStartDate: $trackingStartDate, ')
          ..write('safetyHorizonDays: $safetyHorizonDays, ')
          ..write('bufferPercent: $bufferPercent, ')
          ..write('rolloverMode: $rolloverMode, ')
          ..write('timezone: $timezone, ')
          ..write('weekStart: $weekStart, ')
          ..write('onboardingCompleted: $onboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    currency,
    incomeMode,
    payFrequency,
    payAnchorDate,
    incomePerPaycheckCents,
    firstPeriodBalanceCents,
    startingBalanceCents,
    trackingStartDate,
    safetyHorizonDays,
    bufferPercent,
    rolloverMode,
    timezone,
    weekStart,
    onboardingCompleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetProfileData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.currency == this.currency &&
          other.incomeMode == this.incomeMode &&
          other.payFrequency == this.payFrequency &&
          other.payAnchorDate == this.payAnchorDate &&
          other.incomePerPaycheckCents == this.incomePerPaycheckCents &&
          other.firstPeriodBalanceCents == this.firstPeriodBalanceCents &&
          other.startingBalanceCents == this.startingBalanceCents &&
          other.trackingStartDate == this.trackingStartDate &&
          other.safetyHorizonDays == this.safetyHorizonDays &&
          other.bufferPercent == this.bufferPercent &&
          other.rolloverMode == this.rolloverMode &&
          other.timezone == this.timezone &&
          other.weekStart == this.weekStart &&
          other.onboardingCompleted == this.onboardingCompleted);
}

class BudgetProfilesTableCompanion extends UpdateCompanion<BudgetProfileData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> currency;
  final Value<String> incomeMode;
  final Value<String?> payFrequency;
  final Value<String?> payAnchorDate;
  final Value<int?> incomePerPaycheckCents;
  final Value<int?> firstPeriodBalanceCents;
  final Value<int?> startingBalanceCents;
  final Value<String> trackingStartDate;
  final Value<int> safetyHorizonDays;
  final Value<int> bufferPercent;
  final Value<String> rolloverMode;
  final Value<String> timezone;
  final Value<int> weekStart;
  final Value<bool> onboardingCompleted;
  final Value<int> rowid;
  const BudgetProfilesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.currency = const Value.absent(),
    this.incomeMode = const Value.absent(),
    this.payFrequency = const Value.absent(),
    this.payAnchorDate = const Value.absent(),
    this.incomePerPaycheckCents = const Value.absent(),
    this.firstPeriodBalanceCents = const Value.absent(),
    this.startingBalanceCents = const Value.absent(),
    this.trackingStartDate = const Value.absent(),
    this.safetyHorizonDays = const Value.absent(),
    this.bufferPercent = const Value.absent(),
    this.rolloverMode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetProfilesTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    this.currency = const Value.absent(),
    required String incomeMode,
    this.payFrequency = const Value.absent(),
    this.payAnchorDate = const Value.absent(),
    this.incomePerPaycheckCents = const Value.absent(),
    this.firstPeriodBalanceCents = const Value.absent(),
    this.startingBalanceCents = const Value.absent(),
    required String trackingStartDate,
    this.safetyHorizonDays = const Value.absent(),
    this.bufferPercent = const Value.absent(),
    this.rolloverMode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       incomeMode = Value(incomeMode),
       trackingStartDate = Value(trackingStartDate);
  static Insertable<BudgetProfileData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? currency,
    Expression<String>? incomeMode,
    Expression<String>? payFrequency,
    Expression<String>? payAnchorDate,
    Expression<int>? incomePerPaycheckCents,
    Expression<int>? firstPeriodBalanceCents,
    Expression<int>? startingBalanceCents,
    Expression<String>? trackingStartDate,
    Expression<int>? safetyHorizonDays,
    Expression<int>? bufferPercent,
    Expression<String>? rolloverMode,
    Expression<String>? timezone,
    Expression<int>? weekStart,
    Expression<bool>? onboardingCompleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (currency != null) 'currency': currency,
      if (incomeMode != null) 'income_mode': incomeMode,
      if (payFrequency != null) 'pay_frequency': payFrequency,
      if (payAnchorDate != null) 'pay_anchor_date': payAnchorDate,
      if (incomePerPaycheckCents != null)
        'income_per_paycheck_cents': incomePerPaycheckCents,
      if (firstPeriodBalanceCents != null)
        'first_period_balance_cents': firstPeriodBalanceCents,
      if (startingBalanceCents != null)
        'starting_balance_cents': startingBalanceCents,
      if (trackingStartDate != null) 'tracking_start_date': trackingStartDate,
      if (safetyHorizonDays != null) 'safety_horizon_days': safetyHorizonDays,
      if (bufferPercent != null) 'buffer_percent': bufferPercent,
      if (rolloverMode != null) 'rollover_mode': rolloverMode,
      if (timezone != null) 'timezone': timezone,
      if (weekStart != null) 'week_start': weekStart,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetProfilesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? currency,
    Value<String>? incomeMode,
    Value<String?>? payFrequency,
    Value<String?>? payAnchorDate,
    Value<int?>? incomePerPaycheckCents,
    Value<int?>? firstPeriodBalanceCents,
    Value<int?>? startingBalanceCents,
    Value<String>? trackingStartDate,
    Value<int>? safetyHorizonDays,
    Value<int>? bufferPercent,
    Value<String>? rolloverMode,
    Value<String>? timezone,
    Value<int>? weekStart,
    Value<bool>? onboardingCompleted,
    Value<int>? rowid,
  }) {
    return BudgetProfilesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      currency: currency ?? this.currency,
      incomeMode: incomeMode ?? this.incomeMode,
      payFrequency: payFrequency ?? this.payFrequency,
      payAnchorDate: payAnchorDate ?? this.payAnchorDate,
      incomePerPaycheckCents:
          incomePerPaycheckCents ?? this.incomePerPaycheckCents,
      firstPeriodBalanceCents:
          firstPeriodBalanceCents ?? this.firstPeriodBalanceCents,
      startingBalanceCents: startingBalanceCents ?? this.startingBalanceCents,
      trackingStartDate: trackingStartDate ?? this.trackingStartDate,
      safetyHorizonDays: safetyHorizonDays ?? this.safetyHorizonDays,
      bufferPercent: bufferPercent ?? this.bufferPercent,
      rolloverMode: rolloverMode ?? this.rolloverMode,
      timezone: timezone ?? this.timezone,
      weekStart: weekStart ?? this.weekStart,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (incomeMode.present) {
      map['income_mode'] = Variable<String>(incomeMode.value);
    }
    if (payFrequency.present) {
      map['pay_frequency'] = Variable<String>(payFrequency.value);
    }
    if (payAnchorDate.present) {
      map['pay_anchor_date'] = Variable<String>(payAnchorDate.value);
    }
    if (incomePerPaycheckCents.present) {
      map['income_per_paycheck_cents'] = Variable<int>(
        incomePerPaycheckCents.value,
      );
    }
    if (firstPeriodBalanceCents.present) {
      map['first_period_balance_cents'] = Variable<int>(
        firstPeriodBalanceCents.value,
      );
    }
    if (startingBalanceCents.present) {
      map['starting_balance_cents'] = Variable<int>(startingBalanceCents.value);
    }
    if (trackingStartDate.present) {
      map['tracking_start_date'] = Variable<String>(trackingStartDate.value);
    }
    if (safetyHorizonDays.present) {
      map['safety_horizon_days'] = Variable<int>(safetyHorizonDays.value);
    }
    if (bufferPercent.present) {
      map['buffer_percent'] = Variable<int>(bufferPercent.value);
    }
    if (rolloverMode.present) {
      map['rollover_mode'] = Variable<String>(rolloverMode.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<int>(weekStart.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('currency: $currency, ')
          ..write('incomeMode: $incomeMode, ')
          ..write('payFrequency: $payFrequency, ')
          ..write('payAnchorDate: $payAnchorDate, ')
          ..write('incomePerPaycheckCents: $incomePerPaycheckCents, ')
          ..write('firstPeriodBalanceCents: $firstPeriodBalanceCents, ')
          ..write('startingBalanceCents: $startingBalanceCents, ')
          ..write('trackingStartDate: $trackingStartDate, ')
          ..write('safetyHorizonDays: $safetyHorizonDays, ')
          ..write('bufferPercent: $bufferPercent, ')
          ..write('rolloverMode: $rolloverMode, ')
          ..write('timezone: $timezone, ')
          ..write('weekStart: $weekStart, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeEntriesTableTable extends IncomeEntriesTable
    with TableInfo<$IncomeEntriesTableTable, IncomeEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedOnMeta = const VerificationMeta(
    'receivedOn',
  );
  @override
  late final GeneratedColumn<String> receivedOn = GeneratedColumn<String>(
    'received_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    amountCents,
    receivedOn,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('received_on')) {
      context.handle(
        _receivedOnMeta,
        receivedOn.isAcceptableOrUnknown(data['received_on']!, _receivedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedOnMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      receivedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}received_on'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $IncomeEntriesTableTable createAlias(String alias) {
    return $IncomeEntriesTableTable(attachedDatabase, alias);
  }
}

class IncomeEntryData extends DataClass implements Insertable<IncomeEntryData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Logical foreign key reference to the parent budget profile.
  final String profileId;

  /// Income amount in integer cents.
  final int amountCents;

  /// Date the income was received formatted as ISO string 'YYYY-MM-DD'.
  final String receivedOn;

  /// Optional description or note for this income.
  final String? note;
  const IncomeEntryData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.profileId,
    required this.amountCents,
    required this.receivedOn,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['profile_id'] = Variable<String>(profileId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['received_on'] = Variable<String>(receivedOn);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  IncomeEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return IncomeEntriesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      profileId: Value(profileId),
      amountCents: Value(amountCents),
      receivedOn: Value(receivedOn),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory IncomeEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeEntryData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      receivedOn: serializer.fromJson<String>(json['receivedOn']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'profileId': serializer.toJson<String>(profileId),
      'amountCents': serializer.toJson<int>(amountCents),
      'receivedOn': serializer.toJson<String>(receivedOn),
      'note': serializer.toJson<String?>(note),
    };
  }

  IncomeEntryData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? profileId,
    int? amountCents,
    String? receivedOn,
    Value<String?> note = const Value.absent(),
  }) => IncomeEntryData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    profileId: profileId ?? this.profileId,
    amountCents: amountCents ?? this.amountCents,
    receivedOn: receivedOn ?? this.receivedOn,
    note: note.present ? note.value : this.note,
  );
  IncomeEntryData copyWithCompanion(IncomeEntriesTableCompanion data) {
    return IncomeEntryData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      receivedOn: data.receivedOn.present
          ? data.receivedOn.value
          : this.receivedOn,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeEntryData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('amountCents: $amountCents, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    amountCents,
    receivedOn,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeEntryData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.profileId == this.profileId &&
          other.amountCents == this.amountCents &&
          other.receivedOn == this.receivedOn &&
          other.note == this.note);
}

class IncomeEntriesTableCompanion extends UpdateCompanion<IncomeEntryData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> profileId;
  final Value<int> amountCents;
  final Value<String> receivedOn;
  final Value<String?> note;
  final Value<int> rowid;
  const IncomeEntriesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.receivedOn = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeEntriesTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String profileId,
    required int amountCents,
    required String receivedOn,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       profileId = Value(profileId),
       amountCents = Value(amountCents),
       receivedOn = Value(receivedOn);
  static Insertable<IncomeEntryData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? profileId,
    Expression<int>? amountCents,
    Expression<String>? receivedOn,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (profileId != null) 'profile_id': profileId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (receivedOn != null) 'received_on': receivedOn,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? profileId,
    Value<int>? amountCents,
    Value<String>? receivedOn,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return IncomeEntriesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      profileId: profileId ?? this.profileId,
      amountCents: amountCents ?? this.amountCents,
      receivedOn: receivedOn ?? this.receivedOn,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (receivedOn.present) {
      map['received_on'] = Variable<String>(receivedOn.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('amountCents: $amountCents, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillsTableTable extends BillsTable
    with TableInfo<$BillsTableTable, BillData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<String> recurrence = GeneratedColumn<String>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstDueDateMeta = const VerificationMeta(
    'firstDueDate',
  );
  @override
  late final GeneratedColumn<String> firstDueDate = GeneratedColumn<String>(
    'first_due_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remindDaysBeforeMeta = const VerificationMeta(
    'remindDaysBefore',
  );
  @override
  late final GeneratedColumn<int> remindDaysBefore = GeneratedColumn<int>(
    'remind_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    name,
    amountCents,
    recurrence,
    firstDueDate,
    remindDaysBefore,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bills';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    } else if (isInserting) {
      context.missing(_recurrenceMeta);
    }
    if (data.containsKey('first_due_date')) {
      context.handle(
        _firstDueDateMeta,
        firstDueDate.isAcceptableOrUnknown(
          data['first_due_date']!,
          _firstDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_firstDueDateMeta);
    }
    if (data.containsKey('remind_days_before')) {
      context.handle(
        _remindDaysBeforeMeta,
        remindDaysBefore.isAcceptableOrUnknown(
          data['remind_days_before']!,
          _remindDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence'],
      )!,
      firstDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_due_date'],
      )!,
      remindDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remind_days_before'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $BillsTableTable createAlias(String alias) {
    return $BillsTableTable(attachedDatabase, alias);
  }
}

class BillData extends DataClass implements Insertable<BillData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Logical foreign key reference to the parent budget profile.
  final String profileId;

  /// User-defined bill name (e.g. 'Internet', 'Rent').
  final String name;

  /// Due amount in integer cents.
  final int amountCents;

  /// Recurrence cycle ('weekly', 'biweekly', 'monthly', 'yearly').
  final String recurrence;

  /// First due date formatted as ISO string 'YYYY-MM-DD'.
  final String firstDueDate;

  /// Number of days before due date to trigger notification reminder.
  final int remindDaysBefore;

  /// Whether the bill is currently active.
  final bool isActive;
  const BillData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.profileId,
    required this.name,
    required this.amountCents,
    required this.recurrence,
    required this.firstDueDate,
    required this.remindDaysBefore,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['amount_cents'] = Variable<int>(amountCents);
    map['recurrence'] = Variable<String>(recurrence);
    map['first_due_date'] = Variable<String>(firstDueDate);
    map['remind_days_before'] = Variable<int>(remindDaysBefore);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  BillsTableCompanion toCompanion(bool nullToAbsent) {
    return BillsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      profileId: Value(profileId),
      name: Value(name),
      amountCents: Value(amountCents),
      recurrence: Value(recurrence),
      firstDueDate: Value(firstDueDate),
      remindDaysBefore: Value(remindDaysBefore),
      isActive: Value(isActive),
    );
  }

  factory BillData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      recurrence: serializer.fromJson<String>(json['recurrence']),
      firstDueDate: serializer.fromJson<String>(json['firstDueDate']),
      remindDaysBefore: serializer.fromJson<int>(json['remindDaysBefore']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'amountCents': serializer.toJson<int>(amountCents),
      'recurrence': serializer.toJson<String>(recurrence),
      'firstDueDate': serializer.toJson<String>(firstDueDate),
      'remindDaysBefore': serializer.toJson<int>(remindDaysBefore),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  BillData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? profileId,
    String? name,
    int? amountCents,
    String? recurrence,
    String? firstDueDate,
    int? remindDaysBefore,
    bool? isActive,
  }) => BillData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    amountCents: amountCents ?? this.amountCents,
    recurrence: recurrence ?? this.recurrence,
    firstDueDate: firstDueDate ?? this.firstDueDate,
    remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
    isActive: isActive ?? this.isActive,
  );
  BillData copyWithCompanion(BillsTableCompanion data) {
    return BillData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      firstDueDate: data.firstDueDate.present
          ? data.firstDueDate.value
          : this.firstDueDate,
      remindDaysBefore: data.remindDaysBefore.present
          ? data.remindDaysBefore.value
          : this.remindDaysBefore,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('recurrence: $recurrence, ')
          ..write('firstDueDate: $firstDueDate, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    name,
    amountCents,
    recurrence,
    firstDueDate,
    remindDaysBefore,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.amountCents == this.amountCents &&
          other.recurrence == this.recurrence &&
          other.firstDueDate == this.firstDueDate &&
          other.remindDaysBefore == this.remindDaysBefore &&
          other.isActive == this.isActive);
}

class BillsTableCompanion extends UpdateCompanion<BillData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> amountCents;
  final Value<String> recurrence;
  final Value<String> firstDueDate;
  final Value<int> remindDaysBefore;
  final Value<bool> isActive;
  final Value<int> rowid;
  const BillsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.firstDueDate = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillsTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String profileId,
    required String name,
    required int amountCents,
    required String recurrence,
    required String firstDueDate,
    this.remindDaysBefore = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       profileId = Value(profileId),
       name = Value(name),
       amountCents = Value(amountCents),
       recurrence = Value(recurrence),
       firstDueDate = Value(firstDueDate);
  static Insertable<BillData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? amountCents,
    Expression<String>? recurrence,
    Expression<String>? firstDueDate,
    Expression<int>? remindDaysBefore,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (amountCents != null) 'amount_cents': amountCents,
      if (recurrence != null) 'recurrence': recurrence,
      if (firstDueDate != null) 'first_due_date': firstDueDate,
      if (remindDaysBefore != null) 'remind_days_before': remindDaysBefore,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? profileId,
    Value<String>? name,
    Value<int>? amountCents,
    Value<String>? recurrence,
    Value<String>? firstDueDate,
    Value<int>? remindDaysBefore,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return BillsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      amountCents: amountCents ?? this.amountCents,
      recurrence: recurrence ?? this.recurrence,
      firstDueDate: firstDueDate ?? this.firstDueDate,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(recurrence.value);
    }
    if (firstDueDate.present) {
      map['first_due_date'] = Variable<String>(firstDueDate.value);
    }
    if (remindDaysBefore.present) {
      map['remind_days_before'] = Variable<int>(remindDaysBefore.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('amountCents: $amountCents, ')
          ..write('recurrence: $recurrence, ')
          ..write('firstDueDate: $firstDueDate, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTableTable extends ExpensesTable
    with TableInfo<$ExpensesTableTable, ExpenseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentOnMeta = const VerificationMeta(
    'spentOn',
  );
  @override
  late final GeneratedColumn<String> spentOn = GeneratedColumn<String>(
    'spent_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    amountCents,
    spentOn,
    categoryId,
    note,
    source,
    currency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('spent_on')) {
      context.handle(
        _spentOnMeta,
        spentOn.isAcceptableOrUnknown(data['spent_on']!, _spentOnMeta),
      );
    } else if (isInserting) {
      context.missing(_spentOnMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      spentOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spent_on'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  $ExpensesTableTable createAlias(String alias) {
    return $ExpensesTableTable(attachedDatabase, alias);
  }
}

class ExpenseData extends DataClass implements Insertable<ExpenseData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Logical foreign key reference to the parent budget profile.
  final String profileId;

  /// Spent amount in integer cents.
  final int amountCents;

  /// Date the expense occurred formatted as ISO string 'YYYY-MM-DD'.
  final String spentOn;

  /// Optional foreign key to categories table.
  final String? categoryId;

  /// Optional note or merchant description.
  final String? note;

  /// Source of the expense record ('manual', 'widget').
  final String source;

  /// Currency code of the transaction (defaults to 'USD').
  final String currency;
  const ExpenseData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.profileId,
    required this.amountCents,
    required this.spentOn,
    this.categoryId,
    this.note,
    required this.source,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['profile_id'] = Variable<String>(profileId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['spent_on'] = Variable<String>(spentOn);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['source'] = Variable<String>(source);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  ExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpensesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      profileId: Value(profileId),
      amountCents: Value(amountCents),
      spentOn: Value(spentOn),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      source: Value(source),
      currency: Value(currency),
    );
  }

  factory ExpenseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      spentOn: serializer.fromJson<String>(json['spentOn']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      source: serializer.fromJson<String>(json['source']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'profileId': serializer.toJson<String>(profileId),
      'amountCents': serializer.toJson<int>(amountCents),
      'spentOn': serializer.toJson<String>(spentOn),
      'categoryId': serializer.toJson<String?>(categoryId),
      'note': serializer.toJson<String?>(note),
      'source': serializer.toJson<String>(source),
      'currency': serializer.toJson<String>(currency),
    };
  }

  ExpenseData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? profileId,
    int? amountCents,
    String? spentOn,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? source,
    String? currency,
  }) => ExpenseData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    profileId: profileId ?? this.profileId,
    amountCents: amountCents ?? this.amountCents,
    spentOn: spentOn ?? this.spentOn,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    note: note.present ? note.value : this.note,
    source: source ?? this.source,
    currency: currency ?? this.currency,
  );
  ExpenseData copyWithCompanion(ExpensesTableCompanion data) {
    return ExpenseData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      spentOn: data.spentOn.present ? data.spentOn.value : this.spentOn,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      source: data.source.present ? data.source.value : this.source,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('amountCents: $amountCents, ')
          ..write('spentOn: $spentOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    amountCents,
    spentOn,
    categoryId,
    note,
    source,
    currency,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.profileId == this.profileId &&
          other.amountCents == this.amountCents &&
          other.spentOn == this.spentOn &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.source == this.source &&
          other.currency == this.currency);
}

class ExpensesTableCompanion extends UpdateCompanion<ExpenseData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> profileId;
  final Value<int> amountCents;
  final Value<String> spentOn;
  final Value<String?> categoryId;
  final Value<String?> note;
  final Value<String> source;
  final Value<String> currency;
  final Value<int> rowid;
  const ExpensesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.spentOn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String profileId,
    required int amountCents,
    required String spentOn,
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.source = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       profileId = Value(profileId),
       amountCents = Value(amountCents),
       spentOn = Value(spentOn);
  static Insertable<ExpenseData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? profileId,
    Expression<int>? amountCents,
    Expression<String>? spentOn,
    Expression<String>? categoryId,
    Expression<String>? note,
    Expression<String>? source,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (profileId != null) 'profile_id': profileId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (spentOn != null) 'spent_on': spentOn,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (source != null) 'source': source,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? profileId,
    Value<int>? amountCents,
    Value<String>? spentOn,
    Value<String?>? categoryId,
    Value<String?>? note,
    Value<String>? source,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return ExpensesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      profileId: profileId ?? this.profileId,
      amountCents: amountCents ?? this.amountCents,
      spentOn: spentOn ?? this.spentOn,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      source: source ?? this.source,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (spentOn.present) {
      map['spent_on'] = Variable<String>(spentOn.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('amountCents: $amountCents, ')
          ..write('spentOn: $spentOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('source: $source, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    nameKey,
    customName,
    icon,
    color,
    sortOrder,
    isDefault,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryData extends DataClass implements Insertable<CategoryData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Localization key for system default categories (e.g. 'category_food_drink').
  final String nameKey;

  /// User-defined custom display name (for user created categories).
  final String? customName;

  /// Icon identifier string.
  final String icon;

  /// Hex color code string (e.g. '#FF8A65').
  final String color;

  /// Sorting index for UI presentation.
  final int sortOrder;

  /// Whether this category belongs to system seeded defaults.
  final bool isDefault;
  const CategoryData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.nameKey,
    this.customName,
    required this.icon,
    required this.color,
    required this.sortOrder,
    required this.isDefault,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['name_key'] = Variable<String>(nameKey);
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_default'] = Variable<bool>(isDefault);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      nameKey: Value(nameKey),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      icon: Value(icon),
      color: Value(color),
      sortOrder: Value(sortOrder),
      isDefault: Value(isDefault),
    );
  }

  factory CategoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      customName: serializer.fromJson<String?>(json['customName']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'nameKey': serializer.toJson<String>(nameKey),
      'customName': serializer.toJson<String?>(customName),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDefault': serializer.toJson<bool>(isDefault),
    };
  }

  CategoryData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? nameKey,
    Value<String?> customName = const Value.absent(),
    String? icon,
    String? color,
    int? sortOrder,
    bool? isDefault,
  }) => CategoryData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    nameKey: nameKey ?? this.nameKey,
    customName: customName.present ? customName.value : this.customName,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    sortOrder: sortOrder ?? this.sortOrder,
    isDefault: isDefault ?? this.isDefault,
  );
  CategoryData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('nameKey: $nameKey, ')
          ..write('customName: $customName, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    nameKey,
    customName,
    icon,
    color,
    sortOrder,
    isDefault,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.nameKey == this.nameKey &&
          other.customName == this.customName &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder &&
          other.isDefault == this.isDefault);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> nameKey;
  final Value<String?> customName;
  final Value<String> icon;
  final Value<String> color;
  final Value<int> sortOrder;
  final Value<bool> isDefault;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.customName = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String nameKey,
    this.customName = const Value.absent(),
    required String icon,
    required String color,
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       nameKey = Value(nameKey),
       icon = Value(icon),
       color = Value(color);
  static Insertable<CategoryData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? nameKey,
    Expression<String>? customName,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? sortOrder,
    Expression<bool>? isDefault,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (nameKey != null) 'name_key': nameKey,
      if (customName != null) 'custom_name': customName,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDefault != null) 'is_default': isDefault,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? nameKey,
    Value<String?>? customName,
    Value<String>? icon,
    Value<String>? color,
    Value<int>? sortOrder,
    Value<bool>? isDefault,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      nameKey: nameKey ?? this.nameKey,
      customName: customName ?? this.customName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('nameKey: $nameKey, ')
          ..write('customName: $customName, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountCentsMeta = const VerificationMeta(
    'targetAmountCents',
  );
  @override
  late final GeneratedColumn<int> targetAmountCents = GeneratedColumn<int>(
    'target_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _perPaycheckCentsMeta = const VerificationMeta(
    'perPaycheckCents',
  );
  @override
  late final GeneratedColumn<int> perPaycheckCents = GeneratedColumn<int>(
    'per_paycheck_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdOnMeta = const VerificationMeta(
    'createdOn',
  );
  @override
  late final GeneratedColumn<String> createdOn = GeneratedColumn<String>(
    'created_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    name,
    targetAmountCents,
    targetDate,
    perPaycheckCents,
    createdOn,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount_cents')) {
      context.handle(
        _targetAmountCentsMeta,
        targetAmountCents.isAcceptableOrUnknown(
          data['target_amount_cents']!,
          _targetAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountCentsMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('per_paycheck_cents')) {
      context.handle(
        _perPaycheckCentsMeta,
        perPaycheckCents.isAcceptableOrUnknown(
          data['per_paycheck_cents']!,
          _perPaycheckCentsMeta,
        ),
      );
    }
    if (data.containsKey('created_on')) {
      context.handle(
        _createdOnMeta,
        createdOn.isAcceptableOrUnknown(data['created_on']!, _createdOnMeta),
      );
    } else if (isInserting) {
      context.missing(_createdOnMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_cents'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_date'],
      ),
      perPaycheckCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}per_paycheck_cents'],
      ),
      createdOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_on'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalData extends DataClass implements Insertable<GoalData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Logical foreign key reference to parent budget profile.
  final String profileId;

  /// Goal title (e.g. 'Emergency Fund', 'New Laptop').
  final String name;

  /// Target goal amount in integer cents.
  final int targetAmountCents;

  /// Optional target completion date formatted as ISO string 'YYYY-MM-DD'.
  final String? targetDate;

  /// Optional planned contribution per paycheck in integer cents.
  final int? perPaycheckCents;

  /// Creation business date formatted as ISO string 'YYYY-MM-DD'.
  final String createdOn;

  /// Whether the goal is currently active.
  final bool isActive;
  const GoalData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.profileId,
    required this.name,
    required this.targetAmountCents,
    this.targetDate,
    this.perPaycheckCents,
    required this.createdOn,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['profile_id'] = Variable<String>(profileId);
    map['name'] = Variable<String>(name);
    map['target_amount_cents'] = Variable<int>(targetAmountCents);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<String>(targetDate);
    }
    if (!nullToAbsent || perPaycheckCents != null) {
      map['per_paycheck_cents'] = Variable<int>(perPaycheckCents);
    }
    map['created_on'] = Variable<String>(createdOn);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      profileId: Value(profileId),
      name: Value(name),
      targetAmountCents: Value(targetAmountCents),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      perPaycheckCents: perPaycheckCents == null && nullToAbsent
          ? const Value.absent()
          : Value(perPaycheckCents),
      createdOn: Value(createdOn),
      isActive: Value(isActive),
    );
  }

  factory GoalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      profileId: serializer.fromJson<String>(json['profileId']),
      name: serializer.fromJson<String>(json['name']),
      targetAmountCents: serializer.fromJson<int>(json['targetAmountCents']),
      targetDate: serializer.fromJson<String?>(json['targetDate']),
      perPaycheckCents: serializer.fromJson<int?>(json['perPaycheckCents']),
      createdOn: serializer.fromJson<String>(json['createdOn']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'profileId': serializer.toJson<String>(profileId),
      'name': serializer.toJson<String>(name),
      'targetAmountCents': serializer.toJson<int>(targetAmountCents),
      'targetDate': serializer.toJson<String?>(targetDate),
      'perPaycheckCents': serializer.toJson<int?>(perPaycheckCents),
      'createdOn': serializer.toJson<String>(createdOn),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  GoalData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? profileId,
    String? name,
    int? targetAmountCents,
    Value<String?> targetDate = const Value.absent(),
    Value<int?> perPaycheckCents = const Value.absent(),
    String? createdOn,
    bool? isActive,
  }) => GoalData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    profileId: profileId ?? this.profileId,
    name: name ?? this.name,
    targetAmountCents: targetAmountCents ?? this.targetAmountCents,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    perPaycheckCents: perPaycheckCents.present
        ? perPaycheckCents.value
        : this.perPaycheckCents,
    createdOn: createdOn ?? this.createdOn,
    isActive: isActive ?? this.isActive,
  );
  GoalData copyWithCompanion(GoalsTableCompanion data) {
    return GoalData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      name: data.name.present ? data.name.value : this.name,
      targetAmountCents: data.targetAmountCents.present
          ? data.targetAmountCents.value
          : this.targetAmountCents,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      perPaycheckCents: data.perPaycheckCents.present
          ? data.perPaycheckCents.value
          : this.perPaycheckCents,
      createdOn: data.createdOn.present ? data.createdOn.value : this.createdOn,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('perPaycheckCents: $perPaycheckCents, ')
          ..write('createdOn: $createdOn, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    profileId,
    name,
    targetAmountCents,
    targetDate,
    perPaycheckCents,
    createdOn,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.profileId == this.profileId &&
          other.name == this.name &&
          other.targetAmountCents == this.targetAmountCents &&
          other.targetDate == this.targetDate &&
          other.perPaycheckCents == this.perPaycheckCents &&
          other.createdOn == this.createdOn &&
          other.isActive == this.isActive);
}

class GoalsTableCompanion extends UpdateCompanion<GoalData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> profileId;
  final Value<String> name;
  final Value<int> targetAmountCents;
  final Value<String?> targetDate;
  final Value<int?> perPaycheckCents;
  final Value<String> createdOn;
  final Value<bool> isActive;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmountCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.perPaycheckCents = const Value.absent(),
    this.createdOn = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String profileId,
    required String name,
    required int targetAmountCents,
    this.targetDate = const Value.absent(),
    this.perPaycheckCents = const Value.absent(),
    required String createdOn,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       profileId = Value(profileId),
       name = Value(name),
       targetAmountCents = Value(targetAmountCents),
       createdOn = Value(createdOn);
  static Insertable<GoalData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? profileId,
    Expression<String>? name,
    Expression<int>? targetAmountCents,
    Expression<String>? targetDate,
    Expression<int>? perPaycheckCents,
    Expression<String>? createdOn,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (profileId != null) 'profile_id': profileId,
      if (name != null) 'name': name,
      if (targetAmountCents != null) 'target_amount_cents': targetAmountCents,
      if (targetDate != null) 'target_date': targetDate,
      if (perPaycheckCents != null) 'per_paycheck_cents': perPaycheckCents,
      if (createdOn != null) 'created_on': createdOn,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? profileId,
    Value<String>? name,
    Value<int>? targetAmountCents,
    Value<String?>? targetDate,
    Value<int?>? perPaycheckCents,
    Value<String>? createdOn,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      targetAmountCents: targetAmountCents ?? this.targetAmountCents,
      targetDate: targetDate ?? this.targetDate,
      perPaycheckCents: perPaycheckCents ?? this.perPaycheckCents,
      createdOn: createdOn ?? this.createdOn,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmountCents.present) {
      map['target_amount_cents'] = Variable<int>(targetAmountCents.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<String>(targetDate.value);
    }
    if (perPaycheckCents.present) {
      map['per_paycheck_cents'] = Variable<int>(perPaycheckCents.value);
    }
    if (createdOn.present) {
      map['created_on'] = Variable<String>(createdOn.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('profileId: $profileId, ')
          ..write('name: $name, ')
          ..write('targetAmountCents: $targetAmountCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('perPaycheckCents: $perPaycheckCents, ')
          ..write('createdOn: $createdOn, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTableTable extends GoalContributionsTable
    with TableInfo<$GoalContributionsTableTable, GoalContributionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDateMeta = const VerificationMeta('onDate');
  @override
  late final GeneratedColumn<String> onDate = GeneratedColumn<String>(
    'on_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    goalId,
    amountCents,
    onDate,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalContributionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('on_date')) {
      context.handle(
        _onDateMeta,
        onDate.isAcceptableOrUnknown(data['on_date']!, _onDateMeta),
      );
    } else if (isInserting) {
      context.missing(_onDateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContributionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContributionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      onDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}on_date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $GoalContributionsTableTable createAlias(String alias) {
    return $GoalContributionsTableTable(attachedDatabase, alias);
  }
}

class GoalContributionData extends DataClass
    implements Insertable<GoalContributionData> {
  /// Unique primary key formatted as UUID v4.
  final String id;

  /// Creation timestamp in epoch milliseconds (UTC).
  final int createdAt;

  /// Last modification timestamp in epoch milliseconds (UTC).
  final int updatedAt;

  /// Soft deletion timestamp in epoch milliseconds (UTC), null if record is active.
  final int? deletedAt;

  /// Unique identifier of the device that created/modified this record.
  final String deviceId;

  /// Logical foreign key reference to parent goal.
  final String goalId;

  /// Contribution amount in integer cents.
  final int amountCents;

  /// Business date on which contribution was made ('YYYY-MM-DD').
  final String onDate;

  /// Origin of the contribution ('manual').
  final String source;
  const GoalContributionData({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deviceId,
    required this.goalId,
    required this.amountCents,
    required this.onDate,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['goal_id'] = Variable<String>(goalId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['on_date'] = Variable<String>(onDate);
    map['source'] = Variable<String>(source);
    return map;
  }

  GoalContributionsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsTableCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      deviceId: Value(deviceId),
      goalId: Value(goalId),
      amountCents: Value(amountCents),
      onDate: Value(onDate),
      source: Value(source),
    );
  }

  factory GoalContributionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContributionData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      goalId: serializer.fromJson<String>(json['goalId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      onDate: serializer.fromJson<String>(json['onDate']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'goalId': serializer.toJson<String>(goalId),
      'amountCents': serializer.toJson<int>(amountCents),
      'onDate': serializer.toJson<String>(onDate),
      'source': serializer.toJson<String>(source),
    };
  }

  GoalContributionData copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    String? deviceId,
    String? goalId,
    int? amountCents,
    String? onDate,
    String? source,
  }) => GoalContributionData(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    deviceId: deviceId ?? this.deviceId,
    goalId: goalId ?? this.goalId,
    amountCents: amountCents ?? this.amountCents,
    onDate: onDate ?? this.onDate,
    source: source ?? this.source,
  );
  GoalContributionData copyWithCompanion(GoalContributionsTableCompanion data) {
    return GoalContributionData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      onDate: data.onDate.present ? data.onDate.value : this.onDate,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('goalId: $goalId, ')
          ..write('amountCents: $amountCents, ')
          ..write('onDate: $onDate, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    deviceId,
    goalId,
    amountCents,
    onDate,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContributionData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.deviceId == this.deviceId &&
          other.goalId == this.goalId &&
          other.amountCents == this.amountCents &&
          other.onDate == this.onDate &&
          other.source == this.source);
}

class GoalContributionsTableCompanion
    extends UpdateCompanion<GoalContributionData> {
  final Value<String> id;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<String> deviceId;
  final Value<String> goalId;
  final Value<int> amountCents;
  final Value<String> onDate;
  final Value<String> source;
  final Value<int> rowid;
  const GoalContributionsTableCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.onDate = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalContributionsTableCompanion.insert({
    required String id,
    required int createdAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    required String deviceId,
    required String goalId,
    required int amountCents,
    required String onDate,
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId),
       goalId = Value(goalId),
       amountCents = Value(amountCents),
       onDate = Value(onDate);
  static Insertable<GoalContributionData> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<String>? deviceId,
    Expression<String>? goalId,
    Expression<int>? amountCents,
    Expression<String>? onDate,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (goalId != null) 'goal_id': goalId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (onDate != null) 'on_date': onDate,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalContributionsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<String>? deviceId,
    Value<String>? goalId,
    Value<int>? amountCents,
    Value<String>? onDate,
    Value<String>? source,
    Value<int>? rowid,
  }) {
    return GoalContributionsTableCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
      goalId: goalId ?? this.goalId,
      amountCents: amountCents ?? this.amountCents,
      onDate: onDate ?? this.onDate,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (onDate.present) {
      map['on_date'] = Variable<String>(onDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('goalId: $goalId, ')
          ..write('amountCents: $amountCents, ')
          ..write('onDate: $onDate, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingData extends DataClass implements Insertable<AppSettingData> {
  /// Primary key setting identifier.
  final String key;

  /// Arbitrary string or JSON serialized value.
  final String value;

  /// Timestamp of the last update in epoch milliseconds (UTC).
  final int updatedAt;
  const AppSettingData({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  AppSettingData copyWith({String? key, String? value, int? updatedAt}) =>
      AppSettingData(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingData &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BudgetProfilesTableTable budgetProfilesTable =
      $BudgetProfilesTableTable(this);
  late final $IncomeEntriesTableTable incomeEntriesTable =
      $IncomeEntriesTableTable(this);
  late final $BillsTableTable billsTable = $BillsTableTable(this);
  late final $ExpensesTableTable expensesTable = $ExpensesTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $GoalContributionsTableTable goalContributionsTable =
      $GoalContributionsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    budgetProfilesTable,
    incomeEntriesTable,
    billsTable,
    expensesTable,
    categoriesTable,
    goalsTable,
    goalContributionsTable,
    appSettingsTable,
  ];
}

typedef $$BudgetProfilesTableTableCreateCompanionBuilder =
    BudgetProfilesTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      Value<String> currency,
      required String incomeMode,
      Value<String?> payFrequency,
      Value<String?> payAnchorDate,
      Value<int?> incomePerPaycheckCents,
      Value<int?> firstPeriodBalanceCents,
      Value<int?> startingBalanceCents,
      required String trackingStartDate,
      Value<int> safetyHorizonDays,
      Value<int> bufferPercent,
      Value<String> rolloverMode,
      Value<String> timezone,
      Value<int> weekStart,
      Value<bool> onboardingCompleted,
      Value<int> rowid,
    });
typedef $$BudgetProfilesTableTableUpdateCompanionBuilder =
    BudgetProfilesTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> currency,
      Value<String> incomeMode,
      Value<String?> payFrequency,
      Value<String?> payAnchorDate,
      Value<int?> incomePerPaycheckCents,
      Value<int?> firstPeriodBalanceCents,
      Value<int?> startingBalanceCents,
      Value<String> trackingStartDate,
      Value<int> safetyHorizonDays,
      Value<int> bufferPercent,
      Value<String> rolloverMode,
      Value<String> timezone,
      Value<int> weekStart,
      Value<bool> onboardingCompleted,
      Value<int> rowid,
    });

class $$BudgetProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetProfilesTableTable> {
  $$BudgetProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get incomeMode => $composableBuilder(
    column: $table.incomeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payFrequency => $composableBuilder(
    column: $table.payFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payAnchorDate => $composableBuilder(
    column: $table.payAnchorDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get incomePerPaycheckCents => $composableBuilder(
    column: $table.incomePerPaycheckCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get firstPeriodBalanceCents => $composableBuilder(
    column: $table.firstPeriodBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingBalanceCents => $composableBuilder(
    column: $table.startingBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingStartDate => $composableBuilder(
    column: $table.trackingStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get safetyHorizonDays => $composableBuilder(
    column: $table.safetyHorizonDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bufferPercent => $composableBuilder(
    column: $table.bufferPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rolloverMode => $composableBuilder(
    column: $table.rolloverMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetProfilesTableTable> {
  $$BudgetProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeMode => $composableBuilder(
    column: $table.incomeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payFrequency => $composableBuilder(
    column: $table.payFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payAnchorDate => $composableBuilder(
    column: $table.payAnchorDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get incomePerPaycheckCents => $composableBuilder(
    column: $table.incomePerPaycheckCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get firstPeriodBalanceCents => $composableBuilder(
    column: $table.firstPeriodBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingBalanceCents => $composableBuilder(
    column: $table.startingBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingStartDate => $composableBuilder(
    column: $table.trackingStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get safetyHorizonDays => $composableBuilder(
    column: $table.safetyHorizonDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bufferPercent => $composableBuilder(
    column: $table.bufferPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rolloverMode => $composableBuilder(
    column: $table.rolloverMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetProfilesTableTable> {
  $$BudgetProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get incomeMode => $composableBuilder(
    column: $table.incomeMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payFrequency => $composableBuilder(
    column: $table.payFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payAnchorDate => $composableBuilder(
    column: $table.payAnchorDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get incomePerPaycheckCents => $composableBuilder(
    column: $table.incomePerPaycheckCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get firstPeriodBalanceCents => $composableBuilder(
    column: $table.firstPeriodBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startingBalanceCents => $composableBuilder(
    column: $table.startingBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackingStartDate => $composableBuilder(
    column: $table.trackingStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get safetyHorizonDays => $composableBuilder(
    column: $table.safetyHorizonDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bufferPercent => $composableBuilder(
    column: $table.bufferPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rolloverMode => $composableBuilder(
    column: $table.rolloverMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );
}

class $$BudgetProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetProfilesTableTable,
          BudgetProfileData,
          $$BudgetProfilesTableTableFilterComposer,
          $$BudgetProfilesTableTableOrderingComposer,
          $$BudgetProfilesTableTableAnnotationComposer,
          $$BudgetProfilesTableTableCreateCompanionBuilder,
          $$BudgetProfilesTableTableUpdateCompanionBuilder,
          (
            BudgetProfileData,
            BaseReferences<
              _$AppDatabase,
              $BudgetProfilesTableTable,
              BudgetProfileData
            >,
          ),
          BudgetProfileData,
          PrefetchHooks Function()
        > {
  $$BudgetProfilesTableTableTableManager(
    _$AppDatabase db,
    $BudgetProfilesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetProfilesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetProfilesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> incomeMode = const Value.absent(),
                Value<String?> payFrequency = const Value.absent(),
                Value<String?> payAnchorDate = const Value.absent(),
                Value<int?> incomePerPaycheckCents = const Value.absent(),
                Value<int?> firstPeriodBalanceCents = const Value.absent(),
                Value<int?> startingBalanceCents = const Value.absent(),
                Value<String> trackingStartDate = const Value.absent(),
                Value<int> safetyHorizonDays = const Value.absent(),
                Value<int> bufferPercent = const Value.absent(),
                Value<String> rolloverMode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> weekStart = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetProfilesTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                currency: currency,
                incomeMode: incomeMode,
                payFrequency: payFrequency,
                payAnchorDate: payAnchorDate,
                incomePerPaycheckCents: incomePerPaycheckCents,
                firstPeriodBalanceCents: firstPeriodBalanceCents,
                startingBalanceCents: startingBalanceCents,
                trackingStartDate: trackingStartDate,
                safetyHorizonDays: safetyHorizonDays,
                bufferPercent: bufferPercent,
                rolloverMode: rolloverMode,
                timezone: timezone,
                weekStart: weekStart,
                onboardingCompleted: onboardingCompleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                Value<String> currency = const Value.absent(),
                required String incomeMode,
                Value<String?> payFrequency = const Value.absent(),
                Value<String?> payAnchorDate = const Value.absent(),
                Value<int?> incomePerPaycheckCents = const Value.absent(),
                Value<int?> firstPeriodBalanceCents = const Value.absent(),
                Value<int?> startingBalanceCents = const Value.absent(),
                required String trackingStartDate,
                Value<int> safetyHorizonDays = const Value.absent(),
                Value<int> bufferPercent = const Value.absent(),
                Value<String> rolloverMode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> weekStart = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetProfilesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                currency: currency,
                incomeMode: incomeMode,
                payFrequency: payFrequency,
                payAnchorDate: payAnchorDate,
                incomePerPaycheckCents: incomePerPaycheckCents,
                firstPeriodBalanceCents: firstPeriodBalanceCents,
                startingBalanceCents: startingBalanceCents,
                trackingStartDate: trackingStartDate,
                safetyHorizonDays: safetyHorizonDays,
                bufferPercent: bufferPercent,
                rolloverMode: rolloverMode,
                timezone: timezone,
                weekStart: weekStart,
                onboardingCompleted: onboardingCompleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetProfilesTableTable, BudgetProfileData>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $BudgetProfilesTableTable,
                    BudgetProfileData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetProfilesTableTable,
      BudgetProfileData,
      $$BudgetProfilesTableTableFilterComposer,
      $$BudgetProfilesTableTableOrderingComposer,
      $$BudgetProfilesTableTableAnnotationComposer,
      $$BudgetProfilesTableTableCreateCompanionBuilder,
      $$BudgetProfilesTableTableUpdateCompanionBuilder,
      (
        BudgetProfileData,
        BaseReferences<
          _$AppDatabase,
          $BudgetProfilesTableTable,
          BudgetProfileData
        >,
      ),
      BudgetProfileData,
      PrefetchHooks Function()
    >;
typedef $$IncomeEntriesTableTableCreateCompanionBuilder =
    IncomeEntriesTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String profileId,
      required int amountCents,
      required String receivedOn,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$IncomeEntriesTableTableUpdateCompanionBuilder =
    IncomeEntriesTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> profileId,
      Value<int> amountCents,
      Value<String> receivedOn,
      Value<String?> note,
      Value<int> rowid,
    });

class $$IncomeEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTableTable> {
  $$IncomeEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IncomeEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTableTable> {
  $$IncomeEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomeEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTableTable> {
  $$IncomeEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$IncomeEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeEntriesTableTable,
          IncomeEntryData,
          $$IncomeEntriesTableTableFilterComposer,
          $$IncomeEntriesTableTableOrderingComposer,
          $$IncomeEntriesTableTableAnnotationComposer,
          $$IncomeEntriesTableTableCreateCompanionBuilder,
          $$IncomeEntriesTableTableUpdateCompanionBuilder,
          (
            IncomeEntryData,
            BaseReferences<
              _$AppDatabase,
              $IncomeEntriesTableTable,
              IncomeEntryData
            >,
          ),
          IncomeEntryData,
          PrefetchHooks Function()
        > {
  $$IncomeEntriesTableTableTableManager(
    _$AppDatabase db,
    $IncomeEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeEntriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> receivedOn = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeEntriesTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                amountCents: amountCents,
                receivedOn: receivedOn,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String profileId,
                required int amountCents,
                required String receivedOn,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeEntriesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                amountCents: amountCents,
                receivedOn: receivedOn,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IncomeEntriesTableTable, IncomeEntryData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $IncomeEntriesTableTable,
                    IncomeEntryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IncomeEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeEntriesTableTable,
      IncomeEntryData,
      $$IncomeEntriesTableTableFilterComposer,
      $$IncomeEntriesTableTableOrderingComposer,
      $$IncomeEntriesTableTableAnnotationComposer,
      $$IncomeEntriesTableTableCreateCompanionBuilder,
      $$IncomeEntriesTableTableUpdateCompanionBuilder,
      (
        IncomeEntryData,
        BaseReferences<
          _$AppDatabase,
          $IncomeEntriesTableTable,
          IncomeEntryData
        >,
      ),
      IncomeEntryData,
      PrefetchHooks Function()
    >;
typedef $$BillsTableTableCreateCompanionBuilder =
    BillsTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String profileId,
      required String name,
      required int amountCents,
      required String recurrence,
      required String firstDueDate,
      Value<int> remindDaysBefore,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$BillsTableTableUpdateCompanionBuilder =
    BillsTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> profileId,
      Value<String> name,
      Value<int> amountCents,
      Value<String> recurrence,
      Value<String> firstDueDate,
      Value<int> remindDaysBefore,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$BillsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BillsTableTable> {
  $$BillsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BillsTableTable> {
  $$BillsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillsTableTable> {
  $$BillsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstDueDate => $composableBuilder(
    column: $table.firstDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$BillsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillsTableTable,
          BillData,
          $$BillsTableTableFilterComposer,
          $$BillsTableTableOrderingComposer,
          $$BillsTableTableAnnotationComposer,
          $$BillsTableTableCreateCompanionBuilder,
          $$BillsTableTableUpdateCompanionBuilder,
          (BillData, BaseReferences<_$AppDatabase, $BillsTableTable, BillData>),
          BillData,
          PrefetchHooks Function()
        > {
  $$BillsTableTableTableManager(_$AppDatabase db, $BillsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> recurrence = const Value.absent(),
                Value<String> firstDueDate = const Value.absent(),
                Value<int> remindDaysBefore = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                name: name,
                amountCents: amountCents,
                recurrence: recurrence,
                firstDueDate: firstDueDate,
                remindDaysBefore: remindDaysBefore,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String profileId,
                required String name,
                required int amountCents,
                required String recurrence,
                required String firstDueDate,
                Value<int> remindDaysBefore = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                name: name,
                amountCents: amountCents,
                recurrence: recurrence,
                firstDueDate: firstDueDate,
                remindDaysBefore: remindDaysBefore,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BillsTableTable, BillData>(table),
                  BaseReferences<_$AppDatabase, $BillsTableTable, BillData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillsTableTable,
      BillData,
      $$BillsTableTableFilterComposer,
      $$BillsTableTableOrderingComposer,
      $$BillsTableTableAnnotationComposer,
      $$BillsTableTableCreateCompanionBuilder,
      $$BillsTableTableUpdateCompanionBuilder,
      (BillData, BaseReferences<_$AppDatabase, $BillsTableTable, BillData>),
      BillData,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableTableCreateCompanionBuilder =
    ExpensesTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String profileId,
      required int amountCents,
      required String spentOn,
      Value<String?> categoryId,
      Value<String?> note,
      Value<String> source,
      Value<String> currency,
      Value<int> rowid,
    });
typedef $$ExpensesTableTableUpdateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> profileId,
      Value<int> amountCents,
      Value<String> spentOn,
      Value<String?> categoryId,
      Value<String?> note,
      Value<String> source,
      Value<String> currency,
      Value<int> rowid,
    });

class $$ExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spentOn => $composableBuilder(
    column: $table.spentOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spentOn => $composableBuilder(
    column: $table.spentOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get spentOn =>
      $composableBuilder(column: $table.spentOn, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);
}

class $$ExpensesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTableTable,
          ExpenseData,
          $$ExpensesTableTableFilterComposer,
          $$ExpensesTableTableOrderingComposer,
          $$ExpensesTableTableAnnotationComposer,
          $$ExpensesTableTableCreateCompanionBuilder,
          $$ExpensesTableTableUpdateCompanionBuilder,
          (
            ExpenseData,
            BaseReferences<_$AppDatabase, $ExpensesTableTable, ExpenseData>,
          ),
          ExpenseData,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableTableManager(_$AppDatabase db, $ExpensesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> spentOn = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                amountCents: amountCents,
                spentOn: spentOn,
                categoryId: categoryId,
                note: note,
                source: source,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String profileId,
                required int amountCents,
                required String spentOn,
                Value<String?> categoryId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                amountCents: amountCents,
                spentOn: spentOn,
                categoryId: categoryId,
                note: note,
                source: source,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTableTable, ExpenseData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExpensesTableTable,
                    ExpenseData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTableTable,
      ExpenseData,
      $$ExpensesTableTableFilterComposer,
      $$ExpensesTableTableOrderingComposer,
      $$ExpensesTableTableAnnotationComposer,
      $$ExpensesTableTableCreateCompanionBuilder,
      $$ExpensesTableTableUpdateCompanionBuilder,
      (
        ExpenseData,
        BaseReferences<_$AppDatabase, $ExpensesTableTable, ExpenseData>,
      ),
      ExpenseData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String nameKey,
      Value<String?> customName,
      required String icon,
      required String color,
      Value<int> sortOrder,
      Value<bool> isDefault,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> nameKey,
      Value<String?> customName,
      Value<String> icon,
      Value<String> color,
      Value<int> sortOrder,
      Value<bool> isDefault,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoryData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoryData,
            BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryData>,
          ),
          CategoryData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                nameKey: nameKey,
                customName: customName,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                isDefault: isDefault,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String nameKey,
                Value<String?> customName = const Value.absent(),
                required String icon,
                required String color,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                nameKey: nameKey,
                customName: customName,
                icon: icon,
                color: color,
                sortOrder: sortOrder,
                isDefault: isDefault,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTableTable, CategoryData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CategoriesTableTable,
                    CategoryData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoryData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoryData,
        BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryData>,
      ),
      CategoryData,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableTableCreateCompanionBuilder =
    GoalsTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String profileId,
      required String name,
      required int targetAmountCents,
      Value<String?> targetDate,
      Value<int?> perPaycheckCents,
      required String createdOn,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$GoalsTableTableUpdateCompanionBuilder =
    GoalsTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> profileId,
      Value<String> name,
      Value<int> targetAmountCents,
      Value<String?> targetDate,
      Value<int?> perPaycheckCents,
      Value<String> createdOn,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get perPaycheckCents => $composableBuilder(
    column: $table.perPaycheckCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get perPaycheckCents => $composableBuilder(
    column: $table.perPaycheckCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdOn => $composableBuilder(
    column: $table.createdOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmountCents => $composableBuilder(
    column: $table.targetAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get perPaycheckCents => $composableBuilder(
    column: $table.perPaycheckCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdOn =>
      $composableBuilder(column: $table.createdOn, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTableTable,
          GoalData,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (GoalData, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalData>),
          GoalData,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetAmountCents = const Value.absent(),
                Value<String?> targetDate = const Value.absent(),
                Value<int?> perPaycheckCents = const Value.absent(),
                Value<String> createdOn = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                name: name,
                targetAmountCents: targetAmountCents,
                targetDate: targetDate,
                perPaycheckCents: perPaycheckCents,
                createdOn: createdOn,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String profileId,
                required String name,
                required int targetAmountCents,
                Value<String?> targetDate = const Value.absent(),
                Value<int?> perPaycheckCents = const Value.absent(),
                required String createdOn,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                profileId: profileId,
                name: name,
                targetAmountCents: targetAmountCents,
                targetDate: targetDate,
                perPaycheckCents: perPaycheckCents,
                createdOn: createdOn,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTableTable, GoalData>(table),
                  BaseReferences<_$AppDatabase, $GoalsTableTable, GoalData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTableTable,
      GoalData,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (GoalData, BaseReferences<_$AppDatabase, $GoalsTableTable, GoalData>),
      GoalData,
      PrefetchHooks Function()
    >;
typedef $$GoalContributionsTableTableCreateCompanionBuilder =
    GoalContributionsTableCompanion Function({
      required String id,
      required int createdAt,
      required int updatedAt,
      Value<int?> deletedAt,
      required String deviceId,
      required String goalId,
      required int amountCents,
      required String onDate,
      Value<String> source,
      Value<int> rowid,
    });
typedef $$GoalContributionsTableTableUpdateCompanionBuilder =
    GoalContributionsTableCompanion Function({
      Value<String> id,
      Value<int> createdAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<String> deviceId,
      Value<String> goalId,
      Value<int> amountCents,
      Value<String> onDate,
      Value<String> source,
      Value<int> rowid,
    });

class $$GoalContributionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onDate => $composableBuilder(
    column: $table.onDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalContributionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onDate => $composableBuilder(
    column: $table.onDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalContributionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get onDate =>
      $composableBuilder(column: $table.onDate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$GoalContributionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalContributionsTableTable,
          GoalContributionData,
          $$GoalContributionsTableTableFilterComposer,
          $$GoalContributionsTableTableOrderingComposer,
          $$GoalContributionsTableTableAnnotationComposer,
          $$GoalContributionsTableTableCreateCompanionBuilder,
          $$GoalContributionsTableTableUpdateCompanionBuilder,
          (
            GoalContributionData,
            BaseReferences<
              _$AppDatabase,
              $GoalContributionsTableTable,
              GoalContributionData
            >,
          ),
          GoalContributionData,
          PrefetchHooks Function()
        > {
  $$GoalContributionsTableTableTableManager(
    _$AppDatabase db,
    $GoalContributionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GoalContributionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String> onDate = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsTableCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                goalId: goalId,
                amountCents: amountCents,
                onDate: onDate,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                required String deviceId,
                required String goalId,
                required int amountCents,
                required String onDate,
                Value<String> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsTableCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                deviceId: deviceId,
                goalId: goalId,
                amountCents: amountCents,
                onDate: onDate,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $GoalContributionsTableTable,
                    GoalContributionData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GoalContributionsTableTable,
                    GoalContributionData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalContributionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalContributionsTableTable,
      GoalContributionData,
      $$GoalContributionsTableTableFilterComposer,
      $$GoalContributionsTableTableOrderingComposer,
      $$GoalContributionsTableTableAnnotationComposer,
      $$GoalContributionsTableTableCreateCompanionBuilder,
      $$GoalContributionsTableTableUpdateCompanionBuilder,
      (
        GoalContributionData,
        BaseReferences<
          _$AppDatabase,
          $GoalContributionsTableTable,
          GoalContributionData
        >,
      ),
      GoalContributionData,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      required String value,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingData
            >,
          ),
          AppSettingData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingData,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingData>,
      ),
      AppSettingData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BudgetProfilesTableTableTableManager get budgetProfilesTable =>
      $$BudgetProfilesTableTableTableManager(_db, _db.budgetProfilesTable);
  $$IncomeEntriesTableTableTableManager get incomeEntriesTable =>
      $$IncomeEntriesTableTableTableManager(_db, _db.incomeEntriesTable);
  $$BillsTableTableTableManager get billsTable =>
      $$BillsTableTableTableManager(_db, _db.billsTable);
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db, _db.expensesTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$GoalContributionsTableTableTableManager get goalContributionsTable =>
      $$GoalContributionsTableTableTableManager(
        _db,
        _db.goalContributionsTable,
      );
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
