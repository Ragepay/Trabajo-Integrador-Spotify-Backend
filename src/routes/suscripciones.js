import { Router } from "express";
import { TipoUsuario } from "../models/index.js";

const suscripcionesRouter = Router();

// Funcion para buscar todos los Suscripciones.
suscripcionesRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Suscripciones");
});

export default suscripcionesRouter;