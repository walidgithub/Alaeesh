import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/di/di.dart';

abstract class BaseDataSource {
  // Future<List<HomePageModel>> getMine(GetMineRequest getMineRequest);
}

class DashboardDataSource extends BaseDataSource {
  final FirebaseFirestore firestore = sl<FirebaseFirestore>();
}