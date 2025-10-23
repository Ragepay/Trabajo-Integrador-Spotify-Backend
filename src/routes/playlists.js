import { Router } from "express";
import { 
    getPlaylists, 
    getPlaylistById, 
    createPlaylist, 
    updatePlaylist, 
    addCancionToPlaylist, 
    removeCancionFromPlaylist 
} from "../controllers/playlistsController.js";

const playlistsRouter = Router();

// Listar todas las playlists (opcionalmente por usuario)
playlistsRouter.get("/", getPlaylists);

// Obtener una playlist por ID con sus canciones
playlistsRouter.get("/:id", getPlaylistById);

// Crear nueva playlist
playlistsRouter.post("/", createPlaylist);

// Actualizar playlist (título o estado)
playlistsRouter.put("/:id", updatePlaylist);

// Agregar canción a playlist
playlistsRouter.post("/:id/canciones", addCancionToPlaylist);

// Quitar canción de playlist
playlistsRouter.delete("/:id/canciones/:idCancion", removeCancionFromPlaylist);

export default playlistsRouter;