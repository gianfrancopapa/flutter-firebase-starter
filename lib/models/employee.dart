class Employee {
  final String id;
  String firstName;
  String lastName;
  String email;
  String avatarAsset;
  int age;
  String phoneNumber;
  String address;
  String description;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarAsset,
    this.age,
    this.phoneNumber,
    this.address,
    this.description,
  });

  static Employee fromJson(Map<String, dynamic> json) => Employee(
      id: json['id'],
      firstName: json['firstName'] ?? 'Gonzalo',
      lastName: json['lastName'] ?? 'LastName',
      email: json['email'] ?? 'employee@somnio.com',
      age: json['age'] ?? 18,
      phoneNumber: json['phoneNumber'] ?? '99999999',
      address: json['address'] ?? 'Address',
      description: json['description'] ?? '-',
      avatarAsset: json['avatarAsset']);

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'avatarAsset': avatarAsset,
        'role': 'user',
        'age': age,
        'address': address,
        'phoneNumber': phoneNumber,
        'description': description,
      };
}
