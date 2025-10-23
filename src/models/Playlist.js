import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const Playlist = sequelize.define('Playlist', {
  id_playlist: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  id_usuario: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  titulo: {
    type: DataTypes.STRING(150),
    allowNull: false
  },
  cant_canciones: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  fecha_creacion: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW
  },
  eliminada: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  },
  fecha_eliminacion: {
    type: DataTypes.DATE,
    allowNull: true,
    defaultValue: null
  }
}, {
  tableName: 'playlist',
  timestamps: false,
  validate: {
    softDeleteCheck() {
      if (this.eliminada && this.fecha_eliminacion === null) {
        throw new Error('Si la playlist está eliminada, fecha_eliminacion no puede ser NULL.');
      }
      if (!this.eliminada && this.fecha_eliminacion !== null) {
        throw new Error('Si la playlist está activa, fecha_eliminacion debe ser NULL.');
      }
    }
  }
});


export default Playlist;