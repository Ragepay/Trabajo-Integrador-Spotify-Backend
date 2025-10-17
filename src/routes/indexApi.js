import { Router } from "express";
import usuariosRouter from './usuarios.js';
import artistasRouter from './artistas.js';
import albumesRouter from './albumes.js';
import cancionesRouter from './canciones.js';
import generosRouter from './generos.js';
import playlistsRouter from './playlists.js';
import suscripcionesRouter from './suscripciones.js';
import metodosPagoRouter from './metodos-pago.js';
import pagosRouter from './pagos.js';
import vistasRouter from './vistas.js';

// Importar dotenv para leer variables de entorno.
process.loadEnvFile();
// Configuracion de variables de entorno.
const { PORT, NODE_ENV } = process.env;

const apiRouter = Router();

// HOME - Endpoint principal de la API.
apiRouter.get("/", (req, res) => {
  res.json({
    message: "API Spotify - Backend funcionando correctamente",
    version: "1.0.0",
    endpoints: {
      usuarios: `http://localhost:${PORT}/api/v1/usuarios`,
      artistas: `http://localhost:${PORT}/api/v1/artistas`,
      albumes: `http://localhost:${PORT}/api/v1/albumes`,
      canciones: `http://localhost:${PORT}/api/v1/canciones`,
      generos: `http://localhost:${PORT}/api/v1/generos`,
      playlists: `http://localhost:${PORT}/api/v1/playlists`,
      suscripciones: `http://localhost:${PORT}/api/v1/suscripciones`,
      metodosPago: `http://localhost:${PORT}/api/v1/metodos-pago`,
      pagos: `http://localhost:${PORT}/api/v1/pagos`,
      vistas: `http://localhost:${PORT}/api/v1/vistas`,
    },
  });
});

// RUTAS ESPECIFICAS
apiRouter.use('/usuarios', usuariosRouter);
apiRouter.use('/artistas', artistasRouter);
apiRouter.use('/albumes', albumesRouter);
apiRouter.use('/canciones', cancionesRouter);
apiRouter.use('/generos', generosRouter);
apiRouter.use('/playlists', playlistsRouter);
apiRouter.use('/suscripciones', suscripcionesRouter);
apiRouter.use('/metodos-pago', metodosPagoRouter);
apiRouter.use('/pagos', pagosRouter);
apiRouter.use('/vistas', vistasRouter);

// Endpoint de ruta no encontrada(NOT FOUND).
apiRouter.use((req, res) => {
    res.status(404).json({ error: "Ruta no encontrada. ERROR - NOT FOUND" });
});

export default apiRouter;