import { Router } from "express";
import Album from "../models/Album.js";

const albumesRouter = Router();

// Funcion para buscar todos los Albumes.
albumesRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Albumes");
});

export default albumesRouter;