CREATE OR REPLACE FUNCTION no_testo_function()
  RETURNS trigger AS
$$
BEGIN
 	IF (NEW.”tipoInterazione” LIKE 'like') THEN
		UPDATE interazione SET testo=NULL
			WHERE "idInterazione"=NEW."idInterazione";
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql';
 
CREATE TRIGGER "noTestoInLike"
AFTER INSERT on interazione
FOR EACH ROW
EXECUTE FUNCTION no_testo_function();

-----------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION coerenza_data_post_function()
  RETURNS trigger AS
$$
DECLARE
 dataCreazioneGruppo DATE;
BEGIN
 	SELECT “dataCreazione”
		INTO dataCreazioneGruppo
		FROM gruppo
		WHERE "idGruppo"=NEW."idGruppo";
	IF(NEW."dataPubblicazione"<dataCreazioneGruppo) THEN
		UPDATE post SET "dataPubblicazione"=CURRENT_DATE, "oraPubblicazione"=CURRENT_TIME	
		WHERE "idPost"=NEW."idPost";
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "coerenzaDataPost"
AFTER INSERT on post
FOR EACH ROW
EXECUTE FUNCTION coerenza_data_post_function();

------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION coerenza_data_interazione_function()
  RETURNS trigger AS
$$
DECLARE
 dataPubblicazionePost DATE;
 oraPubblicazionePost TIME;
BEGIN
 	SELECT "dataPubblicazione","oraPubblicazione"
		INTO dataPubblicazionePost,oraPubblicazionePost
		FROM post
		WHERE "idPost"=NEW."idPost";
	IF((NEW.data<dataPubblicazionePost) OR (NEW.data=dataPubblicazionePost AND NEW.ora<oraPubblicazionePost) ) THEN
		UPDATE interazione SET data=CURRENT_DATE,ora=CURRENT_TIME		        
		WHERE "idInterazione"=NEW."idInterazione";
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "coerenzaDataInterazione"
AFTER INSERT ON interazione
FOR EACH ROW
EXECUTE FUNCTION coerenza_data_interazione_function();



-------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION coerenza_data_notificapost_function()
  RETURNS trigger AS
$$
DECLARE
 dataPubblicazionePost DATE;
 oraPubblicazionePost TIME;
BEGIN
 	SELECT "dataPubblicazione","oraPubblicazione"
		INTO dataPubblicazionePost,oraPubblicazionePost
		FROM post
		WHERE "idPost"=NEW."idPost";
	IF (NEW."idInterazione"=NULL) THEN
		IF((NEW.data<dataPubblicazionePost) OR (NEW.data=dataPubblicazionePost AND NEW.ora<oraPubblicazionePost)) THEN
			UPDATE notifica SET data=CURRENT_DATE,ora=CURRENT_TIME		        
			WHERE "idNotifica"=NEW."idNotifica";
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "coerenzaDataNotificaPost"
AFTER INSERT ON notifica
FOR EACH ROW
EXECUTE FUNCTION coerenza_data_notificapost_function();

---------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION coerenza_data_notificainterazione_function()
  RETURNS trigger AS
$$
DECLARE
 dataInterazione DATE;
 oraInterazione TIME;
BEGIN
 	SELECT data,ora
		INTO dataInterazione,oraInterazione
		FROM interazione
		WHERE "idInterazione"=NEW."idInterazione";
	IF (NEW."idInterazione"<>NULL) THEN
		IF((NEW.data<dataInterazione) OR (NEW.data=dataInterazione AND NEW.ora<oraInterazione) ) THEN
			UPDATE notifica SET data=CURRENT_DATE,ora=CURRENT_TIME		        
			WHERE "idNotifica"=NEW."idNotifica";
		END IF;
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "coerenzaDataNotificaInterazione"
AFTER INSERT ON notifica
FOR EACH ROW
EXECUTE FUNCTION coerenza_data_notificainterazione_function();

-----------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION coerenza_data_richiesta_function()
  RETURNS trigger AS
$$
DECLARE
 dataCreazioneGruppo DATE;
BEGIN
 	SELECT "dataCreazione"
		INTO dataCreazioneGruppo
		FROM gruppo
		WHERE "idGruppo"=NEW."idGruppo";
	IF(NEW."dataRichiesta"<dataCreazioneGruppo) THEN
		UPDATE richiesta SET "dataRichiesta"=CURRENT_DATE, "oraRichiesta"=CURRENT_TIME		        
		WHERE "idRichiesta"=NEW."idRichiesta";
	END IF;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "coerenzaDataRichiesta"
AFTER INSERT on richiesta
FOR EACH ROW
EXECUTE FUNCTION coerenza_data_richiesta_function();
----------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION esito_true_richiesta_function()
  RETURNS trigger AS
$$
DECLARE
 myIdGruppo gruppo."idGruppo"%TYPE;
 myUsername utente."username"%TYPE;
BEGIN
 	SELECT "idGruppo","username"
		INTO myIdGruppo,myUsername
		FROM richiesta
		WHERE "idRichiesta"=NEW."idRichiesta";
	INSERT INTO iscrizione VALUES(myUsername,myIdGruppo);
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "esitoTrueRichiesta"
AFTER UPDATE OF esito ON richiesta 
FOR EACH ROW
WHEN (NEW.esito = true)
EXECUTE FUNCTION esito_true_richiesta_function();

---------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION genera_notificaaccesso_function()
  RETURNS trigger AS
$$
DECLARE
 myUsernameCreatore utente."username"%TYPE;
 myIdNotifica notifica."idNotifica"%TYPE;
BEGIN
 	SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255)
	INTO myIdNotifica
	FROM notifica;
	
	SELECT "usernameCreatore"
	INTO myUsernameCreatore
	FROM gruppo
	WHERE "idGruppo"=NEW."idGruppo";
	
	INSERT INTO notifica VALUES (myIdNotifica,CURRENT_DATE,CURRENT_TIME,myUsernameCreatore, NULL, NULL);
	
	RETURN NULL;

END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "generaNotificaAccesso"
AFTER INSERT on iscrizione
FOR EACH ROW
EXECUTE FUNCTION genera_notificaaccesso_function();

-----------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION genera_notificapost_function()
  RETURNS trigger AS
$$
DECLARE
 cursoreIscritti cursor FOR (SELECT username
				FROM iscrizione
				WHERE "idGruppo"=NEW."idGruppo" AND "username"<>NEW."username"
				);
 cursoreAmministratori cursor FOR (SELECT username
					FROM amministra
					WHERE "idGruppo"=NEW."idGruppo" AND "username"<>NEW."username"
				   );
 myIdNotifica notifica."idNotifica"%TYPE;
BEGIN
	
	FOR iscritto IN cursoreIscritti
	LOOP
		SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255)
		INTO myIdNotifica
		FROM notifica;

		INSERT INTO notifica VALUES (myIdNotifica,CURRENT_DATE,CURRENT_TIME,iscritto.username,NEW."idPost",NULL);
	END LOOP;
	
	FOR amministratore IN cursoreAmministratori
	LOOP
		SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255)
		INTO myIdNotifica
		FROM notifica;

		INSERT INTO notifica VALUES (myIdNotifica,CURRENT_DATE,CURRENT_TIME,amministratore.username,NEW."idPost",NULL);
	END LOOP;
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "generaNotificaPost"
AFTER INSERT on post
FOR EACH ROW
EXECUTE FUNCTION genera_notificapost_function();

-----------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION genera_notificainterazione_function()
  RETURNS trigger AS
$$
DECLARE
 myUsernameAutore utente."username"%TYPE;
 myIdNotifica notifica."idNotifica"%TYPE;
BEGIN
 	SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255)
	INTO myIdNotifica
	FROM notifica;
	
	SELECT "username"
	INTO myUsernameAutore
	FROM post
	WHERE "idPost"=NEW."idPost";
	
	INSERT INTO notifica VALUES (myIdNotifica,CURRENT_DATE,CURRENT_TIME,myUsernameAutore,NULL,NEW."idInterazione");
	
	RETURN NULL;
END;
$$
LANGUAGE 'plpgsql'; 

CREATE TRIGGER "generaNotificaInterazione"
AFTER INSERT on interazione
FOR EACH ROW
EXECUTE FUNCTION genera_notificainterazione_function();

----------------------------------------------------------------------------------------------