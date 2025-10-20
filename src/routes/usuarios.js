import { Router } from "express";
import { getAllUsuarios, getAllUsuariosConPasswordVencida, getUsuarioById, createUsuario, updateUsuario, deleteUsuario } from "../controllers/usuariosController.js";


const usuariosRouter = Router();

// Funcion para buscar todos los Usuarios.
usuariosRouter.get("/", getAllUsuarios);

// Funcion para buscar todos los Usuarios con password vencidas.
usuariosRouter.get("/password-vencidas", getAllUsuariosConPasswordVencida);

// Funcion para buscar un Usuario por ID.
usuariosRouter.get("/:id", getUsuarioById);

// Funcion para crear un nuevo Usuario.
usuariosRouter.post("/", createUsuario);

// Funcion para actualizar un Usuario existente.
usuariosRouter.put("/:id", updateUsuario);

// Funcion para eliminar un Usuario existente (Borrado logico).
usuariosRouter.delete("/:id", deleteUsuario);

export default usuariosRouter;