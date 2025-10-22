import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const CancionGenero = sequelize.define('CancionGenero', {
    id_cancion_genero: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    id_cancion: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    id_genero: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'canciongenero',
    timestamps: false
});


export default CancionGenero;
