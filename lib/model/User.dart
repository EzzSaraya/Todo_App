class MyUser {
  static const String collectionName = 'users';

  String? id;
  String? Name;
  String? email;

  MyUser({required this.id, required this.Name, required this.email});

  Map<String, dynamic> toFireStore() {
    return {'id': id, 'Name': Name, 'email': email};
  }

  MyUser.fromFireStore(Map<String, dynamic>? data)
      : this(
            id: data!['id'] as String?,
            Name: data['Name'] as String?,
            email: data['email'] as String?);
}
