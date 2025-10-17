import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';

const Album = sequelize.define('Album', {
  id_album: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  titulo: {
    type: DataTypes.STRING(200),
    allowNull: false
  },
  portada_url: {
    type: DataTypes.STRING(255),
    allowNull: true
  },
  id_artista: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  id_discografica: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'album',
  timestamps: false
});

export default Album;


