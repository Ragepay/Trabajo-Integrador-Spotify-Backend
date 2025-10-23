import { DatosPagoUsuario, Usuario, TipoFormaPago } from "../models/index.js";
import { Op } from "sequelize";


// Función para buscar todos los Métodos de Pago.
const getMetodosPago = async (req, res) => {
    try {
        // Obtener el parámetro de consulta usuarioId si está presente
        const { usuarioId } = req.query;
        const where = {};

        // Filtrar por usuarioId si está presente
        if (usuarioId) where.id_usuario = usuarioId;
        const metodos = await DatosPagoUsuario.findAll({ where, order: [["id_datos_pago", "ASC"]] });

        // Responder con los métodos de pago encontrados
        res.status(200).json({
            mensaje: "Métodos de pago obtenidos correctamente.",
            metodos
        });
    } catch (error) {
        console.error("Error al obtener métodos de pago:", error);
        res.status(500).json({ error: "Error al obtener métodos de pago." });
    }
};

// Funcion para crear un nuevo Método de Pago.
const createMetodoPago = async (req, res) => {
    try {
        // Obtener datos del cuerpo
        const { id_usuario, id_tipo_forma_pago, nro_tarjeta, cbu, mes_caduca, anio_caduca } = req.body;

        // Validaciones básicas
        if (!id_usuario || !id_tipo_forma_pago) {
            return res.status(400).json({ error: "id_usuario e id_tipo_forma_pago son requeridos." });
        }

        // Validar usuario
        const usuario = await Usuario.findByPk(id_usuario);
        if (!usuario) {
            return res.status(400).json({ error: "Usuario no encontrado." });
        }

        // Validar tipo forma pago
        const tipo = await TipoFormaPago.findByPk(id_tipo_forma_pago);
        if (!tipo) {
            return res.status(400).json({ error: "Tipo de forma de pago no encontrado." });
        }

        // Validar tarjeta vs CBU (uno de los dos)
        if (!nro_tarjeta && !cbu) {
            return res.status(400).json({ error: "Debe especificar nro_tarjeta o cbu." });
        }

        // Si es tarjeta validar expiración básica
        if (nro_tarjeta) {
            if (!mes_caduca || !anio_caduca) {
                return res.status(400).json({ error: "mes_caduca y anio_caduca son requeridos para tarjetas." });
            }
        }

        // Validar que no exista un método de pago igual para el usuario
        const metodoPagoExistente = await DatosPagoUsuario.findOne({
            where: {
                id_usuario,
                id_tipo_forma_pago,
                [Op.or]: [
                    { nro_tarjeta: nro_tarjeta.slice(-4) }
                ]
            }
        });
        if (metodoPagoExistente) {
            return res.status(400).json({ error: "Ya existe un método de pago con esos datos." });
        }

        // Crear el método de pago
        const nuevo = await DatosPagoUsuario.create({
            id_usuario,
            id_tipo_forma_pago,
            cbu: cbu || null,
            nro_tarjeta,
            mes_caduca: mes_caduca || null,
            anio_caduca: anio_caduca || null
        });

        // Responder con el nuevo método de pago
        res.status(201).json({
            mensaje: "Método de pago creado correctamente.",
            metodoPago: nuevo
        });
    } catch (error) {
        console.error("Error al crear método de pago:", error);
        res.status(500).json({ error: "Error al crear método de pago." });
    }
};


export { getMetodosPago, createMetodoPago };