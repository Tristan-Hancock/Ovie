// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'services/models.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 8103322577343170361),
      name: 'DailyLog',
      lastPropertyId: const obx_int.IdUid(10, 3332677545117055059),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 4469520575293624519),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 728852762639077097),
            name: 'date',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 5616235913222456173),
            name: 'isMenstruation',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5089657807396400141),
            name: 'isCramps',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 1114988423484000034),
            name: 'isAcne',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 2173028839265320495),
            name: 'isHeadaches',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3932562932403258772),
            name: 'emotion',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 1636797345169590122),
            name: 'imagePath',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 2615910110464159976),
            name: 'userId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(1, 2376494571298422472),
            relationTarget: 'User'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 3332677545117055059),
            name: 'textlog',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 5977605681870573576),
      name: 'User',
      lastPropertyId: const obx_int.IdUid(2, 3601453555275491463),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 744991400423971176),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3601453555275491463),
            name: 'userId',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 3085642789460672247),
      name: 'PeriodTracking',
      lastPropertyId: const obx_int.IdUid(4, 6048038955829759117),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7860658927008926697),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1826707580310391581),
            name: 'startDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 301183330042250849),
            name: 'endDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6048038955829759117),
            name: 'userId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(2, 4149379467928489541),
            relationTarget: 'User')
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 4436851435844874837),
      name: 'Prescription',
      lastPropertyId: const obx_int.IdUid(7, 5618768621099066928),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 2277975934152980910),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 4777661131438470645),
            name: 'title',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 1104571044059952679),
            name: 'extractedText',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 161248815512566361),
            name: 'scanDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 7909258149398639928),
            name: 'frequency',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4631217309151812967),
            name: 'startDate',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 5618768621099066928),
            name: 'times',
            type: 30,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(4, 4436851435844874837),
      lastIndexId: const obx_int.IdUid(2, 4149379467928489541),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    DailyLog: obx_int.EntityDefinition<DailyLog>(
        model: _entities[0],
        toOneRelations: (DailyLog object) => [object.user],
        toManyRelations: (DailyLog object) => {},
        getId: (DailyLog object) => object.id,
        setId: (DailyLog object, int id) {
          object.id = id;
        },
        objectToFB: (DailyLog object, fb.Builder fbb) {
          final dateOffset = fbb.writeString(object.date);
          final emotionOffset = fbb.writeString(object.emotion);
          final imagePathOffset = object.imagePath == null
              ? null
              : fbb.writeString(object.imagePath!);
          final textlogOffset =
              object.textlog == null ? null : fbb.writeString(object.textlog!);
          fbb.startTable(11);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, dateOffset);
          fbb.addBool(2, object.isMenstruation);
          fbb.addBool(3, object.isCramps);
          fbb.addBool(4, object.isAcne);
          fbb.addBool(5, object.isHeadaches);
          fbb.addOffset(6, emotionOffset);
          fbb.addOffset(7, imagePathOffset);
          fbb.addInt64(8, object.user.targetId);
          fbb.addOffset(9, textlogOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final dateParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final isMenstruationParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 8, false);
          final isCrampsParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 10, false);
          final isAcneParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 12, false);
          final isHeadachesParam =
              const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false);
          final emotionParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 16, '');
          final textlogParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 22);
          final imagePathParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 18);
          final object = DailyLog(
              id: idParam,
              date: dateParam,
              isMenstruation: isMenstruationParam,
              isCramps: isCrampsParam,
              isAcne: isAcneParam,
              isHeadaches: isHeadachesParam,
              emotion: emotionParam,
              textlog: textlogParam,
              imagePath: imagePathParam);
          object.user.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 20, 0);
          object.user.attach(store);
          return object;
        }),
    User: obx_int.EntityDefinition<User>(
        model: _entities[1],
        toOneRelations: (User object) => [],
        toManyRelations: (User object) => {},
        getId: (User object) => object.id,
        setId: (User object, int id) {
          object.id = id;
        },
        objectToFB: (User object, fb.Builder fbb) {
          final userIdOffset = fbb.writeString(object.userId);
          fbb.startTable(3);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, userIdOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final userIdParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final object = User(id: idParam, userId: userIdParam);

          return object;
        }),
    PeriodTracking: obx_int.EntityDefinition<PeriodTracking>(
        model: _entities[2],
        toOneRelations: (PeriodTracking object) => [object.user],
        toManyRelations: (PeriodTracking object) => {},
        getId: (PeriodTracking object) => object.id,
        setId: (PeriodTracking object, int id) {
          object.id = id;
        },
        objectToFB: (PeriodTracking object, fb.Builder fbb) {
          fbb.startTable(5);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.startDate.millisecondsSinceEpoch);
          fbb.addInt64(2, object.endDate.millisecondsSinceEpoch);
          fbb.addInt64(3, object.user.targetId);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final startDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0));
          final endDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0));
          final object = PeriodTracking(
              id: idParam, startDate: startDateParam, endDate: endDateParam);
          object.user.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.user.attach(store);
          return object;
        }),
    Prescription: obx_int.EntityDefinition<Prescription>(
        model: _entities[3],
        toOneRelations: (Prescription object) => [],
        toManyRelations: (Prescription object) => {},
        getId: (Prescription object) => object.id,
        setId: (Prescription object, int id) {
          object.id = id;
        },
        objectToFB: (Prescription object, fb.Builder fbb) {
          final titleOffset = fbb.writeString(object.title);
          final extractedTextOffset = fbb.writeString(object.extractedText);
          final frequencyOffset = object.frequency == null
              ? null
              : fbb.writeString(object.frequency!);
          final timesOffset = object.times == null
              ? null
              : fbb.writeList(
                  object.times!.map(fbb.writeString).toList(growable: false));
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, titleOffset);
          fbb.addOffset(2, extractedTextOffset);
          fbb.addInt64(3, object.scanDate.millisecondsSinceEpoch);
          fbb.addOffset(4, frequencyOffset);
          fbb.addInt64(5, object.startDate?.millisecondsSinceEpoch);
          fbb.addOffset(6, timesOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final startDateValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 14);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final titleParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final extractedTextParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final scanDateParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final frequencyParam = const fb.StringReader(asciiOptimization: true)
              .vTableGetNullable(buffer, rootOffset, 12);
          final startDateParam = startDateValue == null
              ? null
              : DateTime.fromMillisecondsSinceEpoch(startDateValue);
          final timesParam = const fb.ListReader<String>(
                  fb.StringReader(asciiOptimization: true),
                  lazy: false)
              .vTableGetNullable(buffer, rootOffset, 16);
          final object = Prescription(
              id: idParam,
              title: titleParam,
              extractedText: extractedTextParam,
              scanDate: scanDateParam,
              frequency: frequencyParam,
              startDate: startDateParam,
              times: timesParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [DailyLog] entity fields to define ObjectBox queries.
class DailyLog_ {
  /// See [DailyLog.id].
  static final id =
      obx.QueryIntegerProperty<DailyLog>(_entities[0].properties[0]);

  /// See [DailyLog.date].
  static final date =
      obx.QueryStringProperty<DailyLog>(_entities[0].properties[1]);

  /// See [DailyLog.isMenstruation].
  static final isMenstruation =
      obx.QueryBooleanProperty<DailyLog>(_entities[0].properties[2]);

  /// See [DailyLog.isCramps].
  static final isCramps =
      obx.QueryBooleanProperty<DailyLog>(_entities[0].properties[3]);

  /// See [DailyLog.isAcne].
  static final isAcne =
      obx.QueryBooleanProperty<DailyLog>(_entities[0].properties[4]);

  /// See [DailyLog.isHeadaches].
  static final isHeadaches =
      obx.QueryBooleanProperty<DailyLog>(_entities[0].properties[5]);

  /// See [DailyLog.emotion].
  static final emotion =
      obx.QueryStringProperty<DailyLog>(_entities[0].properties[6]);

  /// See [DailyLog.imagePath].
  static final imagePath =
      obx.QueryStringProperty<DailyLog>(_entities[0].properties[7]);

  /// See [DailyLog.user].
  static final user =
      obx.QueryRelationToOne<DailyLog, User>(_entities[0].properties[8]);

  /// See [DailyLog.textlog].
  static final textlog =
      obx.QueryStringProperty<DailyLog>(_entities[0].properties[9]);
}

/// [User] entity fields to define ObjectBox queries.
class User_ {
  /// See [User.id].
  static final id = obx.QueryIntegerProperty<User>(_entities[1].properties[0]);

  /// See [User.userId].
  static final userId =
      obx.QueryStringProperty<User>(_entities[1].properties[1]);
}

/// [PeriodTracking] entity fields to define ObjectBox queries.
class PeriodTracking_ {
  /// See [PeriodTracking.id].
  static final id =
      obx.QueryIntegerProperty<PeriodTracking>(_entities[2].properties[0]);

  /// See [PeriodTracking.startDate].
  static final startDate =
      obx.QueryDateProperty<PeriodTracking>(_entities[2].properties[1]);

  /// See [PeriodTracking.endDate].
  static final endDate =
      obx.QueryDateProperty<PeriodTracking>(_entities[2].properties[2]);

  /// See [PeriodTracking.user].
  static final user =
      obx.QueryRelationToOne<PeriodTracking, User>(_entities[2].properties[3]);
}

/// [Prescription] entity fields to define ObjectBox queries.
class Prescription_ {
  /// See [Prescription.id].
  static final id =
      obx.QueryIntegerProperty<Prescription>(_entities[3].properties[0]);

  /// See [Prescription.title].
  static final title =
      obx.QueryStringProperty<Prescription>(_entities[3].properties[1]);

  /// See [Prescription.extractedText].
  static final extractedText =
      obx.QueryStringProperty<Prescription>(_entities[3].properties[2]);

  /// See [Prescription.scanDate].
  static final scanDate =
      obx.QueryDateProperty<Prescription>(_entities[3].properties[3]);

  /// See [Prescription.frequency].
  static final frequency =
      obx.QueryStringProperty<Prescription>(_entities[3].properties[4]);

  /// See [Prescription.startDate].
  static final startDate =
      obx.QueryDateProperty<Prescription>(_entities[3].properties[5]);

  /// See [Prescription.times].
  static final times =
      obx.QueryStringVectorProperty<Prescription>(_entities[3].properties[6]);
}
