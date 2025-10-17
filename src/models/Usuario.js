import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

const Usuario = sequelize.define('Usuario', {
    id_usuario: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    usuario: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true
    },
    nombreCompleto: {
        type: DataTypes.STRING(150),
        allowNull: false
    },
    email: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true,
        validate: { isEmail: true }
    },
    password: {
        type: DataTypes.STRING(255),
        allowNull: false
    },
    fecha_modificacion_pass: {
        type: DataTypes.DATE,
        allowNull: true
    },
    fecha_nacimiento: {
        type: DataTypes.DATEONLY,
        allowNull: true
    },
    sexo: {
        type: DataTypes.CHAR(1),
        allowNull: true
    },
    codigo_postal: {
        type: DataTypes.STRING(20),
        allowNull: true
    },
    id_pais: {
        type: DataTypes.INTEGER,
        allowNull: true

    },
    tipo_usuario: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 1
    }
}, {
    tableName: 'usuario',
    timestamps: false
});

export default Usuario;