class Employee {
  final int? id;
  final String name;
  final String position;
   final String joiningDate; 
  final String? endingDate; 

  Employee({this.id, required this.name, required this.position, required this.joiningDate,
    this.endingDate, });

  factory Employee.fromMap(Map<String, dynamic> json) => Employee(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        joiningDate: json['joiningDate'],
        endingDate: json['endingDate'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'joiningDate': joiningDate,
      'endingDate': endingDate,
    };
  }
}
