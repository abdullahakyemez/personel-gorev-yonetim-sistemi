// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PersonnelTableTable extends PersonnelTable
    with TableInfo<$PersonnelTableTable, PersonnelTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonnelTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _registryNumberMeta = const VerificationMeta(
    'registryNumber',
  );
  @override
  late final GeneratedColumn<String> registryNumber = GeneratedColumn<String>(
    'registry_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<String> rank = GeneratedColumn<String>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentMeta = const VerificationMeta(
    'department',
  );
  @override
  late final GeneratedColumn<String> department = GeneratedColumn<String>(
    'department',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onDutyMeta = const VerificationMeta('onDuty');
  @override
  late final GeneratedColumn<bool> onDuty = GeneratedColumn<bool>(
    'on_duty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_duty" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tcIdentityMeta = const VerificationMeta(
    'tcIdentity',
  );
  @override
  late final GeneratedColumn<String> tcIdentity = GeneratedColumn<String>(
    'tc_identity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profilePhotoMeta = const VerificationMeta(
    'profilePhoto',
  );
  @override
  late final GeneratedColumn<String> profilePhoto = GeneratedColumn<String>(
    'profile_photo',
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
    registryNumber,
    fullName,
    phone,
    rank,
    department,
    branch,
    onDuty,
    email,
    tcIdentity,
    title,
    profilePhoto,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personnel_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonnelTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('registry_number')) {
      context.handle(
        _registryNumberMeta,
        registryNumber.isAcceptableOrUnknown(
          data['registry_number']!,
          _registryNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registryNumberMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    } else if (isInserting) {
      context.missing(_branchMeta);
    }
    if (data.containsKey('on_duty')) {
      context.handle(
        _onDutyMeta,
        onDuty.isAcceptableOrUnknown(data['on_duty']!, _onDutyMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('tc_identity')) {
      context.handle(
        _tcIdentityMeta,
        tcIdentity.isAcceptableOrUnknown(data['tc_identity']!, _tcIdentityMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('profile_photo')) {
      context.handle(
        _profilePhotoMeta,
        profilePhoto.isAcceptableOrUnknown(
          data['profile_photo']!,
          _profilePhotoMeta,
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
  PersonnelTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonnelTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      registryNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registry_number'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      onDuty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_duty'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      tcIdentity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tc_identity'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      profilePhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_photo'],
      ),
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
  $PersonnelTableTable createAlias(String alias) {
    return $PersonnelTableTable(attachedDatabase, alias);
  }
}

class PersonnelTableData extends DataClass
    implements Insertable<PersonnelTableData> {
  final int id;
  final String registryNumber;
  final String fullName;
  final String phone;
  final String rank;
  final String department;
  final String branch;
  final bool onDuty;
  final String? email;
  final String? tcIdentity;
  final String? title;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PersonnelTableData({
    required this.id,
    required this.registryNumber,
    required this.fullName,
    required this.phone,
    required this.rank,
    required this.department,
    required this.branch,
    required this.onDuty,
    this.email,
    this.tcIdentity,
    this.title,
    this.profilePhoto,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['registry_number'] = Variable<String>(registryNumber);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    map['rank'] = Variable<String>(rank);
    map['department'] = Variable<String>(department);
    map['branch'] = Variable<String>(branch);
    map['on_duty'] = Variable<bool>(onDuty);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || tcIdentity != null) {
      map['tc_identity'] = Variable<String>(tcIdentity);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || profilePhoto != null) {
      map['profile_photo'] = Variable<String>(profilePhoto);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonnelTableCompanion toCompanion(bool nullToAbsent) {
    return PersonnelTableCompanion(
      id: Value(id),
      registryNumber: Value(registryNumber),
      fullName: Value(fullName),
      phone: Value(phone),
      rank: Value(rank),
      department: Value(department),
      branch: Value(branch),
      onDuty: Value(onDuty),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      tcIdentity: tcIdentity == null && nullToAbsent
          ? const Value.absent()
          : Value(tcIdentity),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      profilePhoto: profilePhoto == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhoto),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonnelTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonnelTableData(
      id: serializer.fromJson<int>(json['id']),
      registryNumber: serializer.fromJson<String>(json['registryNumber']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String>(json['phone']),
      rank: serializer.fromJson<String>(json['rank']),
      department: serializer.fromJson<String>(json['department']),
      branch: serializer.fromJson<String>(json['branch']),
      onDuty: serializer.fromJson<bool>(json['onDuty']),
      email: serializer.fromJson<String?>(json['email']),
      tcIdentity: serializer.fromJson<String?>(json['tcIdentity']),
      title: serializer.fromJson<String?>(json['title']),
      profilePhoto: serializer.fromJson<String?>(json['profilePhoto']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'registryNumber': serializer.toJson<String>(registryNumber),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String>(phone),
      'rank': serializer.toJson<String>(rank),
      'department': serializer.toJson<String>(department),
      'branch': serializer.toJson<String>(branch),
      'onDuty': serializer.toJson<bool>(onDuty),
      'email': serializer.toJson<String?>(email),
      'tcIdentity': serializer.toJson<String?>(tcIdentity),
      'title': serializer.toJson<String?>(title),
      'profilePhoto': serializer.toJson<String?>(profilePhoto),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonnelTableData copyWith({
    int? id,
    String? registryNumber,
    String? fullName,
    String? phone,
    String? rank,
    String? department,
    String? branch,
    bool? onDuty,
    Value<String?> email = const Value.absent(),
    Value<String?> tcIdentity = const Value.absent(),
    Value<String?> title = const Value.absent(),
    Value<String?> profilePhoto = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PersonnelTableData(
    id: id ?? this.id,
    registryNumber: registryNumber ?? this.registryNumber,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    rank: rank ?? this.rank,
    department: department ?? this.department,
    branch: branch ?? this.branch,
    onDuty: onDuty ?? this.onDuty,
    email: email.present ? email.value : this.email,
    tcIdentity: tcIdentity.present ? tcIdentity.value : this.tcIdentity,
    title: title.present ? title.value : this.title,
    profilePhoto: profilePhoto.present ? profilePhoto.value : this.profilePhoto,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PersonnelTableData copyWithCompanion(PersonnelTableCompanion data) {
    return PersonnelTableData(
      id: data.id.present ? data.id.value : this.id,
      registryNumber: data.registryNumber.present
          ? data.registryNumber.value
          : this.registryNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      rank: data.rank.present ? data.rank.value : this.rank,
      department: data.department.present
          ? data.department.value
          : this.department,
      branch: data.branch.present ? data.branch.value : this.branch,
      onDuty: data.onDuty.present ? data.onDuty.value : this.onDuty,
      email: data.email.present ? data.email.value : this.email,
      tcIdentity: data.tcIdentity.present
          ? data.tcIdentity.value
          : this.tcIdentity,
      title: data.title.present ? data.title.value : this.title,
      profilePhoto: data.profilePhoto.present
          ? data.profilePhoto.value
          : this.profilePhoto,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelTableData(')
          ..write('id: $id, ')
          ..write('registryNumber: $registryNumber, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('rank: $rank, ')
          ..write('department: $department, ')
          ..write('branch: $branch, ')
          ..write('onDuty: $onDuty, ')
          ..write('email: $email, ')
          ..write('tcIdentity: $tcIdentity, ')
          ..write('title: $title, ')
          ..write('profilePhoto: $profilePhoto, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    registryNumber,
    fullName,
    phone,
    rank,
    department,
    branch,
    onDuty,
    email,
    tcIdentity,
    title,
    profilePhoto,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonnelTableData &&
          other.id == this.id &&
          other.registryNumber == this.registryNumber &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.rank == this.rank &&
          other.department == this.department &&
          other.branch == this.branch &&
          other.onDuty == this.onDuty &&
          other.email == this.email &&
          other.tcIdentity == this.tcIdentity &&
          other.title == this.title &&
          other.profilePhoto == this.profilePhoto &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonnelTableCompanion extends UpdateCompanion<PersonnelTableData> {
  final Value<int> id;
  final Value<String> registryNumber;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String> rank;
  final Value<String> department;
  final Value<String> branch;
  final Value<bool> onDuty;
  final Value<String?> email;
  final Value<String?> tcIdentity;
  final Value<String?> title;
  final Value<String?> profilePhoto;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PersonnelTableCompanion({
    this.id = const Value.absent(),
    this.registryNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.rank = const Value.absent(),
    this.department = const Value.absent(),
    this.branch = const Value.absent(),
    this.onDuty = const Value.absent(),
    this.email = const Value.absent(),
    this.tcIdentity = const Value.absent(),
    this.title = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonnelTableCompanion.insert({
    this.id = const Value.absent(),
    required String registryNumber,
    required String fullName,
    required String phone,
    required String rank,
    required String department,
    required String branch,
    this.onDuty = const Value.absent(),
    this.email = const Value.absent(),
    this.tcIdentity = const Value.absent(),
    this.title = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : registryNumber = Value(registryNumber),
       fullName = Value(fullName),
       phone = Value(phone),
       rank = Value(rank),
       department = Value(department),
       branch = Value(branch);
  static Insertable<PersonnelTableData> custom({
    Expression<int>? id,
    Expression<String>? registryNumber,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? rank,
    Expression<String>? department,
    Expression<String>? branch,
    Expression<bool>? onDuty,
    Expression<String>? email,
    Expression<String>? tcIdentity,
    Expression<String>? title,
    Expression<String>? profilePhoto,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (registryNumber != null) 'registry_number': registryNumber,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (rank != null) 'rank': rank,
      if (department != null) 'department': department,
      if (branch != null) 'branch': branch,
      if (onDuty != null) 'on_duty': onDuty,
      if (email != null) 'email': email,
      if (tcIdentity != null) 'tc_identity': tcIdentity,
      if (title != null) 'title': title,
      if (profilePhoto != null) 'profile_photo': profilePhoto,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonnelTableCompanion copyWith({
    Value<int>? id,
    Value<String>? registryNumber,
    Value<String>? fullName,
    Value<String>? phone,
    Value<String>? rank,
    Value<String>? department,
    Value<String>? branch,
    Value<bool>? onDuty,
    Value<String?>? email,
    Value<String?>? tcIdentity,
    Value<String?>? title,
    Value<String?>? profilePhoto,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PersonnelTableCompanion(
      id: id ?? this.id,
      registryNumber: registryNumber ?? this.registryNumber,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      rank: rank ?? this.rank,
      department: department ?? this.department,
      branch: branch ?? this.branch,
      onDuty: onDuty ?? this.onDuty,
      email: email ?? this.email,
      tcIdentity: tcIdentity ?? this.tcIdentity,
      title: title ?? this.title,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (registryNumber.present) {
      map['registry_number'] = Variable<String>(registryNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (rank.present) {
      map['rank'] = Variable<String>(rank.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (onDuty.present) {
      map['on_duty'] = Variable<bool>(onDuty.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (tcIdentity.present) {
      map['tc_identity'] = Variable<String>(tcIdentity.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (profilePhoto.present) {
      map['profile_photo'] = Variable<String>(profilePhoto.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelTableCompanion(')
          ..write('id: $id, ')
          ..write('registryNumber: $registryNumber, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('rank: $rank, ')
          ..write('department: $department, ')
          ..write('branch: $branch, ')
          ..write('onDuty: $onDuty, ')
          ..write('email: $email, ')
          ..write('tcIdentity: $tcIdentity, ')
          ..write('title: $title, ')
          ..write('profilePhoto: $profilePhoto, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonnelTableTable personnelTable = $PersonnelTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [personnelTable];
}

typedef $$PersonnelTableTableCreateCompanionBuilder =
    PersonnelTableCompanion Function({
      Value<int> id,
      required String registryNumber,
      required String fullName,
      required String phone,
      required String rank,
      required String department,
      required String branch,
      Value<bool> onDuty,
      Value<String?> email,
      Value<String?> tcIdentity,
      Value<String?> title,
      Value<String?> profilePhoto,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PersonnelTableTableUpdateCompanionBuilder =
    PersonnelTableCompanion Function({
      Value<int> id,
      Value<String> registryNumber,
      Value<String> fullName,
      Value<String> phone,
      Value<String> rank,
      Value<String> department,
      Value<String> branch,
      Value<bool> onDuty,
      Value<String?> email,
      Value<String?> tcIdentity,
      Value<String?> title,
      Value<String?> profilePhoto,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$PersonnelTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonnelTableTable> {
  $$PersonnelTableTableFilterComposer({
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

  ColumnFilters<String> get registryNumber => $composableBuilder(
    column: $table.registryNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onDuty => $composableBuilder(
    column: $table.onDuty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tcIdentity => $composableBuilder(
    column: $table.tcIdentity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePhoto => $composableBuilder(
    column: $table.profilePhoto,
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
}

class $$PersonnelTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonnelTableTable> {
  $$PersonnelTableTableOrderingComposer({
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

  ColumnOrderings<String> get registryNumber => $composableBuilder(
    column: $table.registryNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onDuty => $composableBuilder(
    column: $table.onDuty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tcIdentity => $composableBuilder(
    column: $table.tcIdentity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePhoto => $composableBuilder(
    column: $table.profilePhoto,
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

class $$PersonnelTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonnelTableTable> {
  $$PersonnelTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get registryNumber => $composableBuilder(
    column: $table.registryNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<bool> get onDuty =>
      $composableBuilder(column: $table.onDuty, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get tcIdentity => $composableBuilder(
    column: $table.tcIdentity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get profilePhoto => $composableBuilder(
    column: $table.profilePhoto,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PersonnelTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonnelTableTable,
          PersonnelTableData,
          $$PersonnelTableTableFilterComposer,
          $$PersonnelTableTableOrderingComposer,
          $$PersonnelTableTableAnnotationComposer,
          $$PersonnelTableTableCreateCompanionBuilder,
          $$PersonnelTableTableUpdateCompanionBuilder,
          (
            PersonnelTableData,
            BaseReferences<
              _$AppDatabase,
              $PersonnelTableTable,
              PersonnelTableData
            >,
          ),
          PersonnelTableData,
          PrefetchHooks Function()
        > {
  $$PersonnelTableTableTableManager(
    _$AppDatabase db,
    $PersonnelTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonnelTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonnelTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonnelTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> registryNumber = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<bool> onDuty = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> tcIdentity = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> profilePhoto = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelTableCompanion(
                id: id,
                registryNumber: registryNumber,
                fullName: fullName,
                phone: phone,
                rank: rank,
                department: department,
                branch: branch,
                onDuty: onDuty,
                email: email,
                tcIdentity: tcIdentity,
                title: title,
                profilePhoto: profilePhoto,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String registryNumber,
                required String fullName,
                required String phone,
                required String rank,
                required String department,
                required String branch,
                Value<bool> onDuty = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> tcIdentity = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> profilePhoto = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelTableCompanion.insert(
                id: id,
                registryNumber: registryNumber,
                fullName: fullName,
                phone: phone,
                rank: rank,
                department: department,
                branch: branch,
                onDuty: onDuty,
                email: email,
                tcIdentity: tcIdentity,
                title: title,
                profilePhoto: profilePhoto,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonnelTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonnelTableTable,
      PersonnelTableData,
      $$PersonnelTableTableFilterComposer,
      $$PersonnelTableTableOrderingComposer,
      $$PersonnelTableTableAnnotationComposer,
      $$PersonnelTableTableCreateCompanionBuilder,
      $$PersonnelTableTableUpdateCompanionBuilder,
      (
        PersonnelTableData,
        BaseReferences<_$AppDatabase, $PersonnelTableTable, PersonnelTableData>,
      ),
      PersonnelTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonnelTableTableTableManager get personnelTable =>
      $$PersonnelTableTableTableManager(_db, _db.personnelTable);
}
