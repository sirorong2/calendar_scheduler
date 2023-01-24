// private 값들은 불러올 수 없다
import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schdule_with_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

//part - private 값까지 불러올 수 있다.
//g - 데이터베이스 생성
part 'drift_database.g.dart'; //아직 존재하지 않는 파일, xxx.g.dart에서 xxx는 현재 파일의 이름

@DriftDatabase(
  tables: [
    //여기에 있는 테이블들 쓸 거라고 드리프트에게 알려주기, 어떤 클래스들을 테이블로 쓸지
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  //_$ - drift가 만들어줌
  LocalDatabase() : super(_openConnection());

  //쿼리는 이안에도 넣어줘도 되지만 따로 빼도 됨

  Future<Schedule> getScheduleById(int id) => (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  //데이터 insert
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  //색 insert
  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  Future<int> removeSchedule(int id) => (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  // Stream<List<Schedule>> watchSchedules(DateTime date) =>
  //     select(schedules).where((tbl) => tbl.date.equals(date)).watch();

  // Stream<List<Schedule>> watchSchedules(DateTime date){
  //   // final query = select(schedules);
  //   // query.where((tbl) => tbl.date.equals(date));
  //   // return query.watch();
  //
  //   return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  // }
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);

    query.where(schedules.date.equals(date));
    query.orderBy([
      OrderingTerm.asc(schedules.startTime),
    ]);

    return query.watch().map(
            (rows) => rows.map(
                    (row) => ScheduleWithColor(
                        schedule: row.readTable(schedules),
                        categoryColor: row.readTable(categoryColors),
                    ),
            ).toList(),
    );
  }

  @override // 데이터베이스 상태의 버전,테이블의 버전이 바뀔때
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
