import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const TipoFormaPago = sequelize.define('TipoFormaPago', {
    id_tipo_forma_pago: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    nombre: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true
    }
}, {
    tableName: 'tipoformapago',
    timestamps: false
});


export default TipoFormaPago;
