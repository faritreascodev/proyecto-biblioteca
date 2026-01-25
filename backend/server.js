const cors = require('cors');
const axios = require('axios');

app.get('/api/proxy-image', async (req, res) => {
    try {
        const imageUrl = req.query.url;
        const response = await axios.get(imageUrl, { responseType: 'stream' });
        response.data.pipe(res);
    } catch (error) {
        res.status(404).send('Imagen no encontrada');
    }
});

// Configuración de CORS
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

// Manejar preflight requests
app.options('*', cors());
