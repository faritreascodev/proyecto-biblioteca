const jwt = require('jsonwebtoken');

const verificarToken = (req, res, next) => {
    try {
        const authHeader = req.headers['authorization'];

        if (!authHeader) {
            return res.status(401).json({
                error: 'Token no proporcionado'
            });
        }

        // para formato "Bearer TOKEN"
        const token = authHeader.split(' ')[1];

        if (!token) {
            return res.status(401).json({
                error: 'Formato de token inválido'
            });
        }

        // viendo el token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        // agregar info del usuario al request
        req.usuario = decoded;

        next();

    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                error: 'Token expirado'
            });
        }

        return res.status(401).json({
            error: 'Token inválido'
        });
    }
};

module.exports = verificarToken;
