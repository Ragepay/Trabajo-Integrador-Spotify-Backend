import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js'; // ajustá la ruta según tu estructura

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
        type: DataTypes.DATEONLY, // se usa DATEONLY para 'date' en MySQL
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