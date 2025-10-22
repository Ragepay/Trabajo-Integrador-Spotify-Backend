import Artista from './Artista.js';
import Album from './Album.js';
import Cancion from './Cancion.js';
import Genero from './Genero.js';
import Usuario from './Usuario.js';
import TipoUsuario from './TipoUsuario.js';
import Playlist from './Playlist.js';
import DatosPagoUsuario from './DatosPagoUsuario.js';
import Pago from './Pago.js';
import Pais from './Pais.js';
import Discografica from './Discografica.js';
import TipoFormaPago from './TipoFormaPago.js';
import SuscripcionReal from './SuscripcionReal.js';
import CancionGenero from './CancionGenero.js';
import PlaylistCancion from './PlaylistCancion.js';


// Relaciones Artista <-> Album
Artista.hasMany(Album, {
    foreignKey: 'id_artista',
    as: 'albumes'
});
Album.belongsTo(Artista, {
    foreignKey: 'id_artista',
    as: 'artista'
});


// Relaciones Album <-> Cancion
Album.hasMany(Cancion, {
    foreignKey: 'id_album',
    as: 'canciones'
});
Cancion.belongsTo(Album, {
    foreignKey: 'id_album',
    as: 'album'
});


// Relaciones Cancion <-> Genero (muchos a muchos vía canciongenero)
Cancion.belongsToMany(Genero, {
    through: 'canciongenero', // ajustar a nombre exacto de la tabla (e.g. 'CancionGenero') si está creado así
    foreignKey: 'id_cancion',
    otherKey: 'id_genero',
    as: 'generos'
});
Genero.belongsToMany(Cancion, {
    through: 'canciongenero',
    foreignKey: 'id_genero',
    otherKey: 'id_cancion',
    as: 'canciones'
});


// Relaciones Usuario <-> Playlist
Usuario.hasMany(Playlist, {
    foreignKey: 'id_usuario',
    as: 'playlists'
});
Playlist.belongsTo(Usuario, {
    foreignKey: 'id_usuario',
    as: 'usuario'
});


// Relaciones Playlist <-> Cancion (muchos a muchos vía playlistcancion)
Playlist.belongsToMany(Cancion, {
    through: 'playlistcancion',
    foreignKey: 'id_playlist',
    otherKey: 'id_cancion',
    as: 'canciones'
});
Cancion.belongsToMany(Playlist, {
    through: 'playlistcancion',
    foreignKey: 'id_cancion',
    otherKey: 'id_playlist',
    as: 'playlists'
});


// Relaciones TipoUsuario (tabla tipousuario) <-> Usuario
TipoUsuario.hasMany(Usuario, {
    foreignKey: 'tipo_usuario',
    as: 'usuarios'
});
Usuario.belongsTo(TipoUsuario, {
    foreignKey: 'tipo_usuario',
    as: 'tipoUsuario'
});


// Relaciones Usuario <-> DatosPagoUsuario
Usuario.hasMany(DatosPagoUsuario, {
    foreignKey: 'id_usuario',
    as: 'metodosPago'
});
DatosPagoUsuario.belongsTo(Usuario, {
    foreignKey: 'id_usuario',
    as: 'usuario'
});


// Relaciones MetodoPago <-> Pago
DatosPagoUsuario.hasMany(Pago, {
    foreignKey: 'id_datos_pago',
    as: 'pagos'
});
Pago.belongsTo(DatosPagoUsuario, {
    foreignKey: 'id_datos_pago',
    as: 'datosPago'
});


// Relaciones Pais <-> Usuario
Pais.hasMany(Usuario, {
    foreignKey: 'id_pais',
    as: 'usuarios'
});
Usuario.belongsTo(Pais, {
    foreignKey: 'id_pais',
    as: 'pais'
});


// Relaciones Discografica <-> Album
Discografica.hasMany(Album, {
    foreignKey: 'id_discografica',
    as: 'albumes'
});
Album.belongsTo(Discografica, {
    foreignKey: 'id_discografica',
    as: 'discografica'
});


// Relaciones TipoFormaPago <-> DatosPagoUsuario
TipoFormaPago.hasMany(DatosPagoUsuario, {
    foreignKey: 'id_tipo_forma_pago',
    as: 'metodos'
});
DatosPagoUsuario.belongsTo(TipoFormaPago, {
    foreignKey: 'id_tipo_forma_pago', as: 'tipoFormaPago'
});


// Relaciones SuscripcionReal <-> Usuario
Usuario.hasMany(SuscripcionReal, {
    foreignKey: 'id_usuario',
    as: 'suscripciones'
});
SuscripcionReal.belongsTo(Usuario, {
    foreignKey: 'id_usuario',
    as: 'usuario'
});


// Relaciones Pago <-> SuscripcionReal (historial de pagos por suscripción)
SuscripcionReal.hasMany(Pago, {
    foreignKey: 'id_suscripcion',
    as: 'pagos'
});
Pago.belongsTo(SuscripcionReal, {
    foreignKey: 'id_suscripcion',
    as: 'suscripcion'
});


export {
    Artista,
    Album,
    Cancion,
    Genero,
    Usuario,
    TipoUsuario,
    Playlist,
    DatosPagoUsuario,
    Pago,
    Pais,
    Discografica,
    TipoFormaPago,
    SuscripcionReal,
    CancionGenero,
    PlaylistCancion
};


