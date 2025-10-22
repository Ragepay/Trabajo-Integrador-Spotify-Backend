import { Router } from "express";
import { getAllGeneros, createGenero } from "../controllers/generosController.js";

const generosRouter = Router();

// Funcion para buscar todos los Géneros.
generosRouter.get("/", getAllGeneros);

// Funcion para crear un nuevo Género.
generosRouter.post("/", createGenero);


export default generosRouter;