import { Pago, SuscripcionReal, DatosPagoUsuario, Usuario } from "../models/index.js";
import { Op } from "sequelize";


// Funcion para buscar todos los Pagos.
const getPagos = async (req, res) => {
    try {
        // Obtener parámetros de consulta
        const { usuarioId, desde, hasta } = req.query;

        // Construir filtro de fecha
        const where = {};
        if (desde || hasta) {
            where.fecha_pago = {};
            if (desde) where.fecha_pago[Op.gte] = desde;
            if (hasta) where.fecha_pago[Op.lte] = hasta;
        }

        // Filtrar por usuario (vía suscripción)
        const include = [];
        if (usuarioId) {
            include.push({
                model: SuscripcionReal,
                as: 'suscripcion',
                where: { id_usuario: usuarioId },
                attributes: []
            });
        }

        // Obtener los pagos con filtros aplicados
        const pagos = await Pago.findAll({ where, include, order: [["id_pago", "ASC"]] });

        // Responder con los pagos encontrados
        res.status(200).json({
            mensaje: "Pagos obtenidos correctamente.", pagos
        });
    } catch (error) {
        console.error("Error al obtener pagos:", error);
        res.status(500).json({ error: "Error al obtener pagos." });
    }
};

// Funcion para crear un nuevo Pago.
const createPago = async (req, res) => {
    try {
        const { id_suscripcion, id_datos_pago, fecha_pago, importe } = req.body;

        // Validaciones básicas
        if (!id_suscripcion || !id_datos_pago || !fecha_pago || importe === undefined) {
            return res.status(400).json({ error: "id_suscripcion, id_datos_pago, fecha_pago e importe son requeridos." });
        }

        // Validar importe > 0
        if (isNaN(importe) || Number(importe) <= 0) {
            return res.status(400).json({ error: "importe debe ser un número mayor a 0." });
        }

        // Validar que la suscripción existe
        const suscripcion = await SuscripcionReal.findByPk(id_suscripcion);
        if (!suscripcion) {
            return res.status(400).json({ error: "Suscripción no encontrada." });
        }

        // Validar método de pago
        const metodo = await DatosPagoUsuario.findByPk(id_datos_pago);
        if (!metodo) {
            return res.status(400).json({ error: "Método de pago no encontrado." });
        }

        // Validar que el método de pago pertenezca al mismo usuario de la suscripción
        if (metodo.id_usuario !== suscripcion.id_usuario) {
            return res.status(400).json({ error: "El método de pago no pertenece al usuario de la suscripción." });
        }

        // Crear el nuevo pago
        const nuevo = await Pago.create({
            id_suscripcion,
            id_datos_pago,
            fecha_pago,
            importe
        });

        // Responder con el nuevo pago creado
        res.status(201).json({
            mensaje: "Pago registrado correctamente.", pago: nuevo
        });
    } catch (error) {
        console.error("Error al crear pago:", error);
        res.status(500).json({ error: "Error al crear pago." });
    }
};


export { getPagos, createPago };