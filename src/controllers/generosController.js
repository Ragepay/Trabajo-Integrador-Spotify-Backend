import { Op } from "sequelize";
import { Genero } from "../models/index.js";


// Funcion para buscar todos los Géneros.
const getAllGeneros = async (req, res) => {
    try {
        // Obtener todos los géneros
        const generos = await Genero.findAll({
            order: [["id_genero", "ASC"]],
        });
        // Respuesta
        res.status(200).json({
            mensaje: "Géneros obtenidos correctamente.",
            generos
        });
    } catch (error) {
        console.error("Error al obtener géneros:", error);
        res.status(500).json({ error: "Error al obtener géneros." });
    }
};
// Funcion para crear un nuevo Género.
const createGenero = async (req, res) => {
    try {
        // Validar datos de entrada
        const { nombre } = req.body;

        // Validar que el nombre no esté vacío
        if (!nombre || typeof nombre !== "string" || !nombre.trim()) {
            return res.status(400).json({ error: "El nombre es requerido." });
        }

        // Normalizar nombre
        const nombreNormalizado = nombre.trim();

        // Verificar unicidad (case insensitive) y existencia
        const existente = await Genero.findOne({
            where: { nombre: { [Op.like]: nombreNormalizado } },
        });
        if (existente) {
            return res.status(400).json({ error: "Ya existe un género con ese nombre." });
        }

        // Crear el género
        const genero = await Genero.create({ nombre: nombreNormalizado });

        // Respuesta
        res.status(201).json({
            mensaje: "Género creado correctamente.",
            genero
        });
    } catch (error) {
        console.error("Error al crear género:", error);
        res.status(500).json({ error: "Error al crear género." });
    }
};


export { getAllGeneros, createGenero };