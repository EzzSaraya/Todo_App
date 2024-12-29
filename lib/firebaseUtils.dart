import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/User.dart';
import 'package:todo_app/model/task.dart';

class FireBaseUtils {
  static CollectionReference<Task> getTaskCollection(String uId) {
    return getUsersCollection()
        .doc(uId)
        .collection(Task
            .collectionName) // get user id doc from users collection and theen create in this document a new collectiobn for the tasks collection
        .withConverter<Task>(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()!),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTaskCollection(uId); // collection
    DocumentReference<Task> taskDoc = taskCollection.doc(); //create doc
    task.id = taskDoc.id; // put id of doc in id of task
    return taskDoc.set(task);
  }

  static Future<void> deletetaskfromFireStore(Task task, String uId) {
    return getTaskCollection(uId).doc(task.id).delete();
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
            fromFirestore: ((snapshot, options) =>
                MyUser.fromFireStore(snapshot.data())),
            toFirestore: (myUser, options) => myUser.toFireStore());
  }

  static Future<void> addUsertoFireStore(MyUser MyUser) {
    return getUsersCollection().doc(MyUser.id).set(MyUser);
  }

  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var querySnapshot = await getUsersCollection().doc(uId).get();
    return querySnapshot.data();
  }

  // static Future<void> updateTaskInFireStore(Task task, String userId) async {
  //   final taskRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('tasks')
  //       .doc(task.id);
  //
  //   // Check if the document exists
  //   final taskSnapshot = await taskRef.get();
  //   if (!taskSnapshot.exists) {
  //     throw Exception('Task not found in Firestore');
  //   }
  //
  //   // Update the document
  //   await taskRef.update({'isDone': task.isDone});
  // }
  static Future<void> updateTaskInFireStore(Task task, String userId) async {
    try {
      final taskRef = getTaskCollection(userId).doc(task.id);

      // Ensure the document exists
      final taskSnapshot = await taskRef.get();
      if (!taskSnapshot.exists) {
        throw Exception('Task not found in Firestore');
      }

      // Update the isDone field
      await taskRef.update({'isDone': task.isDone});
    } catch (e) {
      print('Failed to update task in Firestore: $e');
      throw Exception('Failed to update task');
    }
  }
}
