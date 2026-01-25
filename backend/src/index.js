require('dotenv').config()

const express = require('express');
const cors = require('cors');
const db = require('./config/database')
const authRoutes = require('./routes/auth')
const librosRoutes = require('./routes/libros')
const estudiantesRoutes = require('./routes/estudiantes')

const app = express()
const PORT = process.env.PORT || 3000;

app.use(cors())
app.use(express.json({ limit: '10mb' }))

// consulta de prubas a la bdd
db.query('SELECT NOW()')
    .then(() => console.log('BDD conectada con éxito!'))
    .catch(err => console.error('error al conectarse a la bdd', err))

app.use('/api/auth', authRoutes)
app.use('/api/libros', librosRoutes)
app.use('/api/estudiantes', estudiantesRoutes)

app.get('/api/health', (req, res) => {
    res.json({ estadoApp: 'OK, en operación', detalle: 'API funcionando sin problemas' })
})

// endopints prueba bdd
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

app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto: ${PORT}`);
})