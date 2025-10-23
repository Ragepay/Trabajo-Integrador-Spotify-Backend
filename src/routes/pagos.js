import { Router } from "express";
import { getPagos, createPago } from "../controllers/pagosController.js";

const pagosRouter = Router();

// Funcion para buscar todos los Pagos.
pagosRouter.get("/", getPagos);
// Funcion para crear un nuevo Pago.
pagosRouter.post("/", createPago);

export default pagosRouter;