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
        unique: true,
        set(value) {
            if (typeof value === 'string') {
                this.setDataValue('usuario', value.toUpperCase());
            } else {
                this.setDataValue('usuario', value);
            }
        }
    },
    nombreCompleto: {
        type: DataTypes.STRING(150),
        allowNull: false,
        set(value) {
            if (typeof value === 'string') {
                this.setDataValue('nombreCompleto', value.toUpperCase());
            } else {
                this.setDataValue('nombreCompleto', value);
            }
        }
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
        allowNull: false,
        defaultValue: DataTypes.NOW
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
    },
    activo: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
}
}, {
    tableName: 'usuario',
    timestamps: false
});

export default Usuario;