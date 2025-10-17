import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

const Pago = sequelize.define('Pago', {
    id_pago: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    id_suscripcion: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    fecha_pago: {
        type: DataTypes.DATEONLY,
        allowNull: false
    },
    importe: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    id_datos_pago: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'pagos',
    timestamps: false
});

export default Pago;