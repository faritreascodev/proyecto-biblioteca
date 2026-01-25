import 'package:flutter/material.dart';
import '../../models/estudiante.dart';
import 'estudiante_form_screen.dart';

class EstudianteDetailScreen extends StatelessWidget {
  final Estudiante estudiante;

  const EstudianteDetailScreen({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Estudiante'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EstudianteFormScreen(estudiante: estudiante),
                ),
              );
            },
            tooltip: 'Editar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header con foto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.shade400,
                    Colors.blueAccent.shade700,
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        estudiante.imagen != null &&
                            estudiante.imagen!.isNotEmpty
                        ? NetworkImage(estudiante.imagen!)
                        : null,
                    child:
                        estudiante.imagen == null || estudiante.imagen!.isEmpty
                        ? Text(
                            estudiante.nombres[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    estudiante.nombreCompleto,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    estudiante.carrera,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // info del estudiante
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información Personal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.badge,
                    label: 'Cédula',
                    value: estudiante.cedula,
                  ),
                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.person,
                    label: 'Género',
                    value: estudiante.genero,
                  ),
                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.email,
                    label: 'Email',
                    value: estudiante.email,
                  ),
                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.phone,
                    label: 'Teléfono',
                    value: estudiante.telefono,
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  const Text(
                    'Información Académica',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _InfoRow(
                    icon: Icons.school,
                    label: 'Carrera',
                    value: estudiante.carrera,
                  ),
                  const SizedBox(height: 12),

                  if (estudiante.semestre != null)
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Semestre',
                      value: '${estudiante.semestre}° Semestre',
                    ),
                ],
              ),
            ),
          ],
        ),
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
