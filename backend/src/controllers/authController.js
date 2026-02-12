const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

const login = async (req, res) => {
    try {
        const { username, password } = req.body;

        // validando campos
        if (!username || !password) {
            return res.status(400).json({
                error: 'Username y password son requeridos'
            });
        }

        // consulta para ver usuario
        const result = await db.query(
            'SELECT * FROM usuarios WHERE username = $1',
            [username]
        );

        if (result.rows.length === 0) {
            return res.status(401).json({
                error: 'Credenciales inválidas'
            });
        }

        const usuario = result.rows[0];

        // validando password
        const passwordValido = await bcrypt.compare(password, usuario.password);

        if (!passwordValido) {
            return res.status(401).json({
                error: 'Credenciales inválidas'
            });
        }

        // generando el JWT
        const token = jwt.sign(
            {
                id: usuario.id,
                username: usuario.username
            },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        );

        res.json({
            message: 'Login exitoso',
            token,
            usuario: {
                id: usuario.id,
                username: usuario.username
            }
        });

    } catch (error) {
        console.error('Error en login:', error);
        res.status(500).json({ error: 'Error en el servidor' });
    }
};

const register = async (req, res) => {
    try {
        const { username, password } = req.body;

        // Validaciones
        if (!username || !password) {
            return res.status(400).json({
                error: 'Username y password son requeridos'
            });
        }

        if (password.length < 8) {
            return res.status(400).json({
                error: 'La contraseña debe tener al menos 8 caracteres'
            });
        }

        // Verificar si el usuario ya existe
        const userExists = await db.query(
            'SELECT * FROM usuarios WHERE username = $1',
            [username]
        );

        if (userExists.rows.length > 0) {
            return res.status(409).json({
                error: 'El nombre de usuario ya está registrado'
            });
        }

        // Hashear contraseña
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insertar usuario
        await db.query(
            'INSERT INTO usuarios (username, password) VALUES ($1, $2)',
            [username, hashedPassword]
        );

        res.status(201).json({
            message: 'Usuario registrado exitosamente'
        });

    } catch (error) {
        console.error('Error en registro:', error);
        res.status(500).json({ error: 'Error en el servidor' });
    }
};

module.exports = { login, register };
