require('dotenv').config()

const express = require('express');
const cors = require('cors');
const axios = require('axios');
const path = require('path');
const db = require('./config/database')
const authRoutes = require('./routes/auth')
const librosRoutes = require('./routes/libros')
const estudiantesRoutes = require('./routes/estudiantes')

const app = express()
const PORT = process.env.PORT || 3000;

// CORS
app.use(cors({
    origin: [
        'http://localhost:3000',
        'http://localhost:8080',
        'https://biblioteca-flutter.vercel.app',
        'https://*.vercel.app'
    ],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
}));

app.use(express.json({ limit: '50mb' }))

// Servir archivos estáticos (landing page y APK)
app.use(express.static(path.join(__dirname, '../public')));

// Ruta raíz - Landing page
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '../public', 'index.html'));
});

// Proxy de imágenes
app.get('/api/proxy-image', async (req, res) => {
    try {
        const imageUrl = req.query.url;
        const response = await axios.get(imageUrl, { responseType: 'stream' });
        response.data.pipe(res);
    } catch (error) {
        res.status(404).send('Imagen no encontrada');
    }
});

// consulta de pruebas a la bdd
db.query('SELECT NOW()')
    .then(() => console.log('BDD conectada con éxito!'))
    .catch(err => console.error('error al conectarse a la bdd', err))

// Rutas de API
app.use('/api/auth', authRoutes)
app.use('/api/libros', librosRoutes)
app.use('/api/estudiantes', estudiantesRoutes)

app.get('/api/health', (req, res) => {
    res.json({ estadoApp: 'OK, en operación', detalle: 'API funcionando sin problemas' })
})

// endpoints prueba bdd
app.get('/api/prueba-db', async (req, res) => {
    try {
        const result = await db.query('SELECT COUNT(*) FROM libros');
        res.json({
            message: 'Conexión exitosa',
            total_libros: result.rows[0].count
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});
