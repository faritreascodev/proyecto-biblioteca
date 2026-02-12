import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/libro.dart';
import '../models/estudiante.dart';
import 'auth_service.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String baseUrl = 'https://proyecto-biblioteca-production.up.railway.app/api';
  final AuthService _authService = AuthService();

  // paso de headers con autenticación
  Future<Map<String, String>> _getHeaders({bool needsAuth = false}) async {
    final headers = {'Content-Type': 'application/json'};

    if (needsAuth) {
      final token = await _authService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // LIBROS
  // obtener todos los libros
  Future<List<Libro>> getLibros() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/libros'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Libro.fromJson(json)).toList();
      }
      throw Exception('Error al obtener libros');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // buscar libros
  Future<List<Libro>> searchLibros(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/libros/search?q=$query'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Libro.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al buscar libros: $e');
    }
  }

  // obtener libro por ID
  Future<Libro> getLibro(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/libros/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Libro.fromJson(jsonDecode(response.body));
      }
      throw Exception('Libro no encontrado');
    } catch (e) {
      throw Exception('Error al obtener libro: $e');
    }
  }

  // crear libro
  Future<Libro> createLibro(Libro libro) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/libros'),
        headers: await _getHeaders(needsAuth: true),
        body: jsonEncode(libro.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Libro.fromJson(data['libro']);
      }
      throw Exception('Error al crear libro');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // actualizar libro
  Future<Libro> updateLibro(int id, Libro libro) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/libros/$id'),
        headers: await _getHeaders(needsAuth: true),
        body: jsonEncode(libro.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Libro.fromJson(data['libro']);
      }
      throw Exception('Error al actualizar libro');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // eliminar libro
  Future<void> deleteLibro(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/libros/$id'),
        headers: await _getHeaders(needsAuth: true),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar libro');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ESTUDIANTES
  // obtener todos los estudiantes
  Future<List<Estudiante>> getEstudiantes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiantes'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Estudiante.fromJson(json)).toList();
      }
      throw Exception('Error al obtener estudiantes');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // buscar estudiantes
  Future<List<Estudiante>> searchEstudiantes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiantes/search?q=$query'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Estudiante.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al buscar estudiantes: $e');
    }
  }

  // obtener estudiante por ID
  Future<Estudiante> getEstudiante(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/estudiantes/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Estudiante.fromJson(jsonDecode(response.body));
      }
      throw Exception('Estudiante no encontrado');
    } catch (e) {
      throw Exception('Error al obtener estudiante: $e');
    }
  }

  // crear estudiante
  Future<Estudiante> createEstudiante(Estudiante estudiante) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/estudiantes'),
        headers: await _getHeaders(needsAuth: true),
        body: jsonEncode(estudiante.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Estudiante.fromJson(data['estudiante']);
      }
      throw Exception('Error al crear estudiante');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // actualizar estudiante
  Future<Estudiante> updateEstudiante(int id, Estudiante estudiante) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/estudiantes/$id'),
        headers: await _getHeaders(needsAuth: true),
        body: jsonEncode(estudiante.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Estudiante.fromJson(data['estudiante']);
      }
      throw Exception('Error al actualizar estudiante');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // eliminar estudiante
  Future<void> deleteEstudiante(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/estudiantes/$id'),
        headers: await _getHeaders(needsAuth: true),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar estudiante');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
