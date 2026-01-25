class Libro {
  final int? id;
  final String titulo;
  final String autor;
  final String isbn;
  final int? anioPublicacion;
  final String editorial;
  final String descripcion;
  final String? imagen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Libro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.isbn,
    this.anioPublicacion,
    required this.editorial,
    required this.descripcion,
    this.imagen,
    this.createdAt,
    this.updatedAt,
  });

  // de JSON a Libro
  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      isbn: json['isbn'],
      anioPublicacion: json['anio_publicacion'],
      editorial: json['editorial'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // de Libro a JSON, al revés xd
  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'isbn': isbn,
      'anio_publicacion': anioPublicacion,
      'editorial': editorial,
      'descripcion': descripcion,
      'imagen': imagen,
    };
  }

  // copiar con modificaciones
  Libro copyWith({
    int? id,
    String? titulo,
    String? autor,
    String? isbn,
    int? anioPublicacion,
    String? editorial,
    String? descripcion,
    String? imagen,
  }) {
    return Libro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      isbn: isbn ?? this.isbn,
      anioPublicacion: anioPublicacion ?? this.anioPublicacion,
      editorial: editorial ?? this.editorial,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
