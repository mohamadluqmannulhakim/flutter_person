import 'package:floor/floor.dart';
import 'package:flutter_third_project/floor/person.dart';

@dao
abstract class PersonDao {
  @Query('SELECT * FROM person')
  Future<List<Person>> findAllPersons();

  @Query('SELECT * FROM person WHERE id = :id')
  Stream<Person> findPersonById(int id);

  @insert
  Future<void> insertPerson(Person person);
}
