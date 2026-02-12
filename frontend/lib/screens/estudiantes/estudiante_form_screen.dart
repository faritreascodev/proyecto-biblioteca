import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/estudiante.dart';
import '../../services/api_service.dart';

class EstudianteFormScreen extends StatefulWidget {
  final Estudiante? estudiante;

  const EstudianteFormScreen({super.key, this.estudiante});

  @override
  State<EstudianteFormScreen> createState() => _EstudianteFormScreenState();
}

class _EstudianteFormScreenState extends State<EstudianteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _cedulaController;
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _carreraController;
  late TextEditingController _semestreController;
  late TextEditingController _imagenController;

  File? _selectedImage;
  String _imageSource = 'url'; // 'url' or 'device'
  final ImagePicker _picker = ImagePicker();

  String _generoSeleccionado = 'Masculino';
  bool _isLoading = false;
  bool get _isEditing => widget.estudiante != null;

  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _carreras = [
    'Ingeniería de Software',
    'Ingeniería de Sistemas',
    'Ingeniería en Tecnologías de la Información',
    'Ingeniería Civil',
    'Arquitectura',
    'Administración de Empresas',
    'Contabilidad y Auditoría',
    'Derecho',
    'Psicología',
    'Medicina',
    'Enfermería',
  ];

  @override
  void initState() {
    super.initState();
    _cedulaController = TextEditingController(
      text: widget.estudiante?.cedula ?? '',
    );
    _nombresController = TextEditingController(
      text: widget.estudiante?.nombres ?? '',
    );
    _apellidosController = TextEditingController(
      text: widget.estudiante?.apellidos ?? '',
    );
    _emailController = TextEditingController(
      text: widget.estudiante?.email ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.estudiante?.telefono ?? '',
    );
    _carreraController = TextEditingController(
      text: widget.estudiante?.carrera ?? '',
    );
    _semestreController = TextEditingController(
      text: widget.estudiante?.semestre?.toString() ?? '',
    );
    _imagenController = TextEditingController(
      text: widget.estudiante?.imagen ?? '',
    );

    if (widget.estudiante != null) {
      _generoSeleccionado = widget.estudiante!.genero;
    }
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _carreraController.dispose();
    _semestreController.dispose();
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

      final estudiante = Estudiante(
        id: widget.estudiante?.id,
        cedula: _cedulaController.text.trim(),
        genero: _generoSeleccionado,
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        email: _emailController.text.trim(),
        telefono: _telefonoController.text.trim(),
        carrera: _carreraController.text.trim(),
        semestre: int.tryParse(_semestreController.text.trim()),
        imagen: imagenProcesada,
      );

      if (_isEditing) {
        await _apiService.updateEstudiante(widget.estudiante!.id!, estudiante);
      } else {
        await _apiService.createEstudiante(estudiante);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Estudiante actualizado exitosamente'
                : 'Estudiante creado exitosamente',
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
        title: Text(_isEditing ? 'Editar Estudiante' : 'Nuevo Estudiante'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Cédula
            TextFormField(
              controller: _cedulaController,
              decoration: InputDecoration(
                labelText: 'Cédula *',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '0801234567',
              ),
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La cédula es obligatoria';
                }
                if (value.trim().length != 10) {
                  return 'La cédula debe tener 10 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Género
            DropdownButtonFormField<String>(
              value: _generoSeleccionado,
              decoration: InputDecoration(
                labelText: 'Género *',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _generos.map((genero) {
                return DropdownMenuItem(value: genero, child: Text(genero));
              }).toList(),
              onChanged: (value) {
                setState(() => _generoSeleccionado = value!);
              },
            ),
            const SizedBox(height: 16),

            // Nombres
            TextFormField(
              controller: _nombresController,
              decoration: InputDecoration(
                labelText: 'Nombres *',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Los nombres son obligatorios';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Apellidos
            TextFormField(
              controller: _apellidosController,
              decoration: InputDecoration(
                labelText: 'Apellidos *',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Los apellidos son obligatorios';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email *',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'ejemplo@pucese.edu.ec',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El email es obligatorio';
                }
                if (!value.contains('@')) {
                  return 'Ingrese un email válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // fono
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono *',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '0987654321',
              ),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El teléfono es obligatorio';
                }
                if (value.trim().length != 10) {
                  return 'El teléfono debe tener 10 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Carrera
            TextFormField(
              controller: _carreraController,
              decoration: InputDecoration(
                labelText: 'Carrera *',
                prefixIcon: const Icon(Icons.school),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: PopupMenuButton<String>(
                  icon: const Icon(Icons.arrow_drop_down),
                  onSelected: (value) {
                    _carreraController.text = value;
                  },
                  itemBuilder: (context) {
                    return _carreras.map((carrera) {
                      return PopupMenuItem(
                        value: carrera,
                        child: Text(carrera),
                      );
                    }).toList();
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La carrera es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Semestre
            TextFormField(
              controller: _semestreController,
              decoration: InputDecoration(
                labelText: 'Semestre',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: '1 - 10',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final semestre = int.tryParse(value);
                  if (semestre == null || semestre < 1 || semestre > 10) {
                    return 'Ingrese un semestre válido (1-10)';
                  }
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
                  labelText: 'URL de Foto',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'https://ejemplo.com/foto.jpg',
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

            // Preview de imagen
            if (_selectedImage != null)
              Container(
                height: 150,
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
                height: 150,
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

            // Botón Guardar
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

            // nota sobre campos obligatorios
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
