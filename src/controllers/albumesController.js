import { Album, Cancion, Artista } from "../models/index.js";


// Funcion para buscar todos los Albumes o por artistaId.
const getAlbumsByArtist = async (req, res) => {
    try {
        // Filtros opcionales
        const { artistaId } = req.query;

        // Solo filtra si se pasa artistaId
        const where = {};
        if (artistaId) where.id_artista = artistaId;

        // Obtener información del artista si se filtra por artistaId
        const artista = await Artista.findByPk(artistaId);

        // Realizar la consulta con inclusión del artista
        const albumes = await Album.findAll({ where });

        // Responder con artista y álbumes
        res.status(200).json({ artista, albumes });
    } catch (error) {
        console.error("Error al obtener álbumes:", error);
        res.status(500).json({ error: "Error al obtener álbumes." });
    }
}
// Funcion para buscar un Album por ID.
const getAlbumById = async (req, res) => {
    try {
        // Obtener el ID del álbum desde los parámetros de la solicitud
        const { id } = req.params;

        // Buscar el álbum por su ID
        const album = await Album.findByPk(id);

        // Si no se encuentra el álbum, responder con error 404
        if (!album) {
            return res.status(404).json({ error: "Álbum no encontrado." });
        }

        // Responder con los datos del álbum
        res.status(200).json({
            mensaje: "Álbum encontrado correctamente.",
            album
        });
    } catch (error) {
        console.error("Error al obtener el álbum:", error);
        res.status(500).json({ error: "Error al obtener el álbum." });
    }
}
// Funcion para obtener las canciones de un álbum por ID de álbum.
const getSongsByAlbumId = async (req, res) => {
    try {
        // Obtener el ID del álbum desde los parámetros de la solicitud
        const { id } = req.params;

        // Verificar si el álbum existe
        const album = await Album.findByPk(id);
        if (!album) {
            return res.status(404).json({ error: "Álbum no encontrado." });
        }

        // Obtener las canciones del álbum
        const canciones = await Cancion.findAll({
            where: { id_album: id }
        });

        // Responder con los datos del álbum
        res.status(200).json({
            mensaje: "Álbum encontrado correctamente.",
            album: album.titulo,
            canciones
        });
    } catch (error) {
        console.error("Error al obtener canciones del álbum:", error);
        res.status(500).json({ error: "Error al obtener canciones del álbum." });
    }
}
// Funcion para crear un nuevo Album.
const createAlbum = async (req, res) => {
    try {
        // Obtener los datos del nuevo álbum desde el cuerpo de la solicitud
        const { titulo, id_artista } = req.body;

        // Validar campos requeridos
        if (!titulo || !id_artista) {
            return res.status(400).json({ error: "Título e id_artista son requeridos." });
        }

        // Validar UNIQUE (id_artista, titulo)
        const existente = await Album.findOne({
            where: { id_artista, titulo },
        });

        // Si ya existe un álbum con ese título para el mismo artista, devolver error
        if (existente) {
            return res.status(400).json({
                error: "Ya existe un álbum con ese título para este artista.",
            });
        }

        // Crear el nuevo álbum
        const nuevoAlbum = await Album.create(req.body);

        // Responder con el nuevo álbum creado
        res.status(201).json({
            mensaje: "Álbum creado correctamente.",
            nuevoAlbum
        });
    } catch (error) {
        console.error("Error al crear el álbum:", error);
        res.status(500).json({ error: "Error al crear el álbum." });
    }
}


export { getAlbumsByArtist, getAlbumById, getSongsByAlbumId, createAlbum };