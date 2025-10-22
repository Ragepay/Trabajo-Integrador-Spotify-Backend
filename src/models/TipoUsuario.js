import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const TipoUsuario = sequelize.define('TipoUsuario', {
    id_tipo_usuario: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false,
        unique: true
    }
}, {
    tableName: 'tipousuario',
    timestamps: false
});


export default TipoUsuario;