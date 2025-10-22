import 'package:drift/drift.dart';
import 'package:strop_app_v2/core/database/database_connection.dart';

part 'app_database.g.dart';

// SOLUCIÓN: Con esta anotación, le decimos a Drift que la clase de datos
// que genere se llame 'ProjectData' para evitar el conflicto con tu clase 'Project'.
@DataClassName('ProjectData')
class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get location => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  
  // Campos para sincronización offline/online
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastModifiedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('IncidentData')
class Incidents extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get description => text()();
  TextColumn get author => text()();
  DateTimeColumn get reportedDate => dateTime()();
  TextColumn get status => text()(); // 'open', 'assigned', 'closed'
  TextColumn get imageUrls => text().withDefault(const Constant('[]'))(); // JSON array string
  TextColumn get assignedTo => text().nullable()();
  TextColumn get assignedToId => text().nullable()();
  TextColumn get closingNote => text().nullable()();
  
  // Campos para sincronización offline/online
  BoolColumn get pendingSync => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastModifiedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Projects, Incidents])
class AppDatabase extends _$AppDatabase {
  AppDatabase._(super.e);

  static Future<AppDatabase> create() async {
    final executor = await createQueryExecutor();
    return AppDatabase._(executor);
  }

  @override
  int get schemaVersion => 3;
  
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migración de versión 1 a 2: agregar campos de sincronización a Projects
      if (from < 2) {
        try {
          await m.addColumn(projects, projects.pendingSync);
          await m.addColumn(projects, projects.createdAt);
          await m.addColumn(projects, projects.lastModifiedAt);
          await m.addColumn(projects, projects.syncedAt);
        } catch (e) {
          print('⚠️ Columnas de sincronización de Projects ya existen, omitiendo migración');
        }
      }
      
      // Migración de versión 2 a 3: crear tabla Incidents
      if (from < 3) {
        try {
          await m.createTable(incidents);
          print('✓ Tabla Incidents creada exitosamente');
        } catch (e) {
          print('⚠️ Tabla Incidents ya existe, omitiendo migración: $e');
        }
      }
    },
  );
}