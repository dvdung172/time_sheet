class Employee {
  const Employee({
    required this.position,
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.last_update,
    required this.work_phone,
  });

  final int id;
  final String name;
  final String email;
  final String position;
  final String avatar;
  final String last_update;
  final String work_phone;

  factory Employee.fromJson(Map<String, dynamic> json) {
    try {
      return Employee(
          email: json['work_email'].toString(),
          avatar: json['image_small'].toString(),
          name: json['name'].toString(),
          id: json['id'],
          position: json['department_id'].toString(),
          last_update: json['__last_update'].toString(),
          work_phone: json['work_phone'].toString());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  factory Employee.fromRPC(res) {
    try {
      return Employee(
          email: res['work_email'].toString(),
          avatar: res['image_small'].toString(),
          name: res['name'].toString(),
          id: int.parse(res['id'].toString()),
          position: res['department_id'].toString(),
          last_update: res['__last_update'].toString(),
          work_phone: res['work_phone'].toString());
    } catch (e) {
      print(';;;;;;;;');
      print(e);
      rethrow;
    }
  }

  @override
  String toString() =>
      '$runtimeType {id: $id, username: $name, email: $email, position: $position, avatar: $avatar}';
}
