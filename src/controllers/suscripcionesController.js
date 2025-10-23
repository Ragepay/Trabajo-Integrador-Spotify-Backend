import { SuscripcionReal, Usuario } from "../models/index.js";


// Funcion para buscar todos los Suscripciones.
const getSuscripciones = async (req, res) => {
    try {
        // Obtener todas las suscripciones
        const suscripciones = await SuscripcionReal.findAll({ order: [["id_suscripcion", "ASC"]] });
        
        // Incluir la información del usuario asociado a cada suscripción
        res.status(200).json({
            mensaje: "Suscripciones obtenidas correctamente.",
            suscripciones
        });
    } catch (error) {
        console.error("Error al obtener suscripciones:", error);
        res.status(500).json({ error: "Error al obtener suscripciones." });
    }
};

// Funcion para buscar una suscripcion por ID.
const getSuscripcionById = async (req, res) => {
    try {
        // Obtener el id.
        const { id } = req.params;

        // Buscar la suscripción por ID y vallidar existencia
        const suscripcion = await SuscripcionReal.findByPk(id);
        if (!suscripcion) {
            return res.status(404).json({ error: "Suscripción no encontrada." });
        };

        // Responder con la suscripción encontrada
        res.status(200).json({
            mensaje: "Suscripción encontrada correctamente.", suscripcion
        });

    } catch (error) {
        console.error("Error al obtener suscripción:", error);
        res.status(500).json({ error: "Error al obtener suscripción." });
    }
};

// Funcion para crear una nueva Suscripcion.
const createSuscripcion = async (req, res) => {
    try {
        // Obtener datos del cuerpo
        const { id_usuario, fecha_inicio, fecha_renovacion } = req.body;

        // Validaciones básicas
        if (!id_usuario || !fecha_inicio || !fecha_renovacion) {
            return res.status(400).json({ error: "id_usuario, fecha_inicio y fecha_renovacion son requeridos." });
        }

        // Validar fecha_renovacion > fecha_inicio
        const inicioDate = new Date(fecha_inicio);
        const renovDate = new Date(fecha_renovacion);
        if (isNaN(inicioDate) || isNaN(renovDate)) {
            return res.status(400).json({ error: "Formato de fecha inválido." });
        }
        if (renovDate <= inicioDate) {
            return res.status(400).json({ error: "fecha_renovacion debe ser posterior a fecha_inicio." });
        }

        // Validar existencia de usuario
        const usuarioExiste = await Usuario.findByPk(id_usuario);
        if (!usuarioExiste) {
            return res.status(400).json({ error: "El usuario especificado no existe." });
        }

        // UNIQUE (id_usuario, fecha_inicio)
        const yaExiste = await SuscripcionReal.findOne({ where: { id_usuario, fecha_inicio } });
        if (yaExiste) {
            return res.status(400).json({ error: "Ya existe una suscripción para ese usuario con esa fecha_inicio." });
        }

        // Crear la suscripción
        const nueva = await SuscripcionReal.create({ id_usuario, fecha_inicio, fecha_renovacion });

        // Responder con la nueva suscripción
        res.status(201).json({ mensaje: "Suscripción creada correctamente.", suscripcion: nueva });
    } catch (error) {
        console.error("Error al crear suscripción:", error);
        res.status(500).json({ error: "Error al crear suscripción." });
    }
};

export { getSuscripciones, getSuscripcionById, createSuscripcion };