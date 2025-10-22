import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const Cancion = sequelize.define('Cancion', {
  id_cancion: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  titulo: {
    type: DataTypes.STRING(200),
    allowNull: false
  },
  duracion: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  reproducciones: {
    type: DataTypes.BIGINT,
    allowNull: false,
    defaultValue: 0
  },
  likes: {
    type: DataTypes.BIGINT,
    allowNull: false,
    defaultValue: 0
  },
  id_album: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
}, {
  tableName: 'cancion',
  timestamps: false
});


export default Cancion;

