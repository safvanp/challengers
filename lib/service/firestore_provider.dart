import 'package:challengers/models/admin_model.dart';
import 'package:challengers/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Future addUser(UserModel user) async {
    var id = Uuid();
    String userId = id.v1();
    user.id = userId;
    var ref = _firestore.collection("users").document(userId);
    await ref.setData(user.toMap());
    return user;
  }

  void delete(String id) async {
//    var user = await FirebaseAuthProvider().getCurrentUser();
    _firestore.collection('users').document(id).delete();
  }

  Future getUsers({bloodGroup}) async {
    var docs;
    if (bloodGroup != "All") {
      docs = await _firestore
          .collection('users')
          .where("blood", isEqualTo: bloodGroup)
          .getDocuments();
    } else {
      docs = await _firestore.collection('users').getDocuments();
    }
    return docs.documents
        .map<UserModel>((d) => UserModel.fromMap(d.data))
        .toList();
  }

  Future getUser(String uid) async {
//    var user = await FirebaseAuthProvider().getCurrentUser();
    var doc = await _firestore.collection('users').document(uid).get();
    return UserModel.fromMap(doc.data);
  }

  Future<void> updateUser(UserModel user) async {
//    var userr = await FirebaseAuthProvider().getCurrentUser();
    return await _firestore
        .collection('users')
        .document(user.id)
        .setData(user.toMap(), merge: true);
  }

  //ADMIN

  Future addAdmin(AdminModel admin) async {
    if (admin.name.length > 0) {
      List<AdminModel> adminList;
      getAdmin(admin).then((value) => adminList);
      if (adminList[0].name?.isEmpty ?? true) {
        updateAdmin(admin);
      } else {
        var id = Uuid();
        String userId = id.v1();
        admin.id = userId;
        var ref = _firestore.collection("admin").document(userId);
        await ref.setData(admin.toMap());
      }
    }
    return admin;
  }

  void deleteAdmin(String id) async {
    _firestore.collection('admin').document(id).delete();
  }

  Future getAdmins(String name) async {
    var docs = await _firestore
        .collection('admin')
        .where("name", isEqualTo: name)
        .getDocuments();
    return docs.documents
        .map<AdminModel>((d) => AdminModel.fromMap(d.data))
        .toList();
  }

  Future getAdmin(AdminModel adminModel) async {
    var uid = adminModel.id;
    var doc = await _firestore.collection('admin').document(uid).get();
    return AdminModel.fromMap(doc.data);
  }

  Future<void> updateAdmin(AdminModel admin) async {
    return await _firestore
        .collection('admin')
        .document(admin.id)
        .setData(admin.toMap(), merge: true);
  }
}
