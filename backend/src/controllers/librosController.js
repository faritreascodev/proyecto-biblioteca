const db = require('../config/database');

// cargar todos los libros
const obtenerLibros = async (req, res) => {
    try {
        const result = await db.query(
            'SELECT * FROM libros ORDER BY id DESC'
        );
        res.json(result.rows);
    } catch (error) {
        console.error('Error al obtener libros:', error);
        res.status(500).json({ error: 'Error al obtener libros' });
    }
};

// obtener un libro por id
const obtenerLibroPorId = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await db.query(
            'SELECT * FROM libros WHERE id = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Libro no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error al obtener libro:', error);
        res.status(500).json({ error: 'Error al obtener libro' });
    }
};

// buscar o filtrar libros
const buscarLibros = async (req, res) => {
    try {
        const { q } = req.query;

        if (!q) {
            return res.status(400).json({ error: 'Parámetro de búsqueda requerido' });
        }

        const result = await db.query(
            `SELECT * FROM libros 
       WHERE titulo ILIKE $1 
       OR autor ILIKE $1 
       OR isbn ILIKE $1 
       ORDER BY id DESC`,
            [`%${q}%`]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Error al buscar libros:', error);
        res.status(500).json({ error: 'Error al buscar libros' });
    }
};

// nuevo libro
const crearLibro = async (req, res) => {
    try {
        const { titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen } = req.body;

        // Validaciones
        if (!titulo || !autor || !isbn || !editorial || !descripcion) {
            return res.status(400).json({
                error: 'Todos los campos obligatorios deben ser proporcionados'
            });
        }

        const result = await db.query(
            `INSERT INTO libros (titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
            [titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen]
        );

        res.status(201).json({
            message: 'Libro creado exitosamente',
            libro: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear libro:', error);

        if (error.code === '23505') { // Unique violation
            return res.status(409).json({ error: 'El ISBN ya existe' });
        }

        res.status(500).json({ error: 'Error al crear libro' });
    }
};

// para actializar libro
const actualizarLibro = async (req, res) => {
    try {
        const { id } = req.params;
        const { titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen } = req.body;

        // Verificar que el libro existe
        const libroExiste = await db.query('SELECT * FROM libros WHERE id = $1', [id]);

        if (libroExiste.rows.length === 0) {
            return res.status(404).json({ error: 'Libro no encontrado' });
        }

        const result = await db.query(
            `UPDATE libros 
       SET titulo = $1, autor = $2, isbn = $3, anio_publicacion = $4, 
           editorial = $5, descripcion = $6, imagen = $7, updated_at = CURRENT_TIMESTAMP
       WHERE id = $8
       RETURNING *`,
            [titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen, id]
        );

        res.json({
            message: 'Libro actualizado exitosamente',
            libro: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar libro:', error);

        if (error.code === '23505') {
            return res.status(409).json({ error: 'El ISBN ya existe' });
        }

        res.status(500).json({ error: 'Error al actualizar libro' });
    }
};

// para eliminar un libro
const eliminarLibro = async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(
            'DELETE FROM libros WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Libro no encontrado' });
        }

        res.json({
            message: 'Libro eliminado exitosamente',
            libro: result.rows[0]
        });
    } catch (error) {
        console.error('Error al eliminar libro:', error);
        res.status(500).json({ error: 'Error al eliminar libro' });
    }
};

module.exports = {
    obtenerLibros,
    obtenerLibroPorId,
    buscarLibros,
    crearLibro,
    actualizarLibro,
    eliminarLibro
};
