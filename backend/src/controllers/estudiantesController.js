module.exports = {}; const db = require('../config/database');

// ver todos los estudiantes
const obtenerEstudiantes = async (req, res) => {
    try {
        const result = await db.query(
            'SELECT * FROM estudiantes ORDER BY id DESC'
        );
        res.json(result.rows);
    } catch (error) {
        console.error('Error al obtener estudiantes:', error);
        res.status(500).json({ error: 'Error al obtener estudiantes' });
    }
};

// ver un estudiante por ID
const obtenerEstudiantePorId = async (req, res) => {
    try {
        const { id } = req.params;
        const result = await db.query(
            'SELECT * FROM estudiantes WHERE id = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Estudiante no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error al obtener estudiante:', error);
        res.status(500).json({ error: 'Error al obtener estudiante' });
    }
};

// buscar o filtrar estudiantes
const buscarEstudiantes = async (req, res) => {
    try {
        const { q } = req.query;

        if (!q) {
            return res.status(400).json({ error: 'Parámetro de búsqueda requerido' });
        }

        const result = await db.query(
            `SELECT * FROM estudiantes 
       WHERE nombres ILIKE $1 
       OR apellidos ILIKE $1 
       OR cedula ILIKE $1 
       OR email ILIKE $1
       OR carrera ILIKE $1
       ORDER BY id DESC`,
            [`%${q}%`]
        );

        res.json(result.rows);
    } catch (error) {
        console.error('Error al buscar estudiantes:', error);
        res.status(500).json({ error: 'Error al buscar estudiantes' });
    }
};

// creando nuevo estudiante
const crearEstudiante = async (req, res) => {
    try {
        const { cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen } = req.body;

        // Validaciones
        if (!cedula || !genero || !nombres || !apellidos || !email || !telefono || !carrera) {
            return res.status(400).json({
                error: 'Todos los campos obligatorios deben ser proporcionados'
            });
        }

        const result = await db.query(
            `INSERT INTO estudiantes (cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
            [cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen]
        );

        res.status(201).json({
            message: 'Estudiante creado exitosamente',
            estudiante: result.rows[0]
        });
    } catch (error) {
        console.error('Error al crear estudiante:', error);

        if (error.code === '23505') { // Unique violation
            if (error.constraint === 'estudiantes_cedula_key') {
                return res.status(409).json({ error: 'La cédula ya existe' });
            }
            if (error.constraint === 'estudiantes_email_key') {
                return res.status(409).json({ error: 'El email ya existe' });
            }
        }

        res.status(500).json({ error: 'Error al crear estudiante' });
    }
};

// para actualizar estudiante
const actualizarEstudiante = async (req, res) => {
    try {
        const { id } = req.params;
        const { cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen } = req.body;

        // Verificar que el estudiante existe
        const estudianteExiste = await db.query('SELECT * FROM estudiantes WHERE id = $1', [id]);

        if (estudianteExiste.rows.length === 0) {
            return res.status(404).json({ error: 'Estudiante no encontrado' });
        }

        const result = await db.query(
            `UPDATE estudiantes 
            SET cedula = $1, genero = $2, nombres = $3, apellidos = $4, 
                email = $5, telefono = $6, carrera = $7, semestre = $8, 
                imagen = $9, updated_at = CURRENT_TIMESTAMP
            WHERE id = $10
            RETURNING *`,
            [cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen, id]
        );

        res.json({
            message: 'Estudiante actualizado exitosamente',
            estudiante: result.rows[0]
        });
    } catch (error) {
        console.error('Error al actualizar estudiante:', error);

        if (error.code === '23505') {
            if (error.constraint === 'estudiantes_cedula_key') {
                return res.status(409).json({ error: 'La cédula ya existe' });
            }
            if (error.constraint === 'estudiantes_email_key') {
                return res.status(409).json({ error: 'El email ya existe' });
            }
        }

        res.status(500).json({ error: 'Error al actualizar estudiante' });
    }
};

// para eliminar estudiante
const eliminarEstudiante = async (req, res) => {
    try {
        const { id } = req.params;

        const result = await db.query(
            'DELETE FROM estudiantes WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Estudiante no encontrado' });
        }

        res.json({
            message: 'Estudiante eliminado exitosamente',
            estudiante: result.rows[0]
        });
    } catch (error) {
        console.error('Error al eliminar estudiante:', error);
        res.status(500).json({ error: 'Error al eliminar estudiante' });
    }
};

module.exports = {
    obtenerEstudiantes,
    obtenerEstudiantePorId,
    buscarEstudiantes,
    crearEstudiante,
    actualizarEstudiante,
    eliminarEstudiante
};
