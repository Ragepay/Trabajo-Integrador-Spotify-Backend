import { Router } from "express";
import Usuario from "../models/Usuario.js";

const usuariosRouter = Router();

// Funcion para buscar todos los Usuarios.
usuariosRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Usuarios.");
});

export default usuariosRouter;