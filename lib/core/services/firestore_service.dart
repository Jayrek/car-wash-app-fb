import 'package:car_wash_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service.g.dart';

@riverpod
FirebaseFirestoreService firebaseFirestoreService(Ref ref) {
  return FirebaseFirestoreService();
}

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUser(String docId) async {
    final user = await _firestore.collection('users').doc(docId).get();
    return user.data() != null
        ? UserModel.fromJson(user.data() as Map<String, dynamic>)
        : null;
  }
}
