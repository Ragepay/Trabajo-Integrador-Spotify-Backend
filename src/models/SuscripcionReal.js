import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const SuscripcionReal = sequelize.define('SuscripcionReal', {
    id_suscripcion: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    id_usuario: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    fecha_inicio: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    fecha_renovacion: {
        type: DataTypes.DATEONLY,
        allowNull: false
    }
}, {
    tableName: 'suscripcion',
    timestamps: false
});


export default SuscripcionReal;
