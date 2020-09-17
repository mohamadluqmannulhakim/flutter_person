import 'package:hive/hive.dart';

part 'hive_person.g.dart';

@HiveType(typeId: 0)
class HivePerson {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  HivePerson(this.id, this.name);
}
