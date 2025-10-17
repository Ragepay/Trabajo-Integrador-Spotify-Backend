import { Router } from "express";
import MetodoPago from "../models/MetodoPago.js";

const metodosPagoRouter = Router();

// Funcion para buscar todos los Metodos de Pago.
metodosPagoRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Metodos de Pago");
});

export default metodosPagoRouter;