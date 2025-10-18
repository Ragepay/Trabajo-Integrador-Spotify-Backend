CREATE DATABASE IF NOT EXISTS spotify;
USE spotify;

## Borrar tablas si existen

DROP TABLE IF EXISTS Pagos;
DROP TABLE IF EXISTS DatosPagoUsuario;
DROP TABLE IF EXISTS PlaylistCancion;
DROP TABLE IF EXISTS Suscripcion;
DROP TABLE IF EXISTS Playlist;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS TipoFormaPago;
DROP TABLE IF EXISTS TipoUsuario;
DROP TABLE IF EXISTS CancionGenero;
DROP TABLE IF EXISTS Cancion;
DROP TABLE IF EXISTS Album;
DROP TABLE IF EXISTS Genero;
DROP TABLE IF EXISTS Artista;
DROP TABLE IF EXISTS Discografica;
DROP TABLE IF EXISTS Pais;

## DDL(Data Definition Language)
-- Tabla para Pais
CREATE TABLE Pais (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla para Discográficas
CREATE TABLE Discografica (
    id_discografica INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais),
    UNIQUE (nombre, id_pais)
);

-- Tabla para Artistas
CREATE TABLE  Artista (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    imagen_url VARCHAR(255)
);

CREATE TABLE Album (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    portada_url VARCHAR(255),
    id_artista INT NOT NULL,
    id_discografica INT NOT NULL,
    UNIQUE (id_artista, titulo),
    FOREIGN KEY (id_artista) REFERENCES Artista(id_artista),
    FOREIGN KEY (id_discografica) REFERENCES Discografica(id_discografica)
);

-- Tabla para Generos
CREATE TABLE  Genero (
    id_genero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla para Canciones
CREATE TABLE Cancion (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
	duracion INT,
    reproducciones BIGINT DEFAULT 0,
    likes BIGINT DEFAULT 0,
    id_album INT,
    FOREIGN KEY (id_album) REFERENCES Album(id_album)
);

-- Tabla intermedia para Cancion-Genero
CREATE TABLE  CancionGenero (
    id_cancion_genero INT AUTO_INCREMENT PRIMARY KEY,
    id_cancion INT,
    id_genero INT,
    FOREIGN KEY (id_cancion) REFERENCES Cancion(id_cancion),
    FOREIGN KEY (id_genero) REFERENCES Genero(id_genero)
);

-- Tabla para tipo_usuario
CREATE TABLE  TipoUsuario (
id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL UNIQUE 
);

-- Tabla para Usuarios
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    nombreCompleto VARCHAR(150) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fecha_modificacion_pass TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_nacimiento DATE,
    sexo CHAR(1),
    codigo_postal VARCHAR(20),
    id_pais INT,
    tipo_usuario INT,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (id_pais) REFERENCES Pais(id_pais),
    FOREIGN KEY (tipo_usuario) REFERENCES TipoUsuario(id_tipo_usuario)
);

-- Tabla para Suscripciones
CREATE TABLE Suscripcion (
    id_suscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_renovacion DATE NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla para Playlists
CREATE TABLE Playlist (
    id_playlist INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    cant_canciones INT NOT NULL DEFAULT 0,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    eliminada TINYINT(1) NOT NULL DEFAULT 0,
    fecha_eliminacion TIMESTAMP NULL,
    CONSTRAINT chk_playlist_softdelete
        CHECK (
            (eliminada = 1 AND fecha_eliminacion IS NOT NULL)
            OR
            (eliminada = 0 AND fecha_eliminacion IS NULL)
        ),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla intermedia para Playlist-Cancion (muchos a muchos)
CREATE TABLE PlaylistCancion (
    id_playlist_cancion INT AUTO_INCREMENT PRIMARY KEY,
    id_playlist INT,
    id_cancion INT,
    FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist),
    FOREIGN KEY (id_cancion) REFERENCES Cancion(id_cancion)
);

-- Tabla TipoFormaPago
CREATE TABLE TipoFormaPago(
	id_tipo_forma_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla para los métodos de pago de un usuario.
CREATE TABLE DatosPagoUsuario (
    id_datos_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_tipo_forma_pago INT,
    cbu VARCHAR(50),
    nro_tarjeta VARCHAR(50),
    mes_caduca INT,
    anio_caduca INT,
    FOREIGN KEY (id_tipo_forma_pago) REFERENCES TipoFormaPago(id_tipo_forma_pago),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla para el historial de Pagos.
CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_suscripcion INT,
    fecha_pago DATE NOT NULL,
    importe DECIMAL(10, 2) NOT NULL,
    id_datos_pago INT, -- Referencia al método de pago usado
    FOREIGN KEY (id_suscripcion) REFERENCES Suscripcion(id_suscripcion),
    FOREIGN KEY (id_datos_pago) REFERENCES DatosPagoUsuario(id_datos_pago)
);


## DML (Data Manipulation Language)
-- Desactivar temporalmente la verificación de claves foráneas para evitar errores de orden
SET FOREIGN_KEY_CHECKS=0;

-- Vaciar las tablas en orden inverso para evitar conflictos si se ejecuta varias veces
TRUNCATE TABLE Pais;
TRUNCATE TABLE Pagos;
TRUNCATE TABLE DatosPagoUsuario;
TRUNCATE TABLE TipoFormaPago;
TRUNCATE TABLE PlaylistCancion;
TRUNCATE TABLE Suscripcion;
TRUNCATE TABLE Playlist;
TRUNCATE TABLE Usuario;
TRUNCATE TABLE TipoUsuario;
TRUNCATE TABLE CancionGenero;
TRUNCATE TABLE Cancion;
TRUNCATE TABLE Album;
TRUNCATE TABLE Genero;
TRUNCATE TABLE Artista;
TRUNCATE TABLE Discografica;

-- Reactivar la verificación de claves foráneas
SET FOREIGN_KEY_CHECKS=1;

-- Tabla Pais
INSERT INTO Pais (nombre) VALUES
('Estados Unidos'),
('Inglaterra'),
('España'),
('Brasil'),
('Canadá'),
('Chile'),
('Alemania'),
('Holanda'),
('Colombia'),
('Argentina'),
('México'),
('Francia'),
('Uruguay'),
('Suecia');

-- Tabla Discografica
INSERT INTO Discografica (nombre, id_pais) VALUES
('Sony Music Entertainment', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Universal Music Group', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Warner Music Group', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('EMI', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Apple Records', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Geffen Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Sire Warner Bros', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('UMG Recordings', (SELECT id_pais FROM Pais WHERE nombre = 'España')),
('Elektra Records LLC', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Atlantic Recording Corporation', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Rimas Entertainment LLC', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('RCA Records', (SELECT id_pais FROM Pais WHERE nombre = 'España')),
('Universal International Music BV', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Columbia Records', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('BigHit Entertainment', (SELECT id_pais FROM Pais WHERE nombre = 'Canadá')),
('Interscope Records', (SELECT id_pais FROM Pais WHERE nombre = 'España')),
('Ministry of Sound Recordings Limited', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('WK Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('White World Music', (SELECT id_pais FROM Pais WHERE nombre = 'España')),
('Epic Records.', (SELECT id_pais FROM Pais WHERE nombre = 'Chile')),
('Internet Money Records', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('Aftermath Entertainment', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Atlantic', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Capitol Records', (SELECT id_pais FROM Pais WHERE nombre = 'Canadá')),
('CBS', (SELECT id_pais FROM Pais WHERE nombre = 'España')),
('CBS Masterworks', (SELECT id_pais FROM Pais WHERE nombre = 'Alemania')),
('Commodore', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Death Row Records', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('Decca', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Detroit Underground', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Dial Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Diynamic Music', (SELECT id_pais FROM Pais WHERE nombre = 'Alemania')),
('Etcetera Records B.V.', (SELECT id_pais FROM Pais WHERE nombre = 'Holanda')),
('Fania Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Inca Records', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia')),
('M nus', (SELECT id_pais FROM Pais WHERE nombre = 'Canadá')),
('Music Hall', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina')),
('Musicraft', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Naxos Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('ND Nueva Direccion En La Cultura', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina')),
('NMC', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Octave', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra')),
('Odeon', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina')),
('Prestige', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('RCA Victor Red Seal', (SELECT id_pais FROM Pais WHERE nombre = 'Alemania')),
('REKIDS', (SELECT id_pais FROM Pais WHERE nombre = 'Alemania')),
('Riverside Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Roc-A-Fella Records', (SELECT id_pais FROM Pais WHERE nombre = 'Canadá')),
('Roc-A-Fella Records, Universal Music', (SELECT id_pais FROM Pais WHERE nombre = 'Brasil')),
('Sony Music', (SELECT id_pais FROM Pais WHERE nombre = 'México')),
('Stip Record', (SELECT id_pais FROM Pais WHERE nombre = 'Francia')),
('Tico Records', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos')),
('Trova', (SELECT id_pais FROM Pais WHERE nombre = 'Uruguay')),
('Truesoul', (SELECT id_pais FROM Pais WHERE nombre = 'Suecia')),
('UA Latino', (SELECT id_pais FROM Pais WHERE nombre = 'España'));


-- Tabla Artista 
INSERT INTO Artista (nombre, imagen_url) VALUES
('Pink Floyd', 'Pink Floyd.jpg'), ('AC/DC', NULL), ('The Rolling Stones', 'The Rolling Stones.jpg'), ('The Beatles', NULL),
('Guns\'n Roses', 'Guns\'n Roses.jpg'), ('Linkin Park', NULL), ('Madonna', 'Madonna.jpg'), ('Fito Paez', NULL),
('Diego Torres', 'Diego Torres.jpg'), ('Shakira', NULL), ('Maluma', 'Maluma.jpg'), ('Carlos Vives', NULL),
('Karol G', 'Karol G.jpg'), ('Yo-Yo Ma', NULL), ('Michael Finnissy', 'Michael Finnissy.jpg'), ('John Adams', NULL),
('John Corigliano', 'John Corigliano.jpg'), ('Terry Riley', NULL), ('Brian John Peter Ferneyhough', 'Brian John Peter Ferneyhough.jpg'),
('Charlie Parker', NULL), ('MIles Davis', 'MIles Davis.jpg'), ('Dizzy Gillespie', NULL), ('Coleman Hawkins', 'Coleman Hawkins.jpg'),
('Billie Holiday', NULL), ('Ray Charles', 'Ray Charles.jpg'), ('Chet Baker', NULL), ('Celia Cruz', 'Celia Cruz.jpg'),
('Ruben Blades', NULL), ('Willie Colon', 'Willie Colon.jpg'), ('Hector Lavoe', NULL), ('Tito Rodriguez', 'Tito Rodriguez.jpg'),
('Luis Enrique', NULL), ('Astor Piazzolla', 'Astor Piazzolla.jpg'), ('Carlos Gardel', NULL), ('Adriana Varela', 'Adriana Varela.jpg'),
('Alberto Podestá', NULL), ('Bajofondo Tango Club', 'Bajofondo Tango Club.jpg'), ('Susana Rinaldi', NULL),
('Dr. Dre', 'Dr. Dre.jpg'), ('Eminem', NULL), ('Snoop Dogg', 'Snoop Dogg.jpg'), ('Jay-Z', NULL),
('Beastie Boys', 'Beastie Boys.jpg'), ('Kanye West', NULL), ('Carl Cox', 'Carl Cox.jpg'), ('Marco Carola', NULL),
('Oscar Mulero', 'Oscar Mulero.jpg'), ('Nina Kraviz', NULL), ('Adam Beyer', 'Adam Beyer.jpg'), ('Solomun', NULL);

-- Tabla Genero
INSERT INTO Genero (nombre) VALUES
('Rock'), ('Soul'), ('Pop'), ('Música Clasica'), ('Jazz'), ('Salsa'), ('Tango'), ('Hip Hop'), ('Techno');

-- Tabla tipo_usuario
INSERT INTO TipoUsuario (nombre) VALUES
('Premium'), ('standard'), ('free');

-- INSERTAR DATOS EN TABLAS CON DEPENDENCIAS
-- Tabla Album (usando subconsultas para obtener los IDs correctos)
INSERT INTO Album (titulo, portada_url, id_artista, id_discografica) VALUES
('Is There Anybody Out There', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Pink Floyd'), (SELECT id_discografica FROM Discografica WHERE nombre = 'EMI')),
('Radio Sampler ‎2xCD', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Pink Floyd'), (SELECT id_discografica FROM Discografica WHERE nombre = 'EMI')),
('Delicate Sound Of Thunder', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Pink Floyd'), (SELECT id_discografica FROM Discografica WHERE nombre = 'EMI')),
('Abbey Road', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'The Beatles'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Apple Records')),
('Use Your Illusion II', 'Guns''n Roses.jpg', (SELECT id_artista FROM Artista WHERE nombre = "Guns'n Roses"), (SELECT id_discografica FROM Discografica WHERE nombre = 'Geffen Records')),
('Appetite for Destruction', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = "Guns'n Roses"), (SELECT id_discografica FROM Discografica WHERE nombre = 'Geffen Records')),
('True Blue', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Madonna'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sire Warner Bros')),
('Like A Virgin', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Madonna'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sire Warner Bros')),
('Fito Paez', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Fito Paez'), (SELECT id_discografica FROM Discografica WHERE nombre = 'EMI')),
('Antología', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Fito Paez'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Warner Music Group')),
('Diego Torres', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Diego Torres'), (SELECT id_discografica FROM Discografica WHERE nombre = 'EMI')),
('Check Your Head', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Beastie Boys'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Capitol Records')),
('Loba', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Shakira'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sony Music Entertainment')),
('Pies Descalzos', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Shakira'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Warner Music Group')),
('Papi Juancho', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Maluma'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sony Music Entertainment')),
('Vives', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Carlos Vives'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sony Music Entertainment')),
('OCEAN', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Karol G'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Warner Music Group')),
('Son Con Guaguancó', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Celia Cruz'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Tico Records')),
('Maestra Vida', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Ruben Blades'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Fania Records')),
('El Malo', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Willie Colon'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Fania Records')),
('La Voz', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Hector Lavoe'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Inca Records')),
('Tito Rodriguez At The Palladium', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Tito Rodriguez'), (SELECT id_discografica FROM Discografica WHERE nombre = 'UA Latino')),
('Amor Y Alegria', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Luis Enrique'), (SELECT id_discografica FROM Discografica WHERE nombre = 'CBS')),
('Cello Concertos', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Yo-Yo Ma'), (SELECT id_discografica FROM Discografica WHERE nombre = 'CBS Masterworks')),
('"Plays Weir, Finnissy, Newman And Skempton"', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Michael Finnissy'), (SELECT id_discografica FROM Discografica WHERE nombre = 'NMC')),
('My father Knew Charles Ives and Harmonielehre', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'John Adams'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Naxos Records')),
('Pied Piper Fantasy', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'John Corigliano'), (SELECT id_discografica FROM Discografica WHERE nombre = 'RCA Victor Red Seal')),
('Le Secret De La Vie', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Terry Riley'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Stip Record')),
('Solo Works', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Brian John Peter Ferneyhough'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Etcetera Records B.V.')),
('Charlie Parker Sextet', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Charlie Parker'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Dial Records')),
('Relaxin With The Miles Davis Quintet', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'MIles Davis'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Prestige')),
('Dizzy Gillespie And His All-Stars', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Dizzy Gillespie'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Musicraft')),
('King Of The Tenor Sax', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Coleman Hawkins'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Commodore')),
('Distinctive Song Styling', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Billie Holiday'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Decca')),
('Yes Indeed!', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Ray Charles'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Atlantic')),
('Chet Baker In New York', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Chet Baker'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Riverside Records')),
('Adios Nonino', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Astor Piazzolla'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Trova')),
('Así Cantaba Carlitos', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Carlos Gardel'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Odeon')),
('Cuando El Río Suena', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Adriana Varela'), (SELECT id_discografica FROM Discografica WHERE nombre = 'ND Nueva Direccion En La Cultura')),
('Alma De Bohemio', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Alberto Podestá'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Music Hall')),
('Aura', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Bajofondo Tango Club'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Sony Music')),
('Monton De Vida', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Susana Rinaldi'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Diynamic Music')),
('Let Me Ride', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Dr. Dre'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Inca Records')),
('Kamikaze', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Eminem'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Aftermath Entertainment')),
('Doggystyle', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Snoop Dogg'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Death Row Records')),
('The Black Album', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Jay-Z'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Roc-A-Fella Records')),
('Late Registration', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Kanye West'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Roc-A-Fella Records, Universal Music')),
('Back To Mine', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Carl Cox'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Octave')),
('Play It Loud!', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Marco Carola'), (SELECT id_discografica FROM Discografica WHERE nombre = 'M nus')),
('Biosfera', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Oscar Mulero'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Detroit Underground')),
('The Remixes', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Nina Kraviz'), (SELECT id_discografica FROM Discografica WHERE nombre = 'REKIDS')),
('Ignition Key', 'imagenalbum.jpg', (SELECT id_artista FROM Artista WHERE nombre = 'Adam Beyer'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Truesoul')),
('Dance Baby', NULL, (SELECT id_artista FROM Artista WHERE nombre = 'Solomun'), (SELECT id_discografica FROM Discografica WHERE nombre = 'Diynamic Music'));

-- Tabla Cancion 
INSERT INTO Cancion (titulo, duracion, reproducciones, likes, id_album) VALUES
('In The Flesh', 3*60+25, 1000050, 7500, (SELECT id_album FROM Album WHERE titulo = 'Is There Anybody Out There')),
('The Thin Ice', 2*60+49, 850050, 7600, (SELECT id_album FROM Album WHERE titulo = 'Is There Anybody Out There')),
('Gone For Bad', 3*60+58, 1200400, 6500, (SELECT id_album FROM Album WHERE titulo = 'Radio Sampler ‎2xCD')),
('Fink Is The King', 3*60+15, 218500, 8600, (SELECT id_album FROM Album WHERE titulo = 'Radio Sampler ‎2xCD')),
('Shine On You Crazy Diamond', 11*60+53, 210000, 4500, (SELECT id_album FROM Album WHERE titulo = 'Delicate Sound Of Thunder')),
('Yet Another Movie', 4*60+10, 4500668, 1500, (SELECT id_album FROM Album WHERE titulo = 'Delicate Sound Of Thunder')),
('Oh! Darling', 3*60+26, 1598634, 256986, (SELECT id_album FROM Album WHERE titulo = 'Abbey Road')),
('Come Together', 4*60+20, 3568946, 103569, (SELECT id_album FROM Album WHERE titulo = 'Abbey Road')),
('Something', 3*60+3, 628634, 5698, (SELECT id_album FROM Album WHERE titulo = 'Abbey Road')),
('The End', 2*60+5, 68946, 3569, (SELECT id_album FROM Album WHERE titulo = 'Abbey Road')),
('Open Your Heart', 4*60+13, 2500245, 1785444, (SELECT id_album FROM Album WHERE titulo = 'True Blue')),
('Material Girl', 4*60+4, 457788, 68555, (SELECT id_album FROM Album WHERE titulo = 'True Blue')),
('Open Your Heart', 3*60+57, 7500277, 985444, (SELECT id_album FROM Album WHERE titulo = 'True Blue')),
('Cancion Sobre Cancion', 3*60+49, 988100, 578101, (SELECT id_album FROM Album WHERE titulo = 'Fito Paez')),
('11 Y 6', 2*60+55, 1122554, 245778, (SELECT id_album FROM Album WHERE titulo = 'Fito Paez')),
('Y Dale Alegría A Mi Corazón', 5*60+15, 1985663, 658874, (SELECT id_album FROM Album WHERE titulo = 'Antología')),
('El Amor Después Del Amor', 5*60+10, 2100358, 35456, (SELECT id_album FROM Album WHERE titulo = 'Antología')),
('Estamos Juntos', 4*60+39, 389555, 12488, (SELECT id_album FROM Album WHERE titulo = 'Diego Torres')),
('No Tengas Miedo', 4*60+25, 258456, 5247, (SELECT id_album FROM Album WHERE titulo = 'Diego Torres')),
('Lo Hecho Esta Hecho', 3*60+13, 986444, 657112, (SELECT id_album FROM Album WHERE titulo = 'Loba')),
('Loba', 3*60+9, 3150441, 1244523, (SELECT id_album FROM Album WHERE titulo = 'Loba')),
('Años Luz', 3*60+41, 1335054, 485777, (SELECT id_album FROM Album WHERE titulo = 'Loba')),
('Estoy Aqui', 3*60+52, 845300, 247712, (SELECT id_album FROM Album WHERE titulo = 'Pies Descalzos')),
('Hawai', 3*60+19, 1325450, 857400, (SELECT id_album FROM Album WHERE titulo = 'Papi Juancho')),
('La Cura', 2*60+56, 750425, 74856, (SELECT id_album FROM Album WHERE titulo = 'Papi Juancho')),
('Salida de escape', 3*60+4, 166582, 37142, (SELECT id_album FROM Album WHERE titulo = 'Papi Juancho')),
('Ansiedad', 3*60+40, 500266, 25004, (SELECT id_album FROM Album WHERE titulo = 'Papi Juancho')),
('Baby', 4*60+1, 70052, 12488, (SELECT id_album FROM Album WHERE titulo = 'OCEAN')),
('Dices que te vas', 3*60+11, 1122554, 35456, (SELECT id_album FROM Album WHERE titulo = 'OCEAN')),
('Hoy tengo tiempo', 3*60+12, 10458, 24115, (SELECT id_album FROM Album WHERE titulo = 'Vives')),
('La tierra prometida', 3*60+17, 10047, 3578, (SELECT id_album FROM Album WHERE titulo = 'Vives')),
('Mañana', 2*60+49, 8507, 1574, (SELECT id_album FROM Album WHERE titulo = 'Vives')),
('In A Minor For Cello And Orchestra, Op', 18*60+53, 15934, 0, (SELECT id_album FROM Album WHERE titulo = 'Cello Concertos')),
('Prelude: Lento Allegro Maestoso', 12*60+38, 96306, 4157, (SELECT id_album FROM Album WHERE titulo = 'Cello Concertos')),
('Intermezzo', 6*60+14, 95338, 41, (SELECT id_album FROM Album WHERE titulo = 'Cello Concertos')),
('Reels', 7*60+58, 53402, 340, (SELECT id_album FROM Album WHERE titulo = '"Plays Weir, Finnissy, Newman And Skempton"')),
('An Mein Klavier', 8*60+10, 523452, 984, (SELECT id_album FROM Album WHERE titulo = '"Plays Weir, Finnissy, Newman And Skempton"')),
('Le Repos Sur Le Lit', 7*60+3, 589744, 891, (SELECT id_album FROM Album WHERE titulo = '"Plays Weir, Finnissy, Newman And Skempton"')),
('My father Knew Charles Ives and Harmonielehre', 9*60+41, 292364, 9236, (SELECT id_album FROM Album WHERE titulo = 'My father Knew Charles Ives and Harmonielehre')),
('Harmonielehre I', 17*60+26, 0, 0, (SELECT id_album FROM Album WHERE titulo = 'My father Knew Charles Ives and Harmonielehre')),
('Harmonielehre II .The Anfortas Wound', 12*60+46, 2585604, 984, (SELECT id_album FROM Album WHERE titulo = 'My father Knew Charles Ives and Harmonielehre')),
('Sunrise And The Piper s Song', 9*60+36, 666667, 6, (SELECT id_album FROM Album WHERE titulo = 'Pied Piper Fantasy')),
('The Rats', 1*60+38, 5510, 54, (SELECT id_album FROM Album WHERE titulo = 'Pied Piper Fantasy')),
('The Children is March', 9*60+29, 4295153, 157, (SELECT id_album FROM Album WHERE titulo = 'Pied Piper Fantasy')),
('G. Song', 3*60+4, 535211, 5352, (SELECT id_album FROM Album WHERE titulo = 'Le Secret De La Vie')),
('MIce', 2*60+11, 564916, 9, (SELECT id_album FROM Album WHERE titulo = 'Le Secret De La Vie')),
('In The Summer', 6*60+34, 4701, 984, (SELECT id_album FROM Album WHERE titulo = 'Le Secret De La Vie')),
('Time And Motion Study I', 8*60+42, 673426, 642, (SELECT id_album FROM Album WHERE titulo = 'Solo Works')),
('Bone Alphabet', 2*60+56, 578738, 54, (SELECT id_album FROM Album WHERE titulo = 'Solo Works')),
('Time And Motion Study II', 22*60+32, 714249, 98, (SELECT id_album FROM Album WHERE titulo = 'Solo Works')),
('My Old Flame', 3*60+18, 811641, 1164, (SELECT id_album FROM Album WHERE titulo = 'Charlie Parker Sextet')),
('Air Conditioning', 3*60+6, 592559, 5, (SELECT id_album FROM Album WHERE titulo = 'Charlie Parker Sextet')),
('Crazeology', 3*60+1, 89423798, 158, (SELECT id_album FROM Album WHERE titulo = 'Charlie Parker Sextet')),
('If I Were A Bell', 8*60+17, 949856, 4985, (SELECT id_album FROM Album WHERE titulo = 'Relaxin With The Miles Davis Quintet')),
('You are My Everything', 5*60+20, 606381, 54, (SELECT id_album FROM Album WHERE titulo = 'Relaxin With The Miles Davis Quintet')),
('It Could Happen To You', 6*60+31, 133346, 0, (SELECT id_album FROM Album WHERE titulo = 'Relaxin With The Miles Davis Quintet')),
('A Hand Fulla Gimme', 3*60+2, 108807, 880, (SELECT id_album FROM Album WHERE titulo = 'Dizzy Gillespie And His All-Stars')),
('Groovin High', 2*60+41, 161, 95, (SELECT id_album FROM Album WHERE titulo = 'Dizzy Gillespie And His All-Stars')),
('Blue N Boogie', 2*60+58, 842894, 39, (SELECT id_album FROM Album WHERE titulo = 'Dizzy Gillespie And His All-Stars')),
('I Surrender Dear', 4*60+41, 122628, 4157, (SELECT id_album FROM Album WHERE titulo = 'King Of The Tenor Sax')),
('Smack', 2*60+46, 123, 41, (SELECT id_album FROM Album WHERE titulo = 'King Of The Tenor Sax')),
('My Ideal', 3*60+11, 4552442, 247, (SELECT id_album FROM Album WHERE titulo = 'King Of The Tenor Sax')),
('Lover Man Oh Where Can You Be?', 3*60+21, 136450, 984, (SELECT id_album FROM Album WHERE titulo = 'Distinctive Song Styling')),
('That Ole Devil Called Love', 2*60+51, 1325, 891, (SELECT id_album FROM Album WHERE titulo = 'Distinctive Song Styling')),
('No More', 2*60+44, 6261991, 593, (SELECT id_album FROM Album WHERE titulo = 'Distinctive Song Styling')),
('What Would I Do Without You', 2*60+37, 150271, 545, (SELECT id_album FROM Album WHERE titulo = 'Yes Indeed!')),
('It is All Right', 2*60+15, 666667, 984, (SELECT id_album FROM Album WHERE titulo = 'Yes Indeed!')),
('I Want To Know', 2*60+28, 971539, 340, (SELECT id_album FROM Album WHERE titulo = 'Yes Indeed!')),
('Fair Weather', 7*60+0, 164093, 54, (SELECT id_album FROM Album WHERE titulo = 'Chet Baker In New York')),
('Polka Dots And Moonbeams', 8*60+0, 675467, 157, (SELECT id_album FROM Album WHERE titulo = 'Chet Baker In New York')),
('Hotel 49', 9*60+54, 9681087, 9236, (SELECT id_album FROM Album WHERE titulo = 'Chet Baker In New York')),
('Bemba Colora', 8*60+54, 177914, 9, (SELECT id_album FROM Album WHERE titulo = 'Son Con Guaguancó')),
('Son Con Guaguanco', 2*60+51, 931067, 984, (SELECT id_album FROM Album WHERE titulo = 'Son Con Guaguancó')),
('Es La Humanidad', 2*60+25, 7139063, 6, (SELECT id_album FROM Album WHERE titulo = 'Son Con Guaguancó')),
('El Velorio', 5*60+6, 100184, 5352, (SELECT id_album FROM Album WHERE titulo = 'Maestra Vida')),
('Jazzy', 4*60+19, 205557, 5, (SELECT id_album FROM Album WHERE titulo = 'El Malo')),
('Willie Baby', 2*60+42, 7169667, 158, (SELECT id_album FROM Album WHERE titulo = 'El Malo')),
('Borinquen', 3*60+17, 4809732, 642, (SELECT id_album FROM Album WHERE titulo = 'El Malo')),
('El Todopoderoso', 4*60+21, 219379, 54, (SELECT id_album FROM Album WHERE titulo = 'La Voz')),
('Emborrachame De Amor', 3*60+12, 730767, 0, (SELECT id_album FROM Album WHERE titulo = 'La Voz')),
('Paraiso De Dulzura', 4*60+48, 266281, 1164, (SELECT id_album FROM Album WHERE titulo = 'La Voz')),
('Satin And Lace', 4*60+25, 233200, 95, (SELECT id_album FROM Album WHERE titulo = 'Tito Rodriguez At The Palladium')),
('Mama Guela', 2*60+36, 15518541, 39, (SELECT id_album FROM Album WHERE titulo = 'Tito Rodriguez At The Palladium')),
('Te Comiste Un Pan', 2*60+37, 210, 4985, (SELECT id_album FROM Album WHERE titulo = 'Tito Rodriguez At The Palladium')),
('Desesperado', 3*60+50, 247022, 41, (SELECT id_album FROM Album WHERE titulo = 'Amor Y Alegria')),
('Tu No Le Amas Le Temes', 4*60+27, 1582509, 247, (SELECT id_album FROM Album WHERE titulo = 'Amor Y Alegria')),
('Comprendelo', 5*60+20, 145, 880, (SELECT id_album FROM Album WHERE titulo = 'Amor Y Alegria')),
('Adiós Nonino', 8*60+6, 260843, 891, (SELECT id_album FROM Album WHERE titulo = 'Adios Nonino')),
('Otoño Porteño', 5*60+10, 161387638, 593, (SELECT id_album FROM Album WHERE titulo = 'Adios Nonino')),
('Michelangelo 70', 3*60+20, 27647926, 4157, (SELECT id_album FROM Album WHERE titulo = 'Adios Nonino')),
('Chorra', 2*60+16, 274665, 984, (SELECT id_album FROM Album WHERE titulo = 'Así Cantaba Carlitos')),
('Dicen Que Dicen', 2*60+21, 1644186, 340, (SELECT id_album FROM Album WHERE titulo = 'Así Cantaba Carlitos')),
('Ebrio', 2*60+26, 54575, 984, (SELECT id_album FROM Album WHERE titulo = 'Así Cantaba Carlitos')),
('Aquello', 4*60+33, 288486, 157, (SELECT id_album FROM Album WHERE titulo = 'Cuando El Río Suena')),
('Don Carlos', 3*60+59, 167593735, 9236, (SELECT id_album FROM Album WHERE titulo = 'Cuando El Río Suena')),
('Milongón Del Guruyú', 4*60+46, 245, 0, (SELECT id_album FROM Album WHERE titulo = 'Cuando El Río Suena')),
('Alma De Bohemio', 3*60+38, 302308, 984, (SELECT id_album FROM Album WHERE titulo = 'Alma De Bohemio')),
('Al Compas Del Corazon', 2*60+20, 3523283, 6, (SELECT id_album FROM Album WHERE titulo = 'Alma De Bohemio')),
('Temblando', 2*60+36, 7657, 54, (SELECT id_album FROM Album WHERE titulo = 'Alma De Bohemio')),
('solari yacumenza', 6*60+50, 316129, 98, (SELECT id_album FROM Album WHERE titulo = 'Aura')),
('flor de piel', 4*60+38, 1738831, 5352, (SELECT id_album FROM Album WHERE titulo = 'Aura')),
('Clueca la Cueca', 6*60+17, 1215, 9, (SELECT id_album FROM Album WHERE titulo = 'Aura')),
('Soy Un Circo', 4*60+52, 329951, 158, (SELECT id_album FROM Album WHERE titulo = 'Monton De Vida')),
('La Chanson Des Vieux Amants', 5*60+15, 1738, 642, (SELECT id_album FROM Album WHERE titulo = 'Monton De Vida')),
('Gabbiani', 3*60+50, 2315, 54, (SELECT id_album FROM Album WHERE titulo = 'Monton De Vida')),
('Let Me Ride', 11*60+1, 343772, 0, (SELECT id_album FROM Album WHERE titulo = 'Let Me Ride')),
('One Eight Seven', 4*60+18, 1801928, 1164, (SELECT id_album FROM Album WHERE titulo = 'Let Me Ride')),
('The Ringer', 5*60+37, 357594, 39, (SELECT id_album FROM Album WHERE titulo = 'Kamikaze')),
('Greatest', 3*60+46, 11261476, 4985, (SELECT id_album FROM Album WHERE titulo = 'Kamikaze')),
('Lucky You', 4*60+4, 297944, 54, (SELECT id_album FROM Album WHERE titulo = 'Kamikaze')),
('E Side', 5*60+35, 714156, 247, (SELECT id_album FROM Album WHERE titulo = 'Doggystyle')),
('Bathtub', 4*60+15, 216025, 880, (SELECT id_album FROM Album WHERE titulo = 'Doggystyle')),
('G Funk Intro', 2*60+25, 30112, 95, (SELECT id_album FROM Album WHERE titulo = 'Doggystyle')),
('Encore', 4*60+10, 385271, 593, (SELECT id_album FROM Album WHERE titulo = 'The Black Album')),
('Change Clothes', 4*60+10, 7557119, 4157, (SELECT id_album FROM Album WHERE titulo = 'The Black Album')),
('Dirt Off Your Shoulder', 4*60+18, 3041, 41, (SELECT id_album FROM Album WHERE titulo = 'The Black Album')),
('Jimmy James', 3*60+11, 990586, 340, (SELECT id_album FROM Album WHERE titulo = 'Check Your Head')),
('Funky Boss', 2*60+28, 291527, 984, (SELECT id_album FROM Album WHERE titulo = 'Check Your Head')),
('Pass The Mic', 4*60+4, 307209, 891, (SELECT id_album FROM Album WHERE titulo = 'Check Your Head')),
('Wake Up Mr. West', 0*60+41, 412880, 9236, (SELECT id_album FROM Album WHERE titulo = 'Late Registration')),
('Heard Em Say', 3*60+24, 472110856, 545, (SELECT id_album FROM Album WHERE titulo = 'Late Registration')),
('Touch The Sky', 3*60+56, 452957, 984, (SELECT id_album FROM Album WHERE titulo = 'Late Registration')),
('Give Me Your Love', 8*60+48, 267016, 6, (SELECT id_album FROM Album WHERE titulo = 'Back To Mine')),
('Pacific 212', 3*60+35, 30755, 54, (SELECT id_album FROM Album WHERE titulo = 'Back To Mine')),
('Why Can not We Live Together', 4*60+47, 2162505, 157, (SELECT id_album FROM Album WHERE titulo = 'Back To Mine')),
('The Jingle', 4*60+38, 440523, 5352, (SELECT id_album FROM Album WHERE titulo = 'Play It Loud!')),
('Magic Tribe', 3*60+36, 42540796, 9, (SELECT id_album FROM Album WHERE titulo = 'Play It Loud!')),
('Kimbo', 4*60+54, 938720, 984, (SELECT id_album FROM Album WHERE titulo = 'Play It Loud!')),
('Cova Rosa', 5*60+31, 543440, 642, (SELECT id_album FROM Album WHERE titulo = 'Biosfera')),
('Oscos', 5*60+40, 310024, 54, (SELECT id_album FROM Album WHERE titulo = 'Biosfera')),
('Doiras', 5*60+22, 319672, 98, (SELECT id_album FROM Album WHERE titulo = 'Biosfera')),
('Aus', 9*60+25, 481667, 1164, (SELECT id_album FROM Album WHERE titulo = 'The Remixes')),
('Working', 7*60+5, 65968, 5, (SELECT id_album FROM Album WHERE titulo = 'The Remixes')),
('Pain In The Ass', 9*60+2, 3227, 158, (SELECT id_album FROM Album WHERE titulo = 'The Remixes')),
('Ignition Key', 8*60+5, 4819876, 4985, (SELECT id_album FROM Album WHERE titulo = 'Ignition Key')),
('The Convertion', 2*60+29, 1421912, 54, (SELECT id_album FROM Album WHERE titulo = 'Ignition Key')),
('Triangle', 6*60+2, 3200699, 524545, (SELECT id_album FROM Album WHERE titulo = 'Ignition Key')),
('Country Song', 6*60+43, 49580, 880, (SELECT id_album FROM Album WHERE titulo = 'Dance Baby')),
('Boys In The Hood', 5*60+32, 477856, 95, (SELECT id_album FROM Album WHERE titulo = 'Dance Baby')),
('Cloud Dancer', 4*60+10, 710247, 39, (SELECT id_album FROM Album WHERE titulo = 'Dance Baby'));

-- Tabla CancionGenero (relacionando las canciones insertadas con sus géneros)
INSERT INTO CancionGenero (id_cancion, id_genero) VALUES
((SELECT id_cancion FROM Cancion WHERE titulo = '11 Y 6'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'A Hand Fulla Gimme'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Adiós Nonino'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Air Conditioning'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Al Compas Del Corazon'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Alma De Bohemio'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'An Mein Klavier'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Años Luz'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Aquello'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Aus'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Bathtub'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Bemba Colora'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Blue N Boogie'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Bone Alphabet'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Borinquen'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Boys In The Hood'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Cancion Sobre Cancion'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Change Clothes'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Chorra'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Cloud Dancer'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Clueca la Cueca'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Comprendelo'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Country Song'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Crazeology'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Desesperado'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Dicen Que Dicen'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Dirt Off Your Shoulder'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Doiras'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Don Carlos'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'E Side'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Ebrio'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'El Amor Después Del Amor'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'El Todopoderoso'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'El Velorio'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Emborrachame De Amor'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Encore'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Es La Humanidad'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Estamos Juntos'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Estoy Aqui'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Fair Weather'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Fink Is The King'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'flor de piel'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Funky Boss'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'G Funk Intro'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'G. Song'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Gabbiani'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Give Me Your Love'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Greatest'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Groovin High'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Harmonielehre I'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Harmonielehre II .The Anfortas Wound'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Hawai'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Heard Em Say'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Hotel 49'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'I Surrender Dear'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'I Want To Know'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'If I Were A Bell'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Ignition Key'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'In A Minor For Cello And Orchestra, Op'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'In The Flesh'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'In The Summer'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Intermezzo'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'It Could Happen To You'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'It is All Right'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Jimmy James'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Kimbo'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'La Chanson Des Vieux Amants'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Le Repos Sur Le Lit'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Let Me Ride'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Lo Hecho Esta Hecho'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Loba'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Lover Man Oh Where Can You Be?'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Lucky You'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Magic Tribe'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Mama Guela'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Material Girl'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'MIce'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Michelangelo 70'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Milongón Del Guruyú'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'My father Knew Charles Ives and Harmonielehre'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'My Ideal'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'My Old Flame'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'No More'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'No Tengas Miedo'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'One Eight Seven'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Open Your Heart' LIMIT 1), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Open Your Heart' LIMIT 1,1), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Oscos'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Otoño Porteño'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Pacific 212'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Pain In The Ass'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Paraiso De Dulzura'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Pass The Mic'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Polka Dots And Moonbeams'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Prelude: Lento Allegro Maestoso'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Reels'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Shine On You Crazy Diamond'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Smack'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'solari yacumenza'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Son Con Guaguanco'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Soy Un Circo'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Sunrise And The Piper s Song'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Te Comiste Un Pan'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Temblando'), (SELECT id_genero FROM Genero WHERE nombre = 'Tango')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'That Ole Devil Called Love'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Children is March'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Convertion'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The End'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Rats'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Ringer'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Thin Ice'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Time And Motion Study I'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Time And Motion Study II'), (SELECT id_genero FROM Genero WHERE nombre = 'Música Clasica')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Touch The Sky'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Triangle'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Tu No Le Amas Le Temes'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Wake Up Mr. West'), (SELECT id_genero FROM Genero WHERE nombre = 'Hip Hop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'What Would I Do Without You'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Why Can not We Live Together'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Willie Baby'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Working'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Y Dale Alegría A Mi Corazón'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'You are My Everything'), (SELECT id_genero FROM Genero WHERE nombre = 'Jazz')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Come Together'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Come Together'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Cova Rosa'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Cova Rosa'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Gone For Bad'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Gone For Bad'), (SELECT id_genero FROM Genero WHERE nombre = 'Soul')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Jazzy'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Jazzy'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Oh! Darling'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Oh! Darling'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Satin And Lace'), (SELECT id_genero FROM Genero WHERE nombre = 'Salsa')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Satin And Lace'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Something'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Something'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Jingle'), (SELECT id_genero FROM Genero WHERE nombre = 'Techno')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'The Jingle'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Yet Another Movie'), (SELECT id_genero FROM Genero WHERE nombre = 'Pop')),
((SELECT id_cancion FROM Cancion WHERE titulo = 'Yet Another Movie'), (SELECT id_genero FROM Genero WHERE nombre = 'Rock'));

-- Tabla Usuario (al menos 3 registros como pide la consigna) [26, 34-36]
INSERT INTO Usuario (usuario, nombreCompleto, email, password, fecha_nacimiento, sexo, codigo_postal, id_pais, tipo_usuario) VALUES
('MORTIZ', 'MARIA ORTIZ', 'mortiz@email.com', 'hashed_pass1', '1975-09-27', 'F', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('IBALLESTEROS', 'ISABEL BALLESTEROS', 'iballesteros@email.com', 'hashed_pass2', '1987-10-17', 'F', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('CRAMIREZ', 'CARMEN RAMIREZ', 'cramirez@email.com', 'hashed_pass3', '1994-08-26', 'F', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('MGONZALEZ', 'MARIA PAULA GONZALEZ', 'mgonzalez@email.com', 'hashed_pass4', '1981-03-27', 'F', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('EHERNANDEZ', 'EMILY HERNANDEZ', 'ehernandez@email.com', 'hashed_pass5', '2001-02-10', 'F', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('LGOMEZ', 'LUISA GOMEZ', 'lgomez@email.com', 'hashed_pass6', '1971-12-12', 'F', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('MSOSA', 'MARIA CARMEN SOSA', 'msosa@email.com', 'hashed_pass7', '1981-07-16', 'F', '3', (SELECT id_pais FROM Pais WHERE nombre = 'España'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('MSMITH', 'MARY SMITH', 'msmith@email.com', 'hashed_pass8', '2000-05-04', 'F', 'B24', (SELECT id_pais FROM Pais WHERE nombre = 'Inglaterra'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('PSOTO', 'PATRICIA SOTO', 'psoto@email.com', 'hashed_pass9', '1974-07-12', 'F', '8320000', (SELECT id_pais FROM Pais WHERE nombre = 'Chile'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Free')),
('AGARCIA', 'ANTONIO GARCIA', 'agarcia@email.com', 'hashed_pass10', '1995-08-30', 'M', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('JMARTINEZ', 'JOSE MARTINEZ', 'jmartinez@email.com', 'hashed_pass11', '1987-11-22', 'M', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('FLOPEZ', 'FRANCISCO LOPEZ', 'flopez@email.com', 'hashed_pass12', '1988-02-16', 'M', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Free')),
('JSANCHEZ', 'JUAN SANCHEZ', 'jsanchez@email.com', 'hashed_pass13', '2003-03-23', 'M', '1001', (SELECT id_pais FROM Pais WHERE nombre = 'Argentina'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Free')),
('MRODRIGUEZ', 'MIGUEL ANGEL RODRIGUEZ', 'mrodriguez@email.com', 'hashed_pass14', '2003-10-16', 'M', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('JDIAZ', 'JUAN ESTEBAN DIAZ', 'jdiaz@email.com', 'hashed_pass15', '1973-05-23', 'M', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Premium')),
('JLOPEZ', 'JUAN SEBASTIAN LOPEZ', 'jlopez@email.com', 'hashed_pass16', '1974-03-15', 'M', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('SMARTINEZ', 'SANTIAGO MARTINEZ', 'smartinez@email.com', 'hashed_pass17', '1977-07-18', 'M', '118942', (SELECT id_pais FROM Pais WHERE nombre = 'Colombia'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('DRUBIO', 'DAVID RUBIO', 'drubio@email.com', 'hashed_pass18', '2001-01-17', 'M', '60000', (SELECT id_pais FROM Pais WHERE nombre = 'Uruguay'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Standard')),
('JWATSON', 'JHON WATSON', 'jwatson@email.com', 'hashed_pass19', '2003-10-22', 'M', '10029', (SELECT id_pais FROM Pais WHERE nombre = 'Estados Unidos'), (SELECT id_tipo_usuario FROM TipoUsuario WHERE nombre = 'Free'));

-- 3. INSERTAR DATOS EN TABLAS DE TRANSACCIONES Y RELACIONES COMPLEJAS

-- Tabla Playlist (datos de ejemplo basados en el JSON) [37-40]
INSERT INTO Playlist (id_usuario, titulo, cant_canciones, fecha_creacion, eliminada, fecha_eliminacion) VALUES
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), 'Para correr', 15, '2020-02-27', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), 'Para Estudiar', 10, '2019-05-07', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), 'Para Gym', 15, '2020-03-07', TRUE, '2020-04-10'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), 'Las mejores canciones', 10, '2017-06-06', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), 'Mis canciones favoritos', 10, '2016-09-29', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), 'Top 20', 20, '2016-06-06', TRUE, '2016-04-12'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), 'Mi top 10', 10, '2017-06-16', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), 'Lo mejor del Rock', 10, '2018-07-11', FALSE, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ'), 'Musica Latina', 5, '2016-12-11', TRUE, '2016-02-19'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ'), 'Pop', 6, '2016-06-23', FALSE, NULL);

-- Tabla PlaylistCancion (simulando que se añaden las canciones a las playlists)
INSERT INTO PlaylistCancion (id_playlist, id_cancion) VALUES
-- Playlist: Para correr [2]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para correr'), (SELECT id_cancion FROM Cancion WHERE titulo = 'In The Flesh')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para correr'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Pain In The Ass')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para correr'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Loba')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para correr'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Es La Humanidad')),

-- Playlist: Para Estudiar [2]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Estudiar'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Le Repos Sur Le Lit')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Estudiar'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Harmonielehre II .The Anfortas Wound')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Estudiar'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Sunrise And The Piper s Song')),

-- Playlist: Para Gym [2]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Gym'), (SELECT id_cancion FROM Cancion WHERE titulo = 'G. Song')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Gym'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Smack')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Gym'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Loba')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Gym'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Bemba Colora')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Para Gym'), (SELECT id_cancion FROM Cancion WHERE titulo = 'In The Flesh')),

-- Playlist: Las mejores canciones [2]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Las mejores canciones'), (SELECT id_cancion FROM Cancion WHERE titulo = 'In The Flesh')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Las mejores canciones'), (SELECT id_cancion FROM Cancion WHERE titulo = 'The Thin Ice')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Las mejores canciones'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Gone For Bad')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Las mejores canciones'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Shine On You Crazy Diamond')),

-- Playlist: Mis canciones favoritos [3]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mis canciones favoritos'), (SELECT id_cancion FROM Cancion WHERE titulo = 'El Amor Después Del Amor')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mis canciones favoritos'), (SELECT id_cancion FROM Cancion WHERE titulo = 'La Cura')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mis canciones favoritos'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Dices que te vas')),

-- Playlist: Top 20 [3]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Shine On You Crazy Diamond')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Open Your Heart' LIMIT 1)),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Gabbiani')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Crazeology')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Smack')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Yet Another Movie')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Come Together')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Mañana')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Harmonielehre I')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Dices que te vas')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'The Thin Ice')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Alma De Bohemio')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Willie Baby')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = '11 Y 6')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Y Dale Alegría A Mi Corazón')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Tu No Le Amas Le Temes')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'The Rats')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Intermezzo')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Estamos Juntos')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Top 20'), (SELECT id_cancion FROM Cancion WHERE titulo = 'It Could Happen To You')),

-- Playlist: Mi top 10 [4]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'If I Were A Bell')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Al Compas Del Corazon')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Satin And Lace')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Open Your Heart' LIMIT 1)),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Reels')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Groovin High')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Time And Motion Study I')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'La tierra prometida')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Estamos Juntos')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Mi top 10'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Time And Motion Study II')),

-- Playlist: Lo mejor del Rock [4]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Shine On You Crazy Diamond')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = 'In The Flesh')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Fink Is The King')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = 'The End')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = '11 Y 6')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Lo mejor del Rock'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Y Dale Alegría A Mi Corazón')),

-- Playlist: Musica Latina [5]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Musica Latina'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Estamos Juntos')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Musica Latina'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Cancion Sobre Cancion')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Musica Latina'), (SELECT id_cancion FROM Cancion WHERE titulo = 'No Tengas Miedo')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Musica Latina'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Estoy Aqui')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Musica Latina'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Años Luz')),

-- Playlist: Pop [5]
((SELECT id_playlist FROM Playlist WHERE titulo = 'Pop'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Open Your Heart' LIMIT 1)),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Pop'), (SELECT id_cancion FROM Cancion WHERE titulo = 'No Tengas Miedo')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Pop'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Satin And Lace')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Pop'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Cova Rosa')),
((SELECT id_playlist FROM Playlist WHERE titulo = 'Pop'), (SELECT id_cancion FROM Cancion WHERE titulo = 'Lo Hecho Esta Hecho'));

-- Tabla Suscripcion (ejemplos) [41-43]
INSERT INTO Suscripcion (id_usuario, fecha_inicio, fecha_renovacion) VALUES
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-01-01', '2020-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-02-01', '2020-03-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-02-01', '2020-03-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2020-03-01', '2020-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2020-04-01', '2020-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MRODRIGUEZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ'), '2020-05-01', '2020-08-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), '2020-06-01', '2020-09-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), '2020-06-01', '2020-09-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), '2020-06-01', '2020-09-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON'), '2020-07-01', '2020-10-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ'), '2020-08-01', '2020-11-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), '2020-09-01', '2020-12-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), '2020-09-01', '2020-12-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), '2020-09-01', '2020-12-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON'), '2020-10-01', '2021-01-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ'), '2020-11-01', '2021-02-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), '2020-12-01', '2021-03-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), '2020-12-01', '2021-03-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), '2020-12-01', '2021-03-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON'), '2021-01-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ'), '2021-02-01', '2021-04-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), '2021-03-01', '2021-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), '2021-03-01', '2021-05-01'),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), '2021-03-01', '2021-05-01');

-- Tabla TipoFormaPago
INSERT INTO TipoFormaPago (nombre) VALUES 
('Efectivo'),('Tarjeta de Debito'),('Tarjeta de credito'),('Debito Automatico x Banco');

-- Tabla DatosPagoUsuario 
INSERT INTO DatosPagoUsuario (id_usuario, id_tipo_forma_pago, cbu, nro_tarjeta, mes_caduca, anio_caduca) VALUES
-- Datos del usuario MORTIZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 1881', 1, 21),
-- Datos del usuario IBALLESTEROS
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 8181', 10, 30),
((SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************1117', NULL, 10, 31),
-- Datos del usuario CRAMIREZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 0087', 10, 28),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 0000', 12, 21),
((SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 1117', 10, 31),
-- Datos del usuario MGONZALEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 6300', 1, 21),
-- Datos del usuario EHERNANDEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************3748', NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 5824', 11, 21),
((SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 4654', 11, 21),
-- Datos del usuario LGOMEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************2854', NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 6545', 10, 22),
-- Datos del usuario MSOSA
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************4454', NULL, 12, 21),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 5454', 10, 23),
-- Datos del usuario MSMITH
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 8431', 8, 24),
((SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 4654', 10, 22),
-- Datos del usuario PSOTO
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 8485', 5, 22),
-- Datos del usuario AGARCIA
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************0002', NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 5645', 10, 24),
-- Datos del usuario JMARTINEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 6300', 1, 21),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 4654', 10, 22),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 6545', 10, 22),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************9485', NULL, NULL, NULL),
-- Datos del usuario FLOPEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 3237', 12, 21),
-- Datos del usuario JSANCHEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 5904', 11, 25),
-- Datos del usuario MRODRIGUEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'MRODRIGUEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************2077', NULL, NULL, NULL),
-- Datos del usuario JDIAZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 8431', 5, 29),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 7879', 11, 25),
-- Datos del usuario JLOPEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 0005', 4, 20),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************5478', NULL, NULL, NULL),
-- Datos del usuario SMARTINEZ
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 0007', 2, 20),
((SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 5645', 10, 24),
-- Datos del usuario DRUBIO
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 0009', 3, 30),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Efectivo'), NULL, NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de Debito'), NULL, '**** **** **** 7987', 11, 25),
-- Datos del usuario JWATSON
((SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Debito Automatico x Banco'), '******************4096', NULL, NULL, NULL),
((SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON'), (SELECT id_tipo_forma_pago FROM TipoFormaPago WHERE nombre = 'Tarjeta de credito'), NULL, '**** **** **** 0000', 12, 21);



INSERT INTO Pagos (id_suscripcion, fecha_pago, importe, id_datos_pago) VALUES
-- Pagos de Enero 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-01-01'), '2020-01-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
-- Pagos de Febrero 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-02-01'), '2020-02-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-03-01'), '2020-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Tarjeta de credito')),
-- Pagos de Marzo 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-03-01'), '2020-03-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2020-03-01'), '2020-03-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito')), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-03-01'), '2020-03-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2020-03-01'), '2020-03-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de credito' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2020-03-01'), '2020-03-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Efectivo'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2020-03-01'), '2020-03-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Efectivo'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH') AND fecha_inicio = '2020-03-01'), '2020-03-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSMITH') AND nombre = 'Tarjeta de Debito' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2020-03-01'), '2020-03-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2020-03-01'), '2020-03-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco'LIMIT 1)), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2020-03-01'), '2020-03-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de Debito'LIMIT 1)),
-- Pagos de Abril 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo'LIMIT 1)), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-04-01'), '2020-04-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Debito Automatico x Banco'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de Debito'LIMIT 1)), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Tarjeta de Debito'LIMIT 1)), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND nombre = 'Debito Automatico x Banco'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2020-04-01'), '2020-04-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Tarjeta de Debito'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Tarjeta de Debito'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2020-04-01'), '2020-04-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2020-04-01'), '2020-04-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco'LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2020-04-01'), '2020-04-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de credito'LIMIT 1)),
-- Pagos de Mayo 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-05-01'), '2020-05-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito')), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2020-05-01'), '2020-05-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Tarjeta de Debito')), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2020-05-01'), '2020-05-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2020-05-01'), '2020-05-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MRODRIGUEZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MRODRIGUEZ') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JDIAZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-05-01'), '2020-05-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
-- Pagos de Junio 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND fecha_inicio = '2020-06-01'), '2020-06-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND nombre = 'Debito Automatico x Banco' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND fecha_inicio = '2020-06-01'), '2020-06-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND nombre = 'Tarjeta de Debito' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND fecha_inicio = '2020-06-01'), '2020-06-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND nombre = 'Efectivo' LIMIT 1)),
-- Pagos de Julio 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND fecha_inicio = '2020-07-01'), '2020-07-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND nombre = 'Tarjeta de credito')),
-- Pagos de Agosto 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-08-01'), '2020-08-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2020-08-01'), '2020-08-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2020-08-01'), '2020-08-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2020-08-01'), '2020-08-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND fecha_inicio = '2020-08-01'), '2020-08-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND nombre = 'Tarjeta de Debito')),
-- Pagos de Septiembre 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND fecha_inicio = '2020-09-01'), '2020-09-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND nombre = 'Debito Automatico x Banco' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND fecha_inicio = '2020-09-01'), '2020-09-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND nombre = 'Tarjeta de Debito' LIMIT 1)), 
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND fecha_inicio = '2020-09-01'), '2020-09-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND nombre = 'Efectivo' LIMIT 1)),
-- Pagos de Octubre 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND fecha_inicio = '2020-10-01'), '2020-10-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2020-10-01'), '2020-10-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2020-10-01'), '2020-10-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2020-10-01'), '2020-10-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2020-10-01'), '2020-10-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND fecha_inicio = '2020-10-01'), '2020-10-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND nombre = 'Tarjeta de Debito')),
-- Pagos de Diciembre 2020
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND fecha_inicio = '2020-12-01'), '2020-12-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JLOPEZ') AND nombre = 'Debito Automatico x Banco' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND fecha_inicio = '2020-12-01'), '2020-12-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND nombre = 'Tarjeta de Debito' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND fecha_inicio = '2020-12-01'), '2020-12-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND nombre = 'Efectivo' LIMIT 1)),
-- Pagos de Enero 2021
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND fecha_inicio = '2021-01-01'), '2021-01-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND nombre = 'Tarjeta de credito')),
-- Pagos de Febrero 2021
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND fecha_inicio = '2021-02-01'), '2021-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'IBALLESTEROS') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'CRAMIREZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MGONZALEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'EHERNANDEZ') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'LGOMEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND fecha_inicio = '2021-02-01'), '2021-02-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MSOSA') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'MORTIZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND fecha_inicio = '2021-02-01'), '2021-02-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'PSOTO') AND nombre = 'Efectivo')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND fecha_inicio = '2021-02-01'), '2021-02-01', 0, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'AGARCIA') AND nombre = 'Debito Automatico x Banco')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 100, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JMARTINEZ') AND nombre = 'Tarjeta de credito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'FLOPEZ') AND nombre = 'Tarjeta de Debito')),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND fecha_inicio = '2021-02-01'), '2021-02-01', 800, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JSANCHEZ') AND nombre = 'Tarjeta de Debito')),
-- Pagos de Marzo 2021
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND fecha_inicio = '2021-03-01'), '2021-03-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'SMARTINEZ') AND nombre = 'Tarjeta de Debito' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND fecha_inicio = '2021-03-01'), '2021-03-01', 200, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'DRUBIO') AND nombre = 'Efectivo' LIMIT 1)),
((SELECT id_suscripcion FROM Suscripcion WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND fecha_inicio = '2021-03-01'), '2021-03-01', 500, (SELECT D.id_datos_pago FROM DatosPagoUsuario D JOIN TipoFormaPago T ON D.id_tipo_forma_pago = T.id_tipo_forma_pago WHERE id_usuario = (SELECT id_usuario FROM Usuario WHERE usuario = 'JWATSON') AND nombre = 'Tarjeta de credito' LIMIT 1));
