import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const PlaylistCancion = sequelize.define('PlaylistCancion', {
    id_playlist_cancion: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    id_playlist: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    id_cancion: {
        type: DataTypes.INTEGER,
        allowNull: false
    }
}, {
    tableName: 'playlistcancion',
    timestamps: false
});


export default PlaylistCancion;
