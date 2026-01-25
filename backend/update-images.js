const { Pool } = require('pg');

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

async function updateImages() {
    try {
        // Actualizar URLs de imágenes de libros
        await pool.query(`
      UPDATE libros SET imagen = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Cien_a%C3%B1os_de_soledad.png/250px-Cien_a%C3%B1os_de_soledad.png'
      WHERE isbn = '978-0307474728';
    `);

        await pool.query(`
      UPDATE libros SET imagen = 'https://upload.wikimedia.org/wikipedia/commons/5/51/1984_first_edition_cover.jpg'
      WHERE isbn = '978-0451524935';
    `);

        console.log('Imágenes actualizadas exitosamente');
        await pool.end();
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

updateImages();
