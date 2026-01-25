import 'package:flutter/material.dart';
import '../../models/libro.dart';
import 'libro_form_screen.dart';

class LibroDetailScreen extends StatelessWidget {
  final Libro libro;

  const LibroDetailScreen({super.key, required this.libro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Libro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LibroFormScreen(libro: libro),
                ),
              );
            },
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen del libro
            if (libro.imagen != null && libro.imagen!.isNotEmpty)
              Hero(
                tag: 'libro_${libro.id}',
                child: Image.network(
                  libro.imagen!,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(),
                ),
              )
            else
              _buildPlaceholder(),

            // Información del libro
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    libro.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Autor
                  Row(
                    children: [
                      Icon(Icons.person, size: 20, color: Colors.grey.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          libro.autor,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const Divider(),
                  const SizedBox(height: 16),

                  // Información adicional
                  _InfoRow(
                    icon: Icons.qr_code,
                    label: 'ISBN',
                    value: libro.isbn,
                  ),
                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.business,
                    label: 'Editorial',
                    value: libro.editorial,
                  ),
                  const SizedBox(height: 12),

                  if (libro.anioPublicacion != null)
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Año de Publicación',
                      value: libro.anioPublicacion.toString(),
                    ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Descripción
                  const Text(
                    'Descripción',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    libro.descripcion,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 300,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(Icons.book, size: 100, color: Colors.grey.shade400),
      ),
    );
  }
}

// widget para filas de información
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
