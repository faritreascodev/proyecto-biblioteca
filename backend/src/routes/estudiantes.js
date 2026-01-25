const express = require('express');
const router = express.Router();
const verificarToken = require('../middleware/authMiddleware');
const {
    obtenerEstudiantes,
    obtenerEstudiantePorId,
    buscarEstudiantes,
    crearEstudiante,
    actualizarEstudiante,
    eliminarEstudiante
} = require('../controllers/estudiantesController');

// Rutas públicas (sin autenticación para lectura)
router.get('/', obtenerEstudiantes);
router.get('/search', buscarEstudiantes);
router.get('/:id', obtenerEstudiantePorId);

// Rutas protegidas (requieren autenticación)
router.post('/', verificarToken, crearEstudiante);
router.put('/:id', verificarToken, actualizarEstudiante);
router.delete('/:id', verificarToken, eliminarEstudiante);

module.exports = router;
