import { DataTypes } from 'sequelize';
import sequelize from '../config/database.js'; // ajustá la ruta a tu config real

const Suscripcion = sequelize.define('Suscripcion', {
    id_tipo_usuario: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    }
}, {
    tableName: 'tipousuario',
    timestamps: false
});

export default Suscripcion;