const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

async function initDatabase() {
    try {
        console.log('Conectando a la base de datos...');

        // Leer y ejecutar schema.sql
        const schemaSQL = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
        console.log('Ejecutando schema.sql...');
        await pool.query(schemaSQL);
        console.log('Schema creado exitosamente');

        // Leer y ejecutar data.sql
        const dataSQL = fs.readFileSync(path.join(__dirname, 'data.sql'), 'utf8');
        console.log('Ejecutando data.sql...');
        await pool.query(dataSQL);
        console.log('Datos iniciales insertados exitosamente');

        console.log('Base de datos inicializada correctamente');
        await pool.end();
        process.exit(0);
    } catch (error) {
        console.error('Error al inicializar la base de datos:', error);
        await pool.end();
        process.exit(1);
    }
}

initDatabase();
