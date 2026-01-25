class Estudiante {
  final int? id;
  final String cedula;
  final String genero;
  final String nombres;
  final String apellidos;
  final String email;
  final String telefono;
  final String carrera;
  final int? semestre;
  final String? imagen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Estudiante({
    this.id,
    required this.cedula,
    required this.genero,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.telefono,
    required this.carrera,
    this.semestre,
    this.imagen,
    this.createdAt,
    this.updatedAt,
  });

  // nombre completo
  String get nombreCompleto => '$nombres $apellidos';

  // de JSON a Estudiante
  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      cedula: json['cedula'],
      genero: json['genero'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
      telefono: json['telefono'],
      carrera: json['carrera'],
      semestre: json['semestre'],
      imagen: json['imagen'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // de Estudiante a JSON
  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'genero': genero,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'carrera': carrera,
      'semestre': semestre,
      'imagen': imagen,
    };
  }

  // copiar con modificaciones
  Estudiante copyWith({
    int? id,
    String? cedula,
    String? genero,
    String? nombres,
    String? apellidos,
    String? email,
    String? telefono,
    String? carrera,
    int? semestre,
    String? imagen,
  }) {
    return Estudiante(
      id: id ?? this.id,
      cedula: cedula ?? this.cedula,
      genero: genero ?? this.genero,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      carrera: carrera ?? this.carrera,
      semestre: semestre ?? this.semestre,
      imagen: imagen ?? this.imagen,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
