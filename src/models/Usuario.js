/**
 * Modelo Usuario
 * Los estudiantes deben implementar todas las operaciones CRUD para usuarios
 */

import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

const Usuario = sequelize.define('Usuario', {
    // Atributo: id_usuario
    id_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true,       // Es la clave primaria
        autoIncrement: true,    // Es autoincremental
        allowNull: false        // No puede ser nulo
    },
    // Atributo: usuario
    usuario: {
        type: DataTypes.STRING(50),
        allowNull: false,       // No puede ser nulo
        unique: true            // Debe ser único en la tabla
    },
    // Atributo: nombreCompleto
    nombreCompleto: {
        type: DataTypes.STRING(150),
        allowNull: false        // Se asume que el nombre completo es requerido
    },
    // Atributo: email
    email: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true,
        validate: {
            isEmail: true         // Validación para asegurar que el formato sea de email
        }
    },
    // Atributo: password
    password: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    // Atributo: fecha_modificacion_pass
    fecha_modificacion_pass: {
        type: DataTypes.DATE,   // TIMESTAMP en MySQL se mapea a DATE en Sequelize
        allowNull: true         // Puede ser nulo si nunca se ha modificado la contraseña
    },
    // Atributo: fecha_nacimiento
    fecha_nacimiento: {
        type: DataTypes.DATEONLY, // DATE en MySQL se mapea a DATEONLY para no incluir la hora
        allowNull: true
    },
    // Atributo: sexo
    sexo: {
        type: DataTypes.CHAR(1),
        allowNull: true
    },
    // Atributo: codigo_postal
    codigo_postal: {
        type: DataTypes.STRING(20),
        allowNull: true
    },
    // Atributo: id_pais (clave foránea)
    id_pais: {
        type: DataTypes.INTEGER,
        allowNull: true // o false, dependiendo de tus reglas de negocio
        // Aquí podrías definir la relación con la tabla de Países:
        /*
        references: {
          model: 'Paises', // Nombre del modelo de país
          key: 'id_pais'   // Clave primaria en el modelo de país
        }
        */
    },
    // Atributo: tipo_usuario
    tipo_usuario: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 1 // Se asume un valor por defecto (ej: 1 = usuario estándar)
    }
}, {
    // Opciones adicionales del modelo

    // Nombre exacto de la tabla en la base de datos.
    tableName: 'usuario',

    // Desactiva la creación automática de las columnas 'createdAt' y 'updatedAt'.
    // Tu tabla no las tiene, por lo que es necesario desactivarlas.
    timestamps: false
});

export default Usuario;