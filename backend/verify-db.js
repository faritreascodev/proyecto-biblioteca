const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

async function verifyData() {
    try {
        // Verificar libros
        const libros = await pool.query('SELECT COUNT(*) as total FROM libros');
        console.log('Total de libros:', libros.rows[0].total);

        const librosList = await pool.query('SELECT id, titulo, autor FROM libros ORDER BY id');
        console.log('\nLibros:');
        librosList.rows.forEach(libro => {
            console.log(`  ${libro.id}. ${libro.titulo} - ${libro.autor}`);
        });

        // Verificar estudiantes
        const estudiantes = await pool.query('SELECT COUNT(*) as total FROM estudiantes');
        console.log('\nTotal de estudiantes:', estudiantes.rows[0].total);

        const estudiantesList = await pool.query('SELECT id, nombres, apellidos, cedula FROM estudiantes ORDER BY id');
        console.log('\nEstudiantes:');
        estudiantesList.rows.forEach(est => {
            console.log(`  ${est.id}. ${est.nombres} ${est.apellidos} - CI: ${est.cedula}`);
        });

        await pool.end();
        process.exit(0);
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

verifyData();
