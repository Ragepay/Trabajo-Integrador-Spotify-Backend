import { Playlist, Usuario, Cancion, PlaylistCancion } from "../models/index.js";
import { sequelize } from '../config/database.js';

// Listar todas las playlists (opcionalmente por usuario)
const getPlaylists = async (req, res) => {
    try {
        // Filtrar por id_usuario si se proporciona
        const { usuarioId } = req.query;
        const where = {};
        if (usuarioId) {
            where.id_usuario = usuarioId;
        }

        // Obtener las playlists
        const playlists = await Playlist.findAll({ where });
        // Responder con las playlists obtenidas
        res.status(200).json({
            mensaje: "Playlists obtenidas correctamente.",
            playlists
        });
    } catch (error) {
        console.error("Error al obtener playlists:", error);
        res.status(500).json({ error: "Error al obtener playlists." });
    }
};

// Obtener una playlist por ID con sus canciones
const getPlaylistById = async (req, res) => {
    try {
        // Obtener ID de la playlist desde los parámetros
        const { id } = req.params;

        // Buscar la playlist por su ID
        const playlist = await Playlist.findByPk(id);

        // Si no se encuentra la playlist, responder con error 404
        if (!playlist) {
            return res.status(404).json({ error: "Playlist no encontrada." });
        }

        // Responder con la playlist encontrada
        res.status(200).json({
            mensaje: "Playlist encontrada.",
            playlist
        });
    } catch (error) {
        console.error("Error al obtener playlist:", error);
        res.status(500).json({ error: "Error al obtener playlist." });
    }
};

// Crear nueva playlist
const createPlaylist = async (req, res) => {
    try {
        const { id_usuario, titulo } = req.body;

        // Validaciones básicas
        if (!id_usuario || !titulo) {
            return res.status(400).json({ error: "id_usuario y titulo son requeridos." });
        }

        // Validar que el usuario existe
        const usuario = await Usuario.findByPk(id_usuario);
        if (!usuario) {
            return res.status(400).json({ error: "Usuario no encontrado." });
        }

        // Crear la nueva playlist
        const nuevaPlaylist = await Playlist.create({
            id_usuario,
            titulo,
        });

        // Responder con la nueva playlist creada
        res.status(201).json({
            mensaje: "Playlist creada correctamente.", nuevaPlaylist
        });
    } catch (error) {
        console.error("Error al crear playlist:", error);
        res.status(500).json({ error: "Error al crear playlist." });
    }
};

// Actualizar playlist (título o estado)
const updatePlaylist = async (req, res) => {
    try {
        // Obtener ID de la playlist desde los parámetros y datos del cuerpo
        const { id } = req.params;
        const { titulo, estado, fecha_eliminada } = req.body;

        // Buscar la playlist por su ID y validar existencia
        const playlist = await Playlist.findByPk(id);
        if (!playlist) {
            return res.status(404).json({ error: "Playlist no encontrada." });
        }

        // Actualizar título si se provee
        if (titulo) {
            playlist.titulo = titulo;
        }

        // Manejar cambio de estado
        if (estado !== undefined) {
            if (estado === 'eliminada') {
                if (!fecha_eliminada) {
                    return res.status(400).json({
                        error: "Si se marca como eliminada, debe proporcionar fecha_eliminada."
                    });
                }
                playlist.eliminada = true;
                playlist.fecha_eliminacion = fecha_eliminada;
            } else if (estado === 'activa') {
                playlist.eliminada = false;
                playlist.fecha_eliminacion = null;
            } else {
                return res.status(400).json({
                    error: "Estado debe ser 'activa' o 'eliminada'."
                });
            }
        }

        // Guardar los cambios
        await playlist.save();

        // Responder con la playlist actualizada
        res.status(200).json({
            mensaje: "Playlist actualizada correctamente.",
            playlist
        });
    } catch (error) {
        console.error("Error al actualizar playlist:", error);
        res.status(500).json({ error: "Error al actualizar playlist." });
    }
};

// Agregar canción a playlist
const addCancionToPlaylist = async (req, res) => {
    try {
        const { id } = req.params;
        const { id_cancion } = req.body;

        // Validaciones básicas
        if (!id_cancion) {
            return res.status(400).json({ error: "id_cancion es requerido." });
        }

        // Validar que la playlist existe
        const playlist = await Playlist.findByPk(id);
        if (!playlist) {
            return res.status(404).json({ error: "Playlist no encontrada." });
        }

        // Validar que la canción existe
        const cancion = await Cancion.findByPk(id_cancion);
        if (!cancion) {
            return res.status(400).json({ error: "Canción no encontrada." });
        }

        // Verificar si la canción ya está en la playlist
        const yaExiste = await PlaylistCancion.findOne({
            where: {
                id_playlist: id,
                id_cancion: id_cancion
            }
        });

        if (yaExiste) {
            return res.status(400).json({ error: "La canción ya está en la playlist." });
        }

        // Agregar la canción a la playlist usando el modelo PlaylistCancion
        await PlaylistCancion.create({
            id_playlist: id,
            id_cancion: id_cancion
        });

        // Actualizar contador de canciones
        playlist.cant_canciones = playlist.cant_canciones + 1;
        await playlist.save();

        res.status(201).json({
            mensaje: "Canción agregada a la playlist correctamente.",
            data: { id_playlist: id, id_cancion }
        });
    } catch (error) {
        console.error("Error al agregar canción a playlist:", error);
        res.status(500).json({ error: "Error al agregar canción a playlist." });
    }
};

// Quitar canción de playlist
const removeCancionFromPlaylist = async (req, res) => {
    try {
        const { id, idCancion } = req.params;

        // Validar que la playlist existe
        const playlist = await Playlist.findByPk(id);
        if (!playlist) {
            return res.status(404).json({ error: "Playlist no encontrada." });
        }

        // Validar que la canción existe
        const cancion = await Cancion.findByPk(idCancion);
        if (!cancion) {
            return res.status(404).json({ error: "Canción no encontrada." });
        }

        // Buscar la relación en PlaylistCancion
        const relacion = await PlaylistCancion.findOne({
            where: {
                id_playlist: id,
                id_cancion: idCancion
            }
        });

        if (!relacion) {
            return res.status(404).json({ error: "La canción no está en la playlist." });
        }

        // Eliminar la relación usando el modelo PlaylistCancion
        await relacion.destroy();

        // Actualizar contador de canciones
        playlist.cant_canciones = Math.max(0, playlist.cant_canciones - 1);
        await playlist.save();

        res.status(200).json({ mensaje: "Canción eliminada de la playlist correctamente." });
    } catch (error) {
        console.error("Error al eliminar canción de playlist:", error);
        res.status(500).json({ error: "Error al eliminar canción de playlist." });
    }
};export {
    getPlaylists,
    getPlaylistById,
    createPlaylist,
    updatePlaylist,
    addCancionToPlaylist,
    removeCancionFromPlaylist
};
