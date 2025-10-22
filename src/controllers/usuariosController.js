import { Usuario } from "../models/index.js";
import { createHashUtil } from "../utils/hash.js";
import { Op } from "sequelize";


// Funcion para buscar todos los Usuarios.
const getAllUsuarios = async (req, res) => {
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
};
// Funcion para buscar todos los Usuarios con password vencidas.
const getAllUsuariosConPasswordVencida = async (req, res) => {
    try {
        const usuarios = await Usuario.findAll({
            where: {
                fecha_modificacion_pass: {
                    [Op.lt]: new Date(new Date() - 90 * 24 * 60 * 60 * 1000) // 90 días
                }
            }
        });

        // Verificar si se encontraron usuarios
        if (usuarios.length === 0) {
            return res.status(404).json({ mensaje: "No se encontraron usuarios con contraseña vencida." });
        }

        // Respuesta paginada
        res.status(200).json({
            mensaje: "Usuarios encontrados correctamente.",
            usuarios
        });
    } catch (error) {
        console.error("Error al obtener los usuarios:", error);
        return res.status(500).json({ error: "Error al obtener todos los usuarios." });
    }
};
// Funcion para buscar un Usuario por ID.
const getUsuarioById = async (req, res) => {
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
};
// Funcion para crear un nuevo Usuario.
const createUsuario = async (req, res) => {
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
            usuario,
            nombreCompleto,
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
};
// Funcion para actualizar un Usuario existente.
const updateUsuario = async (req, res) => {
    try {
        // Se obtiene el id del Usuario desde los parametros de la URL.
        const { id } = req.params;

        // Verificar si el Usuario existe
        let existeUser = await Usuario.findByPk(id);
        if (!existeUser) {
            return res.status(404).json({ error: "Usuario no encontrado." });
        }

        // Verificar si el email ya existe
        if (req.body.email) {
            const existeEmail = await Usuario.findOne({ where: { email: req.body.email } });
            if (existeEmail) {
                return res.status(400).json({ error: "El email ya está registrado." });
            }
        }

        // Verificar si el usuario ya existe
        if (req.body.usuario) {
            const existeUsuario = await Usuario.findOne({ where: { usuario: req.body.usuario } });
            if (existeUsuario) {
                return res.status(400).json({ error: "El nombre de usuario ya está registrado." });
            }
        }

        // Hashear la contraseña si vino una nueva
        if (req.body.password) {
            req.body.password = createHashUtil(req.body.password);
            req.body.fecha_modificacion_pass = new Date();
        }

        // Actualizar dinámicamente todos los campos enviados
        Object.entries(req.body).forEach(([key, value]) => {
            if (existeUser.dataValues.hasOwnProperty(key)) {
                existeUser[key] = value;
            }
        });

        // Guardar los cambios
        await existeUser.save();

        // Response exitosa.
        res.status(200).json({
            mensaje: "Usuario actualizado correctamente.",
            usuario: existeUser
        });
    } catch (error) {
        console.error("Error al actualizar el usuario:", error);
        return res.status(500).json({ error: "Error al actualizar el usuario." });
    }
};
// Funcion para eliminar un Usuario existente (Borrado logico).
const deleteUsuario = async (req, res) => {
    try {
        // Se obtiene el id del Usuario desde los parametros de la URL.
        const { id } = req.params;

        // Verificar si el Usuario existe y está activo.
        let existeUser = await Usuario.findByPk(id);
        if (!existeUser || existeUser.activo === false) {
            return res.status(404).json({ error: "Usuario no encontrado." });
        }

        // Borrado logico.
        existeUser.activo = false;

        // Guardar los cambios
        await existeUser.save();
        
        // Response exitosa.
        res.status(200).json({
            mensaje: "Usuario eliminado con Borrado Lógico correctamente."
        });
    } catch (error) {
        console.error("Error al eliminar el usuario:", error);
        return res.status(500).json({ error: "Error al eliminar el usuario." });
    }
};


export { getAllUsuarios, getAllUsuariosConPasswordVencida, getUsuarioById, createUsuario, updateUsuario, deleteUsuario };