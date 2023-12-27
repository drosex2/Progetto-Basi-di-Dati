CREATE TABLE Utente (
	username VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255)
);
ALTER TABLE utente ADD CONSTRAINT "pkUtente" PRIMARY KEY (username);

ALTER TABLE utente ADD CONSTRAINT uniqueEmail UNIQUE(email);



CREATE TABLE Gruppo (
    "idGruppo" VARCHAR(255),
    nome VARCHAR(255),
    tag VARCHAR(255),
    "dataCreazione" DATE,
    "usernameCreatore" VARCHAR(255)
);

ALTER TABLE gruppo ADD CONSTRAINT "pkGruppo" PRIMARY KEY ("idGruppo");

ALTER TABLE gruppo ADD CONSTRAINT "fkUtenteCreatore" FOREIGN KEY ("usernameCreatore") REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE Gruppo ADD CONSTRAINT uniqueNomeGruppo UNIQUE(nome);



CREATE TABLE Richiesta (
    "idRichiesta" VARCHAR(255),
    "dataRichiesta" DATE,
    "oraRichiesta" TIME,
    testo VARCHAR(255),
    esito BOOLEAN DEFAULT false,
    username VARCHAR(255),
    "idGruppo" VARCHAR(255)
    
);
ALTER TABLE richiesta ADD CONSTRAINT "pkRichiesta" PRIMARY KEY ("idRichiesta");

ALTER TABLE richiesta ADD CONSTRAINT "fkUsername" FOREIGN KEY ("username") REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE richiesta ADD CONSTRAINT "fkIdGruppo" FOREIGN KEY ("idGruppo") REFERENCES gruppo("idGruppo") ON DELETE CASCADE;



CREATE TABLE Post (
    "idPost" VARCHAR(255),
    foto VARCHAR(255),
    testo VARCHAR(255),
    "dataPubblicazione" DATE,
    "oraPubblicazione" TIME,
    "idGruppo" VARCHAR(255),
    username VARCHAR(255)
);
ALTER TABLE post ADD CONSTRAINT "pkPost" PRIMARY KEY ("idPost");

ALTER TABLE post ADD CONSTRAINT "fkUsername" FOREIGN KEY ("username") REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE post ADD CONSTRAINT "fkIdGruppo" FOREIGN KEY ("idGruppo") REFERENCES gruppo("idGruppo") ON DELETE CASCADE;

ALTER TABLE post ADD CONSTRAINT "postNonVuoto"
CHECK ((foto IS NOT NULL OR testo IS NOT NULL) AND NOT (foto IS NULL AND testo IS NULL));




CREATE TABLE Interazione (
"idInterazione" VARCHAR(255),
data DATE,
ora TIME,
testo VARCHAR(255),
"tipoInterazione" VARCHAR(255),
username VARCHAR(255),
"idPost" VARCHAR(255)
);
ALTER TABLE interazione ADD CONSTRAINT "pkInterazione" PRIMARY KEY ("idInterazione");

ALTER TABLE interazione ADD CONSTRAINT "fkUsername" FOREIGN KEY ("username") REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE interazione ADD CONSTRAINT "fkIdPost" FOREIGN KEY ("idPost") REFERENCES post("idPost") ON DELETE CASCADE ;

ALTER TABLE interazione ADD CONSTRAINT dominioTipoInterazione CHECK ("tipoInterazione" IN ('like','commento'));



CREATE TABLE Notifica (
"idNotifica" VARCHAR(255),
data DATE,
ora TIME,
username VARCHAR(255),
"idPost" VARCHAR(255),
"idInterazione" VARCHAR(255)
);
ALTER TABLE notifica ADD CONSTRAINT "pkNotifica" PRIMARY KEY ("idNotifica");

ALTER TABLE notifica ADD CONSTRAINT "fkUsername" FOREIGN KEY ("username") REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE notifica ADD CONSTRAINT "fkIdPost" FOREIGN KEY ("idPost") REFERENCES post("idPost") ON DELETE CASCADE;

ALTER TABLE notifica ADD CONSTRAINT "fkIdInterazione" FOREIGN KEY ("idInterazione") REFERENCES interazione("idInterazione") ON DELETE CASCADE;



CREATE TABLE Iscrizione (
username VARCHAR(255),
"idGruppo" VARCHAR(255)
);
ALTER TABLE iscrizione ADD CONSTRAINT "fkUsername" FOREIGN KEY(username) REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE iscrizione ADD CONSTRAINT "fkIdGruppo" FOREIGN KEY("idGruppo") REFERENCES gruppo("idGruppo") ON DELETE CASCADE;



CREATE TABLE Amministra (
username VARCHAR(255),
"idGruppo" VARCHAR(255)
);
ALTER TABLE amministra ADD CONSTRAINT "fkUsername" FOREIGN KEY(username) REFERENCES utente(username) ON DELETE CASCADE;

ALTER TABLE amministra ADD CONSTRAINT "fkIdGruppo" FOREIGN KEY("idGruppo") REFERENCES gruppo("idGruppo") ON DELETE CASCADE;
