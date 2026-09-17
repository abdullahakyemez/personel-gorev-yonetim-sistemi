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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {registryNumber},
  ];
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

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _appNameMeta = const VerificationMeta(
    'appName',
  );
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
    'app_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateFormatMeta = const VerificationMeta(
    'dateFormat',
  );
  @override
  late final GeneratedColumn<String> dateFormat = GeneratedColumn<String>(
    'date_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appName,
    dateFormat,
    themeMode,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('app_name')) {
      context.handle(
        _appNameMeta,
        appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta),
      );
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('date_format')) {
      context.handle(
        _dateFormatMeta,
        dateFormat.isAcceptableOrUnknown(data['date_format']!, _dateFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFormatMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    } else if (isInserting) {
      context.missing(_themeModeMeta);
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
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      appName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_name'],
      )!,
      dateFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_format'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final int id;
  final String appName;
  final String dateFormat;
  final String themeMode;
  final DateTime updatedAt;
  const SettingsTableData({
    required this.id,
    required this.appName,
    required this.dateFormat,
    required this.themeMode,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['app_name'] = Variable<String>(appName);
    map['date_format'] = Variable<String>(dateFormat);
    map['theme_mode'] = Variable<String>(themeMode);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      appName: Value(appName),
      dateFormat: Value(dateFormat),
      themeMode: Value(themeMode),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      appName: serializer.fromJson<String>(json['appName']),
      dateFormat: serializer.fromJson<String>(json['dateFormat']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'appName': serializer.toJson<String>(appName),
      'dateFormat': serializer.toJson<String>(dateFormat),
      'themeMode': serializer.toJson<String>(themeMode),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingsTableData copyWith({
    int? id,
    String? appName,
    String? dateFormat,
    String? themeMode,
    DateTime? updatedAt,
  }) => SettingsTableData(
    id: id ?? this.id,
    appName: appName ?? this.appName,
    dateFormat: dateFormat ?? this.dateFormat,
    themeMode: themeMode ?? this.themeMode,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      appName: data.appName.present ? data.appName.value : this.appName,
      dateFormat: data.dateFormat.present
          ? data.dateFormat.value
          : this.dateFormat,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('id: $id, ')
          ..write('appName: $appName, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, appName, dateFormat, themeMode, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.id == this.id &&
          other.appName == this.appName &&
          other.dateFormat == this.dateFormat &&
          other.themeMode == this.themeMode &&
          other.updatedAt == this.updatedAt);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<int> id;
  final Value<String> appName;
  final Value<String> dateFormat;
  final Value<String> themeMode;
  final Value<DateTime> updatedAt;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.appName = const Value.absent(),
    this.dateFormat = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String appName,
    required String dateFormat,
    required String themeMode,
    this.updatedAt = const Value.absent(),
  }) : appName = Value(appName),
       dateFormat = Value(dateFormat),
       themeMode = Value(themeMode);
  static Insertable<SettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? appName,
    Expression<String>? dateFormat,
    Expression<String>? themeMode,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appName != null) 'app_name': appName,
      if (dateFormat != null) 'date_format': dateFormat,
      if (themeMode != null) 'theme_mode': themeMode,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? appName,
    Value<String>? dateFormat,
    Value<String>? themeMode,
    Value<DateTime>? updatedAt,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      appName: appName ?? this.appName,
      dateFormat: dateFormat ?? this.dateFormat,
      themeMode: themeMode ?? this.themeMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (dateFormat.present) {
      map['date_format'] = Variable<String>(dateFormat.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('appName: $appName, ')
          ..write('dateFormat: $dateFormat, ')
          ..write('themeMode: $themeMode, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TaskTableTable extends TaskTable
    with TableInfo<$TaskTableTable, TaskTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
    false,
    type: DriftSqlType.dateTime,
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
    title,
    description,
    status,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskTableData> instance, {
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
  TaskTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
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
  $TaskTableTable createAlias(String alias) {
    return $TaskTableTable(attachedDatabase, alias);
  }
}

class TaskTableData extends DataClass implements Insertable<TaskTableData> {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskTableData({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskTableCompanion toCompanion(bool nullToAbsent) {
    return TaskTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      status: Value(status),
      startDate: Value(startDate),
      endDate: Value(endDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskTableData copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskTableData copyWithCompanion(TaskTableCompanion data) {
    return TaskTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    status,
    startDate,
    endDate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskTableCompanion extends UpdateCompanion<TaskTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> status;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String status,
    required DateTime startDate,
    required DateTime endDate,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       status = Value(status),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<TaskTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? status,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
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
    return (StringBuffer('TaskTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskPersonnelTableTable extends TaskPersonnelTable
    with TableInfo<$TaskPersonnelTableTable, TaskPersonnelTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPersonnelTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, personnelId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_personnel_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPersonnelTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, personnelId};
  @override
  TaskPersonnelTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPersonnelTableData(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
    );
  }

  @override
  $TaskPersonnelTableTable createAlias(String alias) {
    return $TaskPersonnelTableTable(attachedDatabase, alias);
  }
}

class TaskPersonnelTableData extends DataClass
    implements Insertable<TaskPersonnelTableData> {
  final String taskId;
  final int personnelId;
  const TaskPersonnelTableData({
    required this.taskId,
    required this.personnelId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['personnel_id'] = Variable<int>(personnelId);
    return map;
  }

  TaskPersonnelTableCompanion toCompanion(bool nullToAbsent) {
    return TaskPersonnelTableCompanion(
      taskId: Value(taskId),
      personnelId: Value(personnelId),
    );
  }

  factory TaskPersonnelTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPersonnelTableData(
      taskId: serializer.fromJson<String>(json['taskId']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'personnelId': serializer.toJson<int>(personnelId),
    };
  }

  TaskPersonnelTableData copyWith({String? taskId, int? personnelId}) =>
      TaskPersonnelTableData(
        taskId: taskId ?? this.taskId,
        personnelId: personnelId ?? this.personnelId,
      );
  TaskPersonnelTableData copyWithCompanion(TaskPersonnelTableCompanion data) {
    return TaskPersonnelTableData(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPersonnelTableData(')
          ..write('taskId: $taskId, ')
          ..write('personnelId: $personnelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, personnelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPersonnelTableData &&
          other.taskId == this.taskId &&
          other.personnelId == this.personnelId);
}

class TaskPersonnelTableCompanion
    extends UpdateCompanion<TaskPersonnelTableData> {
  final Value<String> taskId;
  final Value<int> personnelId;
  final Value<int> rowid;
  const TaskPersonnelTableCompanion({
    this.taskId = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskPersonnelTableCompanion.insert({
    required String taskId,
    required int personnelId,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       personnelId = Value(personnelId);
  static Insertable<TaskPersonnelTableData> custom({
    Expression<String>? taskId,
    Expression<int>? personnelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (personnelId != null) 'personnel_id': personnelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskPersonnelTableCompanion copyWith({
    Value<String>? taskId,
    Value<int>? personnelId,
    Value<int>? rowid,
  }) {
    return TaskPersonnelTableCompanion(
      taskId: taskId ?? this.taskId,
      personnelId: personnelId ?? this.personnelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPersonnelTableCompanion(')
          ..write('taskId: $taskId, ')
          ..write('personnelId: $personnelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveTableTable extends LeaveTable
    with TableInfo<$LeaveTableTable, LeaveTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
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
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    personnelId,
    startDate,
    endDate,
    type,
    description,
    address,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
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
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
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
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
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
  LeaveTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
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
  $LeaveTableTable createAlias(String alias) {
    return $LeaveTableTable(attachedDatabase, alias);
  }
}

class LeaveTableData extends DataClass implements Insertable<LeaveTableData> {
  final String id;
  final int personnelId;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String description;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LeaveTableData({
    required this.id,
    required this.personnelId,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.description,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['type'] = Variable<String>(type);
    map['description'] = Variable<String>(description);
    map['address'] = Variable<String>(address);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LeaveTableCompanion toCompanion(bool nullToAbsent) {
    return LeaveTableCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      type: Value(type),
      description: Value(description),
      address: Value(address),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LeaveTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveTableData(
      id: serializer.fromJson<String>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String>(json['description']),
      address: serializer.fromJson<String>(json['address']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String>(description),
      'address': serializer.toJson<String>(address),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LeaveTableData copyWith({
    String? id,
    int? personnelId,
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    String? description,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LeaveTableData(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    type: type ?? this.type,
    description: description ?? this.description,
    address: address ?? this.address,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LeaveTableData copyWithCompanion(LeaveTableCompanion data) {
    return LeaveTableData(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
      address: data.address.present ? data.address.value : this.address,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveTableData(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personnelId,
    startDate,
    endDate,
    type,
    description,
    address,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveTableData &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.type == this.type &&
          other.description == this.description &&
          other.address == this.address &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LeaveTableCompanion extends UpdateCompanion<LeaveTableData> {
  final Value<String> id;
  final Value<int> personnelId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<String> type;
  final Value<String> description;
  final Value<String> address;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LeaveTableCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaveTableCompanion.insert({
    required String id,
    required int personnelId,
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    required String description,
    this.address = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personnelId = Value(personnelId),
       startDate = Value(startDate),
       endDate = Value(endDate),
       type = Value(type),
       description = Value(description);
  static Insertable<LeaveTableData> custom({
    Expression<String>? id,
    Expression<int>? personnelId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? type,
    Expression<String>? description,
    Expression<String>? address,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (address != null) 'address': address,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaveTableCompanion copyWith({
    Value<String>? id,
    Value<int>? personnelId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<String>? type,
    Value<String>? description,
    Value<String>? address,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LeaveTableCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      description: description ?? this.description,
      address: address ?? this.address,
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
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
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
    return (StringBuffer('LeaveTableCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('address: $address, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PersonnelHistoryTableTable extends PersonnelHistoryTable
    with TableInfo<$PersonnelHistoryTableTable, PersonnelHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonnelHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    action,
    description,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personnel_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonnelHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonnelHistoryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonnelHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
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
  $PersonnelHistoryTableTable createAlias(String alias) {
    return $PersonnelHistoryTableTable(attachedDatabase, alias);
  }
}

class PersonnelHistoryTableData extends DataClass
    implements Insertable<PersonnelHistoryTableData> {
  final String id;
  final int personnelId;
  final String action;
  final String description;
  final DateTime createdAt;
  const PersonnelHistoryTableData({
    required this.id,
    required this.personnelId,
    required this.action,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['action'] = Variable<String>(action);
    map['description'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PersonnelHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return PersonnelHistoryTableCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      action: Value(action),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory PersonnelHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonnelHistoryTableData(
      id: serializer.fromJson<String>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      action: serializer.fromJson<String>(json['action']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'action': serializer.toJson<String>(action),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PersonnelHistoryTableData copyWith({
    String? id,
    int? personnelId,
    String? action,
    String? description,
    DateTime? createdAt,
  }) => PersonnelHistoryTableData(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    action: action ?? this.action,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );
  PersonnelHistoryTableData copyWithCompanion(
    PersonnelHistoryTableCompanion data,
  ) {
    return PersonnelHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      action: data.action.present ? data.action.value : this.action,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelHistoryTableData(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('action: $action, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personnelId, action, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonnelHistoryTableData &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.action == this.action &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class PersonnelHistoryTableCompanion
    extends UpdateCompanion<PersonnelHistoryTableData> {
  final Value<String> id;
  final Value<int> personnelId;
  final Value<String> action;
  final Value<String> description;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PersonnelHistoryTableCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.action = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonnelHistoryTableCompanion.insert({
    required String id,
    required int personnelId,
    required String action,
    required String description,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       personnelId = Value(personnelId),
       action = Value(action),
       description = Value(description);
  static Insertable<PersonnelHistoryTableData> custom({
    Expression<String>? id,
    Expression<int>? personnelId,
    Expression<String>? action,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (action != null) 'action': action,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonnelHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<int>? personnelId,
    Value<String>? action,
    Value<String>? description,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PersonnelHistoryTableCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      action: action ?? this.action,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('action: $action, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
    'salt',
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
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _requiresPasswordChangeMeta =
      const VerificationMeta('requiresPasswordChange');
  @override
  late final GeneratedColumn<bool> requiresPasswordChange =
      GeneratedColumn<bool>(
        'requires_password_change',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_password_change" IN (0, 1))',
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
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    salt,
    fullName,
    role,
    personnelId,
    groupName,
    isActive,
    requiresPasswordChange,
    createdAt,
    lastLoginAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('requires_password_change')) {
      context.handle(
        _requiresPasswordChangeMeta,
        requiresPasswordChange.isAcceptableOrUnknown(
          data['requires_password_change']!,
          _requiresPasswordChangeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      ),
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      requiresPasswordChange: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_password_change'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      ),
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final int id;
  final String username;
  final String passwordHash;
  final String salt;
  final String fullName;
  final String role;
  final int? personnelId;
  final String? groupName;
  final bool isActive;
  final bool requiresPasswordChange;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  const UserTableData({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.salt,
    required this.fullName,
    required this.role,
    this.personnelId,
    this.groupName,
    required this.isActive,
    required this.requiresPasswordChange,
    required this.createdAt,
    this.lastLoginAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['salt'] = Variable<String>(salt);
    map['full_name'] = Variable<String>(fullName);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || personnelId != null) {
      map['personnel_id'] = Variable<int>(personnelId);
    }
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['requires_password_change'] = Variable<bool>(requiresPasswordChange);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      salt: Value(salt),
      fullName: Value(fullName),
      role: Value(role),
      personnelId: personnelId == null && nullToAbsent
          ? const Value.absent()
          : Value(personnelId),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      isActive: Value(isActive),
      requiresPasswordChange: Value(requiresPasswordChange),
      createdAt: Value(createdAt),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
    );
  }

  factory UserTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      salt: serializer.fromJson<String>(json['salt']),
      fullName: serializer.fromJson<String>(json['fullName']),
      role: serializer.fromJson<String>(json['role']),
      personnelId: serializer.fromJson<int?>(json['personnelId']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      requiresPasswordChange: serializer.fromJson<bool>(
        json['requiresPasswordChange'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'salt': serializer.toJson<String>(salt),
      'fullName': serializer.toJson<String>(fullName),
      'role': serializer.toJson<String>(role),
      'personnelId': serializer.toJson<int?>(personnelId),
      'groupName': serializer.toJson<String?>(groupName),
      'isActive': serializer.toJson<bool>(isActive),
      'requiresPasswordChange': serializer.toJson<bool>(requiresPasswordChange),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
    };
  }

  UserTableData copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? salt,
    String? fullName,
    String? role,
    Value<int?> personnelId = const Value.absent(),
    Value<String?> groupName = const Value.absent(),
    bool? isActive,
    bool? requiresPasswordChange,
    DateTime? createdAt,
    Value<DateTime?> lastLoginAt = const Value.absent(),
  }) => UserTableData(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    salt: salt ?? this.salt,
    fullName: fullName ?? this.fullName,
    role: role ?? this.role,
    personnelId: personnelId.present ? personnelId.value : this.personnelId,
    groupName: groupName.present ? groupName.value : this.groupName,
    isActive: isActive ?? this.isActive,
    requiresPasswordChange:
        requiresPasswordChange ?? this.requiresPasswordChange,
    createdAt: createdAt ?? this.createdAt,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      salt: data.salt.present ? data.salt.value : this.salt,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      role: data.role.present ? data.role.value : this.role,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      requiresPasswordChange: data.requiresPasswordChange.present
          ? data.requiresPasswordChange.value
          : this.requiresPasswordChange,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('salt: $salt, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('personnelId: $personnelId, ')
          ..write('groupName: $groupName, ')
          ..write('isActive: $isActive, ')
          ..write('requiresPasswordChange: $requiresPasswordChange, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    passwordHash,
    salt,
    fullName,
    role,
    personnelId,
    groupName,
    isActive,
    requiresPasswordChange,
    createdAt,
    lastLoginAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.salt == this.salt &&
          other.fullName == this.fullName &&
          other.role == this.role &&
          other.personnelId == this.personnelId &&
          other.groupName == this.groupName &&
          other.isActive == this.isActive &&
          other.requiresPasswordChange == this.requiresPasswordChange &&
          other.createdAt == this.createdAt &&
          other.lastLoginAt == this.lastLoginAt);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> salt;
  final Value<String> fullName;
  final Value<String> role;
  final Value<int?> personnelId;
  final Value<String?> groupName;
  final Value<bool> isActive;
  final Value<bool> requiresPasswordChange;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastLoginAt;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.fullName = const Value.absent(),
    this.role = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresPasswordChange = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
  });
  UserTableCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    required String salt,
    required String fullName,
    required String role,
    this.personnelId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.isActive = const Value.absent(),
    this.requiresPasswordChange = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
  }) : username = Value(username),
       passwordHash = Value(passwordHash),
       salt = Value(salt),
       fullName = Value(fullName),
       role = Value(role);
  static Insertable<UserTableData> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? salt,
    Expression<String>? fullName,
    Expression<String>? role,
    Expression<int>? personnelId,
    Expression<String>? groupName,
    Expression<bool>? isActive,
    Expression<bool>? requiresPasswordChange,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastLoginAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (salt != null) 'salt': salt,
      if (fullName != null) 'full_name': fullName,
      if (role != null) 'role': role,
      if (personnelId != null) 'personnel_id': personnelId,
      if (groupName != null) 'group_name': groupName,
      if (isActive != null) 'is_active': isActive,
      if (requiresPasswordChange != null)
        'requires_password_change': requiresPasswordChange,
      if (createdAt != null) 'created_at': createdAt,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
    });
  }

  UserTableCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? salt,
    Value<String>? fullName,
    Value<String>? role,
    Value<int?>? personnelId,
    Value<String?>? groupName,
    Value<bool>? isActive,
    Value<bool>? requiresPasswordChange,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastLoginAt,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      personnelId: personnelId ?? this.personnelId,
      groupName: groupName ?? this.groupName,
      isActive: isActive ?? this.isActive,
      requiresPasswordChange:
          requiresPasswordChange ?? this.requiresPasswordChange,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (requiresPasswordChange.present) {
      map['requires_password_change'] = Variable<bool>(
        requiresPasswordChange.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('salt: $salt, ')
          ..write('fullName: $fullName, ')
          ..write('role: $role, ')
          ..write('personnelId: $personnelId, ')
          ..write('groupName: $groupName, ')
          ..write('isActive: $isActive, ')
          ..write('requiresPasswordChange: $requiresPasswordChange, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonnelTableTable personnelTable = $PersonnelTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $TaskTableTable taskTable = $TaskTableTable(this);
  late final $TaskPersonnelTableTable taskPersonnelTable =
      $TaskPersonnelTableTable(this);
  late final $LeaveTableTable leaveTable = $LeaveTableTable(this);
  late final $PersonnelHistoryTableTable personnelHistoryTable =
      $PersonnelHistoryTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    personnelTable,
    settingsTable,
    taskTable,
    taskPersonnelTable,
    leaveTable,
    personnelHistoryTable,
    userTable,
  ];
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
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required String appName,
      required String dateFormat,
      required String themeMode,
      Value<DateTime> updatedAt,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> appName,
      Value<String> dateFormat,
      Value<String> themeMode,
      Value<DateTime> updatedAt,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get appName => $composableBuilder(
    column: $table.appName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get appName =>
      $composableBuilder(column: $table.appName, builder: (column) => column);

  GeneratedColumn<String> get dateFormat => $composableBuilder(
    column: $table.dateFormat,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> appName = const Value.absent(),
                Value<String> dateFormat = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                appName: appName,
                dateFormat: dateFormat,
                themeMode: themeMode,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String appName,
                required String dateFormat,
                required String themeMode,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                appName: appName,
                dateFormat: dateFormat,
                themeMode: themeMode,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskTableTableCreateCompanionBuilder =
    TaskTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String status,
      required DateTime startDate,
      required DateTime endDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskTableTableUpdateCompanionBuilder =
    TaskTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> status,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TaskTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTableTable> {
  $$TaskTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TaskTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskTableTable,
          TaskTableData,
          $$TaskTableTableFilterComposer,
          $$TaskTableTableOrderingComposer,
          $$TaskTableTableAnnotationComposer,
          $$TaskTableTableCreateCompanionBuilder,
          $$TaskTableTableUpdateCompanionBuilder,
          (
            TaskTableData,
            BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>,
          ),
          TaskTableData,
          PrefetchHooks Function()
        > {
  $$TaskTableTableTableManager(_$AppDatabase db, $TaskTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskTableCompanion(
                id: id,
                title: title,
                description: description,
                status: status,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String status,
                required DateTime startDate,
                required DateTime endDate,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                status: status,
                startDate: startDate,
                endDate: endDate,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskTableTable,
      TaskTableData,
      $$TaskTableTableFilterComposer,
      $$TaskTableTableOrderingComposer,
      $$TaskTableTableAnnotationComposer,
      $$TaskTableTableCreateCompanionBuilder,
      $$TaskTableTableUpdateCompanionBuilder,
      (
        TaskTableData,
        BaseReferences<_$AppDatabase, $TaskTableTable, TaskTableData>,
      ),
      TaskTableData,
      PrefetchHooks Function()
    >;
typedef $$TaskPersonnelTableTableCreateCompanionBuilder =
    TaskPersonnelTableCompanion Function({
      required String taskId,
      required int personnelId,
      Value<int> rowid,
    });
typedef $$TaskPersonnelTableTableUpdateCompanionBuilder =
    TaskPersonnelTableCompanion Function({
      Value<String> taskId,
      Value<int> personnelId,
      Value<int> rowid,
    });

class $$TaskPersonnelTableTableFilterComposer
    extends Composer<_$AppDatabase, $TaskPersonnelTableTable> {
  $$TaskPersonnelTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskPersonnelTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskPersonnelTableTable> {
  $$TaskPersonnelTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskPersonnelTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskPersonnelTableTable> {
  $$TaskPersonnelTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => column,
  );
}

class $$TaskPersonnelTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskPersonnelTableTable,
          TaskPersonnelTableData,
          $$TaskPersonnelTableTableFilterComposer,
          $$TaskPersonnelTableTableOrderingComposer,
          $$TaskPersonnelTableTableAnnotationComposer,
          $$TaskPersonnelTableTableCreateCompanionBuilder,
          $$TaskPersonnelTableTableUpdateCompanionBuilder,
          (
            TaskPersonnelTableData,
            BaseReferences<
              _$AppDatabase,
              $TaskPersonnelTableTable,
              TaskPersonnelTableData
            >,
          ),
          TaskPersonnelTableData,
          PrefetchHooks Function()
        > {
  $$TaskPersonnelTableTableTableManager(
    _$AppDatabase db,
    $TaskPersonnelTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskPersonnelTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskPersonnelTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskPersonnelTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPersonnelTableCompanion(
                taskId: taskId,
                personnelId: personnelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required int personnelId,
                Value<int> rowid = const Value.absent(),
              }) => TaskPersonnelTableCompanion.insert(
                taskId: taskId,
                personnelId: personnelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskPersonnelTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskPersonnelTableTable,
      TaskPersonnelTableData,
      $$TaskPersonnelTableTableFilterComposer,
      $$TaskPersonnelTableTableOrderingComposer,
      $$TaskPersonnelTableTableAnnotationComposer,
      $$TaskPersonnelTableTableCreateCompanionBuilder,
      $$TaskPersonnelTableTableUpdateCompanionBuilder,
      (
        TaskPersonnelTableData,
        BaseReferences<
          _$AppDatabase,
          $TaskPersonnelTableTable,
          TaskPersonnelTableData
        >,
      ),
      TaskPersonnelTableData,
      PrefetchHooks Function()
    >;
typedef $$LeaveTableTableCreateCompanionBuilder =
    LeaveTableCompanion Function({
      required String id,
      required int personnelId,
      required DateTime startDate,
      required DateTime endDate,
      required String type,
      required String description,
      Value<String> address,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LeaveTableTableUpdateCompanionBuilder =
    LeaveTableCompanion Function({
      Value<String> id,
      Value<int> personnelId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<String> type,
      Value<String> description,
      Value<String> address,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LeaveTableTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveTableTable> {
  $$LeaveTableTableFilterComposer({
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

  ColumnFilters<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
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

class $$LeaveTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveTableTable> {
  $$LeaveTableTableOrderingComposer({
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

  ColumnOrderings<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
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

class $$LeaveTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveTableTable> {
  $$LeaveTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LeaveTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveTableTable,
          LeaveTableData,
          $$LeaveTableTableFilterComposer,
          $$LeaveTableTableOrderingComposer,
          $$LeaveTableTableAnnotationComposer,
          $$LeaveTableTableCreateCompanionBuilder,
          $$LeaveTableTableUpdateCompanionBuilder,
          (
            LeaveTableData,
            BaseReferences<_$AppDatabase, $LeaveTableTable, LeaveTableData>,
          ),
          LeaveTableData,
          PrefetchHooks Function()
        > {
  $$LeaveTableTableTableManager(_$AppDatabase db, $LeaveTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveTableCompanion(
                id: id,
                personnelId: personnelId,
                startDate: startDate,
                endDate: endDate,
                type: type,
                description: description,
                address: address,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int personnelId,
                required DateTime startDate,
                required DateTime endDate,
                required String type,
                required String description,
                Value<String> address = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveTableCompanion.insert(
                id: id,
                personnelId: personnelId,
                startDate: startDate,
                endDate: endDate,
                type: type,
                description: description,
                address: address,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeaveTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveTableTable,
      LeaveTableData,
      $$LeaveTableTableFilterComposer,
      $$LeaveTableTableOrderingComposer,
      $$LeaveTableTableAnnotationComposer,
      $$LeaveTableTableCreateCompanionBuilder,
      $$LeaveTableTableUpdateCompanionBuilder,
      (
        LeaveTableData,
        BaseReferences<_$AppDatabase, $LeaveTableTable, LeaveTableData>,
      ),
      LeaveTableData,
      PrefetchHooks Function()
    >;
typedef $$PersonnelHistoryTableTableCreateCompanionBuilder =
    PersonnelHistoryTableCompanion Function({
      required String id,
      required int personnelId,
      required String action,
      required String description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PersonnelHistoryTableTableUpdateCompanionBuilder =
    PersonnelHistoryTableCompanion Function({
      Value<String> id,
      Value<int> personnelId,
      Value<String> action,
      Value<String> description,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PersonnelHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $PersonnelHistoryTableTable> {
  $$PersonnelHistoryTableTableFilterComposer({
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

  ColumnFilters<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
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

class $$PersonnelHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonnelHistoryTableTable> {
  $$PersonnelHistoryTableTableOrderingComposer({
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

  ColumnOrderings<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
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

class $$PersonnelHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonnelHistoryTableTable> {
  $$PersonnelHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PersonnelHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonnelHistoryTableTable,
          PersonnelHistoryTableData,
          $$PersonnelHistoryTableTableFilterComposer,
          $$PersonnelHistoryTableTableOrderingComposer,
          $$PersonnelHistoryTableTableAnnotationComposer,
          $$PersonnelHistoryTableTableCreateCompanionBuilder,
          $$PersonnelHistoryTableTableUpdateCompanionBuilder,
          (
            PersonnelHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $PersonnelHistoryTableTable,
              PersonnelHistoryTableData
            >,
          ),
          PersonnelHistoryTableData,
          PrefetchHooks Function()
        > {
  $$PersonnelHistoryTableTableTableManager(
    _$AppDatabase db,
    $PersonnelHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonnelHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PersonnelHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PersonnelHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonnelHistoryTableCompanion(
                id: id,
                personnelId: personnelId,
                action: action,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int personnelId,
                required String action,
                required String description,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonnelHistoryTableCompanion.insert(
                id: id,
                personnelId: personnelId,
                action: action,
                description: description,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonnelHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonnelHistoryTableTable,
      PersonnelHistoryTableData,
      $$PersonnelHistoryTableTableFilterComposer,
      $$PersonnelHistoryTableTableOrderingComposer,
      $$PersonnelHistoryTableTableAnnotationComposer,
      $$PersonnelHistoryTableTableCreateCompanionBuilder,
      $$PersonnelHistoryTableTableUpdateCompanionBuilder,
      (
        PersonnelHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $PersonnelHistoryTableTable,
          PersonnelHistoryTableData
        >,
      ),
      PersonnelHistoryTableData,
      PrefetchHooks Function()
    >;
typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      required String username,
      required String passwordHash,
      required String salt,
      required String fullName,
      required String role,
      Value<int?> personnelId,
      Value<String?> groupName,
      Value<bool> isActive,
      Value<bool> requiresPasswordChange,
      Value<DateTime> createdAt,
      Value<DateTime?> lastLoginAt,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> salt,
      Value<String> fullName,
      Value<String> role,
      Value<int?> personnelId,
      Value<String?> groupName,
      Value<bool> isActive,
      Value<bool> requiresPasswordChange,
      Value<DateTime> createdAt,
      Value<DateTime?> lastLoginAt,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresPasswordChange => $composableBuilder(
    column: $table.requiresPasswordChange,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresPasswordChange => $composableBuilder(
    column: $table.requiresPasswordChange,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<int> get personnelId => $composableBuilder(
    column: $table.personnelId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get requiresPasswordChange => $composableBuilder(
    column: $table.requiresPasswordChange,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTableTable,
          UserTableData,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            UserTableData,
            BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
          ),
          UserTableData,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> salt = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int?> personnelId = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> requiresPasswordChange = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                salt: salt,
                fullName: fullName,
                role: role,
                personnelId: personnelId,
                groupName: groupName,
                isActive: isActive,
                requiresPasswordChange: requiresPasswordChange,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String passwordHash,
                required String salt,
                required String fullName,
                required String role,
                Value<int?> personnelId = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> requiresPasswordChange = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                salt: salt,
                fullName: fullName,
                role: role,
                personnelId: personnelId,
                groupName: groupName,
                isActive: isActive,
                requiresPasswordChange: requiresPasswordChange,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTableTable,
      UserTableData,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        UserTableData,
        BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
      ),
      UserTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonnelTableTableTableManager get personnelTable =>
      $$PersonnelTableTableTableManager(_db, _db.personnelTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$TaskTableTableTableManager get taskTable =>
      $$TaskTableTableTableManager(_db, _db.taskTable);
  $$TaskPersonnelTableTableTableManager get taskPersonnelTable =>
      $$TaskPersonnelTableTableTableManager(_db, _db.taskPersonnelTable);
  $$LeaveTableTableTableManager get leaveTable =>
      $$LeaveTableTableTableManager(_db, _db.leaveTable);
  $$PersonnelHistoryTableTableTableManager get personnelHistoryTable =>
      $$PersonnelHistoryTableTableTableManager(_db, _db.personnelHistoryTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
}
