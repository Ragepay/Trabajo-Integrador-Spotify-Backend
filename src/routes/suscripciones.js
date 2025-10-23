import { Router } from "express";
import { getSuscripciones, getSuscripcionById, createSuscripcion } from "../controllers/suscripcionesController.js";

const suscripcionesRouter = Router();

// Funcion para buscar todos los Suscripciones.
suscripcionesRouter.get("/", getSuscripciones);
// Funcion para buscar una suscripcion por ID.
suscripcionesRouter.get("/:id", getSuscripcionById);
// Funcion para crear una nueva Suscripcion.
suscripcionesRouter.post("/", createSuscripcion);

export default suscripcionesRouter;