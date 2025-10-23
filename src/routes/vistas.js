import { Router } from "express";
import vistasController from "../controllers/vistasController.js";

const vistasRouter = Router();

// Vista 1: Canciones populares por país
// GET /api/v1/vistas/canciones-populares-por-pais
// Muestra las canciones más reproducidas agrupadas por país del usuario
// Incluye: nombre_cancion, nombre_artista, nombre_album, nombre_pais, total_reproducciones, apariciones_en_playlists
vistasRouter.get('/canciones-populares-por-pais', vistasController.cancionesPopularesPorPais);

// Vista 2: Ingresos por artista y discográfica
// GET /api/v1/vistas/ingresos-por-artista-discografica
// Muestra los ingresos generados por cada artista y discográfica
// Incluye: nombre_artista, nombre_discografica, nombre_pais_discografica, total_ingresos, cantidad_suscripciones_activas, total_canciones, promedio_reproducciones
vistasRouter.get('/ingresos-por-artista-discografica', vistasController.ingresosPorArtistaDiscografica);

export default vistasRouter;



