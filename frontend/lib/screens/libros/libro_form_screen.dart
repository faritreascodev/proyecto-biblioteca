import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/libro.dart';
import '../../services/api_service.dart';

class LibroFormScreen extends StatefulWidget {
  final Libro? libro;

  const LibroFormScreen({super.key, this.libro});

  @override
  State<LibroFormScreen> createState() => _LibroFormScreenState();
}

class _LibroFormScreenState extends State<LibroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _isbnController;
  late TextEditingController _anioController;
  late TextEditingController _editorialController;
  late TextEditingController _descripcionController;
  late TextEditingController _imagenController;

  File? _selectedImage;
  String _imageSource = 'url'; // 'url' or 'device'
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get _isEditing => widget.libro != null;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.libro?.titulo ?? '');
    _autorController = TextEditingController(text: widget.libro?.autor ?? '');
    _isbnController = TextEditingController(text: widget.libro?.isbn ?? '');
    _anioController = TextEditingController(
      text: widget.libro?.anioPublicacion?.toString() ?? '',
    );
    _editorialController = TextEditingController(
      text: widget.libro?.editorial ?? '',
    );
    _descripcionController = TextEditingController(
      text: widget.libro?.descripcion ?? '',
    );
    _imagenController = TextEditingController(text: widget.libro?.imagen ?? '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _isbnController.dispose();
    _anioController.dispose();
    _editorialController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Optimización de tamaño
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imagenController.text = image.path; // Solo para validación no vacía
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<String?> _processImage() async {
    if (_imageSource == 'url') {
      return _imagenController.text.trim().isNotEmpty
          ? _imagenController.text.trim()
          : null;
    } else {
      if (_selectedImage != null) {
        List<int> imageBytes = await _selectedImage!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        // Detectar tipo de imagen (asumimos jpeg/png por ahora)
        return 'data:image/jpeg;base64,$base64Image';
      }
      return null;
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final String? imagenProcesada = await _processImage();

      final libro = Libro(
        id: widget.libro?.id,
        titulo: _tituloController.text.trim(),
        autor: _autorController.text.trim(),
        isbn: _isbnController.text.trim(),
        anioPublicacion: int.tryParse(_anioController.text.trim()),
        editorial: _editorialController.text.trim(),
        descripcion: _descripcionController.text.trim(),
        imagen: imagenProcesada,
      );

      if (_isEditing) {
        await _apiService.updateLibro(widget.libro!.id!, libro);
      } else {
        await _apiService.createLibro(libro);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Libro actualizado exitosamente'
                : 'Libro creado exitosamente',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Libro' : 'Nuevo Libro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // título
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: 'Título *',
                prefixIcon: const Icon(Icons.book),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // autor
            TextFormField(
              controller: _autorController,
              decoration: InputDecoration(
                labelText: 'Autor *',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El autor es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // ISBN
            TextFormField(
              controller: _isbnController,
              decoration: InputDecoration(
                labelText: 'ISBN *',
                prefixIcon: const Icon(Icons.qr_code),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '978-0-123456-78-9',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El ISBN es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // editorial
            TextFormField(
              controller: _editorialController,
              decoration: InputDecoration(
                labelText: 'Editorial *',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La editorial es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // año de publicación
            TextFormField(
              controller: _anioController,
              decoration: InputDecoration(
                labelText: 'Año de Publicación',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '2024',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final anio = int.tryParse(value);
                  if (anio == null ||
                      anio < 1000 ||
                      anio > DateTime.now().year + 1) {
                    return 'Ingrese un año válido';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción *',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Selector de tipo de imagen
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('URL'),
                    value: 'url',
                    groupValue: _imageSource,
                    onChanged: (value) {
                      setState(() {
                        _imageSource = value!;
                        if (_selectedImage != null) {
                          _selectedImage = null;
                          _imagenController.clear();
                        }
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Dispositivo'),
                    value: 'device',
                    groupValue: _imageSource,
                    onChanged: (value) {
                      setState(() {
                        _imageSource = value!;
                        _imagenController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Input según fuente
            if (_imageSource == 'url')
              TextFormField(
                controller: _imagenController,
                decoration: InputDecoration(
                  labelText: 'URL de Imagen',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'https://ejemplo.com/imagen.jpg',
                ),
                keyboardType: TextInputType.url,
                onChanged: (value) => setState(() {}),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Galería'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Cámara'),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Preview
            if (_selectedImage != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else if (_imagenController.text.isNotEmpty && _imageSource == 'url')
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _imagenController.text,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey),
                          Text('URL inválida', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // btn Guardar
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditing ? 'Actualizar' : 'Guardar',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),

            // nota pa campos obligatorios
            Text(
              '* Campos obligatorios',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
