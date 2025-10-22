import { Router } from "express";
import { Pago } from "../models/index.js";

const pagosRouter = Router();

// Funcion para buscar todos los Pagos.
pagosRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Pagos");
});

export default pagosRouter;