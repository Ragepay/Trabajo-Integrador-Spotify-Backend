import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const Artista = sequelize.define('Artista', {
    id_artista: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
    },
    nombre: {
        type: DataTypes.STRING(150),
        allowNull: false
    },
    imagen_url: {
        type: DataTypes.STRING(255),
        allowNull: true,
        validate: {
            isUrl: true
        }
    }
}, {
    tableName: 'artista',
    timestamps: false
});


export default Artista;