import { Router } from "express";
import usuariosRouter from "./usuarios.js";
import albumesRouter from "./albumes.js";
import artistasRouter from "./artistas.js";

const apiRouter = Router();

// HOME - Endpoint principal de la API.
apiRouter.get("/", (req, res) => { res.send("API - HOME"); });

// RUTAS ESPECIFICAS
// Rutas de Artistas.
apiRouter.use("/artistas", artistasRouter);
// Rutas de Usuarios.
apiRouter.use("/usuarios", usuariosRouter);
// Rutas de Albumes.
apiRouter.use("/albumes", albumesRouter);

// Endpoint de ruta no encontrada(NOT FOUND).
apiRouter.use((req, res) => {
    res.status(404).json({ error: "Ruta no encontrada. ERROR - NOT FOUND" });
});

export default apiRouter;