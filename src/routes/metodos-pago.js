import { Router } from "express";
import { DatosPagoUsuario } from "../models/index.js";

const metodosPagoRouter = Router();

metodosPagoRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Metodos de Pago");
});

export default metodosPagoRouter;