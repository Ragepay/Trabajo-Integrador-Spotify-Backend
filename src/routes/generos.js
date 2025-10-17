import { Router } from "express";
import Genero from "../models/Genero.js";

const generosRouter = Router();

// Funcion para buscar todos los Generos.
generosRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Generos");
});

export default generosRouter;