const cors = require('cors');
const axios = require('axios');
const path = require('path');

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

app.options('*', cors());

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/api/proxy-image', async (req, res) => {
    try {
        const imageUrl = req.query.url;
        const response = await axios.get(imageUrl, { responseType: 'stream' });
        response.data.pipe(res);
    } catch (error) {
        res.status(404).send('Imagen no encontrada');
    }
});

