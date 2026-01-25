-- Usuario de prueba: admin / admin123
-- Hash generado con bcrypt (rounds=10)
INSERT INTO usuarios (username, password) 
VALUES ('admin', '$2b$10$geT3ZEaYAf6bugdvbjb7X.40JVJNYvfh7n0ABd.juHwsOwwcyBMvW')
ON CONFLICT (username) DO NOTHING;

-- alguns libros de prueba
INSERT INTO libros (titulo, autor, isbn, anio_publicacion, editorial, descripcion, imagen) VALUES
('Cien años de soledad', 'Gabriel García Márquez', '978-0307474728', 1967, 'Editorial Sudamericana', 'Obra maestra del realismo mágico que narra la historia de la familia Buendía en el pueblo ficticio de Macondo.', 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Cien_a%C3%B1os_de_soledad.png/250px-Cien_a%C3%B1os_de_soledad.png?w=400'),
('Don Quijote de la Mancha', 'Miguel de Cervantes', '978-8491050452', 1605, 'Francisco de Robles', 'Clásico de la literatura española que relata las aventuras del ingenioso hidalgo.', 'https://images-na.ssl-images-amazon.com/images/I/61HOpyVqSeL.jpg?w=400'),
('1984', 'George Orwell', '978-0451524935', 1949, 'Secker & Warburg', 'Novela distópica sobre un futuro totalitario donde el Gran Hermano vigila constantemente.', 'https://upload.wikimedia.org/wikipedia/commons/5/51/1984_first_edition_cover.jpg?w=400'),
('El principito', 'Antoine de Saint-Exupéry', '978-0156012195', 1943, 'Reynal & Hitchcock', 'Cuento poético que narra las aventuras de un pequeño príncipe que visita varios planetas.', 'https://online.fliphtml5.com/ilypf/stri/files/large/1.webp?1601836779?w=400'),
('Rayuela', 'Julio Cortázar', '978-8420471648', 1963, 'Editorial Sudamericana', 'Novela experimental de la literatura latinoamericana con estructura no lineal.', 'https://upload.wikimedia.org/wikipedia/commons/c/ca/Rayuela_JC.png?w=400')
ON CONFLICT (isbn) DO NOTHING;

-- estudiantes de prueba
INSERT INTO estudiantes (cedula, genero, nombres, apellidos, email, telefono, carrera, semestre, imagen) VALUES
('0801234567', 'Masculino', 'Farit Alexander', 'Reasco Torres', 'farit.reasco@pucese.edu.ec', '0987654321', 'Ingeniería de Software', 7, 'https://i.ibb.co/qFhvs8PK/persona1.png'),
('0809876543', 'Femenino', 'Martha Luz', 'Hildebrandt Pérez-Treviño', 'martha.palabra@pucese.edu.ec', '0987654322', 'Licenciatura en Lingüística', 6, 'https://i.ibb.co/d00R7KQG/Martha-Hildebrandt.png'),
('0805551234', 'Masculino', 'Jonathan Joseph', 'García García', 'jonathan.garcia@pucese.edu.ec', '0987654323', 'Ingeniería de Software', 8, 'https://i.ibb.co/RLy4xGG/persona2.jpg'),
('0806667890', 'Femenino', 'Haydée Mercedes', 'Sosa  Sosa', 'cantonra.sosa@pucese.edu.ec', '0987654324', 'Ingeniería de Producción Musical Digital', 5, 'https://i.ibb.co/S7DgrvSf/mercedes-sosa.png'),
('0807778901', 'Masculino', 'Jandry Steven', 'Zambrano Palacios', 'jandry.zam@pucese.edu.ec', '0987654325', 'Ingeniería de Software', 9, 'https://i.ibb.co/s9PH4Lmg/persona3.png')
ON CONFLICT (cedula) DO NOTHING;
