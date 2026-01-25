import 'package:flutter/material.dart';
import '../../models/libro.dart';
import '../../services/api_service.dart';
import 'libro_detail_screen.dart';
import 'libro_form_screen.dart';

class LibrosListScreen extends StatefulWidget {
  const LibrosListScreen({super.key});

  @override
  State<LibrosListScreen> createState() => _LibrosListScreenState();
}

class _LibrosListScreenState extends State<LibrosListScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();

  List<Libro> _libros = [];
  List<Libro> _librosFiltered = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLibros();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLibros() async {
    setState(() => _isLoading = true);
    try {
      final libros = await _apiService.getLibros();
      setState(() {
        _libros = libros;
        _librosFiltered = libros;
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

  void _filterLibros(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _librosFiltered = _libros;
      } else {
        _librosFiltered = _libros.where((libro) {
          return libro.titulo.toLowerCase().contains(query.toLowerCase()) ||
              libro.autor.toLowerCase().contains(query.toLowerCase()) ||
              libro.isbn.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<void> _deleteLibro(Libro libro) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar libro'),
        content: Text('¿Está seguro de eliminar "${libro.titulo}"?'),
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
      await _apiService.deleteLibro(libro.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Libro eliminado exitosamente')),
      );
      _loadLibros();
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
        title: const Text('Libros'),
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
              onChanged: _filterLibros,
              decoration: InputDecoration(
                hintText: 'Buscar por título, autor o ISBN',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterLibros('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Lista de libros
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _librosFiltered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No hay libros registrados'
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
                    onRefresh: _loadLibros,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _librosFiltered.length,
                      itemBuilder: (context, index) {
                        final libro = _librosFiltered[index];
                        return _LibroCard(
                          libro: libro,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LibroDetailScreen(libro: libro),
                              ),
                            );
                            _loadLibros();
                          },
                          onEdit: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LibroFormScreen(libro: libro),
                              ),
                            );
                            _loadLibros();
                          },
                          onDelete: () => _deleteLibro(libro),
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
            MaterialPageRoute(builder: (_) => const LibroFormScreen()),
          );
          _loadLibros();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Libro'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

// card de libro
class _LibroCard extends StatelessWidget {
  final Libro libro;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LibroCard({
    required this.libro,
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
              // img del libro
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: libro.imagen != null && libro.imagen!.isNotEmpty
                    ? Image.network(
                        libro.imagen!,
                        width: 60,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
              const SizedBox(width: 12),

              // la info del libro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      libro.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      libro.autor,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ISBN: ${libro.isbn}',
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

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 80,
      color: Colors.grey.shade200,
      child: Icon(Icons.book, color: Colors.grey.shade400, size: 30),
    );
  }
}
