const MetodoPago = sequelize.define('MetodoPago', {
  id_datos_pago: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  id_usuario: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  id_tipo_forma_pago: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  cbu: {
    type: DataTypes.STRING(50),
    allowNull: true
  },
  nro_tarjeta: {
    type: DataTypes.STRING(50),
    allowNull: true
  },
  mes_caduca: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  anio_caduca: {
    type: DataTypes.INTEGER,
    allowNull: true
  }
}, {
  tableName: 'datospagousuario',
  timestamps: false,
  hooks: {
    beforeCreate: (metodo) => {
      if (metodo.nro_tarjeta) {
        metodo.nro_tarjeta = metodo.nro_tarjeta.slice(-4); // solo últimos 4 dígitos
      }
    },
    beforeUpdate: (metodo) => {
      if (metodo.nro_tarjeta) {
        metodo.nro_tarjeta = metodo.nro_tarjeta.slice(-4);
      }
    }
  }
});