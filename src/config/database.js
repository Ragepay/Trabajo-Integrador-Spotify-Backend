import Sequelize from 'sequelize';
// Importar dotenv para leer variables de entorno.
process.loadEnvFile();
// Configuracion de variables de entorno.
const { DB_NAME, DB_USER, DB_PASSWORD, DB_HOST } = process.env;

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASSWORD, {
    host: DB_HOST,
    dialect: 'mysql',
    logging: false, // Desactiva los logs de SQL en consola
    pool: {
        max: 12,              // máximo de conexiones simultáneas
        min: 0,               // mínimo de conexiones inactivas
        acquire: 30000,       // tiempo máximo (ms) para adquirir una conexión antes de tirar error
        idle: 10000           // tiempo máximo (ms) que una conexión puede estar inactiva antes de ser liberada
    }
});

export { sequelize };