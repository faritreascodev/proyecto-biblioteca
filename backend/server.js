const cors = require('cors');

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
