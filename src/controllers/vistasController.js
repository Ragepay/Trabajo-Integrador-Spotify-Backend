import { sequelize } from "../config/database.js";

class VistasController {

  // Vista 1: Canciones Populares por País
  static async cancionesPopularesPorPais(req, res) {
    try {
      // Parámetros: pais opcional, limit opcional
      const pais = (req.query.pais || '').trim();
      const limitParam = parseInt(req.query.limit, 10);
      const finalLimit = Number.isInteger(limitParam) && limitParam > 0 ? limitParam : 50;

      let existePais = false;
      if (pais) {
        const [result] = await sequelize.query(
          "SELECT COUNT(*) AS total FROM Pais WHERE nombre = :pais",
          { replacements: { pais: pais }, type: sequelize.QueryTypes.SELECT }
        );
        existePais = result.total > 0;
      }

      // Construir cláusula WHERE solo si se provee pais
      const whereClause = existePais ? `WHERE p.nombre = '${pais}'` : '';

      const query = `
        SELECT 
          c.titulo AS nombre_cancion,
          ar.nombre AS nombre_artista,
          al.titulo AS nombre_album,
          p.nombre AS nombre_pais,
          SUM(c.reproducciones) AS total_reproducciones,
          COUNT(DISTINCT pc.id_playlist_cancion) AS apariciones_en_playlists
        FROM Cancion c
        JOIN Album al ON c.id_album = al.id_album
        JOIN Artista ar ON al.id_artista = ar.id_artista
        LEFT JOIN PlaylistCancion pc ON c.id_cancion = pc.id_cancion
        LEFT JOIN Playlist pl ON pc.id_playlist = pl.id_playlist AND pl.eliminada = 0
        LEFT JOIN Usuario u ON pl.id_usuario = u.id_usuario
        LEFT JOIN Pais p ON u.id_pais = p.id_pais
        ${whereClause}
        GROUP BY c.id_cancion, c.titulo, ar.nombre, al.titulo, p.nombre
        ORDER BY total_reproducciones DESC
        LIMIT :limit
      `;

      // Ejecutar la consulta
      const [results] = await sequelize.query(query, {
        replacements: { pais: pais || null, limit: finalLimit }
      });

      // Procesar los resultados
      res.status(200).json({
        mensaje: "Canciones populares por país obtenidas exitosamente",
        filtro_pais: pais || null,
        limit: finalLimit,
        results
      });

    } catch (error) {
      console.error("Error al obtener canciones populares por país:", error);
      res.status(500).json({
        error: "Error al obtener canciones populares por país"
      });
    }
  }

  static async ingresosPorArtistaDiscografica(req, res) {
    try {
      // Parámetros
      const pais = (req.query.pais || '').trim();
      const minimoIngresos = parseFloat(req.query.minimo_ingresos);
      const orden = (req.query.orden || 'ingresos').trim();
      const page = parseInt(req.query.page, 10) || 1;
      const limit = parseInt(req.query.limit, 10) || 20;

      // Verificar existencia del país si se proporciona
      let existePais = false;
      if (pais) {
        const [result] = await sequelize.query(
          "SELECT COUNT(*) AS total FROM Pais WHERE nombre = :pais",
          { replacements: { pais: pais }, type: sequelize.QueryTypes.SELECT }
        );
        existePais = result.total > 0;
      }

      // Determinar campo de ordenamiento
      const camposOrden = { ingresos: 'total_ingresos', suscripciones: 'cantidad_suscripciones_activas', canciones: 'total_canciones' };
      const campoOrdenSQL = camposOrden[orden] || camposOrden.ingresos;

      // Construir condiciones dinámicas
      const condiciones = [];
      const Having = [];
      if (existePais) condiciones.push("p.nombre = :pais");
      if (!isNaN(minimoIngresos) && minimoIngresos > 0) Having.push("SUM(pg.importe) >= :minimoIngresos");
      const whereClause = condiciones.length ? `WHERE ${condiciones.join(" AND ")}` : '';
      const havingClause = Having.length ? `HAVING ${Having.join(" AND ")}` : '';

      // Query SQL parametrizada realista con joins relevantes
      const query = `
        SELECT
          ar.nombre AS nombre_artista,
          d.nombre AS nombre_discografica,
          p.nombre AS nombre_pais_discografica,
          SUM(pg.importe) AS total_ingresos,
          COUNT(DISTINCT s.id_suscripcion) AS cantidad_suscripciones_activas,
          COUNT(DISTINCT c.id_cancion) AS total_canciones,
          AVG(c.reproducciones) AS promedio_reproducciones
        FROM Pagos pg
        JOIN Suscripcion s ON pg.id_suscripcion = s.id_suscripcion
        JOIN Usuario u ON s.id_usuario = u.id_usuario
        LEFT JOIN Playlist pl ON pl.id_usuario = u.id_usuario AND pl.eliminada = 0
        LEFT JOIN PlaylistCancion pc ON pc.id_playlist = pl.id_playlist
        LEFT JOIN Cancion c ON c.id_cancion = pc.id_cancion
        LEFT JOIN Album al ON c.id_album = al.id_album
        LEFT JOIN Artista ar ON al.id_artista = ar.id_artista
        LEFT JOIN Discografica d ON al.id_discografica = d.id_discografica
        LEFT JOIN Pais p ON d.id_pais = p.id_pais
        ${whereClause}
        GROUP BY ar.nombre, d.nombre, p.nombre
        ${havingClause}
        ORDER BY ${campoOrdenSQL} DESC
        LIMIT :limit
      `;

      // Ejecutar la consulta
      const [results] = await sequelize.query(query, {
        replacements: {
          pais: pais || null,
          minimoIngresos: !isNaN(minimoIngresos) ? minimoIngresos : null,
          limit
        }
      });

      // Procesar los resultados
      res.status(200).json({
        mensaje: "Ingresos por artista y discográfica obtenidos exitosamente",
        page,
        limit,
        filtro: campoOrdenSQL,
        results
      });
    } catch (error) {
      console.error("Error al obtener ingresos por artista y discográfica:", error);
      res.status(500).json({
        error: "Error al obtener ingresos por artista y discográfica."
      });
    }
  }
}

export default VistasController;
