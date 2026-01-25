import 'package:flutter/material.dart';
import '../../models/estudiante.dart';
import '../../services/api_service.dart';
import 'estudiante_detail_screen.dart';
import 'estudiante_form_screen.dart';

class EstudiantesListScreen extends StatefulWidget {
  const EstudiantesListScreen({super.key});

  @override
  State<EstudiantesListScreen> createState() => _EstudiantesListScreenState();
}

class _EstudiantesListScreenState extends State<EstudiantesListScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();

  List<Estudiante> _estudiantes = [];
  List<Estudiante> _estudiantesFiltered = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEstudiantes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEstudiantes() async {
    setState(() => _isLoading = true);
    try {
      final estudiantes = await _apiService.getEstudiantes();
      setState(() {
        _estudiantes = estudiantes;
        _estudiantesFiltered = estudiantes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _filterEstudiantes(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _estudiantesFiltered = _estudiantes;
      } else {
        _estudiantesFiltered = _estudiantes.where((estudiante) {
          return estudiante.nombres.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              estudiante.apellidos.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              estudiante.cedula.contains(query) ||
              estudiante.email.toLowerCase().contains(query.toLowerCase()) ||
              estudiante.carrera.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _deleteEstudiante(Estudiante estudiante) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar estudiante'),
        content: Text(
          '¿Está seguro de eliminar a "${estudiante.nombreCompleto}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _apiService.deleteEstudiante(estudiante.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudiante eliminado exitosamente')),
      );
      _loadEstudiantes();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudiantes'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterEstudiantes,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, cédula, email o carrera',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterEstudiantes('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // listado de estudiantes
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _estudiantesFiltered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No hay estudiantes registrados'
                              : 'No se encontraron resultados',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadEstudiantes,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _estudiantesFiltered.length,
                      itemBuilder: (context, index) {
                        final estudiante = _estudiantesFiltered[index];
                        return _EstudianteCard(
                          estudiante: estudiante,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EstudianteDetailScreen(
                                  estudiante: estudiante,
                                ),
                              ),
                            );
                            _loadEstudiantes();
                          },
                          onEdit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EstudianteFormScreen(
                                  estudiante: estudiante,
                                ),
                              ),
                            );
                            _loadEstudiantes();
                          },
                          onDelete: () => _deleteEstudiante(estudiante),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EstudianteFormScreen()),
          );
          _loadEstudiantes();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Estudiante'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

// card individual de estudiante
class _EstudianteCard extends StatelessWidget {
  final Estudiante estudiante;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EstudianteCard({
    required this.estudiante,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // avatar del estudiante
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueAccent.shade100,
                backgroundImage:
                    estudiante.imagen != null && estudiante.imagen!.isNotEmpty
                    ? NetworkImage(estudiante.imagen!)
                    : null,
                child: estudiante.imagen == null || estudiante.imagen!.isEmpty
                    ? Text(
                        estudiante.nombres[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // info del estudiante
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estudiante.nombreCompleto,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estudiante.carrera,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'CI: ${estudiante.cedula}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // acciones
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
