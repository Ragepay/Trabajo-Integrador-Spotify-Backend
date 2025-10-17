import { Router } from "express";
import Suscripcion from "../models/Suscripcion.js";

const suscripcionesRouter = Router();

// Funcion para buscar todos los Suscripciones.
suscripcionesRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Suscripciones");
});

export default suscripcionesRouter;