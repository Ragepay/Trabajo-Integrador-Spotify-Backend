import { Router } from "express";
import Usuario from "../models/Usuario.js";
import { createHashUtil } from "../utils/hash.js";

const usuariosRouter = Router();

// Funcion para buscar todos los Usuarios.
usuariosRouter.get("/", async (req, res) => {
    try {
        // Obtengo page y limit desde query, con valores por defecto
        const page = parseInt(req.query.page) || 1;
        const limit = parseInt(req.query.limit) || 20;

        // Calculo el offset
        const offset = (page - 1) * limit;

        // Consulta con Sequelize
        const usuarios = await Usuario.findAll({
            limit,   // cuántos registros
            offset   // desde dónde empezar
        });

        const total = await Usuario.count(); // total de registros

        // Respuesta paginada
        res.status(200).json({
            mensaje: "Usuarios encontrados correctamente.",
            page,
            limit,
            total,
            totalPages: Math.ceil(total / limit),
            usuarios
        });
    } catch (error) {
        console.error("Error al obtener los usuarios:", error);
        return res.status(500).json({ error: "Error al obtener todos los usuarios." });
    }
});

// Funcion para buscar un Usuario por ID.
usuariosRouter.get("/:id", async (req, res) => {
    try {
        // Se obtiene el id del Usuario desde los parametros de la URL.
        const { id } = req.params;
        // Se busca el Usuario por su ID en la base de datos.
        const usuario = await Usuario.findByPk(id);
        // Si no se encuentra el Usuario, se devuelve un error 404.
        if (!usuario) {
            return res.status(404).json({ error: "Usuario no encontrado" });
        }
        // Mensaje y respuesta exitosa.
        const mensaje = "Usuario encontrado correctamente.";
        // Response.
        res.status(200).json({ mensaje, usuario });
    } catch (error) {
        console.error("Error al obtener el usuario:", error);
        return res.status(500).json({ error: "Error al obtener el usuario." });
    }
});

// Funcion para crear un nuevo Usuario.
usuariosRouter.post("/", async (req, res) => {
    try {
        // Se obtienen los datos del nuevo Usuario desde el cuerpo de la solicitud.
        const { usuario, nombreCompleto, email, password, fecha_nacimiento, sexo, codigo_postal, id_pais, tipo_usuario } = req.body;
        // Validación básica de campos obligatorios
        if (!usuario || !nombreCompleto || !email || !password) {
            return res.status(400).json({ error: "usuario, nombreCompleto, email y password son requeridos." });
        }
        // Verificar si el email ya existe
        const existeEmail = await Usuario.findOne({ where: { email } });
        if (existeEmail) {
            return res.status(400).json({ error: "El email ya está registrado." });
        }
        // Verificar si el usuario ya existe
        const existeUsuario = await Usuario.findOne({ where: { usuario } });
        if (existeUsuario) {
            return res.status(400).json({ error: "El nombre de usuario ya está registrado." });
        }
        // Hashear la contraseña
        const hashedPassword = createHashUtil(password);
        // Crear el usuario
        const nuevoUsuario = await Usuario.create({
            usuario: usuario.toUpperCase(),
            nombreCompleto: nombreCompleto.toUpperCase(),
            email,
            password: hashedPassword,
            fecha_nacimiento: fecha_nacimiento || null,
            sexo: sexo || null,
            codigo_postal: codigo_postal || null,
            id_pais: id_pais || null,
            tipo_usuario: tipo_usuario || 1
        });
        // Response exitosa.
        res.status(201).json({
            mensaje: "Usuario creado correctamente.",
            usuario: nuevoUsuario
        });
    } catch (error) {
        console.error("Error al crear el usuario:", error);
        return res.status(500).json({ error: "Error al crear el usuario." });
    }
});

// PUT

// DELETE

export default usuariosRouter;