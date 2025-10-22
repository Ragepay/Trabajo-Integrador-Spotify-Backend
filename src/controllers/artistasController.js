import { Artista } from "../models/index.js";


// Funcion para buscar todos los Artistas.
const getAllArtistas = async (req, res) => {
    try {
        // Obtengo page y limit desde query, con valores por defecto
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 20;

        // Calculo el offset
        const offset = (page - 1) * limit;

        // Consulta con Sequelize
        const artistas = await Artista.findAll({
            limit,   // cuántos registros
            offset   // desde dónde empezar
        });

        const total = await Artista.count(); // total de registros

        // Respuesta paginada
        res.status(200).json({
            mensaje: "Artistas encontrados correctamente.",
            page,
            limit,
            total,
            totalPages: Math.ceil(total / limit),
            artistas
        });
    } catch (error) {
        console.error("Error al obtener los artistas:", error);
        return res.status(500).json({ error: "Error al obtener todos los artistas." });
    }
}
// Funcion para buscar un Artista por ID.
const getArtistaById = async (req, res) => {
    try {
        // Se obtiene el id del Artista desde los parametros de la URL.
        const { id } = req.params;

        // Se busca el Artista por su ID en la base de datos.
        const artista = await Artista.findByPk(id);

        // Si no se encuentra el Artista, se devuelve un error 404.
        if (!artista) {
            return res.status(404).json({ error: "Artista no encontrado" });
        }

        // Mensaje y respuesta exitosa.
        const mensaje = "Artista encontrado correctamente.";

        // Response.
        res.status(200).json({ mensaje, artista });
    } catch (error) {
        console.error("Error al obtener el artista:", error);
        return res.status(500).json({ error: "Error al obtener el artista." });
    }
}
// Funcion para crear un nuevo Artista.
const createArtista =async (req, res) => {
    try {
        // Se obtienen los datos del nuevo Artista desde el cuerpo de la solicitud.
        const { nombre } = req.body;

        // Validación básica de campos obligatorios
        if (!nombre) {
            return res.status(400).json({ error: "nombre es requerido." });
        }

        // obtencion del artista existente por nombre
        const artistaExistente = await Artista.findOne({ where: { nombre } });

        // Validacion de nombre unico
        if (artistaExistente) {
            return res.status(400).json({ error: "El nombre ya está registrado." });
        }

        // Crear el artista
        const nuevoArtista = await Artista.create({ nombre });
        
        // Response exitosa.
        res.status(201).json({
            mensaje: "Artista creado correctamente.",
            artista: nuevoArtista
        });
    } catch (error) {
        console.error("Error al crear el artista:", error);
        return res.status(500).json({ error: "Error al crear el artista." });
    }
}


export { getAllArtistas, getArtistaById, createArtista };