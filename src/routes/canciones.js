import { Router } from "express";
import { Cancion } from "../models/index.js";

const cancionesRouter = Router();

// Funcion para buscar todos los Canciones.
cancionesRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Canciones");
});

export default cancionesRouter;