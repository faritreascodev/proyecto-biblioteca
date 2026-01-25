# Biblioteca API - Backend

API REST para gestión de libros y estudiantes desarrollada con Node.js, Express y PostgreSQL.

## Tecnologías

- **Node.js** v18
- **Express** v5.2
- **PostgreSQL** v15
- **JWT** para autenticación
- **bcryptjs** para hash de contraseñas
- **Docker & Docker Compose** para containerización

## Requisitos previos

- Docker
- Docker Compose
- Node.js 18+ (opcional para desarrollo local)

## Instalación y ejecución

### Con Docker (Recomendado)

```bash
# Clonar el repositorio
git clone https://github.com/faritreascodev/proyecto-biblioteca.git
cd backend

# Levantar servicios
docker-compose up -d --build

# Ver logs
docker-compose logs -f api

# Detener servicios
docker-compose down

# Eliminar volúmenes (resetear base de datos)
docker-compose down -v
```

La API estará disponible en http://localhost:3000

# Sin Docker (Desarrollo local)
# Instalar dependencias
npm install

# Configurar variables de entorno
```
cp .env.example .env
```
Editar .env con tus credenciales

# Ejecutar en modo desarrollo
npm run dev

# Ejecutar en modo producción
npm start

# Variables de entorno
```bash
PORT=xxx
DB_HOST=xxx
DB_PORT=xxx
DB_USER=xxx
DB_PASSWORD=xxx
DB_NAME=biblioteca_db
JWT_SECRET=clvedeljwt
JWT_EXPIRES_IN=24h
```