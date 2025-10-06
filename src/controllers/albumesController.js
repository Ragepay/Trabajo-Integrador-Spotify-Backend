/**
 * Controlador de Álbumes
 * Los estudiantes deben implementar toda la lógica de negocio para álbumes
 */

//import Album from "../models/Album.js";

const getAllAlbums = async (req, res) => {
    try {
        // LOGICA DE NEGOCIO.
    } catch (error) {
        console.error("Error en el servidor.", error);
        res.status(500).json({ error: "Error al buscar albumes." });
    }
}

export { getAllAlbums };