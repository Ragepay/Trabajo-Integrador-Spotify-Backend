import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const Discografica = sequelize.define('Discografica', {
    id_discografica: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    nombre: {
        type: DataTypes.STRING(100),
        allowNull: false
    },
    id_pais: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'discografica',
    timestamps: false,
    indexes: [
        { unique: true, fields: ['nombre', 'id_pais'] }
    ]
});


export default Discografica;
