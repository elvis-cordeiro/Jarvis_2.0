// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
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
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    defaultValue: const Constant(1),
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
    title,
    description,
    dueDate,
    isCompleted,
    priority,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
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
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool isCompleted;
  final int priority;
  final DateTime createdAt;
  const Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    required this.isCompleted,
    required this.priority,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['priority'] = Variable<int>(priority);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      isCompleted: Value(isCompleted),
      priority: Value(priority),
      createdAt: Value(createdAt),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      priority: serializer.fromJson<int>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'priority': serializer.toJson<int>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    bool? isCompleted,
    int? priority,
    DateTime? createdAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    dueDate,
    isCompleted,
    priority,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueDate == this.dueDate &&
          other.isCompleted == this.isCompleted &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime?> dueDate;
  final Value<bool> isCompleted;
  final Value<int> priority;
  final Value<DateTime> createdAt;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueDate,
    Expression<bool>? isCompleted,
    Expression<int>? priority,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueDate != null) 'due_date': dueDate,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime?>? dueDate,
    Value<bool>? isCompleted,
    Value<int>? priority,
    Value<DateTime>? createdAt,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueDate: $dueDate, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeUpTimeMeta = const VerificationMeta(
    'wakeUpTime',
  );
  @override
  late final GeneratedColumn<int> wakeUpTime = GeneratedColumn<int>(
    'wake_up_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaveHomeTimeMeta = const VerificationMeta(
    'leaveHomeTime',
  );
  @override
  late final GeneratedColumn<int> leaveHomeTime = GeneratedColumn<int>(
    'leave_home_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayOfWeek,
    wakeUpTime,
    leaveHomeTime,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('wake_up_time')) {
      context.handle(
        _wakeUpTimeMeta,
        wakeUpTime.isAcceptableOrUnknown(
          data['wake_up_time']!,
          _wakeUpTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_wakeUpTimeMeta);
    }
    if (data.containsKey('leave_home_time')) {
      context.handle(
        _leaveHomeTimeMeta,
        leaveHomeTime.isAcceptableOrUnknown(
          data['leave_home_time']!,
          _leaveHomeTimeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_of_week'],
      )!,
      wakeUpTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_up_time'],
      )!,
      leaveHomeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_home_time'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final int id;
  final String dayOfWeek;
  final int wakeUpTime;
  final int? leaveHomeTime;
  final String? notes;
  const Routine({
    required this.id,
    required this.dayOfWeek,
    required this.wakeUpTime,
    this.leaveHomeTime,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['wake_up_time'] = Variable<int>(wakeUpTime);
    if (!nullToAbsent || leaveHomeTime != null) {
      map['leave_home_time'] = Variable<int>(leaveHomeTime);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      dayOfWeek: Value(dayOfWeek),
      wakeUpTime: Value(wakeUpTime),
      leaveHomeTime: leaveHomeTime == null && nullToAbsent
          ? const Value.absent()
          : Value(leaveHomeTime),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<int>(json['id']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      wakeUpTime: serializer.fromJson<int>(json['wakeUpTime']),
      leaveHomeTime: serializer.fromJson<int?>(json['leaveHomeTime']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'wakeUpTime': serializer.toJson<int>(wakeUpTime),
      'leaveHomeTime': serializer.toJson<int?>(leaveHomeTime),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Routine copyWith({
    int? id,
    String? dayOfWeek,
    int? wakeUpTime,
    Value<int?> leaveHomeTime = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Routine(
    id: id ?? this.id,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    wakeUpTime: wakeUpTime ?? this.wakeUpTime,
    leaveHomeTime: leaveHomeTime.present
        ? leaveHomeTime.value
        : this.leaveHomeTime,
    notes: notes.present ? notes.value : this.notes,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      wakeUpTime: data.wakeUpTime.present
          ? data.wakeUpTime.value
          : this.wakeUpTime,
      leaveHomeTime: data.leaveHomeTime.present
          ? data.leaveHomeTime.value
          : this.leaveHomeTime,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('wakeUpTime: $wakeUpTime, ')
          ..write('leaveHomeTime: $leaveHomeTime, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayOfWeek, wakeUpTime, leaveHomeTime, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.dayOfWeek == this.dayOfWeek &&
          other.wakeUpTime == this.wakeUpTime &&
          other.leaveHomeTime == this.leaveHomeTime &&
          other.notes == this.notes);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<int> id;
  final Value<String> dayOfWeek;
  final Value<int> wakeUpTime;
  final Value<int?> leaveHomeTime;
  final Value<String?> notes;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.wakeUpTime = const Value.absent(),
    this.leaveHomeTime = const Value.absent(),
    this.notes = const Value.absent(),
  });
  RoutinesCompanion.insert({
    this.id = const Value.absent(),
    required String dayOfWeek,
    required int wakeUpTime,
    this.leaveHomeTime = const Value.absent(),
    this.notes = const Value.absent(),
  }) : dayOfWeek = Value(dayOfWeek),
       wakeUpTime = Value(wakeUpTime);
  static Insertable<Routine> custom({
    Expression<int>? id,
    Expression<String>? dayOfWeek,
    Expression<int>? wakeUpTime,
    Expression<int>? leaveHomeTime,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (wakeUpTime != null) 'wake_up_time': wakeUpTime,
      if (leaveHomeTime != null) 'leave_home_time': leaveHomeTime,
      if (notes != null) 'notes': notes,
    });
  }

  RoutinesCompanion copyWith({
    Value<int>? id,
    Value<String>? dayOfWeek,
    Value<int>? wakeUpTime,
    Value<int?>? leaveHomeTime,
    Value<String?>? notes,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      leaveHomeTime: leaveHomeTime ?? this.leaveHomeTime,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (wakeUpTime.present) {
      map['wake_up_time'] = Variable<int>(wakeUpTime.value);
    }
    if (leaveHomeTime.present) {
      map['leave_home_time'] = Variable<int>(leaveHomeTime.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('wakeUpTime: $wakeUpTime, ')
          ..write('leaveHomeTime: $leaveHomeTime, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $LongTermMemoryTable extends LongTermMemory
    with TableInfo<$LongTermMemoryTable, LongTermMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LongTermMemoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
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
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    content,
    source,
    createdAt,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'long_term_memory';
  @override
  VerificationContext validateIntegrity(
    Insertable<LongTermMemoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LongTermMemoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LongTermMemoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
    );
  }

  @override
  $LongTermMemoryTable createAlias(String alias) {
    return $LongTermMemoryTable(attachedDatabase, alias);
  }
}

class LongTermMemoryData extends DataClass
    implements Insertable<LongTermMemoryData> {
  final int id;
  final String category;
  final String content;
  final String? source;
  final DateTime createdAt;
  final DateTime? expiresAt;
  const LongTermMemoryData({
    required this.id,
    required this.category,
    required this.content,
    this.source,
    required this.createdAt,
    this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    return map;
  }

  LongTermMemoryCompanion toCompanion(bool nullToAbsent) {
    return LongTermMemoryCompanion(
      id: Value(id),
      category: Value(category),
      content: Value(content),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
    );
  }

  factory LongTermMemoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LongTermMemoryData(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      content: serializer.fromJson<String>(json['content']),
      source: serializer.fromJson<String?>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'content': serializer.toJson<String>(content),
      'source': serializer.toJson<String?>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
    };
  }

  LongTermMemoryData copyWith({
    int? id,
    String? category,
    String? content,
    Value<String?> source = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
  }) => LongTermMemoryData(
    id: id ?? this.id,
    category: category ?? this.category,
    content: content ?? this.content,
    source: source.present ? source.value : this.source,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
  );
  LongTermMemoryData copyWithCompanion(LongTermMemoryCompanion data) {
    return LongTermMemoryData(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      content: data.content.present ? data.content.value : this.content,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LongTermMemoryData(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, content, source, createdAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LongTermMemoryData &&
          other.id == this.id &&
          other.category == this.category &&
          other.content == this.content &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class LongTermMemoryCompanion extends UpdateCompanion<LongTermMemoryData> {
  final Value<int> id;
  final Value<String> category;
  final Value<String> content;
  final Value<String?> source;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  const LongTermMemoryCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.content = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  LongTermMemoryCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required String content,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  }) : category = Value(category),
       content = Value(content);
  static Insertable<LongTermMemoryData> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<String>? content,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (content != null) 'content': content,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  LongTermMemoryCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<String>? content,
    Value<String?>? source,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
  }) {
    return LongTermMemoryCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      content: content ?? this.content,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LongTermMemoryCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('content: $content, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $TemporaryMemoryTable extends TemporaryMemory
    with TableInfo<$TemporaryMemoryTable, TemporaryMemoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemporaryMemoryTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, content, createdAt, expiresAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temporary_memory';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemporaryMemoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemporaryMemoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemporaryMemoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $TemporaryMemoryTable createAlias(String alias) {
    return $TemporaryMemoryTable(attachedDatabase, alias);
  }
}

class TemporaryMemoryData extends DataClass
    implements Insertable<TemporaryMemoryData> {
  final int id;
  final String content;
  final DateTime createdAt;
  final DateTime expiresAt;
  const TemporaryMemoryData({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  TemporaryMemoryCompanion toCompanion(bool nullToAbsent) {
    return TemporaryMemoryCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
    );
  }

  factory TemporaryMemoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemporaryMemoryData(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  TemporaryMemoryData copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) => TemporaryMemoryData(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  TemporaryMemoryData copyWithCompanion(TemporaryMemoryCompanion data) {
    return TemporaryMemoryData(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemporaryMemoryData(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt, expiresAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemporaryMemoryData &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt);
}

class TemporaryMemoryCompanion extends UpdateCompanion<TemporaryMemoryData> {
  final Value<int> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  const TemporaryMemoryCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
  });
  TemporaryMemoryCompanion.insert({
    this.id = const Value.absent(),
    required String content,
    this.createdAt = const Value.absent(),
    required DateTime expiresAt,
  }) : content = Value(content),
       expiresAt = Value(expiresAt);
  static Insertable<TemporaryMemoryData> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
    });
  }

  TemporaryMemoryCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
  }) {
    return TemporaryMemoryCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemporaryMemoryCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }
}

class $ConversationHistoryTable extends ConversationHistory
    with TableInfo<$ConversationHistoryTable, ConversationHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userMessageMeta = const VerificationMeta(
    'userMessage',
  );
  @override
  late final GeneratedColumn<String> userMessage = GeneratedColumn<String>(
    'user_message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jarvisResponseMeta = const VerificationMeta(
    'jarvisResponse',
  );
  @override
  late final GeneratedColumn<String> jarvisResponse = GeneratedColumn<String>(
    'jarvis_response',
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userMessage,
    jarvisResponse,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_message')) {
      context.handle(
        _userMessageMeta,
        userMessage.isAcceptableOrUnknown(
          data['user_message']!,
          _userMessageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userMessageMeta);
    }
    if (data.containsKey('jarvis_response')) {
      context.handle(
        _jarvisResponseMeta,
        jarvisResponse.isAcceptableOrUnknown(
          data['jarvis_response']!,
          _jarvisResponseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_jarvisResponseMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_message'],
      )!,
      jarvisResponse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jarvis_response'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ConversationHistoryTable createAlias(String alias) {
    return $ConversationHistoryTable(attachedDatabase, alias);
  }
}

class ConversationHistoryData extends DataClass
    implements Insertable<ConversationHistoryData> {
  final int id;
  final String userMessage;
  final String jarvisResponse;
  final DateTime timestamp;
  const ConversationHistoryData({
    required this.id,
    required this.userMessage,
    required this.jarvisResponse,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_message'] = Variable<String>(userMessage);
    map['jarvis_response'] = Variable<String>(jarvisResponse);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ConversationHistoryCompanion toCompanion(bool nullToAbsent) {
    return ConversationHistoryCompanion(
      id: Value(id),
      userMessage: Value(userMessage),
      jarvisResponse: Value(jarvisResponse),
      timestamp: Value(timestamp),
    );
  }

  factory ConversationHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationHistoryData(
      id: serializer.fromJson<int>(json['id']),
      userMessage: serializer.fromJson<String>(json['userMessage']),
      jarvisResponse: serializer.fromJson<String>(json['jarvisResponse']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userMessage': serializer.toJson<String>(userMessage),
      'jarvisResponse': serializer.toJson<String>(jarvisResponse),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ConversationHistoryData copyWith({
    int? id,
    String? userMessage,
    String? jarvisResponse,
    DateTime? timestamp,
  }) => ConversationHistoryData(
    id: id ?? this.id,
    userMessage: userMessage ?? this.userMessage,
    jarvisResponse: jarvisResponse ?? this.jarvisResponse,
    timestamp: timestamp ?? this.timestamp,
  );
  ConversationHistoryData copyWithCompanion(ConversationHistoryCompanion data) {
    return ConversationHistoryData(
      id: data.id.present ? data.id.value : this.id,
      userMessage: data.userMessage.present
          ? data.userMessage.value
          : this.userMessage,
      jarvisResponse: data.jarvisResponse.present
          ? data.jarvisResponse.value
          : this.jarvisResponse,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationHistoryData(')
          ..write('id: $id, ')
          ..write('userMessage: $userMessage, ')
          ..write('jarvisResponse: $jarvisResponse, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userMessage, jarvisResponse, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationHistoryData &&
          other.id == this.id &&
          other.userMessage == this.userMessage &&
          other.jarvisResponse == this.jarvisResponse &&
          other.timestamp == this.timestamp);
}

class ConversationHistoryCompanion
    extends UpdateCompanion<ConversationHistoryData> {
  final Value<int> id;
  final Value<String> userMessage;
  final Value<String> jarvisResponse;
  final Value<DateTime> timestamp;
  const ConversationHistoryCompanion({
    this.id = const Value.absent(),
    this.userMessage = const Value.absent(),
    this.jarvisResponse = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ConversationHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String userMessage,
    required String jarvisResponse,
    this.timestamp = const Value.absent(),
  }) : userMessage = Value(userMessage),
       jarvisResponse = Value(jarvisResponse);
  static Insertable<ConversationHistoryData> custom({
    Expression<int>? id,
    Expression<String>? userMessage,
    Expression<String>? jarvisResponse,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userMessage != null) 'user_message': userMessage,
      if (jarvisResponse != null) 'jarvis_response': jarvisResponse,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ConversationHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? userMessage,
    Value<String>? jarvisResponse,
    Value<DateTime>? timestamp,
  }) {
    return ConversationHistoryCompanion(
      id: id ?? this.id,
      userMessage: userMessage ?? this.userMessage,
      jarvisResponse: jarvisResponse ?? this.jarvisResponse,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userMessage.present) {
      map['user_message'] = Variable<String>(userMessage.value);
    }
    if (jarvisResponse.present) {
      map['jarvis_response'] = Variable<String>(jarvisResponse.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationHistoryCompanion(')
          ..write('id: $id, ')
          ..write('userMessage: $userMessage, ')
          ..write('jarvisResponse: $jarvisResponse, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Elvis'),
  );
  static const VerificationMeta _jarvisNameMeta = const VerificationMeta(
    'jarvisName',
  );
  @override
  late final GeneratedColumn<String> jarvisName = GeneratedColumn<String>(
    'jarvis_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Jarvis'),
  );
  static const VerificationMeta _personalityPromptMeta = const VerificationMeta(
    'personalityPrompt',
  );
  @override
  late final GeneratedColumn<String> personalityPrompt =
      GeneratedColumn<String>(
        'personality_prompt',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _voiceEnabledMeta = const VerificationMeta(
    'voiceEnabled',
  );
  @override
  late final GeneratedColumn<bool> voiceEnabled = GeneratedColumn<bool>(
    'voice_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voice_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userName,
    jarvisName,
    personalityPrompt,
    voiceEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('jarvis_name')) {
      context.handle(
        _jarvisNameMeta,
        jarvisName.isAcceptableOrUnknown(data['jarvis_name']!, _jarvisNameMeta),
      );
    }
    if (data.containsKey('personality_prompt')) {
      context.handle(
        _personalityPromptMeta,
        personalityPrompt.isAcceptableOrUnknown(
          data['personality_prompt']!,
          _personalityPromptMeta,
        ),
      );
    }
    if (data.containsKey('voice_enabled')) {
      context.handle(
        _voiceEnabledMeta,
        voiceEnabled.isAcceptableOrUnknown(
          data['voice_enabled']!,
          _voiceEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      jarvisName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}jarvis_name'],
      )!,
      personalityPrompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personality_prompt'],
      )!,
      voiceEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voice_enabled'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final String userName;
  final String jarvisName;
  final String personalityPrompt;
  final bool voiceEnabled;
  const UserSetting({
    required this.id,
    required this.userName,
    required this.jarvisName,
    required this.personalityPrompt,
    required this.voiceEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_name'] = Variable<String>(userName);
    map['jarvis_name'] = Variable<String>(jarvisName);
    map['personality_prompt'] = Variable<String>(personalityPrompt);
    map['voice_enabled'] = Variable<bool>(voiceEnabled);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      userName: Value(userName),
      jarvisName: Value(jarvisName),
      personalityPrompt: Value(personalityPrompt),
      voiceEnabled: Value(voiceEnabled),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      userName: serializer.fromJson<String>(json['userName']),
      jarvisName: serializer.fromJson<String>(json['jarvisName']),
      personalityPrompt: serializer.fromJson<String>(json['personalityPrompt']),
      voiceEnabled: serializer.fromJson<bool>(json['voiceEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userName': serializer.toJson<String>(userName),
      'jarvisName': serializer.toJson<String>(jarvisName),
      'personalityPrompt': serializer.toJson<String>(personalityPrompt),
      'voiceEnabled': serializer.toJson<bool>(voiceEnabled),
    };
  }

  UserSetting copyWith({
    int? id,
    String? userName,
    String? jarvisName,
    String? personalityPrompt,
    bool? voiceEnabled,
  }) => UserSetting(
    id: id ?? this.id,
    userName: userName ?? this.userName,
    jarvisName: jarvisName ?? this.jarvisName,
    personalityPrompt: personalityPrompt ?? this.personalityPrompt,
    voiceEnabled: voiceEnabled ?? this.voiceEnabled,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      userName: data.userName.present ? data.userName.value : this.userName,
      jarvisName: data.jarvisName.present
          ? data.jarvisName.value
          : this.jarvisName,
      personalityPrompt: data.personalityPrompt.present
          ? data.personalityPrompt.value
          : this.personalityPrompt,
      voiceEnabled: data.voiceEnabled.present
          ? data.voiceEnabled.value
          : this.voiceEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('jarvisName: $jarvisName, ')
          ..write('personalityPrompt: $personalityPrompt, ')
          ..write('voiceEnabled: $voiceEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userName, jarvisName, personalityPrompt, voiceEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.userName == this.userName &&
          other.jarvisName == this.jarvisName &&
          other.personalityPrompt == this.personalityPrompt &&
          other.voiceEnabled == this.voiceEnabled);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<String> userName;
  final Value<String> jarvisName;
  final Value<String> personalityPrompt;
  final Value<bool> voiceEnabled;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.jarvisName = const Value.absent(),
    this.personalityPrompt = const Value.absent(),
    this.voiceEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.userName = const Value.absent(),
    this.jarvisName = const Value.absent(),
    this.personalityPrompt = const Value.absent(),
    this.voiceEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<String>? userName,
    Expression<String>? jarvisName,
    Expression<String>? personalityPrompt,
    Expression<bool>? voiceEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userName != null) 'user_name': userName,
      if (jarvisName != null) 'jarvis_name': jarvisName,
      if (personalityPrompt != null) 'personality_prompt': personalityPrompt,
      if (voiceEnabled != null) 'voice_enabled': voiceEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? userName,
    Value<String>? jarvisName,
    Value<String>? personalityPrompt,
    Value<bool>? voiceEnabled,
    Value<int>? rowid,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      jarvisName: jarvisName ?? this.jarvisName,
      personalityPrompt: personalityPrompt ?? this.personalityPrompt,
      voiceEnabled: voiceEnabled ?? this.voiceEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (jarvisName.present) {
      map['jarvis_name'] = Variable<String>(jarvisName.value);
    }
    if (personalityPrompt.present) {
      map['personality_prompt'] = Variable<String>(personalityPrompt.value);
    }
    if (voiceEnabled.present) {
      map['voice_enabled'] = Variable<bool>(voiceEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userName: $userName, ')
          ..write('jarvisName: $jarvisName, ')
          ..write('personalityPrompt: $personalityPrompt, ')
          ..write('voiceEnabled: $voiceEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $LongTermMemoryTable longTermMemory = $LongTermMemoryTable(this);
  late final $TemporaryMemoryTable temporaryMemory = $TemporaryMemoryTable(
    this,
  );
  late final $ConversationHistoryTable conversationHistory =
      $ConversationHistoryTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tasks,
    routines,
    longTermMemory,
    temporaryMemory,
    conversationHistory,
    userSettings,
  ];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<bool> isCompleted,
      Value<int> priority,
      Value<DateTime> createdAt,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> description,
      Value<DateTime?> dueDate,
      Value<bool> isCompleted,
      Value<int> priority,
      Value<DateTime> createdAt,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                isCompleted: isCompleted,
                priority: priority,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                title: title,
                description: description,
                dueDate: dueDate,
                isCompleted: isCompleted,
                priority: priority,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableCreateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      required String dayOfWeek,
      required int wakeUpTime,
      Value<int?> leaveHomeTime,
      Value<String?> notes,
    });
typedef $$RoutinesTableUpdateCompanionBuilder =
    RoutinesCompanion Function({
      Value<int> id,
      Value<String> dayOfWeek,
      Value<int> wakeUpTime,
      Value<int?> leaveHomeTime,
      Value<String?> notes,
    });

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
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

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeUpTime => $composableBuilder(
    column: $table.wakeUpTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveHomeTime => $composableBuilder(
    column: $table.leaveHomeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
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

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeUpTime => $composableBuilder(
    column: $table.wakeUpTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveHomeTime => $composableBuilder(
    column: $table.leaveHomeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get wakeUpTime => $composableBuilder(
    column: $table.wakeUpTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leaveHomeTime => $composableBuilder(
    column: $table.leaveHomeTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dayOfWeek = const Value.absent(),
                Value<int> wakeUpTime = const Value.absent(),
                Value<int?> leaveHomeTime = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                dayOfWeek: dayOfWeek,
                wakeUpTime: wakeUpTime,
                leaveHomeTime: leaveHomeTime,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dayOfWeek,
                required int wakeUpTime,
                Value<int?> leaveHomeTime = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                dayOfWeek: dayOfWeek,
                wakeUpTime: wakeUpTime,
                leaveHomeTime: leaveHomeTime,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$LongTermMemoryTableCreateCompanionBuilder =
    LongTermMemoryCompanion Function({
      Value<int> id,
      required String category,
      required String content,
      Value<String?> source,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
    });
typedef $$LongTermMemoryTableUpdateCompanionBuilder =
    LongTermMemoryCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<String> content,
      Value<String?> source,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
    });

class $$LongTermMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $LongTermMemoryTable> {
  $$LongTermMemoryTableFilterComposer({
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LongTermMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $LongTermMemoryTable> {
  $$LongTermMemoryTableOrderingComposer({
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LongTermMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $LongTermMemoryTable> {
  $$LongTermMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$LongTermMemoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LongTermMemoryTable,
          LongTermMemoryData,
          $$LongTermMemoryTableFilterComposer,
          $$LongTermMemoryTableOrderingComposer,
          $$LongTermMemoryTableAnnotationComposer,
          $$LongTermMemoryTableCreateCompanionBuilder,
          $$LongTermMemoryTableUpdateCompanionBuilder,
          (
            LongTermMemoryData,
            BaseReferences<
              _$AppDatabase,
              $LongTermMemoryTable,
              LongTermMemoryData
            >,
          ),
          LongTermMemoryData,
          PrefetchHooks Function()
        > {
  $$LongTermMemoryTableTableManager(
    _$AppDatabase db,
    $LongTermMemoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LongTermMemoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LongTermMemoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LongTermMemoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => LongTermMemoryCompanion(
                id: id,
                category: category,
                content: content,
                source: source,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required String content,
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
              }) => LongTermMemoryCompanion.insert(
                id: id,
                category: category,
                content: content,
                source: source,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LongTermMemoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LongTermMemoryTable,
      LongTermMemoryData,
      $$LongTermMemoryTableFilterComposer,
      $$LongTermMemoryTableOrderingComposer,
      $$LongTermMemoryTableAnnotationComposer,
      $$LongTermMemoryTableCreateCompanionBuilder,
      $$LongTermMemoryTableUpdateCompanionBuilder,
      (
        LongTermMemoryData,
        BaseReferences<_$AppDatabase, $LongTermMemoryTable, LongTermMemoryData>,
      ),
      LongTermMemoryData,
      PrefetchHooks Function()
    >;
typedef $$TemporaryMemoryTableCreateCompanionBuilder =
    TemporaryMemoryCompanion Function({
      Value<int> id,
      required String content,
      Value<DateTime> createdAt,
      required DateTime expiresAt,
    });
typedef $$TemporaryMemoryTableUpdateCompanionBuilder =
    TemporaryMemoryCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<DateTime> expiresAt,
    });

class $$TemporaryMemoryTableFilterComposer
    extends Composer<_$AppDatabase, $TemporaryMemoryTable> {
  $$TemporaryMemoryTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TemporaryMemoryTableOrderingComposer
    extends Composer<_$AppDatabase, $TemporaryMemoryTable> {
  $$TemporaryMemoryTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemporaryMemoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemporaryMemoryTable> {
  $$TemporaryMemoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$TemporaryMemoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemporaryMemoryTable,
          TemporaryMemoryData,
          $$TemporaryMemoryTableFilterComposer,
          $$TemporaryMemoryTableOrderingComposer,
          $$TemporaryMemoryTableAnnotationComposer,
          $$TemporaryMemoryTableCreateCompanionBuilder,
          $$TemporaryMemoryTableUpdateCompanionBuilder,
          (
            TemporaryMemoryData,
            BaseReferences<
              _$AppDatabase,
              $TemporaryMemoryTable,
              TemporaryMemoryData
            >,
          ),
          TemporaryMemoryData,
          PrefetchHooks Function()
        > {
  $$TemporaryMemoryTableTableManager(
    _$AppDatabase db,
    $TemporaryMemoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemporaryMemoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemporaryMemoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemporaryMemoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
              }) => TemporaryMemoryCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String content,
                Value<DateTime> createdAt = const Value.absent(),
                required DateTime expiresAt,
              }) => TemporaryMemoryCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                expiresAt: expiresAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TemporaryMemoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemporaryMemoryTable,
      TemporaryMemoryData,
      $$TemporaryMemoryTableFilterComposer,
      $$TemporaryMemoryTableOrderingComposer,
      $$TemporaryMemoryTableAnnotationComposer,
      $$TemporaryMemoryTableCreateCompanionBuilder,
      $$TemporaryMemoryTableUpdateCompanionBuilder,
      (
        TemporaryMemoryData,
        BaseReferences<
          _$AppDatabase,
          $TemporaryMemoryTable,
          TemporaryMemoryData
        >,
      ),
      TemporaryMemoryData,
      PrefetchHooks Function()
    >;
typedef $$ConversationHistoryTableCreateCompanionBuilder =
    ConversationHistoryCompanion Function({
      Value<int> id,
      required String userMessage,
      required String jarvisResponse,
      Value<DateTime> timestamp,
    });
typedef $$ConversationHistoryTableUpdateCompanionBuilder =
    ConversationHistoryCompanion Function({
      Value<int> id,
      Value<String> userMessage,
      Value<String> jarvisResponse,
      Value<DateTime> timestamp,
    });

class $$ConversationHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationHistoryTable> {
  $$ConversationHistoryTableFilterComposer({
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

  ColumnFilters<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jarvisResponse => $composableBuilder(
    column: $table.jarvisResponse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationHistoryTable> {
  $$ConversationHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jarvisResponse => $composableBuilder(
    column: $table.jarvisResponse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationHistoryTable> {
  $$ConversationHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userMessage => $composableBuilder(
    column: $table.userMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get jarvisResponse => $composableBuilder(
    column: $table.jarvisResponse,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ConversationHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationHistoryTable,
          ConversationHistoryData,
          $$ConversationHistoryTableFilterComposer,
          $$ConversationHistoryTableOrderingComposer,
          $$ConversationHistoryTableAnnotationComposer,
          $$ConversationHistoryTableCreateCompanionBuilder,
          $$ConversationHistoryTableUpdateCompanionBuilder,
          (
            ConversationHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ConversationHistoryTable,
              ConversationHistoryData
            >,
          ),
          ConversationHistoryData,
          PrefetchHooks Function()
        > {
  $$ConversationHistoryTableTableManager(
    _$AppDatabase db,
    $ConversationHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConversationHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userMessage = const Value.absent(),
                Value<String> jarvisResponse = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ConversationHistoryCompanion(
                id: id,
                userMessage: userMessage,
                jarvisResponse: jarvisResponse,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userMessage,
                required String jarvisResponse,
                Value<DateTime> timestamp = const Value.absent(),
              }) => ConversationHistoryCompanion.insert(
                id: id,
                userMessage: userMessage,
                jarvisResponse: jarvisResponse,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationHistoryTable,
      ConversationHistoryData,
      $$ConversationHistoryTableFilterComposer,
      $$ConversationHistoryTableOrderingComposer,
      $$ConversationHistoryTableAnnotationComposer,
      $$ConversationHistoryTableCreateCompanionBuilder,
      $$ConversationHistoryTableUpdateCompanionBuilder,
      (
        ConversationHistoryData,
        BaseReferences<
          _$AppDatabase,
          $ConversationHistoryTable,
          ConversationHistoryData
        >,
      ),
      ConversationHistoryData,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> jarvisName,
      Value<String> personalityPrompt,
      Value<bool> voiceEnabled,
      Value<int> rowid,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<String> userName,
      Value<String> jarvisName,
      Value<String> personalityPrompt,
      Value<bool> voiceEnabled,
      Value<int> rowid,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
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

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jarvisName => $composableBuilder(
    column: $table.jarvisName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalityPrompt => $composableBuilder(
    column: $table.personalityPrompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voiceEnabled => $composableBuilder(
    column: $table.voiceEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
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

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jarvisName => $composableBuilder(
    column: $table.jarvisName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalityPrompt => $composableBuilder(
    column: $table.personalityPrompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voiceEnabled => $composableBuilder(
    column: $table.voiceEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get jarvisName => $composableBuilder(
    column: $table.jarvisName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalityPrompt => $composableBuilder(
    column: $table.personalityPrompt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get voiceEnabled => $composableBuilder(
    column: $table.voiceEnabled,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> jarvisName = const Value.absent(),
                Value<String> personalityPrompt = const Value.absent(),
                Value<bool> voiceEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                userName: userName,
                jarvisName: jarvisName,
                personalityPrompt: personalityPrompt,
                voiceEnabled: voiceEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> jarvisName = const Value.absent(),
                Value<String> personalityPrompt = const Value.absent(),
                Value<bool> voiceEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                userName: userName,
                jarvisName: jarvisName,
                personalityPrompt: personalityPrompt,
                voiceEnabled: voiceEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$LongTermMemoryTableTableManager get longTermMemory =>
      $$LongTermMemoryTableTableManager(_db, _db.longTermMemory);
  $$TemporaryMemoryTableTableManager get temporaryMemory =>
      $$TemporaryMemoryTableTableManager(_db, _db.temporaryMemory);
  $$ConversationHistoryTableTableManager get conversationHistory =>
      $$ConversationHistoryTableTableManager(_db, _db.conversationHistory);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
