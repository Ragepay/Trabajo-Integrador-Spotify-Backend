import { Router } from "express";
import { getCancionesByFilters, getCancionById, createCancion, updateCancion, associateGeneroToCancion, disassociateGeneroFromCancion } from "../controllers/cancionesController.js";

const cancionesRouter = Router();

// Función para buscar canciones con filtros opcionales
cancionesRouter.get("/", getCancionesByFilters);

// Función para buscar una canción por ID con detalles
cancionesRouter.get("/:id", getCancionById);

// Crear una nueva canción
cancionesRouter.post("/", createCancion);

// Actualizar una canción existente
cancionesRouter.put("/:id", updateCancion);

// Asociar un género a una canción
cancionesRouter.post("/:id/generos", associateGeneroToCancion);

// Desasociar un género de una canción
cancionesRouter.delete("/:id/generos/:idGenero", disassociateGeneroFromCancion);

export default cancionesRouter;