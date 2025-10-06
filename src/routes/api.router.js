import { Router } from "express";
import albumesRouter from "./albumes.js";
import artistasRouter from "./artistas.js";

const apiRouter = Router();

// HOME -
apiRouter.get("/", (req, res) => { res.send("API - HOME"); });
// Rutas de Albumes.
apiRouter.use("/albumes", albumesRouter);
// Rutas de Artistas.
apiRouter.use("/artistas", artistasRouter);

// Endpoint de ruta no encontrada(NOT FOUND).
apiRouter.use((req, res) => {
    res.status(404).json({ error: "Ruta no encontrada. ERROR - NOT FOUND" });
});

export default apiRouter;