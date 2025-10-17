import { Router } from "express";
import Playlist from "../models/Playlist.js";

const playlistsRouter = Router();

// Funcion para buscar todos los Playlists.
playlistsRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Playlists");
});

export default playlistsRouter;