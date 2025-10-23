-- Vista 1: Canciones Populares por País
CREATE OR REPLACE VIEW vista_canciones_populares_por_pais AS
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
GROUP BY p.nombre, c.id_cancion
ORDER BY p.nombre ASC, total_reproducciones DESC;

-- Vista 2: Ingresos por Artista y Discográfica
CREATE OR REPLACE VIEW vista_ingresos_por_artista_discografica AS
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
JOIN Album al ON EXISTS (
    SELECT 1 FROM Cancion c2 WHERE c2.id_album = al.id_album
)
JOIN Artista ar ON al.id_artista = ar.id_artista
JOIN Discografica d ON al.id_discografica = d.id_discografica
JOIN Pais p ON d.id_pais = p.id_pais
LEFT JOIN Cancion c ON c.id_album = al.id_album
WHERE s.fecha_renovacion > NOW()
GROUP BY ar.nombre, d.nombre, p.nombre
ORDER BY total_ingresos DESC;
