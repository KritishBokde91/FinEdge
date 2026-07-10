// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $SmsMetadataTableTable extends SmsMetadataTable
    with TableInfo<$SmsMetadataTableTable, SmsMetadataTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsMetadataTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
    'sender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isProcessedMeta = const VerificationMeta(
    'isProcessed',
  );
  @override
  late final GeneratedColumn<bool> isProcessed = GeneratedColumn<bool>(
    'is_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sender,
    body,
    timestamp,
    isProcessed,
    confidence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_metadata_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmsMetadataTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(
        _senderMeta,
        sender.isAcceptableOrUnknown(data['sender']!, _senderMeta),
      );
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_processed')) {
      context.handle(
        _isProcessedMeta,
        isProcessed.isAcceptableOrUnknown(
          data['is_processed']!,
          _isProcessedMeta,
        ),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsMetadataTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsMetadataTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_processed'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      )!,
    );
  }

  @override
  $SmsMetadataTableTable createAlias(String alias) {
    return $SmsMetadataTableTable(attachedDatabase, alias);
  }
}

class SmsMetadataTableData extends DataClass
    implements Insertable<SmsMetadataTableData> {
  final String id;
  final String sender;
  final String body;
  final DateTime timestamp;
  final bool isProcessed;
  final double confidence;
  const SmsMetadataTableData({
    required this.id,
    required this.sender,
    required this.body,
    required this.timestamp,
    required this.isProcessed,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_processed'] = Variable<bool>(isProcessed);
    map['confidence'] = Variable<double>(confidence);
    return map;
  }

  SmsMetadataTableCompanion toCompanion(bool nullToAbsent) {
    return SmsMetadataTableCompanion(
      id: Value(id),
      sender: Value(sender),
      body: Value(body),
      timestamp: Value(timestamp),
      isProcessed: Value(isProcessed),
      confidence: Value(confidence),
    );
  }

  factory SmsMetadataTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsMetadataTableData(
      id: serializer.fromJson<String>(json['id']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isProcessed: serializer.fromJson<bool>(json['isProcessed']),
      confidence: serializer.fromJson<double>(json['confidence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isProcessed': serializer.toJson<bool>(isProcessed),
      'confidence': serializer.toJson<double>(confidence),
    };
  }

  SmsMetadataTableData copyWith({
    String? id,
    String? sender,
    String? body,
    DateTime? timestamp,
    bool? isProcessed,
    double? confidence,
  }) => SmsMetadataTableData(
    id: id ?? this.id,
    sender: sender ?? this.sender,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    isProcessed: isProcessed ?? this.isProcessed,
    confidence: confidence ?? this.confidence,
  );
  SmsMetadataTableData copyWithCompanion(SmsMetadataTableCompanion data) {
    return SmsMetadataTableData(
      id: data.id.present ? data.id.value : this.id,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isProcessed: data.isProcessed.present
          ? data.isProcessed.value
          : this.isProcessed,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsMetadataTableData(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sender, body, timestamp, isProcessed, confidence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsMetadataTableData &&
          other.id == this.id &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.isProcessed == this.isProcessed &&
          other.confidence == this.confidence);
}

class SmsMetadataTableCompanion extends UpdateCompanion<SmsMetadataTableData> {
  final Value<String> id;
  final Value<String> sender;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<bool> isProcessed;
  final Value<double> confidence;
  final Value<int> rowid;
  const SmsMetadataTableCompanion({
    this.id = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isProcessed = const Value.absent(),
    this.confidence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmsMetadataTableCompanion.insert({
    required String id,
    required String sender,
    required String body,
    required DateTime timestamp,
    this.isProcessed = const Value.absent(),
    required double confidence,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sender = Value(sender),
       body = Value(body),
       timestamp = Value(timestamp),
       confidence = Value(confidence);
  static Insertable<SmsMetadataTableData> custom({
    Expression<String>? id,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<bool>? isProcessed,
    Expression<double>? confidence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (isProcessed != null) 'is_processed': isProcessed,
      if (confidence != null) 'confidence': confidence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmsMetadataTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sender,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<bool>? isProcessed,
    Value<double>? confidence,
    Value<int>? rowid,
  }) {
    return SmsMetadataTableCompanion(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isProcessed: isProcessed ?? this.isProcessed,
      confidence: confidence ?? this.confidence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isProcessed.present) {
      map['is_processed'] = Variable<bool>(isProcessed.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsMetadataTableCompanion(')
          ..write('id: $id, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('isProcessed: $isProcessed, ')
          ..write('confidence: $confidence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smsIdMeta = const VerificationMeta('smsId');
  @override
  late final GeneratedColumn<String> smsId = GeneratedColumn<String>(
    'sms_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sms_metadata_table (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
  );
  static const VerificationMeta _accountSourceMeta = const VerificationMeta(
    'accountSource',
  );
  @override
  late final GeneratedColumn<String> accountSource = GeneratedColumn<String>(
    'account_source',
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
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    smsId,
    amount,
    merchant,
    category,
    timestamp,
    isIncome,
    accountSource,
    currency,
    reference,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sms_id')) {
      context.handle(
        _smsIdMeta,
        smsId.isAcceptableOrUnknown(data['sms_id']!, _smsIdMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    } else if (isInserting) {
      context.missing(_isIncomeMeta);
    }
    if (data.containsKey('account_source')) {
      context.handle(
        _accountSourceMeta,
        accountSource.isAcceptableOrUnknown(
          data['account_source']!,
          _accountSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountSourceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      smsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_id'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_income'],
      )!,
      accountSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_source'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      ),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String? smsId;
  final double amount;
  final String merchant;
  final String category;
  final DateTime timestamp;
  final bool isIncome;
  final String accountSource;
  final String currency;
  final String? reference;
  const TransactionsTableData({
    required this.id,
    this.smsId,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.timestamp,
    required this.isIncome,
    required this.accountSource,
    required this.currency,
    this.reference,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || smsId != null) {
      map['sms_id'] = Variable<String>(smsId);
    }
    map['amount'] = Variable<double>(amount);
    map['merchant'] = Variable<String>(merchant);
    map['category'] = Variable<String>(category);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_income'] = Variable<bool>(isIncome);
    map['account_source'] = Variable<String>(accountSource);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      smsId: smsId == null && nullToAbsent
          ? const Value.absent()
          : Value(smsId),
      amount: Value(amount),
      merchant: Value(merchant),
      category: Value(category),
      timestamp: Value(timestamp),
      isIncome: Value(isIncome),
      accountSource: Value(accountSource),
      currency: Value(currency),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      smsId: serializer.fromJson<String?>(json['smsId']),
      amount: serializer.fromJson<double>(json['amount']),
      merchant: serializer.fromJson<String>(json['merchant']),
      category: serializer.fromJson<String>(json['category']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      accountSource: serializer.fromJson<String>(json['accountSource']),
      currency: serializer.fromJson<String>(json['currency']),
      reference: serializer.fromJson<String?>(json['reference']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'smsId': serializer.toJson<String?>(smsId),
      'amount': serializer.toJson<double>(amount),
      'merchant': serializer.toJson<String>(merchant),
      'category': serializer.toJson<String>(category),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isIncome': serializer.toJson<bool>(isIncome),
      'accountSource': serializer.toJson<String>(accountSource),
      'currency': serializer.toJson<String>(currency),
      'reference': serializer.toJson<String?>(reference),
    };
  }

  TransactionsTableData copyWith({
    String? id,
    Value<String?> smsId = const Value.absent(),
    double? amount,
    String? merchant,
    String? category,
    DateTime? timestamp,
    bool? isIncome,
    String? accountSource,
    String? currency,
    Value<String?> reference = const Value.absent(),
  }) => TransactionsTableData(
    id: id ?? this.id,
    smsId: smsId.present ? smsId.value : this.smsId,
    amount: amount ?? this.amount,
    merchant: merchant ?? this.merchant,
    category: category ?? this.category,
    timestamp: timestamp ?? this.timestamp,
    isIncome: isIncome ?? this.isIncome,
    accountSource: accountSource ?? this.accountSource,
    currency: currency ?? this.currency,
    reference: reference.present ? reference.value : this.reference,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      smsId: data.smsId.present ? data.smsId.value : this.smsId,
      amount: data.amount.present ? data.amount.value : this.amount,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      category: data.category.present ? data.category.value : this.category,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      accountSource: data.accountSource.present
          ? data.accountSource.value
          : this.accountSource,
      currency: data.currency.present ? data.currency.value : this.currency,
      reference: data.reference.present ? data.reference.value : this.reference,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('smsId: $smsId, ')
          ..write('amount: $amount, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('timestamp: $timestamp, ')
          ..write('isIncome: $isIncome, ')
          ..write('accountSource: $accountSource, ')
          ..write('currency: $currency, ')
          ..write('reference: $reference')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    smsId,
    amount,
    merchant,
    category,
    timestamp,
    isIncome,
    accountSource,
    currency,
    reference,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.smsId == this.smsId &&
          other.amount == this.amount &&
          other.merchant == this.merchant &&
          other.category == this.category &&
          other.timestamp == this.timestamp &&
          other.isIncome == this.isIncome &&
          other.accountSource == this.accountSource &&
          other.currency == this.currency &&
          other.reference == this.reference);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String?> smsId;
  final Value<double> amount;
  final Value<String> merchant;
  final Value<String> category;
  final Value<DateTime> timestamp;
  final Value<bool> isIncome;
  final Value<String> accountSource;
  final Value<String> currency;
  final Value<String?> reference;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.smsId = const Value.absent(),
    this.amount = const Value.absent(),
    this.merchant = const Value.absent(),
    this.category = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.accountSource = const Value.absent(),
    this.currency = const Value.absent(),
    this.reference = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    this.smsId = const Value.absent(),
    required double amount,
    required String merchant,
    required String category,
    required DateTime timestamp,
    required bool isIncome,
    required String accountSource,
    this.currency = const Value.absent(),
    this.reference = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       merchant = Value(merchant),
       category = Value(category),
       timestamp = Value(timestamp),
       isIncome = Value(isIncome),
       accountSource = Value(accountSource);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? smsId,
    Expression<double>? amount,
    Expression<String>? merchant,
    Expression<String>? category,
    Expression<DateTime>? timestamp,
    Expression<bool>? isIncome,
    Expression<String>? accountSource,
    Expression<String>? currency,
    Expression<String>? reference,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (smsId != null) 'sms_id': smsId,
      if (amount != null) 'amount': amount,
      if (merchant != null) 'merchant': merchant,
      if (category != null) 'category': category,
      if (timestamp != null) 'timestamp': timestamp,
      if (isIncome != null) 'is_income': isIncome,
      if (accountSource != null) 'account_source': accountSource,
      if (currency != null) 'currency': currency,
      if (reference != null) 'reference': reference,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? smsId,
    Value<double>? amount,
    Value<String>? merchant,
    Value<String>? category,
    Value<DateTime>? timestamp,
    Value<bool>? isIncome,
    Value<String>? accountSource,
    Value<String>? currency,
    Value<String?>? reference,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      smsId: smsId ?? this.smsId,
      amount: amount ?? this.amount,
      merchant: merchant ?? this.merchant,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      isIncome: isIncome ?? this.isIncome,
      accountSource: accountSource ?? this.accountSource,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (smsId.present) {
      map['sms_id'] = Variable<String>(smsId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (accountSource.present) {
      map['account_source'] = Variable<String>(accountSource.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('smsId: $smsId, ')
          ..write('amount: $amount, ')
          ..write('merchant: $merchant, ')
          ..write('category: $category, ')
          ..write('timestamp: $timestamp, ')
          ..write('isIncome: $isIncome, ')
          ..write('accountSource: $accountSource, ')
          ..write('currency: $currency, ')
          ..write('reference: $reference, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitAmountMeta = const VerificationMeta(
    'limitAmount',
  );
  @override
  late final GeneratedColumn<double> limitAmount = GeneratedColumn<double>(
    'limit_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    limitAmount,
    startDate,
    endDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
        _limitAmountMeta,
        limitAmount.isAcceptableOrUnknown(
          data['limit_amount']!,
          _limitAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      limitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}limit_amount'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }
}

class BudgetsTableData extends DataClass
    implements Insertable<BudgetsTableData> {
  final String id;
  final String category;
  final double limitAmount;
  final DateTime startDate;
  final DateTime endDate;
  const BudgetsTableData({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.startDate,
    required this.endDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['limit_amount'] = Variable<double>(limitAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      category: Value(category),
      limitAmount: Value(limitAmount),
      startDate: Value(startDate),
      endDate: Value(endDate),
    );
  }

  factory BudgetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetsTableData(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      limitAmount: serializer.fromJson<double>(json['limitAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'limitAmount': serializer.toJson<double>(limitAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
    };
  }

  BudgetsTableData copyWith({
    String? id,
    String? category,
    double? limitAmount,
    DateTime? startDate,
    DateTime? endDate,
  }) => BudgetsTableData(
    id: id ?? this.id,
    category: category ?? this.category,
    limitAmount: limitAmount ?? this.limitAmount,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );
  BudgetsTableData copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetsTableData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      limitAmount: data.limitAmount.present
          ? data.limitAmount.value
          : this.limitAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, limitAmount, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetsTableData &&
          other.id == this.id &&
          other.category == this.category &&
          other.limitAmount == this.limitAmount &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetsTableData> {
  final Value<String> id;
  final Value<String> category;
  final Value<double> limitAmount;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.limitAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required String category,
    required double limitAmount,
    required DateTime startDate,
    required DateTime endDate,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       limitAmount = Value(limitAmount),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<BudgetsTableData> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<double>? limitAmount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (limitAmount != null) 'limit_amount': limitAmount,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<double>? limitAmount,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? rowid,
  }) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<double>(limitAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTableTable extends SubscriptionsTable
    with TableInfo<$SubscriptionsTableTable, SubscriptionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _merchantMeta = const VerificationMeta(
    'merchant',
  );
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
    'merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingCycleMeta = const VerificationMeta(
    'billingCycle',
  );
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
    'billing_cycle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextBillingDateMeta = const VerificationMeta(
    'nextBillingDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextBillingDate =
      GeneratedColumn<DateTime>(
        'next_billing_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
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
    merchant,
    amount,
    billingCycle,
    nextBillingDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriptionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('merchant')) {
      context.handle(
        _merchantMeta,
        merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta),
      );
    } else if (isInserting) {
      context.missing(_merchantMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
        _billingCycleMeta,
        billingCycle.isAcceptableOrUnknown(
          data['billing_cycle']!,
          _billingCycleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_billingCycleMeta);
    }
    if (data.containsKey('next_billing_date')) {
      context.handle(
        _nextBillingDateMeta,
        nextBillingDate.isAcceptableOrUnknown(
          data['next_billing_date']!,
          _nextBillingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextBillingDateMeta);
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
  SubscriptionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      merchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}merchant'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      billingCycle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_cycle'],
      )!,
      nextBillingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_billing_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SubscriptionsTableTable createAlias(String alias) {
    return $SubscriptionsTableTable(attachedDatabase, alias);
  }
}

class SubscriptionsTableData extends DataClass
    implements Insertable<SubscriptionsTableData> {
  final String id;
  final String merchant;
  final double amount;
  final String billingCycle;
  final DateTime nextBillingDate;
  final bool isActive;
  const SubscriptionsTableData({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.billingCycle,
    required this.nextBillingDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['merchant'] = Variable<String>(merchant);
    map['amount'] = Variable<double>(amount);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['next_billing_date'] = Variable<DateTime>(nextBillingDate);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SubscriptionsTableCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsTableCompanion(
      id: Value(id),
      merchant: Value(merchant),
      amount: Value(amount),
      billingCycle: Value(billingCycle),
      nextBillingDate: Value(nextBillingDate),
      isActive: Value(isActive),
    );
  }

  factory SubscriptionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionsTableData(
      id: serializer.fromJson<String>(json['id']),
      merchant: serializer.fromJson<String>(json['merchant']),
      amount: serializer.fromJson<double>(json['amount']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      nextBillingDate: serializer.fromJson<DateTime>(json['nextBillingDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'merchant': serializer.toJson<String>(merchant),
      'amount': serializer.toJson<double>(amount),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'nextBillingDate': serializer.toJson<DateTime>(nextBillingDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  SubscriptionsTableData copyWith({
    String? id,
    String? merchant,
    double? amount,
    String? billingCycle,
    DateTime? nextBillingDate,
    bool? isActive,
  }) => SubscriptionsTableData(
    id: id ?? this.id,
    merchant: merchant ?? this.merchant,
    amount: amount ?? this.amount,
    billingCycle: billingCycle ?? this.billingCycle,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    isActive: isActive ?? this.isActive,
  );
  SubscriptionsTableData copyWithCompanion(SubscriptionsTableCompanion data) {
    return SubscriptionsTableData(
      id: data.id.present ? data.id.value : this.id,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      amount: data.amount.present ? data.amount.value : this.amount,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      nextBillingDate: data.nextBillingDate.present
          ? data.nextBillingDate.value
          : this.nextBillingDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsTableData(')
          ..write('id: $id, ')
          ..write('merchant: $merchant, ')
          ..write('amount: $amount, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    merchant,
    amount,
    billingCycle,
    nextBillingDate,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionsTableData &&
          other.id == this.id &&
          other.merchant == this.merchant &&
          other.amount == this.amount &&
          other.billingCycle == this.billingCycle &&
          other.nextBillingDate == this.nextBillingDate &&
          other.isActive == this.isActive);
}

class SubscriptionsTableCompanion
    extends UpdateCompanion<SubscriptionsTableData> {
  final Value<String> id;
  final Value<String> merchant;
  final Value<double> amount;
  final Value<String> billingCycle;
  final Value<DateTime> nextBillingDate;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SubscriptionsTableCompanion({
    this.id = const Value.absent(),
    this.merchant = const Value.absent(),
    this.amount = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.nextBillingDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsTableCompanion.insert({
    required String id,
    required String merchant,
    required double amount,
    required String billingCycle,
    required DateTime nextBillingDate,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       merchant = Value(merchant),
       amount = Value(amount),
       billingCycle = Value(billingCycle),
       nextBillingDate = Value(nextBillingDate);
  static Insertable<SubscriptionsTableData> custom({
    Expression<String>? id,
    Expression<String>? merchant,
    Expression<double>? amount,
    Expression<String>? billingCycle,
    Expression<DateTime>? nextBillingDate,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (merchant != null) 'merchant': merchant,
      if (amount != null) 'amount': amount,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (nextBillingDate != null) 'next_billing_date': nextBillingDate,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? merchant,
    Value<double>? amount,
    Value<String>? billingCycle,
    Value<DateTime>? nextBillingDate,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return SubscriptionsTableCompanion(
      id: id ?? this.id,
      merchant: merchant ?? this.merchant,
      amount: amount ?? this.amount,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
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
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (nextBillingDate.present) {
      map['next_billing_date'] = Variable<DateTime>(nextBillingDate.value);
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
    return (StringBuffer('SubscriptionsTableCompanion(')
          ..write('id: $id, ')
          ..write('merchant: $merchant, ')
          ..write('amount: $amount, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextBillingDate: $nextBillingDate, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FraudAlertsTableTable extends FraudAlertsTable
    with TableInfo<$FraudAlertsTableTable, FraudAlertsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FraudAlertsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions_table (id)',
    ),
  );
  static const VerificationMeta _riskScoreMeta = const VerificationMeta(
    'riskScore',
  );
  @override
  late final GeneratedColumn<double> riskScore = GeneratedColumn<double>(
    'risk_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isResolvedMeta = const VerificationMeta(
    'isResolved',
  );
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
    'is_resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    riskScore,
    reason,
    timestamp,
    isResolved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fraud_alerts_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FraudAlertsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('risk_score')) {
      context.handle(
        _riskScoreMeta,
        riskScore.isAcceptableOrUnknown(data['risk_score']!, _riskScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_riskScoreMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
        _isResolvedMeta,
        isResolved.isAcceptableOrUnknown(data['is_resolved']!, _isResolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FraudAlertsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FraudAlertsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      riskScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}risk_score'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isResolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_resolved'],
      )!,
    );
  }

  @override
  $FraudAlertsTableTable createAlias(String alias) {
    return $FraudAlertsTableTable(attachedDatabase, alias);
  }
}

class FraudAlertsTableData extends DataClass
    implements Insertable<FraudAlertsTableData> {
  final String id;
  final String transactionId;
  final double riskScore;
  final String reason;
  final DateTime timestamp;
  final bool isResolved;
  const FraudAlertsTableData({
    required this.id,
    required this.transactionId,
    required this.riskScore,
    required this.reason,
    required this.timestamp,
    required this.isResolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['risk_score'] = Variable<double>(riskScore);
    map['reason'] = Variable<String>(reason);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_resolved'] = Variable<bool>(isResolved);
    return map;
  }

  FraudAlertsTableCompanion toCompanion(bool nullToAbsent) {
    return FraudAlertsTableCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      riskScore: Value(riskScore),
      reason: Value(reason),
      timestamp: Value(timestamp),
      isResolved: Value(isResolved),
    );
  }

  factory FraudAlertsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FraudAlertsTableData(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      riskScore: serializer.fromJson<double>(json['riskScore']),
      reason: serializer.fromJson<String>(json['reason']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'riskScore': serializer.toJson<double>(riskScore),
      'reason': serializer.toJson<String>(reason),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isResolved': serializer.toJson<bool>(isResolved),
    };
  }

  FraudAlertsTableData copyWith({
    String? id,
    String? transactionId,
    double? riskScore,
    String? reason,
    DateTime? timestamp,
    bool? isResolved,
  }) => FraudAlertsTableData(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    riskScore: riskScore ?? this.riskScore,
    reason: reason ?? this.reason,
    timestamp: timestamp ?? this.timestamp,
    isResolved: isResolved ?? this.isResolved,
  );
  FraudAlertsTableData copyWithCompanion(FraudAlertsTableCompanion data) {
    return FraudAlertsTableData(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      riskScore: data.riskScore.present ? data.riskScore.value : this.riskScore,
      reason: data.reason.present ? data.reason.value : this.reason,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isResolved: data.isResolved.present
          ? data.isResolved.value
          : this.isResolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FraudAlertsTableData(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('riskScore: $riskScore, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp, ')
          ..write('isResolved: $isResolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, riskScore, reason, timestamp, isResolved);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FraudAlertsTableData &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.riskScore == this.riskScore &&
          other.reason == this.reason &&
          other.timestamp == this.timestamp &&
          other.isResolved == this.isResolved);
}

class FraudAlertsTableCompanion extends UpdateCompanion<FraudAlertsTableData> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<double> riskScore;
  final Value<String> reason;
  final Value<DateTime> timestamp;
  final Value<bool> isResolved;
  final Value<int> rowid;
  const FraudAlertsTableCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.riskScore = const Value.absent(),
    this.reason = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FraudAlertsTableCompanion.insert({
    required String id,
    required String transactionId,
    required double riskScore,
    required String reason,
    required DateTime timestamp,
    this.isResolved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       riskScore = Value(riskScore),
       reason = Value(reason),
       timestamp = Value(timestamp);
  static Insertable<FraudAlertsTableData> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<double>? riskScore,
    Expression<String>? reason,
    Expression<DateTime>? timestamp,
    Expression<bool>? isResolved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (riskScore != null) 'risk_score': riskScore,
      if (reason != null) 'reason': reason,
      if (timestamp != null) 'timestamp': timestamp,
      if (isResolved != null) 'is_resolved': isResolved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FraudAlertsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<double>? riskScore,
    Value<String>? reason,
    Value<DateTime>? timestamp,
    Value<bool>? isResolved,
    Value<int>? rowid,
  }) {
    return FraudAlertsTableCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      riskScore: riskScore ?? this.riskScore,
      reason: reason ?? this.reason,
      timestamp: timestamp ?? this.timestamp,
      isResolved: isResolved ?? this.isResolved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (riskScore.present) {
      map['risk_score'] = Variable<double>(riskScore.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FraudAlertsTableCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('riskScore: $riskScore, ')
          ..write('reason: $reason, ')
          ..write('timestamp: $timestamp, ')
          ..write('isResolved: $isResolved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiInsightsTableTable extends AiInsightsTable
    with TableInfo<$AiInsightsTableTable, AiInsightsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiInsightsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    content,
    timestamp,
    isDismissed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_insights_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiInsightsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiInsightsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiInsightsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
    );
  }

  @override
  $AiInsightsTableTable createAlias(String alias) {
    return $AiInsightsTableTable(attachedDatabase, alias);
  }
}

class AiInsightsTableData extends DataClass
    implements Insertable<AiInsightsTableData> {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final bool isDismissed;
  const AiInsightsTableData({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.isDismissed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  AiInsightsTableCompanion toCompanion(bool nullToAbsent) {
    return AiInsightsTableCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      timestamp: Value(timestamp),
      isDismissed: Value(isDismissed),
    );
  }

  factory AiInsightsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiInsightsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  AiInsightsTableData copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? timestamp,
    bool? isDismissed,
  }) => AiInsightsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
    isDismissed: isDismissed ?? this.isDismissed,
  );
  AiInsightsTableData copyWithCompanion(AiInsightsTableCompanion data) {
    return AiInsightsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiInsightsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, timestamp, isDismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiInsightsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.timestamp == this.timestamp &&
          other.isDismissed == this.isDismissed);
}

class AiInsightsTableCompanion extends UpdateCompanion<AiInsightsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> timestamp;
  final Value<bool> isDismissed;
  final Value<int> rowid;
  const AiInsightsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.isDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiInsightsTableCompanion.insert({
    required String id,
    required String title,
    required String content,
    required DateTime timestamp,
    this.isDismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<AiInsightsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
    Expression<bool>? isDismissed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
      if (isDismissed != null) 'is_dismissed': isDismissed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiInsightsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime>? timestamp,
    Value<bool>? isDismissed,
    Value<int>? rowid,
  }) {
    return AiInsightsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isDismissed: isDismissed ?? this.isDismissed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiInsightsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp, ')
          ..write('isDismissed: $isDismissed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    targetAmount,
    currentAmount,
    targetDate,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_amount'],
      )!,
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_amount'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final String category;
  const GoalsTableData({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['category'] = Variable<String>(category);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      title: Value(title),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      targetDate: Value(targetDate),
      category: Value(category),
    );
  }

  factory GoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'category': serializer.toJson<String>(category),
    };
  }

  GoalsTableData copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    String? category,
  }) => GoalsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    targetDate: targetDate ?? this.targetDate,
    category: category ?? this.category,
  );
  GoalsTableData copyWithCompanion(GoalsTableCompanion data) {
    return GoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, targetAmount, currentAmount, targetDate, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.targetDate == this.targetDate &&
          other.category == this.category);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<DateTime> targetDate;
  final Value<String> category;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.category = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String title,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required String category,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       targetAmount = Value(targetAmount),
       currentAmount = Value(currentAmount),
       targetDate = Value(targetDate),
       category = Value(category);
  static Insertable<GoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<DateTime>? targetDate,
    Expression<String>? category,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (category != null) 'category': category,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<double>? targetAmount,
    Value<double>? currentAmount,
    Value<DateTime>? targetDate,
    Value<String>? category,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
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
          ..write('title: $title, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('category: $category, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTableTable extends NotificationsTable
    with TableInfo<$NotificationsTableTable, NotificationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    timestamp,
    type,
    isRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
    );
  }

  @override
  $NotificationsTableTable createAlias(String alias) {
    return $NotificationsTableTable(attachedDatabase, alias);
  }
}

class NotificationsTableData extends DataClass
    implements Insertable<NotificationsTableData> {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type;
  final bool isRead;
  const NotificationsTableData({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['type'] = Variable<String>(type);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  NotificationsTableCompanion toCompanion(bool nullToAbsent) {
    return NotificationsTableCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      timestamp: Value(timestamp),
      type: Value(type),
      isRead: Value(isRead),
    );
  }

  factory NotificationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      type: serializer.fromJson<String>(json['type']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'type': serializer.toJson<String>(type),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  NotificationsTableData copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    String? type,
    bool? isRead,
  }) => NotificationsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    type: type ?? this.type,
    isRead: isRead ?? this.isRead,
  );
  NotificationsTableData copyWithCompanion(NotificationsTableCompanion data) {
    return NotificationsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      type: data.type.present ? data.type.value : this.type,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, timestamp, type, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.type == this.type &&
          other.isRead == this.isRead);
}

class NotificationsTableCompanion
    extends UpdateCompanion<NotificationsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<String> type;
  final Value<bool> isRead;
  final Value<int> rowid;
  const NotificationsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.type = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsTableCompanion.insert({
    required String id,
    required String title,
    required String body,
    required DateTime timestamp,
    required String type,
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       body = Value(body),
       timestamp = Value(timestamp),
       type = Value(type);
  static Insertable<NotificationsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<String>? type,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (type != null) 'type': type,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<String>? type,
    Value<bool>? isRead,
    Value<int>? rowid,
  }) {
    return NotificationsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('type: $type, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTableTable extends ExchangeRatesTable
    with TableInfo<$ExchangeRatesTableTable, ExchangeRatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromCurrencyMeta = const VerificationMeta(
    'fromCurrency',
  );
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
    'from_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCurrencyMeta = const VerificationMeta(
    'toCurrency',
  );
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
    'to_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomRateMeta = const VerificationMeta(
    'isCustomRate',
  );
  @override
  late final GeneratedColumn<bool> isCustomRate = GeneratedColumn<bool>(
    'is_custom_rate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom_rate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromCurrency,
    toCurrency,
    rate,
    provider,
    updatedAt,
    expiresAt,
    isCustomRate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExchangeRatesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_currency')) {
      context.handle(
        _fromCurrencyMeta,
        fromCurrency.isAcceptableOrUnknown(
          data['from_currency']!,
          _fromCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
        _toCurrencyMeta,
        toCurrency.isAcceptableOrUnknown(data['to_currency']!, _toCurrencyMeta),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('is_custom_rate')) {
      context.handle(
        _isCustomRateMeta,
        isCustomRate.isAcceptableOrUnknown(
          data['is_custom_rate']!,
          _isCustomRateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRatesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRatesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_currency'],
      )!,
      toCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_currency'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      isCustomRate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom_rate'],
      )!,
    );
  }

  @override
  $ExchangeRatesTableTable createAlias(String alias) {
    return $ExchangeRatesTableTable(attachedDatabase, alias);
  }
}

class ExchangeRatesTableData extends DataClass
    implements Insertable<ExchangeRatesTableData> {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final String provider;
  final DateTime updatedAt;
  final DateTime expiresAt;
  final bool isCustomRate;
  const ExchangeRatesTableData({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.provider,
    required this.updatedAt,
    required this.expiresAt,
    required this.isCustomRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<double>(rate);
    map['provider'] = Variable<String>(provider);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['is_custom_rate'] = Variable<bool>(isCustomRate);
    return map;
  }

  ExchangeRatesTableCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesTableCompanion(
      id: Value(id),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
      provider: Value(provider),
      updatedAt: Value(updatedAt),
      expiresAt: Value(expiresAt),
      isCustomRate: Value(isCustomRate),
    );
  }

  factory ExchangeRatesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRatesTableData(
      id: serializer.fromJson<String>(json['id']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
      provider: serializer.fromJson<String>(json['provider']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      isCustomRate: serializer.fromJson<bool>(json['isCustomRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<double>(rate),
      'provider': serializer.toJson<String>(provider),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'isCustomRate': serializer.toJson<bool>(isCustomRate),
    };
  }

  ExchangeRatesTableData copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
    String? provider,
    DateTime? updatedAt,
    DateTime? expiresAt,
    bool? isCustomRate,
  }) => ExchangeRatesTableData(
    id: id ?? this.id,
    fromCurrency: fromCurrency ?? this.fromCurrency,
    toCurrency: toCurrency ?? this.toCurrency,
    rate: rate ?? this.rate,
    provider: provider ?? this.provider,
    updatedAt: updatedAt ?? this.updatedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    isCustomRate: isCustomRate ?? this.isCustomRate,
  );
  ExchangeRatesTableData copyWithCompanion(ExchangeRatesTableCompanion data) {
    return ExchangeRatesTableData(
      id: data.id.present ? data.id.value : this.id,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency: data.toCurrency.present
          ? data.toCurrency.value
          : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      provider: data.provider.present ? data.provider.value : this.provider,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      isCustomRate: data.isCustomRate.present
          ? data.isCustomRate.value
          : this.isCustomRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesTableData(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('provider: $provider, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isCustomRate: $isCustomRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromCurrency,
    toCurrency,
    rate,
    provider,
    updatedAt,
    expiresAt,
    isCustomRate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRatesTableData &&
          other.id == this.id &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate &&
          other.provider == this.provider &&
          other.updatedAt == this.updatedAt &&
          other.expiresAt == this.expiresAt &&
          other.isCustomRate == this.isCustomRate);
}

class ExchangeRatesTableCompanion
    extends UpdateCompanion<ExchangeRatesTableData> {
  final Value<String> id;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<double> rate;
  final Value<String> provider;
  final Value<DateTime> updatedAt;
  final Value<DateTime> expiresAt;
  final Value<bool> isCustomRate;
  final Value<int> rowid;
  const ExchangeRatesTableCompanion({
    this.id = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.provider = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.isCustomRate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesTableCompanion.insert({
    required String id,
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    required String provider,
    required DateTime updatedAt,
    required DateTime expiresAt,
    this.isCustomRate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromCurrency = Value(fromCurrency),
       toCurrency = Value(toCurrency),
       rate = Value(rate),
       provider = Value(provider),
       updatedAt = Value(updatedAt),
       expiresAt = Value(expiresAt);
  static Insertable<ExchangeRatesTableData> custom({
    Expression<String>? id,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<double>? rate,
    Expression<String>? provider,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? expiresAt,
    Expression<bool>? isCustomRate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
      if (provider != null) 'provider': provider,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (isCustomRate != null) 'is_custom_rate': isCustomRate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fromCurrency,
    Value<String>? toCurrency,
    Value<double>? rate,
    Value<String>? provider,
    Value<DateTime>? updatedAt,
    Value<DateTime>? expiresAt,
    Value<bool>? isCustomRate,
    Value<int>? rowid,
  }) {
    return ExchangeRatesTableCompanion(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      provider: provider ?? this.provider,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isCustomRate: isCustomRate ?? this.isCustomRate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (isCustomRate.present) {
      map['is_custom_rate'] = Variable<bool>(isCustomRate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesTableCompanion(')
          ..write('id: $id, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate, ')
          ..write('provider: $provider, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('isCustomRate: $isCustomRate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTableTable extends ProfilesTable
    with TableInfo<$ProfilesTableTable, ProfilesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfilesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfilesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfilesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $ProfilesTableTable createAlias(String alias) {
    return $ProfilesTableTable(attachedDatabase, alias);
  }
}

class ProfilesTableData extends DataClass
    implements Insertable<ProfilesTableData> {
  final int id;
  final String name;
  final String icon;
  final String color;
  const ProfilesTableData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    return map;
  }

  ProfilesTableCompanion toCompanion(bool nullToAbsent) {
    return ProfilesTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
    );
  }

  factory ProfilesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfilesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
    };
  }

  ProfilesTableData copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
  }) => ProfilesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
  );
  ProfilesTableData copyWithCompanion(ProfilesTableCompanion data) {
    return ProfilesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfilesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color);
}

class ProfilesTableCompanion extends UpdateCompanion<ProfilesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> color;
  const ProfilesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  ProfilesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required String color,
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color);
  static Insertable<ProfilesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    });
  }

  ProfilesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? color,
  }) {
    return ProfilesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _isIncomeMeta = const VerificationMeta(
    'isIncome',
  );
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
    'is_income',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_income" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isIncome,
    displayOrder,
    isSystem,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(
        _isIncomeMeta,
        isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_income'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final String name;
  final bool isIncome;
  final int displayOrder;
  final bool isSystem;
  final String? color;
  const CategoriesTableData({
    required this.id,
    required this.name,
    required this.isIncome,
    required this.displayOrder,
    required this.isSystem,
    this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_income'] = Variable<bool>(isIncome);
    map['display_order'] = Variable<int>(displayOrder);
    map['is_system'] = Variable<bool>(isSystem);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      isIncome: Value(isIncome),
      displayOrder: Value(displayOrder),
      isSystem: Value(isSystem),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      color: serializer.fromJson<String?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isIncome': serializer.toJson<bool>(isIncome),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isSystem': serializer.toJson<bool>(isSystem),
      'color': serializer.toJson<String?>(color),
    };
  }

  CategoriesTableData copyWith({
    int? id,
    String? name,
    bool? isIncome,
    int? displayOrder,
    bool? isSystem,
    Value<String?> color = const Value.absent(),
  }) => CategoriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    isIncome: isIncome ?? this.isIncome,
    displayOrder: displayOrder ?? this.displayOrder,
    isSystem: isSystem ?? this.isSystem,
    color: color.present ? color.value : this.color,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isIncome: $isIncome, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, isIncome, displayOrder, isSystem, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isIncome == this.isIncome &&
          other.displayOrder == this.displayOrder &&
          other.isSystem == this.isSystem &&
          other.color == this.color);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isIncome;
  final Value<int> displayOrder;
  final Value<bool> isSystem;
  final Value<String?> color;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.color = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isIncome = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isIncome,
    Expression<int>? displayOrder,
    Expression<bool>? isSystem,
    Expression<String>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isIncome != null) 'is_income': isIncome,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isSystem != null) 'is_system': isSystem,
      if (color != null) 'color': color,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isIncome,
    Value<int>? displayOrder,
    Value<bool>? isSystem,
    Value<String?>? color,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isIncome: isIncome ?? this.isIncome,
      displayOrder: displayOrder ?? this.displayOrder,
      isSystem: isSystem ?? this.isSystem,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isIncome: $isIncome, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isSystem: $isSystem, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $CardsTableTable extends CardsTable
    with TableInfo<$CardsTableTable, CardsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardLast4Meta = const VerificationMeta(
    'cardLast4',
  );
  @override
  late final GeneratedColumn<String> cardLast4 = GeneratedColumn<String>(
    'card_last4',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountLast4Meta = const VerificationMeta(
    'accountLast4',
  );
  @override
  late final GeneratedColumn<String> accountLast4 = GeneratedColumn<String>(
    'account_last4',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
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
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankName,
    cardLast4,
    accountLast4,
    cardType,
    isActive,
    creditLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('card_last4')) {
      context.handle(
        _cardLast4Meta,
        cardLast4.isAcceptableOrUnknown(data['card_last4']!, _cardLast4Meta),
      );
    } else if (isInserting) {
      context.missing(_cardLast4Meta);
    }
    if (data.containsKey('account_last4')) {
      context.handle(
        _accountLast4Meta,
        accountLast4.isAcceptableOrUnknown(
          data['account_last4']!,
          _accountLast4Meta,
        ),
      );
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_cardTypeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      cardLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_last4'],
      )!,
      accountLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_last4'],
      ),
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      ),
    );
  }

  @override
  $CardsTableTable createAlias(String alias) {
    return $CardsTableTable(attachedDatabase, alias);
  }
}

class CardsTableData extends DataClass implements Insertable<CardsTableData> {
  final int id;
  final String bankName;
  final String cardLast4;
  final String? accountLast4;
  final String cardType;
  final bool isActive;
  final double? creditLimit;
  const CardsTableData({
    required this.id,
    required this.bankName,
    required this.cardLast4,
    this.accountLast4,
    required this.cardType,
    required this.isActive,
    this.creditLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['card_last4'] = Variable<String>(cardLast4);
    if (!nullToAbsent || accountLast4 != null) {
      map['account_last4'] = Variable<String>(accountLast4);
    }
    map['card_type'] = Variable<String>(cardType);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    return map;
  }

  CardsTableCompanion toCompanion(bool nullToAbsent) {
    return CardsTableCompanion(
      id: Value(id),
      bankName: Value(bankName),
      cardLast4: Value(cardLast4),
      accountLast4: accountLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(accountLast4),
      cardType: Value(cardType),
      isActive: Value(isActive),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
    );
  }

  factory CardsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardsTableData(
      id: serializer.fromJson<int>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      cardLast4: serializer.fromJson<String>(json['cardLast4']),
      accountLast4: serializer.fromJson<String?>(json['accountLast4']),
      cardType: serializer.fromJson<String>(json['cardType']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankName': serializer.toJson<String>(bankName),
      'cardLast4': serializer.toJson<String>(cardLast4),
      'accountLast4': serializer.toJson<String?>(accountLast4),
      'cardType': serializer.toJson<String>(cardType),
      'isActive': serializer.toJson<bool>(isActive),
      'creditLimit': serializer.toJson<double?>(creditLimit),
    };
  }

  CardsTableData copyWith({
    int? id,
    String? bankName,
    String? cardLast4,
    Value<String?> accountLast4 = const Value.absent(),
    String? cardType,
    bool? isActive,
    Value<double?> creditLimit = const Value.absent(),
  }) => CardsTableData(
    id: id ?? this.id,
    bankName: bankName ?? this.bankName,
    cardLast4: cardLast4 ?? this.cardLast4,
    accountLast4: accountLast4.present ? accountLast4.value : this.accountLast4,
    cardType: cardType ?? this.cardType,
    isActive: isActive ?? this.isActive,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
  );
  CardsTableData copyWithCompanion(CardsTableCompanion data) {
    return CardsTableData(
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      cardLast4: data.cardLast4.present ? data.cardLast4.value : this.cardLast4,
      accountLast4: data.accountLast4.present
          ? data.accountLast4.value
          : this.accountLast4,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableData(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('accountLast4: $accountLast4, ')
          ..write('cardType: $cardType, ')
          ..write('isActive: $isActive, ')
          ..write('creditLimit: $creditLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankName,
    cardLast4,
    accountLast4,
    cardType,
    isActive,
    creditLimit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardsTableData &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.cardLast4 == this.cardLast4 &&
          other.accountLast4 == this.accountLast4 &&
          other.cardType == this.cardType &&
          other.isActive == this.isActive &&
          other.creditLimit == this.creditLimit);
}

class CardsTableCompanion extends UpdateCompanion<CardsTableData> {
  final Value<int> id;
  final Value<String> bankName;
  final Value<String> cardLast4;
  final Value<String?> accountLast4;
  final Value<String> cardType;
  final Value<bool> isActive;
  final Value<double?> creditLimit;
  const CardsTableCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    this.accountLast4 = const Value.absent(),
    this.cardType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.creditLimit = const Value.absent(),
  });
  CardsTableCompanion.insert({
    this.id = const Value.absent(),
    required String bankName,
    required String cardLast4,
    this.accountLast4 = const Value.absent(),
    required String cardType,
    this.isActive = const Value.absent(),
    this.creditLimit = const Value.absent(),
  }) : bankName = Value(bankName),
       cardLast4 = Value(cardLast4),
       cardType = Value(cardType);
  static Insertable<CardsTableData> custom({
    Expression<int>? id,
    Expression<String>? bankName,
    Expression<String>? cardLast4,
    Expression<String>? accountLast4,
    Expression<String>? cardType,
    Expression<bool>? isActive,
    Expression<double>? creditLimit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (cardLast4 != null) 'card_last4': cardLast4,
      if (accountLast4 != null) 'account_last4': accountLast4,
      if (cardType != null) 'card_type': cardType,
      if (isActive != null) 'is_active': isActive,
      if (creditLimit != null) 'credit_limit': creditLimit,
    });
  }

  CardsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? bankName,
    Value<String>? cardLast4,
    Value<String?>? accountLast4,
    Value<String>? cardType,
    Value<bool>? isActive,
    Value<double?>? creditLimit,
  }) {
    return CardsTableCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      cardLast4: cardLast4 ?? this.cardLast4,
      accountLast4: accountLast4 ?? this.accountLast4,
      cardType: cardType ?? this.cardType,
      isActive: isActive ?? this.isActive,
      creditLimit: creditLimit ?? this.creditLimit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (cardLast4.present) {
      map['card_last4'] = Variable<String>(cardLast4.value);
    }
    if (accountLast4.present) {
      map['account_last4'] = Variable<String>(accountLast4.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsTableCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('accountLast4: $accountLast4, ')
          ..write('cardType: $cardType, ')
          ..write('isActive: $isActive, ')
          ..write('creditLimit: $creditLimit')
          ..write(')'))
        .toString();
  }
}

class $AccountBalancesTableTable extends AccountBalancesTable
    with TableInfo<$AccountBalancesTableTable, AccountBalancesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountBalancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountLast4Meta = const VerificationMeta(
    'accountLast4',
  );
  @override
  late final GeneratedColumn<String> accountLast4 = GeneratedColumn<String>(
    'account_last4',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCreditCardMeta = const VerificationMeta(
    'isCreditCard',
  );
  @override
  late final GeneratedColumn<bool> isCreditCard = GeneratedColumn<bool>(
    'is_credit_card',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_credit_card" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _smsSourceMeta = const VerificationMeta(
    'smsSource',
  );
  @override
  late final GeneratedColumn<String> smsSource = GeneratedColumn<String>(
    'sms_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowBalanceThresholdMeta =
      const VerificationMeta('lowBalanceThreshold');
  @override
  late final GeneratedColumn<double> lowBalanceThreshold =
      GeneratedColumn<double>(
        'low_balance_threshold',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bankName,
    accountLast4,
    balance,
    timestamp,
    transactionId,
    createdAt,
    creditLimit,
    isCreditCard,
    smsSource,
    sourceType,
    currency,
    profileId,
    alias,
    lowBalanceThreshold,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_balances_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountBalancesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    } else if (isInserting) {
      context.missing(_bankNameMeta);
    }
    if (data.containsKey('account_last4')) {
      context.handle(
        _accountLast4Meta,
        accountLast4.isAcceptableOrUnknown(
          data['account_last4']!,
          _accountLast4Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountLast4Meta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('is_credit_card')) {
      context.handle(
        _isCreditCardMeta,
        isCreditCard.isAcceptableOrUnknown(
          data['is_credit_card']!,
          _isCreditCardMeta,
        ),
      );
    }
    if (data.containsKey('sms_source')) {
      context.handle(
        _smsSourceMeta,
        smsSource.isAcceptableOrUnknown(data['sms_source']!, _smsSourceMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('low_balance_threshold')) {
      context.handle(
        _lowBalanceThresholdMeta,
        lowBalanceThreshold.isAcceptableOrUnknown(
          data['low_balance_threshold']!,
          _lowBalanceThresholdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountBalancesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountBalancesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      )!,
      accountLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_last4'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      ),
      isCreditCard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_credit_card'],
      )!,
      smsSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_source'],
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      ),
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      lowBalanceThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low_balance_threshold'],
      ),
    );
  }

  @override
  $AccountBalancesTableTable createAlias(String alias) {
    return $AccountBalancesTableTable(attachedDatabase, alias);
  }
}

class AccountBalancesTableData extends DataClass
    implements Insertable<AccountBalancesTableData> {
  final int id;
  final String bankName;
  final String accountLast4;
  final double balance;
  final DateTime timestamp;
  final String? transactionId;
  final DateTime createdAt;
  final double? creditLimit;
  final bool isCreditCard;
  final String? smsSource;
  final String? sourceType;
  final String currency;
  final int? profileId;
  final String? alias;
  final double? lowBalanceThreshold;
  const AccountBalancesTableData({
    required this.id,
    required this.bankName,
    required this.accountLast4,
    required this.balance,
    required this.timestamp,
    this.transactionId,
    required this.createdAt,
    this.creditLimit,
    required this.isCreditCard,
    this.smsSource,
    this.sourceType,
    required this.currency,
    this.profileId,
    this.alias,
    this.lowBalanceThreshold,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bank_name'] = Variable<String>(bankName);
    map['account_last4'] = Variable<String>(accountLast4);
    map['balance'] = Variable<double>(balance);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    map['is_credit_card'] = Variable<bool>(isCreditCard);
    if (!nullToAbsent || smsSource != null) {
      map['sms_source'] = Variable<String>(smsSource);
    }
    if (!nullToAbsent || sourceType != null) {
      map['source_type'] = Variable<String>(sourceType);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || profileId != null) {
      map['profile_id'] = Variable<int>(profileId);
    }
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || lowBalanceThreshold != null) {
      map['low_balance_threshold'] = Variable<double>(lowBalanceThreshold);
    }
    return map;
  }

  AccountBalancesTableCompanion toCompanion(bool nullToAbsent) {
    return AccountBalancesTableCompanion(
      id: Value(id),
      bankName: Value(bankName),
      accountLast4: Value(accountLast4),
      balance: Value(balance),
      timestamp: Value(timestamp),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      createdAt: Value(createdAt),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      isCreditCard: Value(isCreditCard),
      smsSource: smsSource == null && nullToAbsent
          ? const Value.absent()
          : Value(smsSource),
      sourceType: sourceType == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceType),
      currency: Value(currency),
      profileId: profileId == null && nullToAbsent
          ? const Value.absent()
          : Value(profileId),
      alias: alias == null && nullToAbsent
          ? const Value.absent()
          : Value(alias),
      lowBalanceThreshold: lowBalanceThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(lowBalanceThreshold),
    );
  }

  factory AccountBalancesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountBalancesTableData(
      id: serializer.fromJson<int>(json['id']),
      bankName: serializer.fromJson<String>(json['bankName']),
      accountLast4: serializer.fromJson<String>(json['accountLast4']),
      balance: serializer.fromJson<double>(json['balance']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
      isCreditCard: serializer.fromJson<bool>(json['isCreditCard']),
      smsSource: serializer.fromJson<String?>(json['smsSource']),
      sourceType: serializer.fromJson<String?>(json['sourceType']),
      currency: serializer.fromJson<String>(json['currency']),
      profileId: serializer.fromJson<int?>(json['profileId']),
      alias: serializer.fromJson<String?>(json['alias']),
      lowBalanceThreshold: serializer.fromJson<double?>(
        json['lowBalanceThreshold'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bankName': serializer.toJson<String>(bankName),
      'accountLast4': serializer.toJson<String>(accountLast4),
      'balance': serializer.toJson<double>(balance),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'transactionId': serializer.toJson<String?>(transactionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'creditLimit': serializer.toJson<double?>(creditLimit),
      'isCreditCard': serializer.toJson<bool>(isCreditCard),
      'smsSource': serializer.toJson<String?>(smsSource),
      'sourceType': serializer.toJson<String?>(sourceType),
      'currency': serializer.toJson<String>(currency),
      'profileId': serializer.toJson<int?>(profileId),
      'alias': serializer.toJson<String?>(alias),
      'lowBalanceThreshold': serializer.toJson<double?>(lowBalanceThreshold),
    };
  }

  AccountBalancesTableData copyWith({
    int? id,
    String? bankName,
    String? accountLast4,
    double? balance,
    DateTime? timestamp,
    Value<String?> transactionId = const Value.absent(),
    DateTime? createdAt,
    Value<double?> creditLimit = const Value.absent(),
    bool? isCreditCard,
    Value<String?> smsSource = const Value.absent(),
    Value<String?> sourceType = const Value.absent(),
    String? currency,
    Value<int?> profileId = const Value.absent(),
    Value<String?> alias = const Value.absent(),
    Value<double?> lowBalanceThreshold = const Value.absent(),
  }) => AccountBalancesTableData(
    id: id ?? this.id,
    bankName: bankName ?? this.bankName,
    accountLast4: accountLast4 ?? this.accountLast4,
    balance: balance ?? this.balance,
    timestamp: timestamp ?? this.timestamp,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    createdAt: createdAt ?? this.createdAt,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
    isCreditCard: isCreditCard ?? this.isCreditCard,
    smsSource: smsSource.present ? smsSource.value : this.smsSource,
    sourceType: sourceType.present ? sourceType.value : this.sourceType,
    currency: currency ?? this.currency,
    profileId: profileId.present ? profileId.value : this.profileId,
    alias: alias.present ? alias.value : this.alias,
    lowBalanceThreshold: lowBalanceThreshold.present
        ? lowBalanceThreshold.value
        : this.lowBalanceThreshold,
  );
  AccountBalancesTableData copyWithCompanion(
    AccountBalancesTableCompanion data,
  ) {
    return AccountBalancesTableData(
      id: data.id.present ? data.id.value : this.id,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      accountLast4: data.accountLast4.present
          ? data.accountLast4.value
          : this.accountLast4,
      balance: data.balance.present ? data.balance.value : this.balance,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      isCreditCard: data.isCreditCard.present
          ? data.isCreditCard.value
          : this.isCreditCard,
      smsSource: data.smsSource.present ? data.smsSource.value : this.smsSource,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      currency: data.currency.present ? data.currency.value : this.currency,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      alias: data.alias.present ? data.alias.value : this.alias,
      lowBalanceThreshold: data.lowBalanceThreshold.present
          ? data.lowBalanceThreshold.value
          : this.lowBalanceThreshold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountBalancesTableData(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('accountLast4: $accountLast4, ')
          ..write('balance: $balance, ')
          ..write('timestamp: $timestamp, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('isCreditCard: $isCreditCard, ')
          ..write('smsSource: $smsSource, ')
          ..write('sourceType: $sourceType, ')
          ..write('currency: $currency, ')
          ..write('profileId: $profileId, ')
          ..write('alias: $alias, ')
          ..write('lowBalanceThreshold: $lowBalanceThreshold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bankName,
    accountLast4,
    balance,
    timestamp,
    transactionId,
    createdAt,
    creditLimit,
    isCreditCard,
    smsSource,
    sourceType,
    currency,
    profileId,
    alias,
    lowBalanceThreshold,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountBalancesTableData &&
          other.id == this.id &&
          other.bankName == this.bankName &&
          other.accountLast4 == this.accountLast4 &&
          other.balance == this.balance &&
          other.timestamp == this.timestamp &&
          other.transactionId == this.transactionId &&
          other.createdAt == this.createdAt &&
          other.creditLimit == this.creditLimit &&
          other.isCreditCard == this.isCreditCard &&
          other.smsSource == this.smsSource &&
          other.sourceType == this.sourceType &&
          other.currency == this.currency &&
          other.profileId == this.profileId &&
          other.alias == this.alias &&
          other.lowBalanceThreshold == this.lowBalanceThreshold);
}

class AccountBalancesTableCompanion
    extends UpdateCompanion<AccountBalancesTableData> {
  final Value<int> id;
  final Value<String> bankName;
  final Value<String> accountLast4;
  final Value<double> balance;
  final Value<DateTime> timestamp;
  final Value<String?> transactionId;
  final Value<DateTime> createdAt;
  final Value<double?> creditLimit;
  final Value<bool> isCreditCard;
  final Value<String?> smsSource;
  final Value<String?> sourceType;
  final Value<String> currency;
  final Value<int?> profileId;
  final Value<String?> alias;
  final Value<double?> lowBalanceThreshold;
  const AccountBalancesTableCompanion({
    this.id = const Value.absent(),
    this.bankName = const Value.absent(),
    this.accountLast4 = const Value.absent(),
    this.balance = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.isCreditCard = const Value.absent(),
    this.smsSource = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.currency = const Value.absent(),
    this.profileId = const Value.absent(),
    this.alias = const Value.absent(),
    this.lowBalanceThreshold = const Value.absent(),
  });
  AccountBalancesTableCompanion.insert({
    this.id = const Value.absent(),
    required String bankName,
    required String accountLast4,
    required double balance,
    required DateTime timestamp,
    this.transactionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.isCreditCard = const Value.absent(),
    this.smsSource = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.currency = const Value.absent(),
    this.profileId = const Value.absent(),
    this.alias = const Value.absent(),
    this.lowBalanceThreshold = const Value.absent(),
  }) : bankName = Value(bankName),
       accountLast4 = Value(accountLast4),
       balance = Value(balance),
       timestamp = Value(timestamp);
  static Insertable<AccountBalancesTableData> custom({
    Expression<int>? id,
    Expression<String>? bankName,
    Expression<String>? accountLast4,
    Expression<double>? balance,
    Expression<DateTime>? timestamp,
    Expression<String>? transactionId,
    Expression<DateTime>? createdAt,
    Expression<double>? creditLimit,
    Expression<bool>? isCreditCard,
    Expression<String>? smsSource,
    Expression<String>? sourceType,
    Expression<String>? currency,
    Expression<int>? profileId,
    Expression<String>? alias,
    Expression<double>? lowBalanceThreshold,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bankName != null) 'bank_name': bankName,
      if (accountLast4 != null) 'account_last4': accountLast4,
      if (balance != null) 'balance': balance,
      if (timestamp != null) 'timestamp': timestamp,
      if (transactionId != null) 'transaction_id': transactionId,
      if (createdAt != null) 'created_at': createdAt,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (isCreditCard != null) 'is_credit_card': isCreditCard,
      if (smsSource != null) 'sms_source': smsSource,
      if (sourceType != null) 'source_type': sourceType,
      if (currency != null) 'currency': currency,
      if (profileId != null) 'profile_id': profileId,
      if (alias != null) 'alias': alias,
      if (lowBalanceThreshold != null)
        'low_balance_threshold': lowBalanceThreshold,
    });
  }

  AccountBalancesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? bankName,
    Value<String>? accountLast4,
    Value<double>? balance,
    Value<DateTime>? timestamp,
    Value<String?>? transactionId,
    Value<DateTime>? createdAt,
    Value<double?>? creditLimit,
    Value<bool>? isCreditCard,
    Value<String?>? smsSource,
    Value<String?>? sourceType,
    Value<String>? currency,
    Value<int?>? profileId,
    Value<String?>? alias,
    Value<double?>? lowBalanceThreshold,
  }) {
    return AccountBalancesTableCompanion(
      id: id ?? this.id,
      bankName: bankName ?? this.bankName,
      accountLast4: accountLast4 ?? this.accountLast4,
      balance: balance ?? this.balance,
      timestamp: timestamp ?? this.timestamp,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      creditLimit: creditLimit ?? this.creditLimit,
      isCreditCard: isCreditCard ?? this.isCreditCard,
      smsSource: smsSource ?? this.smsSource,
      sourceType: sourceType ?? this.sourceType,
      currency: currency ?? this.currency,
      profileId: profileId ?? this.profileId,
      alias: alias ?? this.alias,
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (accountLast4.present) {
      map['account_last4'] = Variable<String>(accountLast4.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (isCreditCard.present) {
      map['is_credit_card'] = Variable<bool>(isCreditCard.value);
    }
    if (smsSource.present) {
      map['sms_source'] = Variable<String>(smsSource.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (lowBalanceThreshold.present) {
      map['low_balance_threshold'] = Variable<double>(
        lowBalanceThreshold.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountBalancesTableCompanion(')
          ..write('id: $id, ')
          ..write('bankName: $bankName, ')
          ..write('accountLast4: $accountLast4, ')
          ..write('balance: $balance, ')
          ..write('timestamp: $timestamp, ')
          ..write('transactionId: $transactionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('isCreditCard: $isCreditCard, ')
          ..write('smsSource: $smsSource, ')
          ..write('sourceType: $sourceType, ')
          ..write('currency: $currency, ')
          ..write('profileId: $profileId, ')
          ..write('alias: $alias, ')
          ..write('lowBalanceThreshold: $lowBalanceThreshold')
          ..write(')'))
        .toString();
  }
}

class $MerchantMappingsTableTable extends MerchantMappingsTable
    with TableInfo<$MerchantMappingsTableTable, MerchantMappingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MerchantMappingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rawMerchantMeta = const VerificationMeta(
    'rawMerchant',
  );
  @override
  late final GeneratedColumn<String> rawMerchant = GeneratedColumn<String>(
    'raw_merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cleanMerchantMeta = const VerificationMeta(
    'cleanMerchant',
  );
  @override
  late final GeneratedColumn<String> cleanMerchant = GeneratedColumn<String>(
    'clean_merchant',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, rawMerchant, cleanMerchant];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'merchant_mappings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MerchantMappingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('raw_merchant')) {
      context.handle(
        _rawMerchantMeta,
        rawMerchant.isAcceptableOrUnknown(
          data['raw_merchant']!,
          _rawMerchantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rawMerchantMeta);
    }
    if (data.containsKey('clean_merchant')) {
      context.handle(
        _cleanMerchantMeta,
        cleanMerchant.isAcceptableOrUnknown(
          data['clean_merchant']!,
          _cleanMerchantMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cleanMerchantMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MerchantMappingsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MerchantMappingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      rawMerchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_merchant'],
      )!,
      cleanMerchant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clean_merchant'],
      )!,
    );
  }

  @override
  $MerchantMappingsTableTable createAlias(String alias) {
    return $MerchantMappingsTableTable(attachedDatabase, alias);
  }
}

class MerchantMappingsTableData extends DataClass
    implements Insertable<MerchantMappingsTableData> {
  final int id;
  final String rawMerchant;
  final String cleanMerchant;
  const MerchantMappingsTableData({
    required this.id,
    required this.rawMerchant,
    required this.cleanMerchant,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['raw_merchant'] = Variable<String>(rawMerchant);
    map['clean_merchant'] = Variable<String>(cleanMerchant);
    return map;
  }

  MerchantMappingsTableCompanion toCompanion(bool nullToAbsent) {
    return MerchantMappingsTableCompanion(
      id: Value(id),
      rawMerchant: Value(rawMerchant),
      cleanMerchant: Value(cleanMerchant),
    );
  }

  factory MerchantMappingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MerchantMappingsTableData(
      id: serializer.fromJson<int>(json['id']),
      rawMerchant: serializer.fromJson<String>(json['rawMerchant']),
      cleanMerchant: serializer.fromJson<String>(json['cleanMerchant']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'rawMerchant': serializer.toJson<String>(rawMerchant),
      'cleanMerchant': serializer.toJson<String>(cleanMerchant),
    };
  }

  MerchantMappingsTableData copyWith({
    int? id,
    String? rawMerchant,
    String? cleanMerchant,
  }) => MerchantMappingsTableData(
    id: id ?? this.id,
    rawMerchant: rawMerchant ?? this.rawMerchant,
    cleanMerchant: cleanMerchant ?? this.cleanMerchant,
  );
  MerchantMappingsTableData copyWithCompanion(
    MerchantMappingsTableCompanion data,
  ) {
    return MerchantMappingsTableData(
      id: data.id.present ? data.id.value : this.id,
      rawMerchant: data.rawMerchant.present
          ? data.rawMerchant.value
          : this.rawMerchant,
      cleanMerchant: data.cleanMerchant.present
          ? data.cleanMerchant.value
          : this.cleanMerchant,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMappingsTableData(')
          ..write('id: $id, ')
          ..write('rawMerchant: $rawMerchant, ')
          ..write('cleanMerchant: $cleanMerchant')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, rawMerchant, cleanMerchant);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MerchantMappingsTableData &&
          other.id == this.id &&
          other.rawMerchant == this.rawMerchant &&
          other.cleanMerchant == this.cleanMerchant);
}

class MerchantMappingsTableCompanion
    extends UpdateCompanion<MerchantMappingsTableData> {
  final Value<int> id;
  final Value<String> rawMerchant;
  final Value<String> cleanMerchant;
  const MerchantMappingsTableCompanion({
    this.id = const Value.absent(),
    this.rawMerchant = const Value.absent(),
    this.cleanMerchant = const Value.absent(),
  });
  MerchantMappingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String rawMerchant,
    required String cleanMerchant,
  }) : rawMerchant = Value(rawMerchant),
       cleanMerchant = Value(cleanMerchant);
  static Insertable<MerchantMappingsTableData> custom({
    Expression<int>? id,
    Expression<String>? rawMerchant,
    Expression<String>? cleanMerchant,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rawMerchant != null) 'raw_merchant': rawMerchant,
      if (cleanMerchant != null) 'clean_merchant': cleanMerchant,
    });
  }

  MerchantMappingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? rawMerchant,
    Value<String>? cleanMerchant,
  }) {
    return MerchantMappingsTableCompanion(
      id: id ?? this.id,
      rawMerchant: rawMerchant ?? this.rawMerchant,
      cleanMerchant: cleanMerchant ?? this.cleanMerchant,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (rawMerchant.present) {
      map['raw_merchant'] = Variable<String>(rawMerchant.value);
    }
    if (cleanMerchant.present) {
      map['clean_merchant'] = Variable<String>(cleanMerchant.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MerchantMappingsTableCompanion(')
          ..write('id: $id, ')
          ..write('rawMerchant: $rawMerchant, ')
          ..write('cleanMerchant: $cleanMerchant')
          ..write(')'))
        .toString();
  }
}

class $UnrecognizedSmsTableTable extends UnrecognizedSmsTable
    with TableInfo<$UnrecognizedSmsTableTable, UnrecognizedSmsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnrecognizedSmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _smsIdMeta = const VerificationMeta('smsId');
  @override
  late final GeneratedColumn<String> smsId = GeneratedColumn<String>(
    'sms_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, smsId, body, timestamp, reason];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unrecognized_sms_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnrecognizedSmsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sms_id')) {
      context.handle(
        _smsIdMeta,
        smsId.isAcceptableOrUnknown(data['sms_id']!, _smsIdMeta),
      );
    } else if (isInserting) {
      context.missing(_smsIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnrecognizedSmsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnrecognizedSmsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      smsId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sms_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
    );
  }

  @override
  $UnrecognizedSmsTableTable createAlias(String alias) {
    return $UnrecognizedSmsTableTable(attachedDatabase, alias);
  }
}

class UnrecognizedSmsTableData extends DataClass
    implements Insertable<UnrecognizedSmsTableData> {
  final int id;
  final String smsId;
  final String body;
  final DateTime timestamp;
  final String reason;
  const UnrecognizedSmsTableData({
    required this.id,
    required this.smsId,
    required this.body,
    required this.timestamp,
    required this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sms_id'] = Variable<String>(smsId);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['reason'] = Variable<String>(reason);
    return map;
  }

  UnrecognizedSmsTableCompanion toCompanion(bool nullToAbsent) {
    return UnrecognizedSmsTableCompanion(
      id: Value(id),
      smsId: Value(smsId),
      body: Value(body),
      timestamp: Value(timestamp),
      reason: Value(reason),
    );
  }

  factory UnrecognizedSmsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnrecognizedSmsTableData(
      id: serializer.fromJson<int>(json['id']),
      smsId: serializer.fromJson<String>(json['smsId']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      reason: serializer.fromJson<String>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'smsId': serializer.toJson<String>(smsId),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'reason': serializer.toJson<String>(reason),
    };
  }

  UnrecognizedSmsTableData copyWith({
    int? id,
    String? smsId,
    String? body,
    DateTime? timestamp,
    String? reason,
  }) => UnrecognizedSmsTableData(
    id: id ?? this.id,
    smsId: smsId ?? this.smsId,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
    reason: reason ?? this.reason,
  );
  UnrecognizedSmsTableData copyWithCompanion(
    UnrecognizedSmsTableCompanion data,
  ) {
    return UnrecognizedSmsTableData(
      id: data.id.present ? data.id.value : this.id,
      smsId: data.smsId.present ? data.smsId.value : this.smsId,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnrecognizedSmsTableData(')
          ..write('id: $id, ')
          ..write('smsId: $smsId, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, smsId, body, timestamp, reason);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnrecognizedSmsTableData &&
          other.id == this.id &&
          other.smsId == this.smsId &&
          other.body == this.body &&
          other.timestamp == this.timestamp &&
          other.reason == this.reason);
}

class UnrecognizedSmsTableCompanion
    extends UpdateCompanion<UnrecognizedSmsTableData> {
  final Value<int> id;
  final Value<String> smsId;
  final Value<String> body;
  final Value<DateTime> timestamp;
  final Value<String> reason;
  const UnrecognizedSmsTableCompanion({
    this.id = const Value.absent(),
    this.smsId = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.reason = const Value.absent(),
  });
  UnrecognizedSmsTableCompanion.insert({
    this.id = const Value.absent(),
    required String smsId,
    required String body,
    required DateTime timestamp,
    required String reason,
  }) : smsId = Value(smsId),
       body = Value(body),
       timestamp = Value(timestamp),
       reason = Value(reason);
  static Insertable<UnrecognizedSmsTableData> custom({
    Expression<int>? id,
    Expression<String>? smsId,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
    Expression<String>? reason,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (smsId != null) 'sms_id': smsId,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
      if (reason != null) 'reason': reason,
    });
  }

  UnrecognizedSmsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? smsId,
    Value<String>? body,
    Value<DateTime>? timestamp,
    Value<String>? reason,
  }) {
    return UnrecognizedSmsTableCompanion(
      id: id ?? this.id,
      smsId: smsId ?? this.smsId,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      reason: reason ?? this.reason,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (smsId.present) {
      map['sms_id'] = Variable<String>(smsId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnrecognizedSmsTableCompanion(')
          ..write('id: $id, ')
          ..write('smsId: $smsId, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }
}

class $ChatMessagesTableTable extends ChatMessagesTable
    with TableInfo<$ChatMessagesTableTable, ChatMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, role, content, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ChatMessagesTableTable createAlias(String alias) {
    return $ChatMessagesTableTable(attachedDatabase, alias);
  }
}

class ChatMessagesTableData extends DataClass
    implements Insertable<ChatMessagesTableData> {
  final int id;
  final String role;
  final String content;
  final DateTime timestamp;
  const ChatMessagesTableData({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ChatMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return ChatMessagesTableCompanion(
      id: Value(id),
      role: Value(role),
      content: Value(content),
      timestamp: Value(timestamp),
    );
  }

  factory ChatMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessagesTableData(
      id: serializer.fromJson<int>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ChatMessagesTableData copyWith({
    int? id,
    String? role,
    String? content,
    DateTime? timestamp,
  }) => ChatMessagesTableData(
    id: id ?? this.id,
    role: role ?? this.role,
    content: content ?? this.content,
    timestamp: timestamp ?? this.timestamp,
  );
  ChatMessagesTableData copyWithCompanion(ChatMessagesTableCompanion data) {
    return ChatMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableData(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, role, content, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessagesTableData &&
          other.id == this.id &&
          other.role == this.role &&
          other.content == this.content &&
          other.timestamp == this.timestamp);
}

class ChatMessagesTableCompanion
    extends UpdateCompanion<ChatMessagesTableData> {
  final Value<int> id;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> timestamp;
  const ChatMessagesTableCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ChatMessagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String role,
    required String content,
    required DateTime timestamp,
  }) : role = Value(role),
       content = Value(content),
       timestamp = Value(timestamp);
  static Insertable<ChatMessagesTableData> custom({
    Expression<int>? id,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ChatMessagesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? timestamp,
  }) {
    return ChatMessagesTableCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $RulesTableTable extends RulesTable
    with TableInfo<$RulesTableTable, RulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _conditionsMeta = const VerificationMeta(
    'conditions',
  );
  @override
  late final GeneratedColumn<String> conditions = GeneratedColumn<String>(
    'conditions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionsMeta = const VerificationMeta(
    'actions',
  );
  @override
  late final GeneratedColumn<String> actions = GeneratedColumn<String>(
    'actions',
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
  static const VerificationMeta _isSystemTemplateMeta = const VerificationMeta(
    'isSystemTemplate',
  );
  @override
  late final GeneratedColumn<bool> isSystemTemplate = GeneratedColumn<bool>(
    'is_system_template',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_template" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    priority,
    conditions,
    actions,
    isActive,
    isSystemTemplate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('conditions')) {
      context.handle(
        _conditionsMeta,
        conditions.isAcceptableOrUnknown(data['conditions']!, _conditionsMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionsMeta);
    }
    if (data.containsKey('actions')) {
      context.handle(
        _actionsMeta,
        actions.isAcceptableOrUnknown(data['actions']!, _actionsMeta),
      );
    } else if (isInserting) {
      context.missing(_actionsMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_system_template')) {
      context.handle(
        _isSystemTemplateMeta,
        isSystemTemplate.isAcceptableOrUnknown(
          data['is_system_template']!,
          _isSystemTemplateMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RulesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      conditions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conditions'],
      )!,
      actions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actions'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isSystemTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_template'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RulesTableTable createAlias(String alias) {
    return $RulesTableTable(attachedDatabase, alias);
  }
}

class RulesTableData extends DataClass implements Insertable<RulesTableData> {
  final String id;
  final String name;
  final String? description;
  final int priority;
  final String conditions;
  final String actions;
  final bool isActive;
  final bool isSystemTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RulesTableData({
    required this.id,
    required this.name,
    this.description,
    required this.priority,
    required this.conditions,
    required this.actions,
    required this.isActive,
    required this.isSystemTemplate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['priority'] = Variable<int>(priority);
    map['conditions'] = Variable<String>(conditions);
    map['actions'] = Variable<String>(actions);
    map['is_active'] = Variable<bool>(isActive);
    map['is_system_template'] = Variable<bool>(isSystemTemplate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RulesTableCompanion toCompanion(bool nullToAbsent) {
    return RulesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      priority: Value(priority),
      conditions: Value(conditions),
      actions: Value(actions),
      isActive: Value(isActive),
      isSystemTemplate: Value(isSystemTemplate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RulesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      priority: serializer.fromJson<int>(json['priority']),
      conditions: serializer.fromJson<String>(json['conditions']),
      actions: serializer.fromJson<String>(json['actions']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSystemTemplate: serializer.fromJson<bool>(json['isSystemTemplate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'priority': serializer.toJson<int>(priority),
      'conditions': serializer.toJson<String>(conditions),
      'actions': serializer.toJson<String>(actions),
      'isActive': serializer.toJson<bool>(isActive),
      'isSystemTemplate': serializer.toJson<bool>(isSystemTemplate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RulesTableData copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? priority,
    String? conditions,
    String? actions,
    bool? isActive,
    bool? isSystemTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RulesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    priority: priority ?? this.priority,
    conditions: conditions ?? this.conditions,
    actions: actions ?? this.actions,
    isActive: isActive ?? this.isActive,
    isSystemTemplate: isSystemTemplate ?? this.isSystemTemplate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RulesTableData copyWithCompanion(RulesTableCompanion data) {
    return RulesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      priority: data.priority.present ? data.priority.value : this.priority,
      conditions: data.conditions.present
          ? data.conditions.value
          : this.conditions,
      actions: data.actions.present ? data.actions.value : this.actions,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSystemTemplate: data.isSystemTemplate.present
          ? data.isSystemTemplate.value
          : this.isSystemTemplate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RulesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('conditions: $conditions, ')
          ..write('actions: $actions, ')
          ..write('isActive: $isActive, ')
          ..write('isSystemTemplate: $isSystemTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    priority,
    conditions,
    actions,
    isActive,
    isSystemTemplate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RulesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.priority == this.priority &&
          other.conditions == this.conditions &&
          other.actions == this.actions &&
          other.isActive == this.isActive &&
          other.isSystemTemplate == this.isSystemTemplate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RulesTableCompanion extends UpdateCompanion<RulesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> priority;
  final Value<String> conditions;
  final Value<String> actions;
  final Value<bool> isActive;
  final Value<bool> isSystemTemplate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RulesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    this.conditions = const Value.absent(),
    this.actions = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSystemTemplate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RulesTableCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.priority = const Value.absent(),
    required String conditions,
    required String actions,
    this.isActive = const Value.absent(),
    this.isSystemTemplate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       conditions = Value(conditions),
       actions = Value(actions);
  static Insertable<RulesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? priority,
    Expression<String>? conditions,
    Expression<String>? actions,
    Expression<bool>? isActive,
    Expression<bool>? isSystemTemplate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (priority != null) 'priority': priority,
      if (conditions != null) 'conditions': conditions,
      if (actions != null) 'actions': actions,
      if (isActive != null) 'is_active': isActive,
      if (isSystemTemplate != null) 'is_system_template': isSystemTemplate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? priority,
    Value<String>? conditions,
    Value<String>? actions,
    Value<bool>? isActive,
    Value<bool>? isSystemTemplate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RulesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      isActive: isActive ?? this.isActive,
      isSystemTemplate: isSystemTemplate ?? this.isSystemTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (conditions.present) {
      map['conditions'] = Variable<String>(conditions.value);
    }
    if (actions.present) {
      map['actions'] = Variable<String>(actions.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSystemTemplate.present) {
      map['is_system_template'] = Variable<bool>(isSystemTemplate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RulesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('priority: $priority, ')
          ..write('conditions: $conditions, ')
          ..write('actions: $actions, ')
          ..write('isActive: $isActive, ')
          ..write('isSystemTemplate: $isSystemTemplate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RuleApplicationsTableTable extends RuleApplicationsTable
    with TableInfo<$RuleApplicationsTableTable, RuleApplicationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RuleApplicationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES rules_table (id)',
    ),
  );
  static const VerificationMeta _ruleNameMeta = const VerificationMeta(
    'ruleName',
  );
  @override
  late final GeneratedColumn<String> ruleName = GeneratedColumn<String>(
    'rule_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions_table (id)',
    ),
  );
  static const VerificationMeta _fieldsModifiedMeta = const VerificationMeta(
    'fieldsModified',
  );
  @override
  late final GeneratedColumn<String> fieldsModified = GeneratedColumn<String>(
    'fields_modified',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ruleId,
    ruleName,
    transactionId,
    fieldsModified,
    appliedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rule_applications_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RuleApplicationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('rule_name')) {
      context.handle(
        _ruleNameMeta,
        ruleName.isAcceptableOrUnknown(data['rule_name']!, _ruleNameMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleNameMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('fields_modified')) {
      context.handle(
        _fieldsModifiedMeta,
        fieldsModified.isAcceptableOrUnknown(
          data['fields_modified']!,
          _fieldsModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fieldsModifiedMeta);
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_appliedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RuleApplicationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RuleApplicationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      )!,
      ruleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_name'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      fieldsModified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fields_modified'],
      )!,
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      )!,
    );
  }

  @override
  $RuleApplicationsTableTable createAlias(String alias) {
    return $RuleApplicationsTableTable(attachedDatabase, alias);
  }
}

class RuleApplicationsTableData extends DataClass
    implements Insertable<RuleApplicationsTableData> {
  final String id;
  final String ruleId;
  final String ruleName;
  final String transactionId;
  final String fieldsModified;
  final DateTime appliedAt;
  const RuleApplicationsTableData({
    required this.id,
    required this.ruleId,
    required this.ruleName,
    required this.transactionId,
    required this.fieldsModified,
    required this.appliedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rule_id'] = Variable<String>(ruleId);
    map['rule_name'] = Variable<String>(ruleName);
    map['transaction_id'] = Variable<String>(transactionId);
    map['fields_modified'] = Variable<String>(fieldsModified);
    map['applied_at'] = Variable<DateTime>(appliedAt);
    return map;
  }

  RuleApplicationsTableCompanion toCompanion(bool nullToAbsent) {
    return RuleApplicationsTableCompanion(
      id: Value(id),
      ruleId: Value(ruleId),
      ruleName: Value(ruleName),
      transactionId: Value(transactionId),
      fieldsModified: Value(fieldsModified),
      appliedAt: Value(appliedAt),
    );
  }

  factory RuleApplicationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RuleApplicationsTableData(
      id: serializer.fromJson<String>(json['id']),
      ruleId: serializer.fromJson<String>(json['ruleId']),
      ruleName: serializer.fromJson<String>(json['ruleName']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      fieldsModified: serializer.fromJson<String>(json['fieldsModified']),
      appliedAt: serializer.fromJson<DateTime>(json['appliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ruleId': serializer.toJson<String>(ruleId),
      'ruleName': serializer.toJson<String>(ruleName),
      'transactionId': serializer.toJson<String>(transactionId),
      'fieldsModified': serializer.toJson<String>(fieldsModified),
      'appliedAt': serializer.toJson<DateTime>(appliedAt),
    };
  }

  RuleApplicationsTableData copyWith({
    String? id,
    String? ruleId,
    String? ruleName,
    String? transactionId,
    String? fieldsModified,
    DateTime? appliedAt,
  }) => RuleApplicationsTableData(
    id: id ?? this.id,
    ruleId: ruleId ?? this.ruleId,
    ruleName: ruleName ?? this.ruleName,
    transactionId: transactionId ?? this.transactionId,
    fieldsModified: fieldsModified ?? this.fieldsModified,
    appliedAt: appliedAt ?? this.appliedAt,
  );
  RuleApplicationsTableData copyWithCompanion(
    RuleApplicationsTableCompanion data,
  ) {
    return RuleApplicationsTableData(
      id: data.id.present ? data.id.value : this.id,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      ruleName: data.ruleName.present ? data.ruleName.value : this.ruleName,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      fieldsModified: data.fieldsModified.present
          ? data.fieldsModified.value
          : this.fieldsModified,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RuleApplicationsTableData(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleName: $ruleName, ')
          ..write('transactionId: $transactionId, ')
          ..write('fieldsModified: $fieldsModified, ')
          ..write('appliedAt: $appliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ruleId,
    ruleName,
    transactionId,
    fieldsModified,
    appliedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RuleApplicationsTableData &&
          other.id == this.id &&
          other.ruleId == this.ruleId &&
          other.ruleName == this.ruleName &&
          other.transactionId == this.transactionId &&
          other.fieldsModified == this.fieldsModified &&
          other.appliedAt == this.appliedAt);
}

class RuleApplicationsTableCompanion
    extends UpdateCompanion<RuleApplicationsTableData> {
  final Value<String> id;
  final Value<String> ruleId;
  final Value<String> ruleName;
  final Value<String> transactionId;
  final Value<String> fieldsModified;
  final Value<DateTime> appliedAt;
  final Value<int> rowid;
  const RuleApplicationsTableCompanion({
    this.id = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.ruleName = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.fieldsModified = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RuleApplicationsTableCompanion.insert({
    required String id,
    required String ruleId,
    required String ruleName,
    required String transactionId,
    required String fieldsModified,
    required DateTime appliedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ruleId = Value(ruleId),
       ruleName = Value(ruleName),
       transactionId = Value(transactionId),
       fieldsModified = Value(fieldsModified),
       appliedAt = Value(appliedAt);
  static Insertable<RuleApplicationsTableData> custom({
    Expression<String>? id,
    Expression<String>? ruleId,
    Expression<String>? ruleName,
    Expression<String>? transactionId,
    Expression<String>? fieldsModified,
    Expression<DateTime>? appliedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ruleId != null) 'rule_id': ruleId,
      if (ruleName != null) 'rule_name': ruleName,
      if (transactionId != null) 'transaction_id': transactionId,
      if (fieldsModified != null) 'fields_modified': fieldsModified,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RuleApplicationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? ruleId,
    Value<String>? ruleName,
    Value<String>? transactionId,
    Value<String>? fieldsModified,
    Value<DateTime>? appliedAt,
    Value<int>? rowid,
  }) {
    return RuleApplicationsTableCompanion(
      id: id ?? this.id,
      ruleId: ruleId ?? this.ruleId,
      ruleName: ruleName ?? this.ruleName,
      transactionId: transactionId ?? this.transactionId,
      fieldsModified: fieldsModified ?? this.fieldsModified,
      appliedAt: appliedAt ?? this.appliedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (ruleName.present) {
      map['rule_name'] = Variable<String>(ruleName.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (fieldsModified.present) {
      map['fields_modified'] = Variable<String>(fieldsModified.value);
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RuleApplicationsTableCompanion(')
          ..write('id: $id, ')
          ..write('ruleId: $ruleId, ')
          ..write('ruleName: $ruleName, ')
          ..write('transactionId: $transactionId, ')
          ..write('fieldsModified: $fieldsModified, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionSplitsTableTable extends TransactionSplitsTable
    with TableInfo<$TransactionSplitsTableTable, TransactionSplitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSplitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionId,
    category,
    amount,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_splits_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSplitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionSplitsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSplitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $TransactionSplitsTableTable createAlias(String alias) {
    return $TransactionSplitsTableTable(attachedDatabase, alias);
  }
}

class TransactionSplitsTableData extends DataClass
    implements Insertable<TransactionSplitsTableData> {
  final int id;
  final String transactionId;
  final String category;
  final double amount;
  final String? description;
  const TransactionSplitsTableData({
    required this.id,
    required this.transactionId,
    required this.category,
    required this.amount,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  TransactionSplitsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionSplitsTableCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      category: Value(category),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory TransactionSplitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSplitsTableData(
      id: serializer.fromJson<int>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
    };
  }

  TransactionSplitsTableData copyWith({
    int? id,
    String? transactionId,
    String? category,
    double? amount,
    Value<String?> description = const Value.absent(),
  }) => TransactionSplitsTableData(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
  );
  TransactionSplitsTableData copyWithCompanion(
    TransactionSplitsTableCompanion data,
  ) {
    return TransactionSplitsTableData(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplitsTableData(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, transactionId, category, amount, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSplitsTableData &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.description == this.description);
}

class TransactionSplitsTableCompanion
    extends UpdateCompanion<TransactionSplitsTableData> {
  final Value<int> id;
  final Value<String> transactionId;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> description;
  const TransactionSplitsTableCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
  });
  TransactionSplitsTableCompanion.insert({
    this.id = const Value.absent(),
    required String transactionId,
    required String category,
    required double amount,
    this.description = const Value.absent(),
  }) : transactionId = Value(transactionId),
       category = Value(category),
       amount = Value(amount);
  static Insertable<TransactionSplitsTableData> custom({
    Expression<int>? id,
    Expression<String>? transactionId,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
    });
  }

  TransactionSplitsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? transactionId,
    Value<String>? category,
    Value<double>? amount,
    Value<String?>? description,
  }) {
    return TransactionSplitsTableCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplitsTableCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $BankNotificationsTableTable extends BankNotificationsTable
    with TableInfo<$BankNotificationsTableTable, BankNotificationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BankNotificationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, body, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bank_notifications_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BankNotificationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BankNotificationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BankNotificationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $BankNotificationsTableTable createAlias(String alias) {
    return $BankNotificationsTableTable(attachedDatabase, alias);
  }
}

class BankNotificationsTableData extends DataClass
    implements Insertable<BankNotificationsTableData> {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  const BankNotificationsTableData({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  BankNotificationsTableCompanion toCompanion(bool nullToAbsent) {
    return BankNotificationsTableCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      timestamp: Value(timestamp),
    );
  }

  factory BankNotificationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BankNotificationsTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  BankNotificationsTableData copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? timestamp,
  }) => BankNotificationsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    timestamp: timestamp ?? this.timestamp,
  );
  BankNotificationsTableData copyWithCompanion(
    BankNotificationsTableCompanion data,
  ) {
    return BankNotificationsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BankNotificationsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BankNotificationsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.timestamp == this.timestamp);
}

class BankNotificationsTableCompanion
    extends UpdateCompanion<BankNotificationsTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<DateTime> timestamp;
  const BankNotificationsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  BankNotificationsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    required DateTime timestamp,
  }) : title = Value(title),
       body = Value(body),
       timestamp = Value(timestamp);
  static Insertable<BankNotificationsTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  BankNotificationsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<DateTime>? timestamp,
  }) {
    return BankNotificationsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BankNotificationsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $LoansTableTable extends LoansTable
    with TableInfo<$LoansTableTable, LoansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lenderMeta = const VerificationMeta('lender');
  @override
  late final GeneratedColumn<String> lender = GeneratedColumn<String>(
    'lender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalMeta = const VerificationMeta(
    'principal',
  );
  @override
  late final GeneratedColumn<double> principal = GeneratedColumn<double>(
    'principal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMonthsMeta = const VerificationMeta(
    'durationMonths',
  );
  @override
  late final GeneratedColumn<int> durationMonths = GeneratedColumn<int>(
    'duration_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lender,
    principal,
    interestRate,
    startDate,
    durationMonths,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoansTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lender')) {
      context.handle(
        _lenderMeta,
        lender.isAcceptableOrUnknown(data['lender']!, _lenderMeta),
      );
    } else if (isInserting) {
      context.missing(_lenderMeta);
    }
    if (data.containsKey('principal')) {
      context.handle(
        _principalMeta,
        principal.isAcceptableOrUnknown(data['principal']!, _principalMeta),
      );
    } else if (isInserting) {
      context.missing(_principalMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('duration_months')) {
      context.handle(
        _durationMonthsMeta,
        durationMonths.isAcceptableOrUnknown(
          data['duration_months']!,
          _durationMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMonthsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoansTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lender'],
      )!,
      principal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}principal'],
      )!,
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      durationMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_months'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $LoansTableTable createAlias(String alias) {
    return $LoansTableTable(attachedDatabase, alias);
  }
}

class LoansTableData extends DataClass implements Insertable<LoansTableData> {
  final int id;
  final String lender;
  final double principal;
  final double interestRate;
  final DateTime startDate;
  final int durationMonths;
  final bool active;
  const LoansTableData({
    required this.id,
    required this.lender,
    required this.principal,
    required this.interestRate,
    required this.startDate,
    required this.durationMonths,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lender'] = Variable<String>(lender);
    map['principal'] = Variable<double>(principal);
    map['interest_rate'] = Variable<double>(interestRate);
    map['start_date'] = Variable<DateTime>(startDate);
    map['duration_months'] = Variable<int>(durationMonths);
    map['active'] = Variable<bool>(active);
    return map;
  }

  LoansTableCompanion toCompanion(bool nullToAbsent) {
    return LoansTableCompanion(
      id: Value(id),
      lender: Value(lender),
      principal: Value(principal),
      interestRate: Value(interestRate),
      startDate: Value(startDate),
      durationMonths: Value(durationMonths),
      active: Value(active),
    );
  }

  factory LoansTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoansTableData(
      id: serializer.fromJson<int>(json['id']),
      lender: serializer.fromJson<String>(json['lender']),
      principal: serializer.fromJson<double>(json['principal']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      durationMonths: serializer.fromJson<int>(json['durationMonths']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lender': serializer.toJson<String>(lender),
      'principal': serializer.toJson<double>(principal),
      'interestRate': serializer.toJson<double>(interestRate),
      'startDate': serializer.toJson<DateTime>(startDate),
      'durationMonths': serializer.toJson<int>(durationMonths),
      'active': serializer.toJson<bool>(active),
    };
  }

  LoansTableData copyWith({
    int? id,
    String? lender,
    double? principal,
    double? interestRate,
    DateTime? startDate,
    int? durationMonths,
    bool? active,
  }) => LoansTableData(
    id: id ?? this.id,
    lender: lender ?? this.lender,
    principal: principal ?? this.principal,
    interestRate: interestRate ?? this.interestRate,
    startDate: startDate ?? this.startDate,
    durationMonths: durationMonths ?? this.durationMonths,
    active: active ?? this.active,
  );
  LoansTableData copyWithCompanion(LoansTableCompanion data) {
    return LoansTableData(
      id: data.id.present ? data.id.value : this.id,
      lender: data.lender.present ? data.lender.value : this.lender,
      principal: data.principal.present ? data.principal.value : this.principal,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      durationMonths: data.durationMonths.present
          ? data.durationMonths.value
          : this.durationMonths,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableData(')
          ..write('id: $id, ')
          ..write('lender: $lender, ')
          ..write('principal: $principal, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lender,
    principal,
    interestRate,
    startDate,
    durationMonths,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoansTableData &&
          other.id == this.id &&
          other.lender == this.lender &&
          other.principal == this.principal &&
          other.interestRate == this.interestRate &&
          other.startDate == this.startDate &&
          other.durationMonths == this.durationMonths &&
          other.active == this.active);
}

class LoansTableCompanion extends UpdateCompanion<LoansTableData> {
  final Value<int> id;
  final Value<String> lender;
  final Value<double> principal;
  final Value<double> interestRate;
  final Value<DateTime> startDate;
  final Value<int> durationMonths;
  final Value<bool> active;
  const LoansTableCompanion({
    this.id = const Value.absent(),
    this.lender = const Value.absent(),
    this.principal = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.durationMonths = const Value.absent(),
    this.active = const Value.absent(),
  });
  LoansTableCompanion.insert({
    this.id = const Value.absent(),
    required String lender,
    required double principal,
    required double interestRate,
    required DateTime startDate,
    required int durationMonths,
    this.active = const Value.absent(),
  }) : lender = Value(lender),
       principal = Value(principal),
       interestRate = Value(interestRate),
       startDate = Value(startDate),
       durationMonths = Value(durationMonths);
  static Insertable<LoansTableData> custom({
    Expression<int>? id,
    Expression<String>? lender,
    Expression<double>? principal,
    Expression<double>? interestRate,
    Expression<DateTime>? startDate,
    Expression<int>? durationMonths,
    Expression<bool>? active,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lender != null) 'lender': lender,
      if (principal != null) 'principal': principal,
      if (interestRate != null) 'interest_rate': interestRate,
      if (startDate != null) 'start_date': startDate,
      if (durationMonths != null) 'duration_months': durationMonths,
      if (active != null) 'active': active,
    });
  }

  LoansTableCompanion copyWith({
    Value<int>? id,
    Value<String>? lender,
    Value<double>? principal,
    Value<double>? interestRate,
    Value<DateTime>? startDate,
    Value<int>? durationMonths,
    Value<bool>? active,
  }) {
    return LoansTableCompanion(
      id: id ?? this.id,
      lender: lender ?? this.lender,
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      startDate: startDate ?? this.startDate,
      durationMonths: durationMonths ?? this.durationMonths,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lender.present) {
      map['lender'] = Variable<String>(lender.value);
    }
    if (principal.present) {
      map['principal'] = Variable<double>(principal.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (durationMonths.present) {
      map['duration_months'] = Variable<int>(durationMonths.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansTableCompanion(')
          ..write('id: $id, ')
          ..write('lender: $lender, ')
          ..write('principal: $principal, ')
          ..write('interestRate: $interestRate, ')
          ..write('startDate: $startDate, ')
          ..write('durationMonths: $durationMonths, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }
}

class $TransactionGroupsTableTable extends TransactionGroupsTable
    with TableInfo<$TransactionGroupsTableTable, TransactionGroupsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionGroupsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_groups_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionGroupsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionGroupsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionGroupsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionGroupsTableTable createAlias(String alias) {
    return $TransactionGroupsTableTable(attachedDatabase, alias);
  }
}

class TransactionGroupsTableData extends DataClass
    implements Insertable<TransactionGroupsTableData> {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  const TransactionGroupsTableData({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionGroupsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionGroupsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionGroupsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionGroupsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionGroupsTableData copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) => TransactionGroupsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionGroupsTableData copyWithCompanion(
    TransactionGroupsTableCompanion data,
  ) {
    return TransactionGroupsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionGroupsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionGroupsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class TransactionGroupsTableCompanion
    extends UpdateCompanion<TransactionGroupsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> createdAt;
  const TransactionGroupsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionGroupsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required DateTime createdAt,
  }) : name = Value(name),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<TransactionGroupsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionGroupsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<DateTime>? createdAt,
  }) {
    return TransactionGroupsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionGroupsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $BudgetMonthSnapshotsTableTable extends BudgetMonthSnapshotsTable
    with
        TableInfo<
          $BudgetMonthSnapshotsTableTable,
          BudgetMonthSnapshotsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetMonthSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, spentAmount, month];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_month_snapshots_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetMonthSnapshotsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spentAmountMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetMonthSnapshotsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetMonthSnapshotsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_amount'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
    );
  }

  @override
  $BudgetMonthSnapshotsTableTable createAlias(String alias) {
    return $BudgetMonthSnapshotsTableTable(attachedDatabase, alias);
  }
}

class BudgetMonthSnapshotsTableData extends DataClass
    implements Insertable<BudgetMonthSnapshotsTableData> {
  final int id;
  final int budgetId;
  final double spentAmount;
  final String month;
  const BudgetMonthSnapshotsTableData({
    required this.id,
    required this.budgetId,
    required this.spentAmount,
    required this.month,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['spent_amount'] = Variable<double>(spentAmount);
    map['month'] = Variable<String>(month);
    return map;
  }

  BudgetMonthSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetMonthSnapshotsTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      spentAmount: Value(spentAmount),
      month: Value(month),
    );
  }

  factory BudgetMonthSnapshotsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetMonthSnapshotsTableData(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
      month: serializer.fromJson<String>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'spentAmount': serializer.toJson<double>(spentAmount),
      'month': serializer.toJson<String>(month),
    };
  }

  BudgetMonthSnapshotsTableData copyWith({
    int? id,
    int? budgetId,
    double? spentAmount,
    String? month,
  }) => BudgetMonthSnapshotsTableData(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    spentAmount: spentAmount ?? this.spentAmount,
    month: month ?? this.month,
  );
  BudgetMonthSnapshotsTableData copyWithCompanion(
    BudgetMonthSnapshotsTableCompanion data,
  ) {
    return BudgetMonthSnapshotsTableData(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMonthSnapshotsTableData(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, spentAmount, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetMonthSnapshotsTableData &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.spentAmount == this.spentAmount &&
          other.month == this.month);
}

class BudgetMonthSnapshotsTableCompanion
    extends UpdateCompanion<BudgetMonthSnapshotsTableData> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<double> spentAmount;
  final Value<String> month;
  const BudgetMonthSnapshotsTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.month = const Value.absent(),
  });
  BudgetMonthSnapshotsTableCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required double spentAmount,
    required String month,
  }) : budgetId = Value(budgetId),
       spentAmount = Value(spentAmount),
       month = Value(month);
  static Insertable<BudgetMonthSnapshotsTableData> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<double>? spentAmount,
    Expression<String>? month,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (month != null) 'month': month,
    });
  }

  BudgetMonthSnapshotsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? budgetId,
    Value<double>? spentAmount,
    Value<String>? month,
  }) {
    return BudgetMonthSnapshotsTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      spentAmount: spentAmount ?? this.spentAmount,
      month: month ?? this.month,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMonthSnapshotsTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoryMonthSnapshotsTableTable
    extends BudgetCategoryMonthSnapshotsTable
    with
        TableInfo<
          $BudgetCategoryMonthSnapshotsTableTable,
          BudgetCategoryMonthSnapshotsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoryMonthSnapshotsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<double> spentAmount = GeneratedColumn<double>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    category,
    spentAmount,
    month,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_category_month_snapshots_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategoryMonthSnapshotsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_spentAmountMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCategoryMonthSnapshotsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategoryMonthSnapshotsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent_amount'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
    );
  }

  @override
  $BudgetCategoryMonthSnapshotsTableTable createAlias(String alias) {
    return $BudgetCategoryMonthSnapshotsTableTable(attachedDatabase, alias);
  }
}

class BudgetCategoryMonthSnapshotsTableData extends DataClass
    implements Insertable<BudgetCategoryMonthSnapshotsTableData> {
  final int id;
  final int budgetId;
  final String category;
  final double spentAmount;
  final String month;
  const BudgetCategoryMonthSnapshotsTableData({
    required this.id,
    required this.budgetId,
    required this.category,
    required this.spentAmount,
    required this.month,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['category'] = Variable<String>(category);
    map['spent_amount'] = Variable<double>(spentAmount);
    map['month'] = Variable<String>(month);
    return map;
  }

  BudgetCategoryMonthSnapshotsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoryMonthSnapshotsTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      category: Value(category),
      spentAmount: Value(spentAmount),
      month: Value(month),
    );
  }

  factory BudgetCategoryMonthSnapshotsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategoryMonthSnapshotsTableData(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      category: serializer.fromJson<String>(json['category']),
      spentAmount: serializer.fromJson<double>(json['spentAmount']),
      month: serializer.fromJson<String>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'category': serializer.toJson<String>(category),
      'spentAmount': serializer.toJson<double>(spentAmount),
      'month': serializer.toJson<String>(month),
    };
  }

  BudgetCategoryMonthSnapshotsTableData copyWith({
    int? id,
    int? budgetId,
    String? category,
    double? spentAmount,
    String? month,
  }) => BudgetCategoryMonthSnapshotsTableData(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    category: category ?? this.category,
    spentAmount: spentAmount ?? this.spentAmount,
    month: month ?? this.month,
  );
  BudgetCategoryMonthSnapshotsTableData copyWithCompanion(
    BudgetCategoryMonthSnapshotsTableCompanion data,
  ) {
    return BudgetCategoryMonthSnapshotsTableData(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      category: data.category.present ? data.category.value : this.category,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoryMonthSnapshotsTableData(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('category: $category, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, category, spentAmount, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategoryMonthSnapshotsTableData &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.category == this.category &&
          other.spentAmount == this.spentAmount &&
          other.month == this.month);
}

class BudgetCategoryMonthSnapshotsTableCompanion
    extends UpdateCompanion<BudgetCategoryMonthSnapshotsTableData> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<String> category;
  final Value<double> spentAmount;
  final Value<String> month;
  const BudgetCategoryMonthSnapshotsTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.category = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.month = const Value.absent(),
  });
  BudgetCategoryMonthSnapshotsTableCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required String category,
    required double spentAmount,
    required String month,
  }) : budgetId = Value(budgetId),
       category = Value(category),
       spentAmount = Value(spentAmount),
       month = Value(month);
  static Insertable<BudgetCategoryMonthSnapshotsTableData> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<String>? category,
    Expression<double>? spentAmount,
    Expression<String>? month,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (category != null) 'category': category,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (month != null) 'month': month,
    });
  }

  BudgetCategoryMonthSnapshotsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? budgetId,
    Value<String>? category,
    Value<double>? spentAmount,
    Value<String>? month,
  }) {
    return BudgetCategoryMonthSnapshotsTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      category: category ?? this.category,
      spentAmount: spentAmount ?? this.spentAmount,
      month: month ?? this.month,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<double>(spentAmount.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoryMonthSnapshotsTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('category: $category, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTableTable extends BudgetCategoriesTable
    with TableInfo<$BudgetCategoriesTableTable, BudgetCategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _limitAmountMeta = const VerificationMeta(
    'limitAmount',
  );
  @override
  late final GeneratedColumn<double> limitAmount = GeneratedColumn<double>(
    'limit_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, category, limitAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('limit_amount')) {
      context.handle(
        _limitAmountMeta,
        limitAmount.isAcceptableOrUnknown(
          data['limit_amount']!,
          _limitAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_limitAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetCategoriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      limitAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}limit_amount'],
      )!,
    );
  }

  @override
  $BudgetCategoriesTableTable createAlias(String alias) {
    return $BudgetCategoriesTableTable(attachedDatabase, alias);
  }
}

class BudgetCategoriesTableData extends DataClass
    implements Insertable<BudgetCategoriesTableData> {
  final int id;
  final int budgetId;
  final String category;
  final double limitAmount;
  const BudgetCategoriesTableData({
    required this.id,
    required this.budgetId,
    required this.category,
    required this.limitAmount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<int>(budgetId);
    map['category'] = Variable<String>(category);
    map['limit_amount'] = Variable<double>(limitAmount);
    return map;
  }

  BudgetCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      category: Value(category),
      limitAmount: Value(limitAmount),
    );
  }

  factory BudgetCategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<int>(json['budgetId']),
      category: serializer.fromJson<String>(json['category']),
      limitAmount: serializer.fromJson<double>(json['limitAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<int>(budgetId),
      'category': serializer.toJson<String>(category),
      'limitAmount': serializer.toJson<double>(limitAmount),
    };
  }

  BudgetCategoriesTableData copyWith({
    int? id,
    int? budgetId,
    String? category,
    double? limitAmount,
  }) => BudgetCategoriesTableData(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    category: category ?? this.category,
    limitAmount: limitAmount ?? this.limitAmount,
  );
  BudgetCategoriesTableData copyWithCompanion(
    BudgetCategoriesTableCompanion data,
  ) {
    return BudgetCategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      category: data.category.present ? data.category.value : this.category,
      limitAmount: data.limitAmount.present
          ? data.limitAmount.value
          : this.limitAmount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesTableData(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, category, limitAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategoriesTableData &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.category == this.category &&
          other.limitAmount == this.limitAmount);
}

class BudgetCategoriesTableCompanion
    extends UpdateCompanion<BudgetCategoriesTableData> {
  final Value<int> id;
  final Value<int> budgetId;
  final Value<String> category;
  final Value<double> limitAmount;
  const BudgetCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.category = const Value.absent(),
    this.limitAmount = const Value.absent(),
  });
  BudgetCategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    required int budgetId,
    required String category,
    required double limitAmount,
  }) : budgetId = Value(budgetId),
       category = Value(category),
       limitAmount = Value(limitAmount);
  static Insertable<BudgetCategoriesTableData> custom({
    Expression<int>? id,
    Expression<int>? budgetId,
    Expression<String>? category,
    Expression<double>? limitAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (category != null) 'category': category,
      if (limitAmount != null) 'limit_amount': limitAmount,
    });
  }

  BudgetCategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? budgetId,
    Value<String>? category,
    Value<double>? limitAmount,
  }) {
    return BudgetCategoriesTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (limitAmount.present) {
      map['limit_amount'] = Variable<double>(limitAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('category: $category, ')
          ..write('limitAmount: $limitAmount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SmsMetadataTableTable smsMetadataTable = $SmsMetadataTableTable(
    this,
  );
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $SubscriptionsTableTable subscriptionsTable =
      $SubscriptionsTableTable(this);
  late final $FraudAlertsTableTable fraudAlertsTable = $FraudAlertsTableTable(
    this,
  );
  late final $AiInsightsTableTable aiInsightsTable = $AiInsightsTableTable(
    this,
  );
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $NotificationsTableTable notificationsTable =
      $NotificationsTableTable(this);
  late final $ExchangeRatesTableTable exchangeRatesTable =
      $ExchangeRatesTableTable(this);
  late final $ProfilesTableTable profilesTable = $ProfilesTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $CardsTableTable cardsTable = $CardsTableTable(this);
  late final $AccountBalancesTableTable accountBalancesTable =
      $AccountBalancesTableTable(this);
  late final $MerchantMappingsTableTable merchantMappingsTable =
      $MerchantMappingsTableTable(this);
  late final $UnrecognizedSmsTableTable unrecognizedSmsTable =
      $UnrecognizedSmsTableTable(this);
  late final $ChatMessagesTableTable chatMessagesTable =
      $ChatMessagesTableTable(this);
  late final $RulesTableTable rulesTable = $RulesTableTable(this);
  late final $RuleApplicationsTableTable ruleApplicationsTable =
      $RuleApplicationsTableTable(this);
  late final $TransactionSplitsTableTable transactionSplitsTable =
      $TransactionSplitsTableTable(this);
  late final $BankNotificationsTableTable bankNotificationsTable =
      $BankNotificationsTableTable(this);
  late final $LoansTableTable loansTable = $LoansTableTable(this);
  late final $TransactionGroupsTableTable transactionGroupsTable =
      $TransactionGroupsTableTable(this);
  late final $BudgetMonthSnapshotsTableTable budgetMonthSnapshotsTable =
      $BudgetMonthSnapshotsTableTable(this);
  late final $BudgetCategoryMonthSnapshotsTableTable
  budgetCategoryMonthSnapshotsTable = $BudgetCategoryMonthSnapshotsTableTable(
    this,
  );
  late final $BudgetCategoriesTableTable budgetCategoriesTable =
      $BudgetCategoriesTableTable(this);
  late final AccountBalanceDao accountBalanceDao = AccountBalanceDao(
    this as AppDatabase,
  );
  late final BudgetSnapshotDao budgetSnapshotDao = BudgetSnapshotDao(
    this as AppDatabase,
  );
  late final ChatDao chatDao = ChatDao(this as AppDatabase);
  late final MerchantMappingDao merchantMappingDao = MerchantMappingDao(
    this as AppDatabase,
  );
  late final RuleDao ruleDao = RuleDao(this as AppDatabase);
  late final TransactionGroupDao transactionGroupDao = TransactionGroupDao(
    this as AppDatabase,
  );
  late final BankNotificationDao bankNotificationDao = BankNotificationDao(
    this as AppDatabase,
  );
  late final CardDao cardDao = CardDao(this as AppDatabase);
  late final ExchangeRateDao exchangeRateDao = ExchangeRateDao(
    this as AppDatabase,
  );
  late final ProfileDao profileDao = ProfileDao(this as AppDatabase);
  late final SubscriptionDao subscriptionDao = SubscriptionDao(
    this as AppDatabase,
  );
  late final TransactionSplitDao transactionSplitDao = TransactionSplitDao(
    this as AppDatabase,
  );
  late final BudgetDao budgetDao = BudgetDao(this as AppDatabase);
  late final CategoryDao categoryDao = CategoryDao(this as AppDatabase);
  late final LoanDao loanDao = LoanDao(this as AppDatabase);
  late final RuleApplicationDao ruleApplicationDao = RuleApplicationDao(
    this as AppDatabase,
  );
  late final TransactionDao transactionDao = TransactionDao(
    this as AppDatabase,
  );
  late final UnrecognizedSmsDao unrecognizedSmsDao = UnrecognizedSmsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    smsMetadataTable,
    transactionsTable,
    budgetsTable,
    subscriptionsTable,
    fraudAlertsTable,
    aiInsightsTable,
    goalsTable,
    notificationsTable,
    exchangeRatesTable,
    profilesTable,
    categoriesTable,
    cardsTable,
    accountBalancesTable,
    merchantMappingsTable,
    unrecognizedSmsTable,
    chatMessagesTable,
    rulesTable,
    ruleApplicationsTable,
    transactionSplitsTable,
    bankNotificationsTable,
    loansTable,
    transactionGroupsTable,
    budgetMonthSnapshotsTable,
    budgetCategoryMonthSnapshotsTable,
    budgetCategoriesTable,
  ];
}

typedef $$SmsMetadataTableTableCreateCompanionBuilder =
    SmsMetadataTableCompanion Function({
      required String id,
      required String sender,
      required String body,
      required DateTime timestamp,
      Value<bool> isProcessed,
      required double confidence,
      Value<int> rowid,
    });
typedef $$SmsMetadataTableTableUpdateCompanionBuilder =
    SmsMetadataTableCompanion Function({
      Value<String> id,
      Value<String> sender,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<bool> isProcessed,
      Value<double> confidence,
      Value<int> rowid,
    });

final class $$SmsMetadataTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SmsMetadataTableTable,
          SmsMetadataTableData
        > {
  $$SmsMetadataTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'sms_metadata_table__id__transactions_table__sms_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.smsId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SmsMetadataTableTableFilterComposer
    extends Composer<_$AppDatabase, $SmsMetadataTableTable> {
  $$SmsMetadataTableTableFilterComposer({
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

  ColumnFilters<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.smsId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmsMetadataTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsMetadataTableTable> {
  $$SmsMetadataTableTableOrderingComposer({
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

  ColumnOrderings<String> get sender => $composableBuilder(
    column: $table.sender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmsMetadataTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsMetadataTableTable> {
  $$SmsMetadataTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => column,
  );

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.smsId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SmsMetadataTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmsMetadataTableTable,
          SmsMetadataTableData,
          $$SmsMetadataTableTableFilterComposer,
          $$SmsMetadataTableTableOrderingComposer,
          $$SmsMetadataTableTableAnnotationComposer,
          $$SmsMetadataTableTableCreateCompanionBuilder,
          $$SmsMetadataTableTableUpdateCompanionBuilder,
          (SmsMetadataTableData, $$SmsMetadataTableTableReferences),
          SmsMetadataTableData,
          PrefetchHooks Function({bool transactionsTableRefs})
        > {
  $$SmsMetadataTableTableTableManager(
    _$AppDatabase db,
    $SmsMetadataTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsMetadataTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsMetadataTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsMetadataTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sender = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
                Value<double> confidence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmsMetadataTableCompanion(
                id: id,
                sender: sender,
                body: body,
                timestamp: timestamp,
                isProcessed: isProcessed,
                confidence: confidence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sender,
                required String body,
                required DateTime timestamp,
                Value<bool> isProcessed = const Value.absent(),
                required double confidence,
                Value<int> rowid = const Value.absent(),
              }) => SmsMetadataTableCompanion.insert(
                id: id,
                sender: sender,
                body: body,
                timestamp: timestamp,
                isProcessed: isProcessed,
                confidence: confidence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmsMetadataTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsTableRefs) db.transactionsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsTableRefs)
                    await $_getPrefetchedData<
                      SmsMetadataTableData,
                      $SmsMetadataTableTable,
                      TransactionsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$SmsMetadataTableTableReferences
                          ._transactionsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SmsMetadataTableTableReferences(
                            db,
                            table,
                            p0,
                          ).transactionsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.smsId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SmsMetadataTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmsMetadataTableTable,
      SmsMetadataTableData,
      $$SmsMetadataTableTableFilterComposer,
      $$SmsMetadataTableTableOrderingComposer,
      $$SmsMetadataTableTableAnnotationComposer,
      $$SmsMetadataTableTableCreateCompanionBuilder,
      $$SmsMetadataTableTableUpdateCompanionBuilder,
      (SmsMetadataTableData, $$SmsMetadataTableTableReferences),
      SmsMetadataTableData,
      PrefetchHooks Function({bool transactionsTableRefs})
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      Value<String?> smsId,
      required double amount,
      required String merchant,
      required String category,
      required DateTime timestamp,
      required bool isIncome,
      required String accountSource,
      Value<String> currency,
      Value<String?> reference,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<String?> smsId,
      Value<double> amount,
      Value<String> merchant,
      Value<String> category,
      Value<DateTime> timestamp,
      Value<bool> isIncome,
      Value<String> accountSource,
      Value<String> currency,
      Value<String?> reference,
      Value<int> rowid,
    });

final class $$TransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        > {
  $$TransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SmsMetadataTableTable _smsIdTable(_$AppDatabase db) => db
      .smsMetadataTable
      .createAlias('transactions_table__sms_id__sms_metadata_table__id');

  $$SmsMetadataTableTableProcessedTableManager? get smsId {
    final $_column = $_itemColumn<String>('sms_id');
    if ($_column == null) return null;
    final manager = $$SmsMetadataTableTableTableManager(
      $_db,
      $_db.smsMetadataTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_smsIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FraudAlertsTableTable, List<FraudAlertsTableData>>
  _fraudAlertsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.fraudAlertsTable,
    aliasName: 'transactions_table__id__fraud_alerts_table__transaction_id',
  );

  $$FraudAlertsTableTableProcessedTableManager get fraudAlertsTableRefs {
    final manager = $$FraudAlertsTableTableTableManager(
      $_db,
      $_db.fraudAlertsTable,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _fraudAlertsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RuleApplicationsTableTable,
    List<RuleApplicationsTableData>
  >
  _ruleApplicationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ruleApplicationsTable,
        aliasName:
            'transactions_table__id__rule_applications_table__transaction_id',
      );

  $$RuleApplicationsTableTableProcessedTableManager
  get ruleApplicationsTableRefs {
    final manager = $$RuleApplicationsTableTableTableManager(
      $_db,
      $_db.ruleApplicationsTable,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ruleApplicationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
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

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountSource => $composableBuilder(
    column: $table.accountSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  $$SmsMetadataTableTableFilterComposer get smsId {
    final $$SmsMetadataTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsId,
      referencedTable: $db.smsMetadataTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsMetadataTableTableFilterComposer(
            $db: $db,
            $table: $db.smsMetadataTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> fraudAlertsTableRefs(
    Expression<bool> Function($$FraudAlertsTableTableFilterComposer f) f,
  ) {
    final $$FraudAlertsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fraudAlertsTable,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FraudAlertsTableTableFilterComposer(
            $db: $db,
            $table: $db.fraudAlertsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ruleApplicationsTableRefs(
    Expression<bool> Function($$RuleApplicationsTableTableFilterComposer f) f,
  ) {
    final $$RuleApplicationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ruleApplicationsTable,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RuleApplicationsTableTableFilterComposer(
                $db: $db,
                $table: $db.ruleApplicationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
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

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountSource => $composableBuilder(
    column: $table.accountSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  $$SmsMetadataTableTableOrderingComposer get smsId {
    final $$SmsMetadataTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsId,
      referencedTable: $db.smsMetadataTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsMetadataTableTableOrderingComposer(
            $db: $db,
            $table: $db.smsMetadataTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<String> get accountSource => $composableBuilder(
    column: $table.accountSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  $$SmsMetadataTableTableAnnotationComposer get smsId {
    final $$SmsMetadataTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smsId,
      referencedTable: $db.smsMetadataTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmsMetadataTableTableAnnotationComposer(
            $db: $db,
            $table: $db.smsMetadataTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> fraudAlertsTableRefs<T extends Object>(
    Expression<T> Function($$FraudAlertsTableTableAnnotationComposer a) f,
  ) {
    final $$FraudAlertsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fraudAlertsTable,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FraudAlertsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.fraudAlertsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ruleApplicationsTableRefs<T extends Object>(
    Expression<T> Function($$RuleApplicationsTableTableAnnotationComposer a) f,
  ) {
    final $$RuleApplicationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ruleApplicationsTable,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RuleApplicationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.ruleApplicationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (TransactionsTableData, $$TransactionsTableTableReferences),
          TransactionsTableData,
          PrefetchHooks Function({
            bool smsId,
            bool fraudAlertsTableRefs,
            bool ruleApplicationsTableRefs,
          })
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> smsId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
                Value<String> accountSource = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                smsId: smsId,
                amount: amount,
                merchant: merchant,
                category: category,
                timestamp: timestamp,
                isIncome: isIncome,
                accountSource: accountSource,
                currency: currency,
                reference: reference,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> smsId = const Value.absent(),
                required double amount,
                required String merchant,
                required String category,
                required DateTime timestamp,
                required bool isIncome,
                required String accountSource,
                Value<String> currency = const Value.absent(),
                Value<String?> reference = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                smsId: smsId,
                amount: amount,
                merchant: merchant,
                category: category,
                timestamp: timestamp,
                isIncome: isIncome,
                accountSource: accountSource,
                currency: currency,
                reference: reference,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                smsId = false,
                fraudAlertsTableRefs = false,
                ruleApplicationsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fraudAlertsTableRefs) db.fraudAlertsTable,
                    if (ruleApplicationsTableRefs) db.ruleApplicationsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (smsId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.smsId,
                                    referencedTable:
                                        $$TransactionsTableTableReferences
                                            ._smsIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableTableReferences
                                            ._smsIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fraudAlertsTableRefs)
                        await $_getPrefetchedData<
                          TransactionsTableData,
                          $TransactionsTableTable,
                          FraudAlertsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableTableReferences
                              ._fraudAlertsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).fraudAlertsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ruleApplicationsTableRefs)
                        await $_getPrefetchedData<
                          TransactionsTableData,
                          $TransactionsTableTable,
                          RuleApplicationsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableTableReferences
                              ._ruleApplicationsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).ruleApplicationsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (TransactionsTableData, $$TransactionsTableTableReferences),
      TransactionsTableData,
      PrefetchHooks Function({
        bool smsId,
        bool fraudAlertsTableRefs,
        bool ruleApplicationsTableRefs,
      })
    >;
typedef $$BudgetsTableTableCreateCompanionBuilder =
    BudgetsTableCompanion Function({
      required String id,
      required String category,
      required double limitAmount,
      required DateTime startDate,
      required DateTime endDate,
      Value<int> rowid,
    });
typedef $$BudgetsTableTableUpdateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<double> limitAmount,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> rowid,
    });

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);
}

class $$BudgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTableTable,
          BudgetsTableData,
          $$BudgetsTableTableFilterComposer,
          $$BudgetsTableTableOrderingComposer,
          $$BudgetsTableTableAnnotationComposer,
          $$BudgetsTableTableCreateCompanionBuilder,
          $$BudgetsTableTableUpdateCompanionBuilder,
          (
            BudgetsTableData,
            BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData>,
          ),
          BudgetsTableData,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> limitAmount = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion(
                id: id,
                category: category,
                limitAmount: limitAmount,
                startDate: startDate,
                endDate: endDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                required double limitAmount,
                required DateTime startDate,
                required DateTime endDate,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion.insert(
                id: id,
                category: category,
                limitAmount: limitAmount,
                startDate: startDate,
                endDate: endDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTableTable,
      BudgetsTableData,
      $$BudgetsTableTableFilterComposer,
      $$BudgetsTableTableOrderingComposer,
      $$BudgetsTableTableAnnotationComposer,
      $$BudgetsTableTableCreateCompanionBuilder,
      $$BudgetsTableTableUpdateCompanionBuilder,
      (
        BudgetsTableData,
        BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData>,
      ),
      BudgetsTableData,
      PrefetchHooks Function()
    >;
typedef $$SubscriptionsTableTableCreateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      required String id,
      required String merchant,
      required double amount,
      required String billingCycle,
      required DateTime nextBillingDate,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$SubscriptionsTableTableUpdateCompanionBuilder =
    SubscriptionsTableCompanion Function({
      Value<String> id,
      Value<String> merchant,
      Value<double> amount,
      Value<String> billingCycle,
      Value<DateTime> nextBillingDate,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$SubscriptionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableFilterComposer({
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

  ColumnFilters<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubscriptionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableOrderingComposer({
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

  ColumnOrderings<String> get merchant => $composableBuilder(
    column: $table.merchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscriptionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTableTable> {
  $$SubscriptionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get merchant =>
      $composableBuilder(column: $table.merchant, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
    column: $table.billingCycle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextBillingDate => $composableBuilder(
    column: $table.nextBillingDate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$SubscriptionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData,
          $$SubscriptionsTableTableFilterComposer,
          $$SubscriptionsTableTableOrderingComposer,
          $$SubscriptionsTableTableAnnotationComposer,
          $$SubscriptionsTableTableCreateCompanionBuilder,
          $$SubscriptionsTableTableUpdateCompanionBuilder,
          (
            SubscriptionsTableData,
            BaseReferences<
              _$AppDatabase,
              $SubscriptionsTableTable,
              SubscriptionsTableData
            >,
          ),
          SubscriptionsTableData,
          PrefetchHooks Function()
        > {
  $$SubscriptionsTableTableTableManager(
    _$AppDatabase db,
    $SubscriptionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> merchant = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> billingCycle = const Value.absent(),
                Value<DateTime> nextBillingDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion(
                id: id,
                merchant: merchant,
                amount: amount,
                billingCycle: billingCycle,
                nextBillingDate: nextBillingDate,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String merchant,
                required double amount,
                required String billingCycle,
                required DateTime nextBillingDate,
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubscriptionsTableCompanion.insert(
                id: id,
                merchant: merchant,
                amount: amount,
                billingCycle: billingCycle,
                nextBillingDate: nextBillingDate,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubscriptionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriptionsTableTable,
      SubscriptionsTableData,
      $$SubscriptionsTableTableFilterComposer,
      $$SubscriptionsTableTableOrderingComposer,
      $$SubscriptionsTableTableAnnotationComposer,
      $$SubscriptionsTableTableCreateCompanionBuilder,
      $$SubscriptionsTableTableUpdateCompanionBuilder,
      (
        SubscriptionsTableData,
        BaseReferences<
          _$AppDatabase,
          $SubscriptionsTableTable,
          SubscriptionsTableData
        >,
      ),
      SubscriptionsTableData,
      PrefetchHooks Function()
    >;
typedef $$FraudAlertsTableTableCreateCompanionBuilder =
    FraudAlertsTableCompanion Function({
      required String id,
      required String transactionId,
      required double riskScore,
      required String reason,
      required DateTime timestamp,
      Value<bool> isResolved,
      Value<int> rowid,
    });
typedef $$FraudAlertsTableTableUpdateCompanionBuilder =
    FraudAlertsTableCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<double> riskScore,
      Value<String> reason,
      Value<DateTime> timestamp,
      Value<bool> isResolved,
      Value<int> rowid,
    });

final class $$FraudAlertsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FraudAlertsTableTable,
          FraudAlertsTableData
        > {
  $$FraudAlertsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransactionsTableTable _transactionIdTable(_$AppDatabase db) =>
      db.transactionsTable.createAlias(
        'fraud_alerts_table__transaction_id__transactions_table__id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FraudAlertsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FraudAlertsTableTable> {
  $$FraudAlertsTableTableFilterComposer({
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

  ColumnFilters<double> get riskScore => $composableBuilder(
    column: $table.riskScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnFilters(column),
  );

  $$TransactionsTableTableFilterComposer get transactionId {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FraudAlertsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FraudAlertsTableTable> {
  $$FraudAlertsTableTableOrderingComposer({
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

  ColumnOrderings<double> get riskScore => $composableBuilder(
    column: $table.riskScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransactionsTableTableOrderingComposer get transactionId {
    final $$TransactionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FraudAlertsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FraudAlertsTableTable> {
  $$FraudAlertsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get riskScore =>
      $composableBuilder(column: $table.riskScore, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isResolved => $composableBuilder(
    column: $table.isResolved,
    builder: (column) => column,
  );

  $$TransactionsTableTableAnnotationComposer get transactionId {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.transactionId,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FraudAlertsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FraudAlertsTableTable,
          FraudAlertsTableData,
          $$FraudAlertsTableTableFilterComposer,
          $$FraudAlertsTableTableOrderingComposer,
          $$FraudAlertsTableTableAnnotationComposer,
          $$FraudAlertsTableTableCreateCompanionBuilder,
          $$FraudAlertsTableTableUpdateCompanionBuilder,
          (FraudAlertsTableData, $$FraudAlertsTableTableReferences),
          FraudAlertsTableData,
          PrefetchHooks Function({bool transactionId})
        > {
  $$FraudAlertsTableTableTableManager(
    _$AppDatabase db,
    $FraudAlertsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FraudAlertsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FraudAlertsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FraudAlertsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<double> riskScore = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isResolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FraudAlertsTableCompanion(
                id: id,
                transactionId: transactionId,
                riskScore: riskScore,
                reason: reason,
                timestamp: timestamp,
                isResolved: isResolved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                required double riskScore,
                required String reason,
                required DateTime timestamp,
                Value<bool> isResolved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FraudAlertsTableCompanion.insert(
                id: id,
                transactionId: transactionId,
                riskScore: riskScore,
                reason: reason,
                timestamp: timestamp,
                isResolved: isResolved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FraudAlertsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable:
                                    $$FraudAlertsTableTableReferences
                                        ._transactionIdTable(db),
                                referencedColumn:
                                    $$FraudAlertsTableTableReferences
                                        ._transactionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FraudAlertsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FraudAlertsTableTable,
      FraudAlertsTableData,
      $$FraudAlertsTableTableFilterComposer,
      $$FraudAlertsTableTableOrderingComposer,
      $$FraudAlertsTableTableAnnotationComposer,
      $$FraudAlertsTableTableCreateCompanionBuilder,
      $$FraudAlertsTableTableUpdateCompanionBuilder,
      (FraudAlertsTableData, $$FraudAlertsTableTableReferences),
      FraudAlertsTableData,
      PrefetchHooks Function({bool transactionId})
    >;
typedef $$AiInsightsTableTableCreateCompanionBuilder =
    AiInsightsTableCompanion Function({
      required String id,
      required String title,
      required String content,
      required DateTime timestamp,
      Value<bool> isDismissed,
      Value<int> rowid,
    });
typedef $$AiInsightsTableTableUpdateCompanionBuilder =
    AiInsightsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> timestamp,
      Value<bool> isDismissed,
      Value<int> rowid,
    });

class $$AiInsightsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiInsightsTableTable> {
  $$AiInsightsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiInsightsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiInsightsTableTable> {
  $$AiInsightsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiInsightsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiInsightsTableTable> {
  $$AiInsightsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );
}

class $$AiInsightsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiInsightsTableTable,
          AiInsightsTableData,
          $$AiInsightsTableTableFilterComposer,
          $$AiInsightsTableTableOrderingComposer,
          $$AiInsightsTableTableAnnotationComposer,
          $$AiInsightsTableTableCreateCompanionBuilder,
          $$AiInsightsTableTableUpdateCompanionBuilder,
          (
            AiInsightsTableData,
            BaseReferences<
              _$AppDatabase,
              $AiInsightsTableTable,
              AiInsightsTableData
            >,
          ),
          AiInsightsTableData,
          PrefetchHooks Function()
        > {
  $$AiInsightsTableTableTableManager(
    _$AppDatabase db,
    $AiInsightsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiInsightsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiInsightsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiInsightsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiInsightsTableCompanion(
                id: id,
                title: title,
                content: content,
                timestamp: timestamp,
                isDismissed: isDismissed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                required DateTime timestamp,
                Value<bool> isDismissed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiInsightsTableCompanion.insert(
                id: id,
                title: title,
                content: content,
                timestamp: timestamp,
                isDismissed: isDismissed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiInsightsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiInsightsTableTable,
      AiInsightsTableData,
      $$AiInsightsTableTableFilterComposer,
      $$AiInsightsTableTableOrderingComposer,
      $$AiInsightsTableTableAnnotationComposer,
      $$AiInsightsTableTableCreateCompanionBuilder,
      $$AiInsightsTableTableUpdateCompanionBuilder,
      (
        AiInsightsTableData,
        BaseReferences<
          _$AppDatabase,
          $AiInsightsTableTable,
          AiInsightsTableData
        >,
      ),
      AiInsightsTableData,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableTableCreateCompanionBuilder =
    GoalsTableCompanion Function({
      required String id,
      required String title,
      required double targetAmount,
      required double currentAmount,
      required DateTime targetDate,
      required String category,
      Value<int> rowid,
    });
typedef $$GoalsTableTableUpdateCompanionBuilder =
    GoalsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<double> targetAmount,
      Value<double> currentAmount,
      Value<DateTime> targetDate,
      Value<String> category,
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
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

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTableTable,
          GoalsTableData,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (
            GoalsTableData,
            BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>,
          ),
          GoalsTableData,
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
                Value<String> title = const Value.absent(),
                Value<double> targetAmount = const Value.absent(),
                Value<double> currentAmount = const Value.absent(),
                Value<DateTime> targetDate = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                title: title,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                category: category,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required double targetAmount,
                required double currentAmount,
                required DateTime targetDate,
                required String category,
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                title: title,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                category: category,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTableTable,
      GoalsTableData,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (
        GoalsTableData,
        BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData>,
      ),
      GoalsTableData,
      PrefetchHooks Function()
    >;
typedef $$NotificationsTableTableCreateCompanionBuilder =
    NotificationsTableCompanion Function({
      required String id,
      required String title,
      required String body,
      required DateTime timestamp,
      required String type,
      Value<bool> isRead,
      Value<int> rowid,
    });
typedef $$NotificationsTableTableUpdateCompanionBuilder =
    NotificationsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<String> type,
      Value<bool> isRead,
      Value<int> rowid,
    });

class $$NotificationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTableTable> {
  $$NotificationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$NotificationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationsTableTable,
          NotificationsTableData,
          $$NotificationsTableTableFilterComposer,
          $$NotificationsTableTableOrderingComposer,
          $$NotificationsTableTableAnnotationComposer,
          $$NotificationsTableTableCreateCompanionBuilder,
          $$NotificationsTableTableUpdateCompanionBuilder,
          (
            NotificationsTableData,
            BaseReferences<
              _$AppDatabase,
              $NotificationsTableTable,
              NotificationsTableData
            >,
          ),
          NotificationsTableData,
          PrefetchHooks Function()
        > {
  $$NotificationsTableTableTableManager(
    _$AppDatabase db,
    $NotificationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsTableCompanion(
                id: id,
                title: title,
                body: body,
                timestamp: timestamp,
                type: type,
                isRead: isRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String body,
                required DateTime timestamp,
                required String type,
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationsTableCompanion.insert(
                id: id,
                title: title,
                body: body,
                timestamp: timestamp,
                type: type,
                isRead: isRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationsTableTable,
      NotificationsTableData,
      $$NotificationsTableTableFilterComposer,
      $$NotificationsTableTableOrderingComposer,
      $$NotificationsTableTableAnnotationComposer,
      $$NotificationsTableTableCreateCompanionBuilder,
      $$NotificationsTableTableUpdateCompanionBuilder,
      (
        NotificationsTableData,
        BaseReferences<
          _$AppDatabase,
          $NotificationsTableTable,
          NotificationsTableData
        >,
      ),
      NotificationsTableData,
      PrefetchHooks Function()
    >;
typedef $$ExchangeRatesTableTableCreateCompanionBuilder =
    ExchangeRatesTableCompanion Function({
      required String id,
      required String fromCurrency,
      required String toCurrency,
      required double rate,
      required String provider,
      required DateTime updatedAt,
      required DateTime expiresAt,
      Value<bool> isCustomRate,
      Value<int> rowid,
    });
typedef $$ExchangeRatesTableTableUpdateCompanionBuilder =
    ExchangeRatesTableCompanion Function({
      Value<String> id,
      Value<String> fromCurrency,
      Value<String> toCurrency,
      Value<double> rate,
      Value<String> provider,
      Value<DateTime> updatedAt,
      Value<DateTime> expiresAt,
      Value<bool> isCustomRate,
      Value<int> rowid,
    });

class $$ExchangeRatesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableFilterComposer({
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

  ColumnFilters<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustomRate => $composableBuilder(
    column: $table.isCustomRate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExchangeRatesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableOrderingComposer({
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

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustomRate => $composableBuilder(
    column: $table.isCustomRate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExchangeRatesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTableTable> {
  $$ExchangeRatesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<bool> get isCustomRate => $composableBuilder(
    column: $table.isCustomRate,
    builder: (column) => column,
  );
}

class $$ExchangeRatesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExchangeRatesTableTable,
          ExchangeRatesTableData,
          $$ExchangeRatesTableTableFilterComposer,
          $$ExchangeRatesTableTableOrderingComposer,
          $$ExchangeRatesTableTableAnnotationComposer,
          $$ExchangeRatesTableTableCreateCompanionBuilder,
          $$ExchangeRatesTableTableUpdateCompanionBuilder,
          (
            ExchangeRatesTableData,
            BaseReferences<
              _$AppDatabase,
              $ExchangeRatesTableTable,
              ExchangeRatesTableData
            >,
          ),
          ExchangeRatesTableData,
          PrefetchHooks Function()
        > {
  $$ExchangeRatesTableTableTableManager(
    _$AppDatabase db,
    $ExchangeRatesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromCurrency = const Value.absent(),
                Value<String> toCurrency = const Value.absent(),
                Value<double> rate = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<bool> isCustomRate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesTableCompanion(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                provider: provider,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                isCustomRate: isCustomRate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromCurrency,
                required String toCurrency,
                required double rate,
                required String provider,
                required DateTime updatedAt,
                required DateTime expiresAt,
                Value<bool> isCustomRate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExchangeRatesTableCompanion.insert(
                id: id,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
                provider: provider,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                isCustomRate: isCustomRate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExchangeRatesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExchangeRatesTableTable,
      ExchangeRatesTableData,
      $$ExchangeRatesTableTableFilterComposer,
      $$ExchangeRatesTableTableOrderingComposer,
      $$ExchangeRatesTableTableAnnotationComposer,
      $$ExchangeRatesTableTableCreateCompanionBuilder,
      $$ExchangeRatesTableTableUpdateCompanionBuilder,
      (
        ExchangeRatesTableData,
        BaseReferences<
          _$AppDatabase,
          $ExchangeRatesTableTable,
          ExchangeRatesTableData
        >,
      ),
      ExchangeRatesTableData,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableTableCreateCompanionBuilder =
    ProfilesTableCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      required String color,
    });
typedef $$ProfilesTableTableUpdateCompanionBuilder =
    ProfilesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<String> color,
    });

class $$ProfilesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
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
}

class $$ProfilesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
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
}

class $$ProfilesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTableTable> {
  $$ProfilesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$ProfilesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTableTable,
          ProfilesTableData,
          $$ProfilesTableTableFilterComposer,
          $$ProfilesTableTableOrderingComposer,
          $$ProfilesTableTableAnnotationComposer,
          $$ProfilesTableTableCreateCompanionBuilder,
          $$ProfilesTableTableUpdateCompanionBuilder,
          (
            ProfilesTableData,
            BaseReferences<
              _$AppDatabase,
              $ProfilesTableTable,
              ProfilesTableData
            >,
          ),
          ProfilesTableData,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableTableManager(_$AppDatabase db, $ProfilesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
              }) => ProfilesTableCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                required String color,
              }) => ProfilesTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTableTable,
      ProfilesTableData,
      $$ProfilesTableTableFilterComposer,
      $$ProfilesTableTableOrderingComposer,
      $$ProfilesTableTableAnnotationComposer,
      $$ProfilesTableTableCreateCompanionBuilder,
      $$ProfilesTableTableUpdateCompanionBuilder,
      (
        ProfilesTableData,
        BaseReferences<_$AppDatabase, $ProfilesTableTable, ProfilesTableData>,
      ),
      ProfilesTableData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> isIncome,
      Value<int> displayOrder,
      Value<bool> isSystem,
      Value<String?> color,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isIncome,
      Value<int> displayOrder,
      Value<bool> isSystem,
      Value<String?> color,
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
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
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
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIncome => $composableBuilder(
    column: $table.isIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $CategoriesTableTable,
              CategoriesTableData
            >,
          ),
          CategoriesTableData,
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
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isIncome = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                isIncome: isIncome,
                displayOrder: displayOrder,
                isSystem: isSystem,
                color: color,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> isIncome = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<String?> color = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                isIncome: isIncome,
                displayOrder: displayOrder,
                isSystem: isSystem,
                color: color,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        >,
      ),
      CategoriesTableData,
      PrefetchHooks Function()
    >;
typedef $$CardsTableTableCreateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> id,
      required String bankName,
      required String cardLast4,
      Value<String?> accountLast4,
      required String cardType,
      Value<bool> isActive,
      Value<double?> creditLimit,
    });
typedef $$CardsTableTableUpdateCompanionBuilder =
    CardsTableCompanion Function({
      Value<int> id,
      Value<String> bankName,
      Value<String> cardLast4,
      Value<String?> accountLast4,
      Value<String> cardType,
      Value<bool> isActive,
      Value<double?> creditLimit,
    });

class $$CardsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardsTableTable> {
  $$CardsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get cardLast4 =>
      $composableBuilder(column: $table.cardLast4, builder: (column) => column);

  GeneratedColumn<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );
}

class $$CardsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardsTableTable,
          CardsTableData,
          $$CardsTableTableFilterComposer,
          $$CardsTableTableOrderingComposer,
          $$CardsTableTableAnnotationComposer,
          $$CardsTableTableCreateCompanionBuilder,
          $$CardsTableTableUpdateCompanionBuilder,
          (
            CardsTableData,
            BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>,
          ),
          CardsTableData,
          PrefetchHooks Function()
        > {
  $$CardsTableTableTableManager(_$AppDatabase db, $CardsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> cardLast4 = const Value.absent(),
                Value<String?> accountLast4 = const Value.absent(),
                Value<String> cardType = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
              }) => CardsTableCompanion(
                id: id,
                bankName: bankName,
                cardLast4: cardLast4,
                accountLast4: accountLast4,
                cardType: cardType,
                isActive: isActive,
                creditLimit: creditLimit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bankName,
                required String cardLast4,
                Value<String?> accountLast4 = const Value.absent(),
                required String cardType,
                Value<bool> isActive = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
              }) => CardsTableCompanion.insert(
                id: id,
                bankName: bankName,
                cardLast4: cardLast4,
                accountLast4: accountLast4,
                cardType: cardType,
                isActive: isActive,
                creditLimit: creditLimit,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardsTableTable,
      CardsTableData,
      $$CardsTableTableFilterComposer,
      $$CardsTableTableOrderingComposer,
      $$CardsTableTableAnnotationComposer,
      $$CardsTableTableCreateCompanionBuilder,
      $$CardsTableTableUpdateCompanionBuilder,
      (
        CardsTableData,
        BaseReferences<_$AppDatabase, $CardsTableTable, CardsTableData>,
      ),
      CardsTableData,
      PrefetchHooks Function()
    >;
typedef $$AccountBalancesTableTableCreateCompanionBuilder =
    AccountBalancesTableCompanion Function({
      Value<int> id,
      required String bankName,
      required String accountLast4,
      required double balance,
      required DateTime timestamp,
      Value<String?> transactionId,
      Value<DateTime> createdAt,
      Value<double?> creditLimit,
      Value<bool> isCreditCard,
      Value<String?> smsSource,
      Value<String?> sourceType,
      Value<String> currency,
      Value<int?> profileId,
      Value<String?> alias,
      Value<double?> lowBalanceThreshold,
    });
typedef $$AccountBalancesTableTableUpdateCompanionBuilder =
    AccountBalancesTableCompanion Function({
      Value<int> id,
      Value<String> bankName,
      Value<String> accountLast4,
      Value<double> balance,
      Value<DateTime> timestamp,
      Value<String?> transactionId,
      Value<DateTime> createdAt,
      Value<double?> creditLimit,
      Value<bool> isCreditCard,
      Value<String?> smsSource,
      Value<String?> sourceType,
      Value<String> currency,
      Value<int?> profileId,
      Value<String?> alias,
      Value<double?> lowBalanceThreshold,
    });

class $$AccountBalancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountBalancesTableTable> {
  $$AccountBalancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCreditCard => $composableBuilder(
    column: $table.isCreditCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsSource => $composableBuilder(
    column: $table.smsSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowBalanceThreshold => $composableBuilder(
    column: $table.lowBalanceThreshold,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountBalancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountBalancesTableTable> {
  $$AccountBalancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCreditCard => $composableBuilder(
    column: $table.isCreditCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsSource => $composableBuilder(
    column: $table.smsSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowBalanceThreshold => $composableBuilder(
    column: $table.lowBalanceThreshold,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountBalancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountBalancesTableTable> {
  $$AccountBalancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<String> get accountLast4 => $composableBuilder(
    column: $table.accountLast4,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCreditCard => $composableBuilder(
    column: $table.isCreditCard,
    builder: (column) => column,
  );

  GeneratedColumn<String> get smsSource =>
      $composableBuilder(column: $table.smsSource, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<double> get lowBalanceThreshold => $composableBuilder(
    column: $table.lowBalanceThreshold,
    builder: (column) => column,
  );
}

class $$AccountBalancesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountBalancesTableTable,
          AccountBalancesTableData,
          $$AccountBalancesTableTableFilterComposer,
          $$AccountBalancesTableTableOrderingComposer,
          $$AccountBalancesTableTableAnnotationComposer,
          $$AccountBalancesTableTableCreateCompanionBuilder,
          $$AccountBalancesTableTableUpdateCompanionBuilder,
          (
            AccountBalancesTableData,
            BaseReferences<
              _$AppDatabase,
              $AccountBalancesTableTable,
              AccountBalancesTableData
            >,
          ),
          AccountBalancesTableData,
          PrefetchHooks Function()
        > {
  $$AccountBalancesTableTableTableManager(
    _$AppDatabase db,
    $AccountBalancesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountBalancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountBalancesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AccountBalancesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> bankName = const Value.absent(),
                Value<String> accountLast4 = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<bool> isCreditCard = const Value.absent(),
                Value<String?> smsSource = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> profileId = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<double?> lowBalanceThreshold = const Value.absent(),
              }) => AccountBalancesTableCompanion(
                id: id,
                bankName: bankName,
                accountLast4: accountLast4,
                balance: balance,
                timestamp: timestamp,
                transactionId: transactionId,
                createdAt: createdAt,
                creditLimit: creditLimit,
                isCreditCard: isCreditCard,
                smsSource: smsSource,
                sourceType: sourceType,
                currency: currency,
                profileId: profileId,
                alias: alias,
                lowBalanceThreshold: lowBalanceThreshold,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String bankName,
                required String accountLast4,
                required double balance,
                required DateTime timestamp,
                Value<String?> transactionId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<bool> isCreditCard = const Value.absent(),
                Value<String?> smsSource = const Value.absent(),
                Value<String?> sourceType = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> profileId = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<double?> lowBalanceThreshold = const Value.absent(),
              }) => AccountBalancesTableCompanion.insert(
                id: id,
                bankName: bankName,
                accountLast4: accountLast4,
                balance: balance,
                timestamp: timestamp,
                transactionId: transactionId,
                createdAt: createdAt,
                creditLimit: creditLimit,
                isCreditCard: isCreditCard,
                smsSource: smsSource,
                sourceType: sourceType,
                currency: currency,
                profileId: profileId,
                alias: alias,
                lowBalanceThreshold: lowBalanceThreshold,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountBalancesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountBalancesTableTable,
      AccountBalancesTableData,
      $$AccountBalancesTableTableFilterComposer,
      $$AccountBalancesTableTableOrderingComposer,
      $$AccountBalancesTableTableAnnotationComposer,
      $$AccountBalancesTableTableCreateCompanionBuilder,
      $$AccountBalancesTableTableUpdateCompanionBuilder,
      (
        AccountBalancesTableData,
        BaseReferences<
          _$AppDatabase,
          $AccountBalancesTableTable,
          AccountBalancesTableData
        >,
      ),
      AccountBalancesTableData,
      PrefetchHooks Function()
    >;
typedef $$MerchantMappingsTableTableCreateCompanionBuilder =
    MerchantMappingsTableCompanion Function({
      Value<int> id,
      required String rawMerchant,
      required String cleanMerchant,
    });
typedef $$MerchantMappingsTableTableUpdateCompanionBuilder =
    MerchantMappingsTableCompanion Function({
      Value<int> id,
      Value<String> rawMerchant,
      Value<String> cleanMerchant,
    });

class $$MerchantMappingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTableTable> {
  $$MerchantMappingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawMerchant => $composableBuilder(
    column: $table.rawMerchant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cleanMerchant => $composableBuilder(
    column: $table.cleanMerchant,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MerchantMappingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTableTable> {
  $$MerchantMappingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawMerchant => $composableBuilder(
    column: $table.rawMerchant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cleanMerchant => $composableBuilder(
    column: $table.cleanMerchant,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MerchantMappingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MerchantMappingsTableTable> {
  $$MerchantMappingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rawMerchant => $composableBuilder(
    column: $table.rawMerchant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cleanMerchant => $composableBuilder(
    column: $table.cleanMerchant,
    builder: (column) => column,
  );
}

class $$MerchantMappingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MerchantMappingsTableTable,
          MerchantMappingsTableData,
          $$MerchantMappingsTableTableFilterComposer,
          $$MerchantMappingsTableTableOrderingComposer,
          $$MerchantMappingsTableTableAnnotationComposer,
          $$MerchantMappingsTableTableCreateCompanionBuilder,
          $$MerchantMappingsTableTableUpdateCompanionBuilder,
          (
            MerchantMappingsTableData,
            BaseReferences<
              _$AppDatabase,
              $MerchantMappingsTableTable,
              MerchantMappingsTableData
            >,
          ),
          MerchantMappingsTableData,
          PrefetchHooks Function()
        > {
  $$MerchantMappingsTableTableTableManager(
    _$AppDatabase db,
    $MerchantMappingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MerchantMappingsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MerchantMappingsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MerchantMappingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> rawMerchant = const Value.absent(),
                Value<String> cleanMerchant = const Value.absent(),
              }) => MerchantMappingsTableCompanion(
                id: id,
                rawMerchant: rawMerchant,
                cleanMerchant: cleanMerchant,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String rawMerchant,
                required String cleanMerchant,
              }) => MerchantMappingsTableCompanion.insert(
                id: id,
                rawMerchant: rawMerchant,
                cleanMerchant: cleanMerchant,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MerchantMappingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MerchantMappingsTableTable,
      MerchantMappingsTableData,
      $$MerchantMappingsTableTableFilterComposer,
      $$MerchantMappingsTableTableOrderingComposer,
      $$MerchantMappingsTableTableAnnotationComposer,
      $$MerchantMappingsTableTableCreateCompanionBuilder,
      $$MerchantMappingsTableTableUpdateCompanionBuilder,
      (
        MerchantMappingsTableData,
        BaseReferences<
          _$AppDatabase,
          $MerchantMappingsTableTable,
          MerchantMappingsTableData
        >,
      ),
      MerchantMappingsTableData,
      PrefetchHooks Function()
    >;
typedef $$UnrecognizedSmsTableTableCreateCompanionBuilder =
    UnrecognizedSmsTableCompanion Function({
      Value<int> id,
      required String smsId,
      required String body,
      required DateTime timestamp,
      required String reason,
    });
typedef $$UnrecognizedSmsTableTableUpdateCompanionBuilder =
    UnrecognizedSmsTableCompanion Function({
      Value<int> id,
      Value<String> smsId,
      Value<String> body,
      Value<DateTime> timestamp,
      Value<String> reason,
    });

class $$UnrecognizedSmsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsTableTable> {
  $$UnrecognizedSmsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smsId => $composableBuilder(
    column: $table.smsId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnrecognizedSmsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsTableTable> {
  $$UnrecognizedSmsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smsId => $composableBuilder(
    column: $table.smsId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnrecognizedSmsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnrecognizedSmsTableTable> {
  $$UnrecognizedSmsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get smsId =>
      $composableBuilder(column: $table.smsId, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$UnrecognizedSmsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnrecognizedSmsTableTable,
          UnrecognizedSmsTableData,
          $$UnrecognizedSmsTableTableFilterComposer,
          $$UnrecognizedSmsTableTableOrderingComposer,
          $$UnrecognizedSmsTableTableAnnotationComposer,
          $$UnrecognizedSmsTableTableCreateCompanionBuilder,
          $$UnrecognizedSmsTableTableUpdateCompanionBuilder,
          (
            UnrecognizedSmsTableData,
            BaseReferences<
              _$AppDatabase,
              $UnrecognizedSmsTableTable,
              UnrecognizedSmsTableData
            >,
          ),
          UnrecognizedSmsTableData,
          PrefetchHooks Function()
        > {
  $$UnrecognizedSmsTableTableTableManager(
    _$AppDatabase db,
    $UnrecognizedSmsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnrecognizedSmsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnrecognizedSmsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UnrecognizedSmsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> smsId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> reason = const Value.absent(),
              }) => UnrecognizedSmsTableCompanion(
                id: id,
                smsId: smsId,
                body: body,
                timestamp: timestamp,
                reason: reason,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String smsId,
                required String body,
                required DateTime timestamp,
                required String reason,
              }) => UnrecognizedSmsTableCompanion.insert(
                id: id,
                smsId: smsId,
                body: body,
                timestamp: timestamp,
                reason: reason,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnrecognizedSmsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnrecognizedSmsTableTable,
      UnrecognizedSmsTableData,
      $$UnrecognizedSmsTableTableFilterComposer,
      $$UnrecognizedSmsTableTableOrderingComposer,
      $$UnrecognizedSmsTableTableAnnotationComposer,
      $$UnrecognizedSmsTableTableCreateCompanionBuilder,
      $$UnrecognizedSmsTableTableUpdateCompanionBuilder,
      (
        UnrecognizedSmsTableData,
        BaseReferences<
          _$AppDatabase,
          $UnrecognizedSmsTableTable,
          UnrecognizedSmsTableData
        >,
      ),
      UnrecognizedSmsTableData,
      PrefetchHooks Function()
    >;
typedef $$ChatMessagesTableTableCreateCompanionBuilder =
    ChatMessagesTableCompanion Function({
      Value<int> id,
      required String role,
      required String content,
      required DateTime timestamp,
    });
typedef $$ChatMessagesTableTableUpdateCompanionBuilder =
    ChatMessagesTableCompanion Function({
      Value<int> id,
      Value<String> role,
      Value<String> content,
      Value<DateTime> timestamp,
    });

class $$ChatMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMessagesTableTable> {
  $$ChatMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ChatMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMessagesTableTable,
          ChatMessagesTableData,
          $$ChatMessagesTableTableFilterComposer,
          $$ChatMessagesTableTableOrderingComposer,
          $$ChatMessagesTableTableAnnotationComposer,
          $$ChatMessagesTableTableCreateCompanionBuilder,
          $$ChatMessagesTableTableUpdateCompanionBuilder,
          (
            ChatMessagesTableData,
            BaseReferences<
              _$AppDatabase,
              $ChatMessagesTableTable,
              ChatMessagesTableData
            >,
          ),
          ChatMessagesTableData,
          PrefetchHooks Function()
        > {
  $$ChatMessagesTableTableTableManager(
    _$AppDatabase db,
    $ChatMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMessagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMessagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ChatMessagesTableCompanion(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String role,
                required String content,
                required DateTime timestamp,
              }) => ChatMessagesTableCompanion.insert(
                id: id,
                role: role,
                content: content,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMessagesTableTable,
      ChatMessagesTableData,
      $$ChatMessagesTableTableFilterComposer,
      $$ChatMessagesTableTableOrderingComposer,
      $$ChatMessagesTableTableAnnotationComposer,
      $$ChatMessagesTableTableCreateCompanionBuilder,
      $$ChatMessagesTableTableUpdateCompanionBuilder,
      (
        ChatMessagesTableData,
        BaseReferences<
          _$AppDatabase,
          $ChatMessagesTableTable,
          ChatMessagesTableData
        >,
      ),
      ChatMessagesTableData,
      PrefetchHooks Function()
    >;
typedef $$RulesTableTableCreateCompanionBuilder =
    RulesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int> priority,
      required String conditions,
      required String actions,
      Value<bool> isActive,
      Value<bool> isSystemTemplate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$RulesTableTableUpdateCompanionBuilder =
    RulesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> priority,
      Value<String> conditions,
      Value<String> actions,
      Value<bool> isActive,
      Value<bool> isSystemTemplate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RulesTableTableReferences
    extends BaseReferences<_$AppDatabase, $RulesTableTable, RulesTableData> {
  $$RulesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $RuleApplicationsTableTable,
    List<RuleApplicationsTableData>
  >
  _ruleApplicationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.ruleApplicationsTable,
        aliasName: 'rules_table__id__rule_applications_table__rule_id',
      );

  $$RuleApplicationsTableTableProcessedTableManager
  get ruleApplicationsTableRefs {
    final manager = $$RuleApplicationsTableTableTableManager(
      $_db,
      $_db.ruleApplicationsTable,
    ).filter((f) => f.ruleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ruleApplicationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RulesTableTable> {
  $$RulesTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actions => $composableBuilder(
    column: $table.actions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemTemplate => $composableBuilder(
    column: $table.isSystemTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ruleApplicationsTableRefs(
    Expression<bool> Function($$RuleApplicationsTableTableFilterComposer f) f,
  ) {
    final $$RuleApplicationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ruleApplicationsTable,
          getReferencedColumn: (t) => t.ruleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RuleApplicationsTableTableFilterComposer(
                $db: $db,
                $table: $db.ruleApplicationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RulesTableTable> {
  $$RulesTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actions => $composableBuilder(
    column: $table.actions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemTemplate => $composableBuilder(
    column: $table.isSystemTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RulesTableTable> {
  $$RulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get conditions => $composableBuilder(
    column: $table.conditions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actions =>
      $composableBuilder(column: $table.actions, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSystemTemplate => $composableBuilder(
    column: $table.isSystemTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ruleApplicationsTableRefs<T extends Object>(
    Expression<T> Function($$RuleApplicationsTableTableAnnotationComposer a) f,
  ) {
    final $$RuleApplicationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ruleApplicationsTable,
          getReferencedColumn: (t) => t.ruleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RuleApplicationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.ruleApplicationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RulesTableTable,
          RulesTableData,
          $$RulesTableTableFilterComposer,
          $$RulesTableTableOrderingComposer,
          $$RulesTableTableAnnotationComposer,
          $$RulesTableTableCreateCompanionBuilder,
          $$RulesTableTableUpdateCompanionBuilder,
          (RulesTableData, $$RulesTableTableReferences),
          RulesTableData,
          PrefetchHooks Function({bool ruleApplicationsTableRefs})
        > {
  $$RulesTableTableTableManager(_$AppDatabase db, $RulesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RulesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String> conditions = const Value.absent(),
                Value<String> actions = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSystemTemplate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesTableCompanion(
                id: id,
                name: name,
                description: description,
                priority: priority,
                conditions: conditions,
                actions: actions,
                isActive: isActive,
                isSystemTemplate: isSystemTemplate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> priority = const Value.absent(),
                required String conditions,
                required String actions,
                Value<bool> isActive = const Value.absent(),
                Value<bool> isSystemTemplate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RulesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                priority: priority,
                conditions: conditions,
                actions: actions,
                isActive: isActive,
                isSystemTemplate: isSystemTemplate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ruleApplicationsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ruleApplicationsTableRefs) db.ruleApplicationsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ruleApplicationsTableRefs)
                    await $_getPrefetchedData<
                      RulesTableData,
                      $RulesTableTable,
                      RuleApplicationsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$RulesTableTableReferences
                          ._ruleApplicationsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RulesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).ruleApplicationsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ruleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RulesTableTable,
      RulesTableData,
      $$RulesTableTableFilterComposer,
      $$RulesTableTableOrderingComposer,
      $$RulesTableTableAnnotationComposer,
      $$RulesTableTableCreateCompanionBuilder,
      $$RulesTableTableUpdateCompanionBuilder,
      (RulesTableData, $$RulesTableTableReferences),
      RulesTableData,
      PrefetchHooks Function({bool ruleApplicationsTableRefs})
    >;
typedef $$RuleApplicationsTableTableCreateCompanionBuilder =
    RuleApplicationsTableCompanion Function({
      required String id,
      required String ruleId,
      required String ruleName,
      required String transactionId,
      required String fieldsModified,
      required DateTime appliedAt,
      Value<int> rowid,
    });
typedef $$RuleApplicationsTableTableUpdateCompanionBuilder =
    RuleApplicationsTableCompanion Function({
      Value<String> id,
      Value<String> ruleId,
      Value<String> ruleName,
      Value<String> transactionId,
      Value<String> fieldsModified,
      Value<DateTime> appliedAt,
      Value<int> rowid,
    });

final class $$RuleApplicationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RuleApplicationsTableTable,
          RuleApplicationsTableData
        > {
  $$RuleApplicationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RulesTableTable _ruleIdTable(_$AppDatabase db) => db.rulesTable
      .createAlias('rule_applications_table__rule_id__rules_table__id');

  $$RulesTableTableProcessedTableManager get ruleId {
    final $_column = $_itemColumn<String>('rule_id')!;

    final manager = $$RulesTableTableTableManager(
      $_db,
      $_db.rulesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTableTable _transactionIdTable(_$AppDatabase db) =>
      db.transactionsTable.createAlias(
        'rule_applications_table__transaction_id__transactions_table__id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RuleApplicationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RuleApplicationsTableTable> {
  $$RuleApplicationsTableTableFilterComposer({
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

  ColumnFilters<String> get ruleName => $composableBuilder(
    column: $table.ruleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldsModified => $composableBuilder(
    column: $table.fieldsModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RulesTableTableFilterComposer get ruleId {
    final $$RulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.rulesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RulesTableTableFilterComposer(
            $db: $db,
            $table: $db.rulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableFilterComposer get transactionId {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleApplicationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RuleApplicationsTableTable> {
  $$RuleApplicationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get ruleName => $composableBuilder(
    column: $table.ruleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldsModified => $composableBuilder(
    column: $table.fieldsModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RulesTableTableOrderingComposer get ruleId {
    final $$RulesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.rulesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RulesTableTableOrderingComposer(
            $db: $db,
            $table: $db.rulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableOrderingComposer get transactionId {
    final $$TransactionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RuleApplicationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RuleApplicationsTableTable> {
  $$RuleApplicationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleName =>
      $composableBuilder(column: $table.ruleName, builder: (column) => column);

  GeneratedColumn<String> get fieldsModified => $composableBuilder(
    column: $table.fieldsModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  $$RulesTableTableAnnotationComposer get ruleId {
    final $$RulesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.rulesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RulesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.rulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableAnnotationComposer get transactionId {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.transactionId,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RuleApplicationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RuleApplicationsTableTable,
          RuleApplicationsTableData,
          $$RuleApplicationsTableTableFilterComposer,
          $$RuleApplicationsTableTableOrderingComposer,
          $$RuleApplicationsTableTableAnnotationComposer,
          $$RuleApplicationsTableTableCreateCompanionBuilder,
          $$RuleApplicationsTableTableUpdateCompanionBuilder,
          (RuleApplicationsTableData, $$RuleApplicationsTableTableReferences),
          RuleApplicationsTableData,
          PrefetchHooks Function({bool ruleId, bool transactionId})
        > {
  $$RuleApplicationsTableTableTableManager(
    _$AppDatabase db,
    $RuleApplicationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RuleApplicationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RuleApplicationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RuleApplicationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ruleId = const Value.absent(),
                Value<String> ruleName = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> fieldsModified = const Value.absent(),
                Value<DateTime> appliedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RuleApplicationsTableCompanion(
                id: id,
                ruleId: ruleId,
                ruleName: ruleName,
                transactionId: transactionId,
                fieldsModified: fieldsModified,
                appliedAt: appliedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ruleId,
                required String ruleName,
                required String transactionId,
                required String fieldsModified,
                required DateTime appliedAt,
                Value<int> rowid = const Value.absent(),
              }) => RuleApplicationsTableCompanion.insert(
                id: id,
                ruleId: ruleId,
                ruleName: ruleName,
                transactionId: transactionId,
                fieldsModified: fieldsModified,
                appliedAt: appliedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RuleApplicationsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ruleId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ruleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ruleId,
                                referencedTable:
                                    $$RuleApplicationsTableTableReferences
                                        ._ruleIdTable(db),
                                referencedColumn:
                                    $$RuleApplicationsTableTableReferences
                                        ._ruleIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable:
                                    $$RuleApplicationsTableTableReferences
                                        ._transactionIdTable(db),
                                referencedColumn:
                                    $$RuleApplicationsTableTableReferences
                                        ._transactionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RuleApplicationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RuleApplicationsTableTable,
      RuleApplicationsTableData,
      $$RuleApplicationsTableTableFilterComposer,
      $$RuleApplicationsTableTableOrderingComposer,
      $$RuleApplicationsTableTableAnnotationComposer,
      $$RuleApplicationsTableTableCreateCompanionBuilder,
      $$RuleApplicationsTableTableUpdateCompanionBuilder,
      (RuleApplicationsTableData, $$RuleApplicationsTableTableReferences),
      RuleApplicationsTableData,
      PrefetchHooks Function({bool ruleId, bool transactionId})
    >;
typedef $$TransactionSplitsTableTableCreateCompanionBuilder =
    TransactionSplitsTableCompanion Function({
      Value<int> id,
      required String transactionId,
      required String category,
      required double amount,
      Value<String?> description,
    });
typedef $$TransactionSplitsTableTableUpdateCompanionBuilder =
    TransactionSplitsTableCompanion Function({
      Value<int> id,
      Value<String> transactionId,
      Value<String> category,
      Value<double> amount,
      Value<String?> description,
    });

class $$TransactionSplitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTableTable> {
  $$TransactionSplitsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionSplitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTableTable> {
  $$TransactionSplitsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionSplitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTableTable> {
  $$TransactionSplitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$TransactionSplitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSplitsTableTable,
          TransactionSplitsTableData,
          $$TransactionSplitsTableTableFilterComposer,
          $$TransactionSplitsTableTableOrderingComposer,
          $$TransactionSplitsTableTableAnnotationComposer,
          $$TransactionSplitsTableTableCreateCompanionBuilder,
          $$TransactionSplitsTableTableUpdateCompanionBuilder,
          (
            TransactionSplitsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransactionSplitsTableTable,
              TransactionSplitsTableData
            >,
          ),
          TransactionSplitsTableData,
          PrefetchHooks Function()
        > {
  $$TransactionSplitsTableTableTableManager(
    _$AppDatabase db,
    $TransactionSplitsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSplitsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionSplitsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionSplitsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => TransactionSplitsTableCompanion(
                id: id,
                transactionId: transactionId,
                category: category,
                amount: amount,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String transactionId,
                required String category,
                required double amount,
                Value<String?> description = const Value.absent(),
              }) => TransactionSplitsTableCompanion.insert(
                id: id,
                transactionId: transactionId,
                category: category,
                amount: amount,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionSplitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSplitsTableTable,
      TransactionSplitsTableData,
      $$TransactionSplitsTableTableFilterComposer,
      $$TransactionSplitsTableTableOrderingComposer,
      $$TransactionSplitsTableTableAnnotationComposer,
      $$TransactionSplitsTableTableCreateCompanionBuilder,
      $$TransactionSplitsTableTableUpdateCompanionBuilder,
      (
        TransactionSplitsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransactionSplitsTableTable,
          TransactionSplitsTableData
        >,
      ),
      TransactionSplitsTableData,
      PrefetchHooks Function()
    >;
typedef $$BankNotificationsTableTableCreateCompanionBuilder =
    BankNotificationsTableCompanion Function({
      Value<int> id,
      required String title,
      required String body,
      required DateTime timestamp,
    });
typedef $$BankNotificationsTableTableUpdateCompanionBuilder =
    BankNotificationsTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<DateTime> timestamp,
    });

class $$BankNotificationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BankNotificationsTableTable> {
  $$BankNotificationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BankNotificationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BankNotificationsTableTable> {
  $$BankNotificationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BankNotificationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BankNotificationsTableTable> {
  $$BankNotificationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$BankNotificationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BankNotificationsTableTable,
          BankNotificationsTableData,
          $$BankNotificationsTableTableFilterComposer,
          $$BankNotificationsTableTableOrderingComposer,
          $$BankNotificationsTableTableAnnotationComposer,
          $$BankNotificationsTableTableCreateCompanionBuilder,
          $$BankNotificationsTableTableUpdateCompanionBuilder,
          (
            BankNotificationsTableData,
            BaseReferences<
              _$AppDatabase,
              $BankNotificationsTableTable,
              BankNotificationsTableData
            >,
          ),
          BankNotificationsTableData,
          PrefetchHooks Function()
        > {
  $$BankNotificationsTableTableTableManager(
    _$AppDatabase db,
    $BankNotificationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BankNotificationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BankNotificationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BankNotificationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => BankNotificationsTableCompanion(
                id: id,
                title: title,
                body: body,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String body,
                required DateTime timestamp,
              }) => BankNotificationsTableCompanion.insert(
                id: id,
                title: title,
                body: body,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BankNotificationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BankNotificationsTableTable,
      BankNotificationsTableData,
      $$BankNotificationsTableTableFilterComposer,
      $$BankNotificationsTableTableOrderingComposer,
      $$BankNotificationsTableTableAnnotationComposer,
      $$BankNotificationsTableTableCreateCompanionBuilder,
      $$BankNotificationsTableTableUpdateCompanionBuilder,
      (
        BankNotificationsTableData,
        BaseReferences<
          _$AppDatabase,
          $BankNotificationsTableTable,
          BankNotificationsTableData
        >,
      ),
      BankNotificationsTableData,
      PrefetchHooks Function()
    >;
typedef $$LoansTableTableCreateCompanionBuilder =
    LoansTableCompanion Function({
      Value<int> id,
      required String lender,
      required double principal,
      required double interestRate,
      required DateTime startDate,
      required int durationMonths,
      Value<bool> active,
    });
typedef $$LoansTableTableUpdateCompanionBuilder =
    LoansTableCompanion Function({
      Value<int> id,
      Value<String> lender,
      Value<double> principal,
      Value<double> interestRate,
      Value<DateTime> startDate,
      Value<int> durationMonths,
      Value<bool> active,
    });

class $$LoansTableTableFilterComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get principal => $composableBuilder(
    column: $table.principal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LoansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lender => $composableBuilder(
    column: $table.lender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get principal => $composableBuilder(
    column: $table.principal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LoansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTableTable> {
  $$LoansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lender =>
      $composableBuilder(column: $table.lender, builder: (column) => column);

  GeneratedColumn<double> get principal =>
      $composableBuilder(column: $table.principal, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get durationMonths => $composableBuilder(
    column: $table.durationMonths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$LoansTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoansTableTable,
          LoansTableData,
          $$LoansTableTableFilterComposer,
          $$LoansTableTableOrderingComposer,
          $$LoansTableTableAnnotationComposer,
          $$LoansTableTableCreateCompanionBuilder,
          $$LoansTableTableUpdateCompanionBuilder,
          (
            LoansTableData,
            BaseReferences<_$AppDatabase, $LoansTableTable, LoansTableData>,
          ),
          LoansTableData,
          PrefetchHooks Function()
        > {
  $$LoansTableTableTableManager(_$AppDatabase db, $LoansTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> lender = const Value.absent(),
                Value<double> principal = const Value.absent(),
                Value<double> interestRate = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<int> durationMonths = const Value.absent(),
                Value<bool> active = const Value.absent(),
              }) => LoansTableCompanion(
                id: id,
                lender: lender,
                principal: principal,
                interestRate: interestRate,
                startDate: startDate,
                durationMonths: durationMonths,
                active: active,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lender,
                required double principal,
                required double interestRate,
                required DateTime startDate,
                required int durationMonths,
                Value<bool> active = const Value.absent(),
              }) => LoansTableCompanion.insert(
                id: id,
                lender: lender,
                principal: principal,
                interestRate: interestRate,
                startDate: startDate,
                durationMonths: durationMonths,
                active: active,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LoansTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoansTableTable,
      LoansTableData,
      $$LoansTableTableFilterComposer,
      $$LoansTableTableOrderingComposer,
      $$LoansTableTableAnnotationComposer,
      $$LoansTableTableCreateCompanionBuilder,
      $$LoansTableTableUpdateCompanionBuilder,
      (
        LoansTableData,
        BaseReferences<_$AppDatabase, $LoansTableTable, LoansTableData>,
      ),
      LoansTableData,
      PrefetchHooks Function()
    >;
typedef $$TransactionGroupsTableTableCreateCompanionBuilder =
    TransactionGroupsTableCompanion Function({
      Value<int> id,
      required String name,
      required String description,
      required DateTime createdAt,
    });
typedef $$TransactionGroupsTableTableUpdateCompanionBuilder =
    TransactionGroupsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<DateTime> createdAt,
    });

class $$TransactionGroupsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionGroupsTableTable> {
  $$TransactionGroupsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionGroupsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionGroupsTableTable> {
  $$TransactionGroupsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionGroupsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionGroupsTableTable> {
  $$TransactionGroupsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionGroupsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionGroupsTableTable,
          TransactionGroupsTableData,
          $$TransactionGroupsTableTableFilterComposer,
          $$TransactionGroupsTableTableOrderingComposer,
          $$TransactionGroupsTableTableAnnotationComposer,
          $$TransactionGroupsTableTableCreateCompanionBuilder,
          $$TransactionGroupsTableTableUpdateCompanionBuilder,
          (
            TransactionGroupsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransactionGroupsTableTable,
              TransactionGroupsTableData
            >,
          ),
          TransactionGroupsTableData,
          PrefetchHooks Function()
        > {
  $$TransactionGroupsTableTableTableManager(
    _$AppDatabase db,
    $TransactionGroupsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionGroupsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$TransactionGroupsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TransactionGroupsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionGroupsTableCompanion(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                required DateTime createdAt,
              }) => TransactionGroupsTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionGroupsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionGroupsTableTable,
      TransactionGroupsTableData,
      $$TransactionGroupsTableTableFilterComposer,
      $$TransactionGroupsTableTableOrderingComposer,
      $$TransactionGroupsTableTableAnnotationComposer,
      $$TransactionGroupsTableTableCreateCompanionBuilder,
      $$TransactionGroupsTableTableUpdateCompanionBuilder,
      (
        TransactionGroupsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransactionGroupsTableTable,
          TransactionGroupsTableData
        >,
      ),
      TransactionGroupsTableData,
      PrefetchHooks Function()
    >;
typedef $$BudgetMonthSnapshotsTableTableCreateCompanionBuilder =
    BudgetMonthSnapshotsTableCompanion Function({
      Value<int> id,
      required int budgetId,
      required double spentAmount,
      required String month,
    });
typedef $$BudgetMonthSnapshotsTableTableUpdateCompanionBuilder =
    BudgetMonthSnapshotsTableCompanion Function({
      Value<int> id,
      Value<int> budgetId,
      Value<double> spentAmount,
      Value<String> month,
    });

class $$BudgetMonthSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetMonthSnapshotsTableTable> {
  $$BudgetMonthSnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetMonthSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetMonthSnapshotsTableTable> {
  $$BudgetMonthSnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetMonthSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetMonthSnapshotsTableTable> {
  $$BudgetMonthSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);
}

class $$BudgetMonthSnapshotsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetMonthSnapshotsTableTable,
          BudgetMonthSnapshotsTableData,
          $$BudgetMonthSnapshotsTableTableFilterComposer,
          $$BudgetMonthSnapshotsTableTableOrderingComposer,
          $$BudgetMonthSnapshotsTableTableAnnotationComposer,
          $$BudgetMonthSnapshotsTableTableCreateCompanionBuilder,
          $$BudgetMonthSnapshotsTableTableUpdateCompanionBuilder,
          (
            BudgetMonthSnapshotsTableData,
            BaseReferences<
              _$AppDatabase,
              $BudgetMonthSnapshotsTableTable,
              BudgetMonthSnapshotsTableData
            >,
          ),
          BudgetMonthSnapshotsTableData,
          PrefetchHooks Function()
        > {
  $$BudgetMonthSnapshotsTableTableTableManager(
    _$AppDatabase db,
    $BudgetMonthSnapshotsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetMonthSnapshotsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BudgetMonthSnapshotsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetMonthSnapshotsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> budgetId = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> month = const Value.absent(),
              }) => BudgetMonthSnapshotsTableCompanion(
                id: id,
                budgetId: budgetId,
                spentAmount: spentAmount,
                month: month,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int budgetId,
                required double spentAmount,
                required String month,
              }) => BudgetMonthSnapshotsTableCompanion.insert(
                id: id,
                budgetId: budgetId,
                spentAmount: spentAmount,
                month: month,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetMonthSnapshotsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetMonthSnapshotsTableTable,
      BudgetMonthSnapshotsTableData,
      $$BudgetMonthSnapshotsTableTableFilterComposer,
      $$BudgetMonthSnapshotsTableTableOrderingComposer,
      $$BudgetMonthSnapshotsTableTableAnnotationComposer,
      $$BudgetMonthSnapshotsTableTableCreateCompanionBuilder,
      $$BudgetMonthSnapshotsTableTableUpdateCompanionBuilder,
      (
        BudgetMonthSnapshotsTableData,
        BaseReferences<
          _$AppDatabase,
          $BudgetMonthSnapshotsTableTable,
          BudgetMonthSnapshotsTableData
        >,
      ),
      BudgetMonthSnapshotsTableData,
      PrefetchHooks Function()
    >;
typedef $$BudgetCategoryMonthSnapshotsTableTableCreateCompanionBuilder =
    BudgetCategoryMonthSnapshotsTableCompanion Function({
      Value<int> id,
      required int budgetId,
      required String category,
      required double spentAmount,
      required String month,
    });
typedef $$BudgetCategoryMonthSnapshotsTableTableUpdateCompanionBuilder =
    BudgetCategoryMonthSnapshotsTableCompanion Function({
      Value<int> id,
      Value<int> budgetId,
      Value<String> category,
      Value<double> spentAmount,
      Value<String> month,
    });

class $$BudgetCategoryMonthSnapshotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoryMonthSnapshotsTableTable> {
  $$BudgetCategoryMonthSnapshotsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetCategoryMonthSnapshotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoryMonthSnapshotsTableTable> {
  $$BudgetCategoryMonthSnapshotsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCategoryMonthSnapshotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoryMonthSnapshotsTableTable> {
  $$BudgetCategoryMonthSnapshotsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);
}

class $$BudgetCategoryMonthSnapshotsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCategoryMonthSnapshotsTableTable,
          BudgetCategoryMonthSnapshotsTableData,
          $$BudgetCategoryMonthSnapshotsTableTableFilterComposer,
          $$BudgetCategoryMonthSnapshotsTableTableOrderingComposer,
          $$BudgetCategoryMonthSnapshotsTableTableAnnotationComposer,
          $$BudgetCategoryMonthSnapshotsTableTableCreateCompanionBuilder,
          $$BudgetCategoryMonthSnapshotsTableTableUpdateCompanionBuilder,
          (
            BudgetCategoryMonthSnapshotsTableData,
            BaseReferences<
              _$AppDatabase,
              $BudgetCategoryMonthSnapshotsTableTable,
              BudgetCategoryMonthSnapshotsTableData
            >,
          ),
          BudgetCategoryMonthSnapshotsTableData,
          PrefetchHooks Function()
        > {
  $$BudgetCategoryMonthSnapshotsTableTableTableManager(
    _$AppDatabase db,
    $BudgetCategoryMonthSnapshotsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoryMonthSnapshotsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BudgetCategoryMonthSnapshotsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetCategoryMonthSnapshotsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> budgetId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> spentAmount = const Value.absent(),
                Value<String> month = const Value.absent(),
              }) => BudgetCategoryMonthSnapshotsTableCompanion(
                id: id,
                budgetId: budgetId,
                category: category,
                spentAmount: spentAmount,
                month: month,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int budgetId,
                required String category,
                required double spentAmount,
                required String month,
              }) => BudgetCategoryMonthSnapshotsTableCompanion.insert(
                id: id,
                budgetId: budgetId,
                category: category,
                spentAmount: spentAmount,
                month: month,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetCategoryMonthSnapshotsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCategoryMonthSnapshotsTableTable,
      BudgetCategoryMonthSnapshotsTableData,
      $$BudgetCategoryMonthSnapshotsTableTableFilterComposer,
      $$BudgetCategoryMonthSnapshotsTableTableOrderingComposer,
      $$BudgetCategoryMonthSnapshotsTableTableAnnotationComposer,
      $$BudgetCategoryMonthSnapshotsTableTableCreateCompanionBuilder,
      $$BudgetCategoryMonthSnapshotsTableTableUpdateCompanionBuilder,
      (
        BudgetCategoryMonthSnapshotsTableData,
        BaseReferences<
          _$AppDatabase,
          $BudgetCategoryMonthSnapshotsTableTable,
          BudgetCategoryMonthSnapshotsTableData
        >,
      ),
      BudgetCategoryMonthSnapshotsTableData,
      PrefetchHooks Function()
    >;
typedef $$BudgetCategoriesTableTableCreateCompanionBuilder =
    BudgetCategoriesTableCompanion Function({
      Value<int> id,
      required int budgetId,
      required String category,
      required double limitAmount,
    });
typedef $$BudgetCategoriesTableTableUpdateCompanionBuilder =
    BudgetCategoriesTableCompanion Function({
      Value<int> id,
      Value<int> budgetId,
      Value<String> category,
      Value<double> limitAmount,
    });

class $$BudgetCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get limitAmount => $composableBuilder(
    column: $table.limitAmount,
    builder: (column) => column,
  );
}

class $$BudgetCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCategoriesTableTable,
          BudgetCategoriesTableData,
          $$BudgetCategoriesTableTableFilterComposer,
          $$BudgetCategoriesTableTableOrderingComposer,
          $$BudgetCategoriesTableTableAnnotationComposer,
          $$BudgetCategoriesTableTableCreateCompanionBuilder,
          $$BudgetCategoriesTableTableUpdateCompanionBuilder,
          (
            BudgetCategoriesTableData,
            BaseReferences<
              _$AppDatabase,
              $BudgetCategoriesTableTable,
              BudgetCategoriesTableData
            >,
          ),
          BudgetCategoriesTableData,
          PrefetchHooks Function()
        > {
  $$BudgetCategoriesTableTableTableManager(
    _$AppDatabase db,
    $BudgetCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BudgetCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> budgetId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> limitAmount = const Value.absent(),
              }) => BudgetCategoriesTableCompanion(
                id: id,
                budgetId: budgetId,
                category: category,
                limitAmount: limitAmount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int budgetId,
                required String category,
                required double limitAmount,
              }) => BudgetCategoriesTableCompanion.insert(
                id: id,
                budgetId: budgetId,
                category: category,
                limitAmount: limitAmount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCategoriesTableTable,
      BudgetCategoriesTableData,
      $$BudgetCategoriesTableTableFilterComposer,
      $$BudgetCategoriesTableTableOrderingComposer,
      $$BudgetCategoriesTableTableAnnotationComposer,
      $$BudgetCategoriesTableTableCreateCompanionBuilder,
      $$BudgetCategoriesTableTableUpdateCompanionBuilder,
      (
        BudgetCategoriesTableData,
        BaseReferences<
          _$AppDatabase,
          $BudgetCategoriesTableTable,
          BudgetCategoriesTableData
        >,
      ),
      BudgetCategoriesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SmsMetadataTableTableTableManager get smsMetadataTable =>
      $$SmsMetadataTableTableTableManager(_db, _db.smsMetadataTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$SubscriptionsTableTableTableManager get subscriptionsTable =>
      $$SubscriptionsTableTableTableManager(_db, _db.subscriptionsTable);
  $$FraudAlertsTableTableTableManager get fraudAlertsTable =>
      $$FraudAlertsTableTableTableManager(_db, _db.fraudAlertsTable);
  $$AiInsightsTableTableTableManager get aiInsightsTable =>
      $$AiInsightsTableTableTableManager(_db, _db.aiInsightsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$NotificationsTableTableTableManager get notificationsTable =>
      $$NotificationsTableTableTableManager(_db, _db.notificationsTable);
  $$ExchangeRatesTableTableTableManager get exchangeRatesTable =>
      $$ExchangeRatesTableTableTableManager(_db, _db.exchangeRatesTable);
  $$ProfilesTableTableTableManager get profilesTable =>
      $$ProfilesTableTableTableManager(_db, _db.profilesTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$CardsTableTableTableManager get cardsTable =>
      $$CardsTableTableTableManager(_db, _db.cardsTable);
  $$AccountBalancesTableTableTableManager get accountBalancesTable =>
      $$AccountBalancesTableTableTableManager(_db, _db.accountBalancesTable);
  $$MerchantMappingsTableTableTableManager get merchantMappingsTable =>
      $$MerchantMappingsTableTableTableManager(_db, _db.merchantMappingsTable);
  $$UnrecognizedSmsTableTableTableManager get unrecognizedSmsTable =>
      $$UnrecognizedSmsTableTableTableManager(_db, _db.unrecognizedSmsTable);
  $$ChatMessagesTableTableTableManager get chatMessagesTable =>
      $$ChatMessagesTableTableTableManager(_db, _db.chatMessagesTable);
  $$RulesTableTableTableManager get rulesTable =>
      $$RulesTableTableTableManager(_db, _db.rulesTable);
  $$RuleApplicationsTableTableTableManager get ruleApplicationsTable =>
      $$RuleApplicationsTableTableTableManager(_db, _db.ruleApplicationsTable);
  $$TransactionSplitsTableTableTableManager get transactionSplitsTable =>
      $$TransactionSplitsTableTableTableManager(
        _db,
        _db.transactionSplitsTable,
      );
  $$BankNotificationsTableTableTableManager get bankNotificationsTable =>
      $$BankNotificationsTableTableTableManager(
        _db,
        _db.bankNotificationsTable,
      );
  $$LoansTableTableTableManager get loansTable =>
      $$LoansTableTableTableManager(_db, _db.loansTable);
  $$TransactionGroupsTableTableTableManager get transactionGroupsTable =>
      $$TransactionGroupsTableTableTableManager(
        _db,
        _db.transactionGroupsTable,
      );
  $$BudgetMonthSnapshotsTableTableTableManager get budgetMonthSnapshotsTable =>
      $$BudgetMonthSnapshotsTableTableTableManager(
        _db,
        _db.budgetMonthSnapshotsTable,
      );
  $$BudgetCategoryMonthSnapshotsTableTableTableManager
  get budgetCategoryMonthSnapshotsTable =>
      $$BudgetCategoryMonthSnapshotsTableTableTableManager(
        _db,
        _db.budgetCategoryMonthSnapshotsTable,
      );
  $$BudgetCategoriesTableTableTableManager get budgetCategoriesTable =>
      $$BudgetCategoriesTableTableTableManager(_db, _db.budgetCategoriesTable);
}
