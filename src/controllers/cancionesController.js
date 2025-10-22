import { Op } from "sequelize";
import { Cancion, Album, Genero, CancionGenero, Artista } from "../models/index.js";


// Función para buscar canciones con filtros opcionales
const getCancionesByFilters = async (req, res) => {
    try {
        const { genero, artistaId, albumId } = req.query;

        // Validar que solo se use UN filtro a la vez
        const filtrosActivos = [genero, artistaId, albumId].filter(f => f !== undefined);
        if (filtrosActivos.length > 1) {
            return res.status(400).json({
                error: "Solo puede usar un filtro a la vez: genero, artistaId o albumId."
            });
        }

        // Variable para almacenar las canciones encontradas
        let canciones;

        // Filtro por Álbum
        if (albumId) {
            canciones = await Cancion.findAll({
                where: { id_album: albumId },
                order: [['id_cancion', 'ASC']]
            });
        }

        // Filtro por Artista 
        else if (artistaId) {
            canciones = await Cancion.findAll({
                include: [
                    {
                        model: Album,
                        as: 'album',
                        where: { id_artista: artistaId },
                        attributes: []
                    }
                ],
                order: [['id_cancion', 'ASC']]
            });
        }


        // Filtro por Género
        else if (genero) {
            canciones = await Cancion.findAll({
                include: [
                    {
                        model: Genero,
                        as: 'generos',
                        where: { nombre: { [Op.like]: `%${genero}%` } },
                        attributes: [], // No incluir datos del género en respuesta
                        through: { attributes: [] }
                    }
                ],
                order: [['id_cancion', 'ASC']]
            });
        }
        // SIN FILTRO: Todas las canciones
        else {
            canciones = await Cancion.findAll({
                order: [['id_cancion', 'ASC']]
            });
        }

        // Si no se encontraron canciones
        if (canciones.length === 0) {
            return res.status(404).json({
                error: "No se encontraron canciones con el filtro especificado."
            });
        }

        res.status(200).json({
            mensaje: "Canciones encontradas correctamente.",
            filtro_usado: genero ? 'genero' + ": " + genero : artistaId ? 'artistaId' + ": " + artistaId : albumId ? 'albumId' + ": " + albumId : 'ninguno',
            total: canciones.length,
            canciones
        });
    } catch (error) {
        console.error("Error al obtener canciones:", error);
        res.status(500).json({ error: "Error al obtener canciones." });
    }
};
// Función para buscar una canción por ID con detalles
const getCancionById = async (req, res) => {
    try {
        // Obtener el ID de la canción desde los parámetros de la URL
        const { id } = req.params;

        // Buscar la canción por su ID incluyendo sus relaciones
        const cancion = await Cancion.findByPk(id, {
            include: [
                {
                    model: Album,
                    as: 'album',
                    attributes: ['id_album', 'titulo'],
                    include: [
                        {
                            model: Artista,
                            as: 'artista',
                            attributes: ['id_artista', 'nombre']
                        }
                    ]
                },
                {
                    model: Genero,
                    as: 'generos',
                    attributes: ['id_genero', 'nombre'],
                    through: { attributes: [] }
                }
            ]
        });

        // Si no se encuentra la canción
        if (!cancion) {
            return res.status(404).json({ error: "Canción no encontrada." });
        }

        // Responder con los detalles de la canción
        res.json({ mensaje: "Canción encontrada correctamente.", cancion });
    } catch (error) {
        console.error("Error al obtener la canción:", error);
        res.status(500).json({ error: "Error al obtener la canción." });
    }
};
// Crear una nueva canción
const createCancion = async (req, res) => {
    try {
        // Obtener los datos de la nueva canción desde el cuerpo de la solicitud
        const { titulo, duracion, id_album, reproducciones, likes } = req.body;

        // Validaciones
        if (!titulo) {
            return res.status(400).json({ error: "El título es requerido." });
        }

        // Validar duración si se proporciona
        if (duracion !== undefined && duracion !== null) {
            if (!Number.isInteger(duracion) || duracion <= 0) {
                return res.status(400).json({ error: "La duración debe ser un entero mayor a 0." });
            }
        }

        // Validar que el álbum exista si se proporciona
        if (id_album) {
            const albumExiste = await Album.findByPk(id_album);
            if (!albumExiste) {
                return res.status(400).json({ error: "El álbum especificado no existe." });
            }
        }

        // Validar que no exista otra canción con el mismo título en el mismo álbum
        const cancionExistente = await Cancion.findOne({
            where: {
                titulo,
                id_album: id_album || null
            }
        });
        if (cancionExistente) {
            return res.status(400).json({ error: "Ya existe una canción con el mismo título en el álbum especificado." });
        }

        // Crear la nueva canción
        const nuevaCancion = await Cancion.create(req.body);

        // Responder con la canción creada
        res.status(201).json({ mensaje: "Canción creada correctamente.", nuevaCancion });
    } catch (error) {
        console.error("Error al crear la canción:", error);
        res.status(500).json({ error: "Error al crear la canción." });
    }
};
// Actualizar una canción existente
const updateCancion = async (req, res) => {
    try {
        // Obtener el ID de la canción desde los parámetros de la URL
        const { id } = req.params;
        const { duracion, id_album } = req.body;

        // Validar que la canción exista
        let cancion = await Cancion.findByPk(id);
        if (!cancion) {
            return res.status(404).json({ mensaje: "Canción no encontrada." });
        }

        // Validar duración si se proporciona
        if (duracion !== undefined && duracion !== null) {
            if (!Number.isInteger(duracion) || duracion <= 0) {
                return res.status(400).json({ error: "La duración debe ser un entero mayor a 0." });
            }
        }

        // Validar álbum si se proporciona
        if (id_album) {
            const albumExiste = await Album.findByPk(id_album);
            if (!albumExiste) {
                return res.status(400).json({ error: "El álbum especificado no existe." });
            }
        }

        // Actualizar dinámicamente todos los campos enviados
        Object.entries(req.body).forEach(([key, value]) => {
            if (cancion.dataValues.hasOwnProperty(key)) {
                cancion[key] = value;
            }
        });

        // Guardar los cambios
        await cancion.save();

        // Responder con la canción actualizada
        res.status(200).json({
            mensaje: "Canción actualizada correctamente.",
            cancion
        });
    } catch (error) {
        console.error("Error al actualizar la canción:", error);
        res.status(500).json({ error: "Error al actualizar la canción." });
    }
};
// Asociar un género a una canción
const associateGeneroToCancion = async (req, res) => {
    try {
        // Obtener el ID de la canción desde los parámetros y el id_genero desde el cuerpo
        const { id } = req.params;
        const { id_genero } = req.body;

        // Validaciones
        if (!id_genero) {
            return res.status(400).json({ error: "El id_genero es requerido." });
        }

        // Validar que la canción exista
        const cancion = await Cancion.findByPk(id);
        if (!cancion) {
            return res.status(404).json({ error: "Canción no encontrada." });
        }

        // Validar que el género exista
        const genero = await Genero.findByPk(id_genero);
        if (!genero) {
            return res.status(404).json({ error: "Género no encontrado." });
        }

        // Verificar si ya existe la asociación
        const asociacionExiste = await CancionGenero.findOne({
            where: { id_cancion: id, id_genero }
        });
        if (asociacionExiste) {
            return res.status(400).json({ error: "La canción ya tiene este género asociado." });
        }

        // Crear la asociación
        await CancionGenero.create({
            id_cancion: id,
            id_genero
        });

        // Responder con éxito
        res.status(201).json({
            message: "Género asociado exitosamente.",
            id_cancion: id,
            generoAsociado: id_genero
        });
    } catch (error) {
        console.error("Error al asociar género:", error);
        res.status(500).json({ error: "Error al asociar género." });
    }
};
// Desasociar un género de una canción
const disassociateGeneroFromCancion = async (req, res) => {
    try {
        // Obtener los IDs desde los parámetros
        const { id, idGenero } = req.params;

        // Validar que la canción exista
        const cancion = await Cancion.findByPk(id);
        if (!cancion) {
            return res.status(404).json({ error: "Canción no encontrada." });
        }

        // Buscar y eliminar la asociación
        const asociacion = await CancionGenero.findOne({
            where: { id_cancion: id, id_genero: idGenero }
        });
        if (!asociacion) {
            return res.status(404).json({ error: "La asociación no existe." });
        }

        // Eliminar la asociación
        await asociacion.destroy();

        // Responder con éxito
        res.status(200).json({
            mensaje: "Género desasociado exitosamente.",
            generoDesasociado: idGenero
        });
    } catch (error) {
        console.error("Error al desasociar género:", error);
        res.status(500).json({ error: "Error al desasociar género." });
    }
};


export { getCancionesByFilters, getCancionById, createCancion, updateCancion, associateGeneroToCancion, disassociateGeneroFromCancion };