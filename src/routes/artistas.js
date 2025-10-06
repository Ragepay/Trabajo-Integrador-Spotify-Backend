import { Router } from "express";
//import Album from "../models/Album.js";

const artistasRouter = Router();

// Funcion para buscar todos los Artistas.
artistasRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Artistas.");
});

export default artistasRouter;