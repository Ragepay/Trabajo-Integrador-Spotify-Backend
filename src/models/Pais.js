import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const Pais = sequelize.define('Pais', {
    id_pais: {
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
    tableName: 'pais',
    timestamps: false
});


export default Pais;
