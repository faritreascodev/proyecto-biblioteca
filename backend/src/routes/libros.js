const express = require('express');
const router = express.Router();
const verificarToken = require('../middleware/authMiddleware');
const {
    obtenerLibros,
    obtenerLibroPorId,
    buscarLibros,
    crearLibro,
    actualizarLibro,
    eliminarLibro
} = require('../controllers/librosController');

// rutas públicas (sin autenticación para lectura)
router.get('/', obtenerLibros);
router.get('/search', buscarLibros);
router.get('/:id', obtenerLibroPorId);

// rutas protegidas
router.post('/', verificarToken, crearLibro);
router.put('/:id', verificarToken, actualizarLibro);
router.delete('/:id', verificarToken, eliminarLibro);

module.exports = router;
