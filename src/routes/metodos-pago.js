import { Router } from "express";
import { getMetodosPago, createMetodoPago } from "../controllers/metodosPagoController.js";

const metodosPagoRouter = Router();

// Función para buscar todos los Métodos de Pago.
metodosPagoRouter.get("/", getMetodosPago);
// Funcion para crear un nuevo Método de Pago.
metodosPagoRouter.post("/", createMetodoPago);

export default metodosPagoRouter;