import { Router } from "express";
import { getAllArtistas, getArtistaById, createArtista } from "../controllers/artistasController.js";

const artistasRouter = Router();

// Funcion para buscar todos los Artistas.
artistasRouter.get("/", getAllArtistas);
// Funcion para buscar un Artista por ID.
artistasRouter.get("/:id", getArtistaById);
// Funcion para crear un nuevo Artista.
artistasRouter.post("/", createArtista);


export default artistasRouter;