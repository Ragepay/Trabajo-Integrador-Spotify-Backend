/**
 * Modelo Artista
 * Los estudiantes deben implementar todas las operaciones CRUD para artistas
 */

import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

const Artista = sequelize.define('Artista', {
    // Atributo: id_artista
    id_artista: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    // Atributo: nombre
    nombre: {
        type: DataTypes.STRING(150),
        allowNull: false, // Es una buena práctica asegurar que el artista tenga un nombre.
        unique: true      // Generalmente, el nombre del artista debería ser único.
    },
    // Atributo: imagen_url
    imagen_url: {
        type: DataTypes.STRING(255),
        allowNull: true, // La URL de la imagen podría ser opcional.
        validate: {
            isUrl: true    // Se añade una validación para asegurar que el valor sea una URL válida.
        }
    }
}, {
    // Opciones adicionales del modelo

    // Nombre exacto de la tabla en la base de datos.
    tableName: 'artista',

    // Desactiva la creación automática de las columnas 'createdAt' y 'updatedAt'.
    timestamps: false
});

export default Artista;