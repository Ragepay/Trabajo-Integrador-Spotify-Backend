import { DataTypes } from 'sequelize';
import { sequelize } from '../config/database.js';


const DatosPagoUsuario = sequelize.define('DatosPagoUsuario', {
    id_datos_pago: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true
    },
    id_usuario: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    id_tipo_forma_pago: {
        type: DataTypes.INTEGER,
        allowNull: true
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
        beforeCreate: (reg) => {
            if (reg.nro_tarjeta) {
                reg.nro_tarjeta = reg.nro_tarjeta.slice(-4);
            }
        },
        beforeUpdate: (reg) => {
            if (reg.nro_tarjeta) {
                reg.nro_tarjeta = reg.nro_tarjeta.slice(-4);
            }
        }
    }
});


export default DatosPagoUsuario;