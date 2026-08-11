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
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<String> rank = GeneratedColumn<String>(
    'rank',
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
  static const VerificationMeta _branchMeta = const VerificationMeta('branch');
  @override
  late final GeneratedColumn<String> branch = GeneratedColumn<String>(
    'branch',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bloodTypeMeta = const VerificationMeta(
    'bloodType',
  );
  @override
  late final GeneratedColumn<String> bloodType = GeneratedColumn<String>(
    'blood_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relativeNameMeta = const VerificationMeta(
    'relativeName',
  );
  @override
  late final GeneratedColumn<String> relativeName = GeneratedColumn<String>(
    'relative_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relativePhoneMeta = const VerificationMeta(
    'relativePhone',
  );
  @override
  late final GeneratedColumn<String> relativePhone = GeneratedColumn<String>(
    'relative_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workScheduleTypeMeta = const VerificationMeta(
    'workScheduleType',
  );
  @override
  late final GeneratedColumn<String> workScheduleType = GeneratedColumn<String>(
    'work_schedule_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workScheduleDutyDaysMeta =
      const VerificationMeta('workScheduleDutyDays');
  @override
  late final GeneratedColumn<int> workScheduleDutyDays = GeneratedColumn<int>(
    'work_schedule_duty_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workScheduleRestDaysMeta =
      const VerificationMeta('workScheduleRestDays');
  @override
  late final GeneratedColumn<int> workScheduleRestDays = GeneratedColumn<int>(
    'work_schedule_rest_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _workScheduleStartDateMeta =
      const VerificationMeta('workScheduleStartDate');
  @override
  late final GeneratedColumn<DateTime> workScheduleStartDate =
      GeneratedColumn<DateTime>(
        'work_schedule_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('duty'),
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
    rank,
    title,
    branch,
    department,
    startDate,
    endDate,
    phone,
    email,
    address,
    bloodType,
    relativeName,
    relativePhone,
    workScheduleType,
    workScheduleDutyDays,
    workScheduleRestDays,
    workScheduleStartDate,
    status,
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
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('branch')) {
      context.handle(
        _branchMeta,
        branch.isAcceptableOrUnknown(data['branch']!, _branchMeta),
      );
    } else if (isInserting) {
      context.missing(_branchMeta);
    }
    if (data.containsKey('department')) {
      context.handle(
        _departmentMeta,
        department.isAcceptableOrUnknown(data['department']!, _departmentMeta),
      );
    } else if (isInserting) {
      context.missing(_departmentMeta);
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
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('blood_type')) {
      context.handle(
        _bloodTypeMeta,
        bloodType.isAcceptableOrUnknown(data['blood_type']!, _bloodTypeMeta),
      );
    }
    if (data.containsKey('relative_name')) {
      context.handle(
        _relativeNameMeta,
        relativeName.isAcceptableOrUnknown(
          data['relative_name']!,
          _relativeNameMeta,
        ),
      );
    }
    if (data.containsKey('relative_phone')) {
      context.handle(
        _relativePhoneMeta,
        relativePhone.isAcceptableOrUnknown(
          data['relative_phone']!,
          _relativePhoneMeta,
        ),
      );
    }
    if (data.containsKey('work_schedule_type')) {
      context.handle(
        _workScheduleTypeMeta,
        workScheduleType.isAcceptableOrUnknown(
          data['work_schedule_type']!,
          _workScheduleTypeMeta,
        ),
      );
    }
    if (data.containsKey('work_schedule_duty_days')) {
      context.handle(
        _workScheduleDutyDaysMeta,
        workScheduleDutyDays.isAcceptableOrUnknown(
          data['work_schedule_duty_days']!,
          _workScheduleDutyDaysMeta,
        ),
      );
    }
    if (data.containsKey('work_schedule_rest_days')) {
      context.handle(
        _workScheduleRestDaysMeta,
        workScheduleRestDays.isAcceptableOrUnknown(
          data['work_schedule_rest_days']!,
          _workScheduleRestDaysMeta,
        ),
      );
    }
    if (data.containsKey('work_schedule_start_date')) {
      context.handle(
        _workScheduleStartDateMeta,
        workScheduleStartDate.isAcceptableOrUnknown(
          data['work_schedule_start_date']!,
          _workScheduleStartDateMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      branch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}branch'],
      )!,
      department: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      bloodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blood_type'],
      ),
      relativeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_name'],
      ),
      relativePhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relative_phone'],
      ),
      workScheduleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_schedule_type'],
      ),
      workScheduleDutyDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_schedule_duty_days'],
      ),
      workScheduleRestDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}work_schedule_rest_days'],
      ),
      workScheduleStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}work_schedule_start_date'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
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
  final String rank;
  final String title;
  final String branch;
  final String department;
  final DateTime startDate;
  final DateTime? endDate;
  final String phone;
  final String email;
  final String address;
  final String? bloodType;
  final String? relativeName;
  final String? relativePhone;
  final String? workScheduleType;
  final int? workScheduleDutyDays;
  final int? workScheduleRestDays;
  final DateTime? workScheduleStartDate;
  final String status;
  final String? profilePhoto;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PersonnelTableData({
    required this.id,
    required this.registryNumber,
    required this.fullName,
    required this.rank,
    required this.title,
    required this.branch,
    required this.department,
    required this.startDate,
    this.endDate,
    required this.phone,
    required this.email,
    required this.address,
    this.bloodType,
    this.relativeName,
    this.relativePhone,
    this.workScheduleType,
    this.workScheduleDutyDays,
    this.workScheduleRestDays,
    this.workScheduleStartDate,
    required this.status,
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
    map['rank'] = Variable<String>(rank);
    map['title'] = Variable<String>(title);
    map['branch'] = Variable<String>(branch);
    map['department'] = Variable<String>(department);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || bloodType != null) {
      map['blood_type'] = Variable<String>(bloodType);
    }
    if (!nullToAbsent || relativeName != null) {
      map['relative_name'] = Variable<String>(relativeName);
    }
    if (!nullToAbsent || relativePhone != null) {
      map['relative_phone'] = Variable<String>(relativePhone);
    }
    if (!nullToAbsent || workScheduleType != null) {
      map['work_schedule_type'] = Variable<String>(workScheduleType);
    }
    if (!nullToAbsent || workScheduleDutyDays != null) {
      map['work_schedule_duty_days'] = Variable<int>(workScheduleDutyDays);
    }
    if (!nullToAbsent || workScheduleRestDays != null) {
      map['work_schedule_rest_days'] = Variable<int>(workScheduleRestDays);
    }
    if (!nullToAbsent || workScheduleStartDate != null) {
      map['work_schedule_start_date'] = Variable<DateTime>(
        workScheduleStartDate,
      );
    }
    map['status'] = Variable<String>(status);
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
      rank: Value(rank),
      title: Value(title),
      branch: Value(branch),
      department: Value(department),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      phone: Value(phone),
      email: Value(email),
      address: Value(address),
      bloodType: bloodType == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodType),
      relativeName: relativeName == null && nullToAbsent
          ? const Value.absent()
          : Value(relativeName),
      relativePhone: relativePhone == null && nullToAbsent
          ? const Value.absent()
          : Value(relativePhone),
      workScheduleType: workScheduleType == null && nullToAbsent
          ? const Value.absent()
          : Value(workScheduleType),
      workScheduleDutyDays: workScheduleDutyDays == null && nullToAbsent
          ? const Value.absent()
          : Value(workScheduleDutyDays),
      workScheduleRestDays: workScheduleRestDays == null && nullToAbsent
          ? const Value.absent()
          : Value(workScheduleRestDays),
      workScheduleStartDate: workScheduleStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(workScheduleStartDate),
      status: Value(status),
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
      rank: serializer.fromJson<String>(json['rank']),
      title: serializer.fromJson<String>(json['title']),
      branch: serializer.fromJson<String>(json['branch']),
      department: serializer.fromJson<String>(json['department']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      address: serializer.fromJson<String>(json['address']),
      bloodType: serializer.fromJson<String?>(json['bloodType']),
      relativeName: serializer.fromJson<String?>(json['relativeName']),
      relativePhone: serializer.fromJson<String?>(json['relativePhone']),
      workScheduleType: serializer.fromJson<String?>(json['workScheduleType']),
      workScheduleDutyDays: serializer.fromJson<int?>(
        json['workScheduleDutyDays'],
      ),
      workScheduleRestDays: serializer.fromJson<int?>(
        json['workScheduleRestDays'],
      ),
      workScheduleStartDate: serializer.fromJson<DateTime?>(
        json['workScheduleStartDate'],
      ),
      status: serializer.fromJson<String>(json['status']),
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
      'rank': serializer.toJson<String>(rank),
      'title': serializer.toJson<String>(title),
      'branch': serializer.toJson<String>(branch),
      'department': serializer.toJson<String>(department),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'address': serializer.toJson<String>(address),
      'bloodType': serializer.toJson<String?>(bloodType),
      'relativeName': serializer.toJson<String?>(relativeName),
      'relativePhone': serializer.toJson<String?>(relativePhone),
      'workScheduleType': serializer.toJson<String?>(workScheduleType),
      'workScheduleDutyDays': serializer.toJson<int?>(workScheduleDutyDays),
      'workScheduleRestDays': serializer.toJson<int?>(workScheduleRestDays),
      'workScheduleStartDate': serializer.toJson<DateTime?>(
        workScheduleStartDate,
      ),
      'status': serializer.toJson<String>(status),
      'profilePhoto': serializer.toJson<String?>(profilePhoto),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonnelTableData copyWith({
    int? id,
    String? registryNumber,
    String? fullName,
    String? rank,
    String? title,
    String? branch,
    String? department,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    String? phone,
    String? email,
    String? address,
    Value<String?> bloodType = const Value.absent(),
    Value<String?> relativeName = const Value.absent(),
    Value<String?> relativePhone = const Value.absent(),
    Value<String?> workScheduleType = const Value.absent(),
    Value<int?> workScheduleDutyDays = const Value.absent(),
    Value<int?> workScheduleRestDays = const Value.absent(),
    Value<DateTime?> workScheduleStartDate = const Value.absent(),
    String? status,
    Value<String?> profilePhoto = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PersonnelTableData(
    id: id ?? this.id,
    registryNumber: registryNumber ?? this.registryNumber,
    fullName: fullName ?? this.fullName,
    rank: rank ?? this.rank,
    title: title ?? this.title,
    branch: branch ?? this.branch,
    department: department ?? this.department,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    bloodType: bloodType.present ? bloodType.value : this.bloodType,
    relativeName: relativeName.present ? relativeName.value : this.relativeName,
    relativePhone: relativePhone.present
        ? relativePhone.value
        : this.relativePhone,
    workScheduleType: workScheduleType.present
        ? workScheduleType.value
        : this.workScheduleType,
    workScheduleDutyDays: workScheduleDutyDays.present
        ? workScheduleDutyDays.value
        : this.workScheduleDutyDays,
    workScheduleRestDays: workScheduleRestDays.present
        ? workScheduleRestDays.value
        : this.workScheduleRestDays,
    workScheduleStartDate: workScheduleStartDate.present
        ? workScheduleStartDate.value
        : this.workScheduleStartDate,
    status: status ?? this.status,
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
      rank: data.rank.present ? data.rank.value : this.rank,
      title: data.title.present ? data.title.value : this.title,
      branch: data.branch.present ? data.branch.value : this.branch,
      department: data.department.present
          ? data.department.value
          : this.department,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      bloodType: data.bloodType.present ? data.bloodType.value : this.bloodType,
      relativeName: data.relativeName.present
          ? data.relativeName.value
          : this.relativeName,
      relativePhone: data.relativePhone.present
          ? data.relativePhone.value
          : this.relativePhone,
      workScheduleType: data.workScheduleType.present
          ? data.workScheduleType.value
          : this.workScheduleType,
      workScheduleDutyDays: data.workScheduleDutyDays.present
          ? data.workScheduleDutyDays.value
          : this.workScheduleDutyDays,
      workScheduleRestDays: data.workScheduleRestDays.present
          ? data.workScheduleRestDays.value
          : this.workScheduleRestDays,
      workScheduleStartDate: data.workScheduleStartDate.present
          ? data.workScheduleStartDate.value
          : this.workScheduleStartDate,
      status: data.status.present ? data.status.value : this.status,
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
          ..write('rank: $rank, ')
          ..write('title: $title, ')
          ..write('branch: $branch, ')
          ..write('department: $department, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('bloodType: $bloodType, ')
          ..write('relativeName: $relativeName, ')
          ..write('relativePhone: $relativePhone, ')
          ..write('workScheduleType: $workScheduleType, ')
          ..write('workScheduleDutyDays: $workScheduleDutyDays, ')
          ..write('workScheduleRestDays: $workScheduleRestDays, ')
          ..write('workScheduleStartDate: $workScheduleStartDate, ')
          ..write('status: $status, ')
          ..write('profilePhoto: $profilePhoto, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    registryNumber,
    fullName,
    rank,
    title,
    branch,
    department,
    startDate,
    endDate,
    phone,
    email,
    address,
    bloodType,
    relativeName,
    relativePhone,
    workScheduleType,
    workScheduleDutyDays,
    workScheduleRestDays,
    workScheduleStartDate,
    status,
    profilePhoto,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonnelTableData &&
          other.id == this.id &&
          other.registryNumber == this.registryNumber &&
          other.fullName == this.fullName &&
          other.rank == this.rank &&
          other.title == this.title &&
          other.branch == this.branch &&
          other.department == this.department &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.bloodType == this.bloodType &&
          other.relativeName == this.relativeName &&
          other.relativePhone == this.relativePhone &&
          other.workScheduleType == this.workScheduleType &&
          other.workScheduleDutyDays == this.workScheduleDutyDays &&
          other.workScheduleRestDays == this.workScheduleRestDays &&
          other.workScheduleStartDate == this.workScheduleStartDate &&
          other.status == this.status &&
          other.profilePhoto == this.profilePhoto &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonnelTableCompanion extends UpdateCompanion<PersonnelTableData> {
  final Value<int> id;
  final Value<String> registryNumber;
  final Value<String> fullName;
  final Value<String> rank;
  final Value<String> title;
  final Value<String> branch;
  final Value<String> department;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> address;
  final Value<String?> bloodType;
  final Value<String?> relativeName;
  final Value<String?> relativePhone;
  final Value<String?> workScheduleType;
  final Value<int?> workScheduleDutyDays;
  final Value<int?> workScheduleRestDays;
  final Value<DateTime?> workScheduleStartDate;
  final Value<String> status;
  final Value<String?> profilePhoto;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PersonnelTableCompanion({
    this.id = const Value.absent(),
    this.registryNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.rank = const Value.absent(),
    this.title = const Value.absent(),
    this.branch = const Value.absent(),
    this.department = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.bloodType = const Value.absent(),
    this.relativeName = const Value.absent(),
    this.relativePhone = const Value.absent(),
    this.workScheduleType = const Value.absent(),
    this.workScheduleDutyDays = const Value.absent(),
    this.workScheduleRestDays = const Value.absent(),
    this.workScheduleStartDate = const Value.absent(),
    this.status = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonnelTableCompanion.insert({
    this.id = const Value.absent(),
    required String registryNumber,
    required String fullName,
    required String rank,
    required String title,
    required String branch,
    required String department,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required String phone,
    required String email,
    required String address,
    this.bloodType = const Value.absent(),
    this.relativeName = const Value.absent(),
    this.relativePhone = const Value.absent(),
    this.workScheduleType = const Value.absent(),
    this.workScheduleDutyDays = const Value.absent(),
    this.workScheduleRestDays = const Value.absent(),
    this.workScheduleStartDate = const Value.absent(),
    this.status = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : registryNumber = Value(registryNumber),
       fullName = Value(fullName),
       rank = Value(rank),
       title = Value(title),
       branch = Value(branch),
       department = Value(department),
       startDate = Value(startDate),
       phone = Value(phone),
       email = Value(email),
       address = Value(address);
  static Insertable<PersonnelTableData> custom({
    Expression<int>? id,
    Expression<String>? registryNumber,
    Expression<String>? fullName,
    Expression<String>? rank,
    Expression<String>? title,
    Expression<String>? branch,
    Expression<String>? department,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? bloodType,
    Expression<String>? relativeName,
    Expression<String>? relativePhone,
    Expression<String>? workScheduleType,
    Expression<int>? workScheduleDutyDays,
    Expression<int>? workScheduleRestDays,
    Expression<DateTime>? workScheduleStartDate,
    Expression<String>? status,
    Expression<String>? profilePhoto,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (registryNumber != null) 'registry_number': registryNumber,
      if (fullName != null) 'full_name': fullName,
      if (rank != null) 'rank': rank,
      if (title != null) 'title': title,
      if (branch != null) 'branch': branch,
      if (department != null) 'department': department,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (bloodType != null) 'blood_type': bloodType,
      if (relativeName != null) 'relative_name': relativeName,
      if (relativePhone != null) 'relative_phone': relativePhone,
      if (workScheduleType != null) 'work_schedule_type': workScheduleType,
      if (workScheduleDutyDays != null)
        'work_schedule_duty_days': workScheduleDutyDays,
      if (workScheduleRestDays != null)
        'work_schedule_rest_days': workScheduleRestDays,
      if (workScheduleStartDate != null)
        'work_schedule_start_date': workScheduleStartDate,
      if (status != null) 'status': status,
      if (profilePhoto != null) 'profile_photo': profilePhoto,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonnelTableCompanion copyWith({
    Value<int>? id,
    Value<String>? registryNumber,
    Value<String>? fullName,
    Value<String>? rank,
    Value<String>? title,
    Value<String>? branch,
    Value<String>? department,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? address,
    Value<String?>? bloodType,
    Value<String?>? relativeName,
    Value<String?>? relativePhone,
    Value<String?>? workScheduleType,
    Value<int?>? workScheduleDutyDays,
    Value<int?>? workScheduleRestDays,
    Value<DateTime?>? workScheduleStartDate,
    Value<String>? status,
    Value<String?>? profilePhoto,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PersonnelTableCompanion(
      id: id ?? this.id,
      registryNumber: registryNumber ?? this.registryNumber,
      fullName: fullName ?? this.fullName,
      rank: rank ?? this.rank,
      title: title ?? this.title,
      branch: branch ?? this.branch,
      department: department ?? this.department,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodType: bloodType ?? this.bloodType,
      relativeName: relativeName ?? this.relativeName,
      relativePhone: relativePhone ?? this.relativePhone,
      workScheduleType: workScheduleType ?? this.workScheduleType,
      workScheduleDutyDays: workScheduleDutyDays ?? this.workScheduleDutyDays,
      workScheduleRestDays: workScheduleRestDays ?? this.workScheduleRestDays,
      workScheduleStartDate:
          workScheduleStartDate ?? this.workScheduleStartDate,
      status: status ?? this.status,
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
    if (rank.present) {
      map['rank'] = Variable<String>(rank.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (branch.present) {
      map['branch'] = Variable<String>(branch.value);
    }
    if (department.present) {
      map['department'] = Variable<String>(department.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (bloodType.present) {
      map['blood_type'] = Variable<String>(bloodType.value);
    }
    if (relativeName.present) {
      map['relative_name'] = Variable<String>(relativeName.value);
    }
    if (relativePhone.present) {
      map['relative_phone'] = Variable<String>(relativePhone.value);
    }
    if (workScheduleType.present) {
      map['work_schedule_type'] = Variable<String>(workScheduleType.value);
    }
    if (workScheduleDutyDays.present) {
      map['work_schedule_duty_days'] = Variable<int>(
        workScheduleDutyDays.value,
      );
    }
    if (workScheduleRestDays.present) {
      map['work_schedule_rest_days'] = Variable<int>(
        workScheduleRestDays.value,
      );
    }
    if (workScheduleStartDate.present) {
      map['work_schedule_start_date'] = Variable<DateTime>(
        workScheduleStartDate.value,
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
          ..write('rank: $rank, ')
          ..write('title: $title, ')
          ..write('branch: $branch, ')
          ..write('department: $department, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('bloodType: $bloodType, ')
          ..write('relativeName: $relativeName, ')
          ..write('relativePhone: $relativePhone, ')
          ..write('workScheduleType: $workScheduleType, ')
          ..write('workScheduleDutyDays: $workScheduleDutyDays, ')
          ..write('workScheduleRestDays: $workScheduleRestDays, ')
          ..write('workScheduleStartDate: $workScheduleStartDate, ')
          ..write('status: $status, ')
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
      required String rank,
      required String title,
      required String branch,
      required String department,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required String phone,
      required String email,
      required String address,
      Value<String?> bloodType,
      Value<String?> relativeName,
      Value<String?> relativePhone,
      Value<String?> workScheduleType,
      Value<int?> workScheduleDutyDays,
      Value<int?> workScheduleRestDays,
      Value<DateTime?> workScheduleStartDate,
      Value<String> status,
      Value<String?> profilePhoto,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PersonnelTableTableUpdateCompanionBuilder =
    PersonnelTableCompanion Function({
      Value<int> id,
      Value<String> registryNumber,
      Value<String> fullName,
      Value<String> rank,
      Value<String> title,
      Value<String> branch,
      Value<String> department,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<String> phone,
      Value<String> email,
      Value<String> address,
      Value<String?> bloodType,
      Value<String?> relativeName,
      Value<String?> relativePhone,
      Value<String?> workScheduleType,
      Value<int?> workScheduleDutyDays,
      Value<int?> workScheduleRestDays,
      Value<DateTime?> workScheduleStartDate,
      Value<String> status,
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

  ColumnFilters<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get department => $composableBuilder(
    column: $table.department,
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePhone => $composableBuilder(
    column: $table.relativePhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workScheduleType => $composableBuilder(
    column: $table.workScheduleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workScheduleDutyDays => $composableBuilder(
    column: $table.workScheduleDutyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workScheduleRestDays => $composableBuilder(
    column: $table.workScheduleRestDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get workScheduleStartDate => $composableBuilder(
    column: $table.workScheduleStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get branch => $composableBuilder(
    column: $table.branch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get department => $composableBuilder(
    column: $table.department,
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bloodType => $composableBuilder(
    column: $table.bloodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePhone => $composableBuilder(
    column: $table.relativePhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workScheduleType => $composableBuilder(
    column: $table.workScheduleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workScheduleDutyDays => $composableBuilder(
    column: $table.workScheduleDutyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workScheduleRestDays => $composableBuilder(
    column: $table.workScheduleRestDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get workScheduleStartDate => $composableBuilder(
    column: $table.workScheduleStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  GeneratedColumn<String> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get branch =>
      $composableBuilder(column: $table.branch, builder: (column) => column);

  GeneratedColumn<String> get department => $composableBuilder(
    column: $table.department,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get bloodType =>
      $composableBuilder(column: $table.bloodType, builder: (column) => column);

  GeneratedColumn<String> get relativeName => $composableBuilder(
    column: $table.relativeName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relativePhone => $composableBuilder(
    column: $table.relativePhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get workScheduleType => $composableBuilder(
    column: $table.workScheduleType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workScheduleDutyDays => $composableBuilder(
    column: $table.workScheduleDutyDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workScheduleRestDays => $composableBuilder(
    column: $table.workScheduleRestDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get workScheduleStartDate => $composableBuilder(
    column: $table.workScheduleStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

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
                Value<String> rank = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> branch = const Value.absent(),
                Value<String> department = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> bloodType = const Value.absent(),
                Value<String?> relativeName = const Value.absent(),
                Value<String?> relativePhone = const Value.absent(),
                Value<String?> workScheduleType = const Value.absent(),
                Value<int?> workScheduleDutyDays = const Value.absent(),
                Value<int?> workScheduleRestDays = const Value.absent(),
                Value<DateTime?> workScheduleStartDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> profilePhoto = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelTableCompanion(
                id: id,
                registryNumber: registryNumber,
                fullName: fullName,
                rank: rank,
                title: title,
                branch: branch,
                department: department,
                startDate: startDate,
                endDate: endDate,
                phone: phone,
                email: email,
                address: address,
                bloodType: bloodType,
                relativeName: relativeName,
                relativePhone: relativePhone,
                workScheduleType: workScheduleType,
                workScheduleDutyDays: workScheduleDutyDays,
                workScheduleRestDays: workScheduleRestDays,
                workScheduleStartDate: workScheduleStartDate,
                status: status,
                profilePhoto: profilePhoto,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String registryNumber,
                required String fullName,
                required String rank,
                required String title,
                required String branch,
                required String department,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required String phone,
                required String email,
                required String address,
                Value<String?> bloodType = const Value.absent(),
                Value<String?> relativeName = const Value.absent(),
                Value<String?> relativePhone = const Value.absent(),
                Value<String?> workScheduleType = const Value.absent(),
                Value<int?> workScheduleDutyDays = const Value.absent(),
                Value<int?> workScheduleRestDays = const Value.absent(),
                Value<DateTime?> workScheduleStartDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> profilePhoto = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelTableCompanion.insert(
                id: id,
                registryNumber: registryNumber,
                fullName: fullName,
                rank: rank,
                title: title,
                branch: branch,
                department: department,
                startDate: startDate,
                endDate: endDate,
                phone: phone,
                email: email,
                address: address,
                bloodType: bloodType,
                relativeName: relativeName,
                relativePhone: relativePhone,
                workScheduleType: workScheduleType,
                workScheduleDutyDays: workScheduleDutyDays,
                workScheduleRestDays: workScheduleRestDays,
                workScheduleStartDate: workScheduleStartDate,
                status: status,
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
