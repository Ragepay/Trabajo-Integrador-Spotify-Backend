import { Router } from "express";
import { getAlbumsByArtist, getAlbumById, getSongsByAlbumId, createAlbum } from "../controllers/albumesController.js";

const albumesRouter = Router();

// Funcion para buscar todos los Albumes o por artistaId.
albumesRouter.get("/", getAlbumsByArtist);

// Funcion para buscar un Album por ID.
albumesRouter.get("/:id", getAlbumById);

// Funcion para obtener las canciones de un álbum por ID de álbum.
albumesRouter.get("/:id/canciones", getSongsByAlbumId);

// Funcion para crear un nuevo Album.
albumesRouter.post("/", createAlbum);


export default albumesRouter;
