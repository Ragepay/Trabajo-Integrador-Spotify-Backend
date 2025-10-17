import { Router } from "express";
//import Vista from "../models/Vista.js";

const vistasRouter = Router();

// Funcion para buscar todos los Vistas.
vistasRouter.get("/", async (req, res) => {
    res.send("Obtener todos los Vistas");
});

// TODO: Importar controlador de vistas
// const vistasController = require('../controllers/vistasController');

// TODO: EJERCICIO 1 - Vista de canciones populares por país
// GET /api/v1/vistas/canciones-populares-por-pais
// Debe mostrar las canciones más reproducidas agrupadas por país del usuario
// Incluir: nombre_cancion, nombre_artista, nombre_album, nombre_pais, total_reproducciones
// router.get('/canciones-populares-por-pais', vistasController.cancionesPopularesPorPais);

// TODO: EJERCICIO 2 - Vista de ingresos por artista y discográfica
// GET /api/v1/vistas/ingresos-por-artista-discografica
// Debe mostrar los ingresos generados por cada artista y discográfica
// Incluir: nombre_artista, nombre_discografica, nombre_pais_discografica, total_ingresos, cantidad_suscripciones_activas
// router.get('/ingresos-por-artista-discografica', vistasController.ingresosPorArtistaDiscografica);


export default vistasRouter;



