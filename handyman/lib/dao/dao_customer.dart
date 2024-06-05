import 'package:sqflite/sqflite.dart';

import '../entity/customer.dart';
import '../entity/job.dart';
import 'dao.dart';

class DaoCustomer extends Dao<Customer> {
  Future<void> createTable(Database db, int version) async {}

  @override
  Customer fromMap(Map<String, dynamic> map) => Customer.fromMap(map);

  @override
  String get tableName => 'customer';

  Future<Customer?> getByJob(Job? job) async {
    final db = getDb();

    if (job == null) {
      return null;
    }
    final data = await db.rawQuery('''
select j.* 
from job j
join customer c
  on c.id = job.customer_id
where j.id =? 
''', [job.id]);

    return toList(data).first;
  }
}
