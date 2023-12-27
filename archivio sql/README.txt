Questo vincolo assicura che nella base di dati non esistano interazioni di tipo like contenenti del testo  (possibile solo per interazioni di tipo commento)

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
Questo vincolo intercetta i post che hanno una data di pubblicazione precedente alla creazione del gruppo. Nel caso in cui ciò si verifichi la data e l'ora vengono sostituite con la data e l'ora attuale del sistema.

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
Questo vincolo intercetta le interazioni (like e commenti) che hanno data e ora non coerenti con quelli del post. Nel caso in cui ciò si verifichi la data e l'ora vengono sostituite con la data e l'ora attuale del sistema.


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
Questo vincolo intercetta le notifiche generate da post che hanno data e orario precedenti alla creazione del post. Nel caso in cui ciò si verifichi la data e l'ora vengono sostituite con la data e l'ora attuale del sistema.

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
Questo vincolo intercetta le notifiche generate da interazioni che hanno data e orario precedenti all'interazione generante. Nel caso in cui ciò si verifichi la data e l'ora vengono sostituite con la data e l'ora attuale del sistema.

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
Questo vincolo intercetta le richieste che hanno data precedente alla data di creazione del gruppo. Nel caso in cui ciò si verifichi la data e l'ora vengono sostituite con la data e l'ora attuale del sistema.

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
Qusto vincolo crea una nuova istanza di iscrizione quando una richiesta viene accettata (viene aggiornato l'esito a true)

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
Questo vincolo si occupa di creare una riga di notifica quando viene creata una nuova riga di iscrizione. Il campo username della notifica è l'usernameCreatore del gruppo
mentre le chiavi esterne idPost e idInterazione restano null.

CREATE OR REPLACE FUNCTION genera_notificaaccesso_function()
  RETURNS trigger AS
$$
DECLARE
 myUsernameCreatore utente."username"%TYPE;
 myIdNotifica notifica."idNotifica"%TYPE;
BEGIN
 	SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255) -- ricavo l'idNotifica ricavando il massimo id e incrementandolo di uno (con appositi casting)
	INTO myIdNotifica
	FROM notifica;
	
	SELECT "usernameCreatore" --ricavo l'username del creatore del gruppo
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
Questo vincolo si occupa di creare una riga di notifica per ogni utente e per ogni amministratore del gruppo quando viene creata un nuovo post.
Il campo idPost avrà come valore l'id del post inserito mentre l'idIterazione avrà valore NULL.

CREATE OR REPLACE FUNCTION genera_notificapost_function()
  RETURNS trigger AS
$$
DECLARE

--dichiaro un cursore contenenti gli username degli utenti iscritti al gruppo in cui è stato inserito il post (ad eccezione dell'autore del post)
 cursoreIscritti cursor FOR (SELECT username
				FROM iscrizione
				WHERE "idGruppo"=NEW."idGruppo" AND "username"<>NEW."username"
				);

--dichiaro un cursore contenenti gli username degli utenti che amministrano il gruppo in cui è stato inserito il post (ad eccezione dell'autore del post)
 cursoreAmministratori cursor FOR (SELECT username
					FROM amministra
					WHERE "idGruppo"=NEW."idGruppo" AND "username"<>NEW."username"
				);
 myIdNotifica notifica."idNotifica"%TYPE;
BEGIN
	
	FOR iscritto IN cursoreIscritti --nel loop genero una notifica per tutti gli iscritti nel cursore
	LOOP
		SELECT (MAX("idNotifica" :: INTEGER)+1)::VARCHAR(255)
		INTO myIdNotifica
		FROM notifica;

		INSERT INTO notifica VALUES (myIdNotifica,CURRENT_DATE,CURRENT_TIME,iscritto.username,NEW."idPost",NULL);
	END LOOP;
	
	FOR amministratore IN cursoreAmministratori --nel loop genero una notifica per tutti gli amministratori nel cursore
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
Quando viene inserita una riga di interazione viene creata una notifica. Il campo username della notifica è l'username dell'autore del post, il campo idInterazione
è l'id dell'interazione generante, il campo idPost avrà valore NULL
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