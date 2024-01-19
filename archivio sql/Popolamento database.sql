--popolamento tabella utente
INSERT INTO utente VALUES ('sjobs','sjobs@icloud.com','pw0001');
INSERT INTO utente VALUES ('JohnDoe', 'john_doe@email.com', 'pw0002');
INSERT INTO utente VALUES ('MarySmith', 'mary_smith@gmail.com', 'pw0003');
INSERT INTO utente VALUES ('JFKennedy', 'jf_kennedy@yahoo.com', 'pw0004');
INSERT INTO utente VALUES ('AliceExample', 'alice_example@hotmail.com', 'pw0005');
INSERT INTO utente VALUES ('BobTest', 'bob_test@email.com', 'pw0006');
INSERT INTO utente VALUES ('DavidSmith', 'david_smith@example.com', 'pw0007');
INSERT INTO utente VALUES ('EmilyJones', 'emily_jones@example.com', 'pw0008');
INSERT INTO utente VALUES ('MichaelBrown', 'michael_brown@example.com', 'pw0009');
INSERT INTO utente VALUES ('SophiaClark', 'sophia_clark@example.com', 'pw0010');
INSERT INTO utente VALUES ('janedoe', 'jane_doe@email.com', 'janepass');
INSERT INTO utente VALUES ('alexsmith', 'alex_smith@gmail.com', 'alexpass');
INSERT INTO utente VALUES ('laurajones', 'laura_jones@yahoo.com', 'laurapass');
INSERT INTO utente VALUES ('markbrown', 'mark_brown@hotmail.com', 'markpass');
INSERT INTO utente VALUES ('sarahclark', 'sarah_clark@gmail.com', 'sarahpass');


--popolamento tabella gruppo
INSERT INTO Gruppo VALUES ('g1', 'Informatici', 'DevTeam', '2023-01-01', 'sjobs');
INSERT INTO Gruppo VALUES ('g2', 'Serie A 2023-24', 'calcio', '2023-02-15', 'JohnDoe');
INSERT INTO Gruppo VALUES ('g3', 'Designer', 'DesignTeam', '2023-03-10', 'MarySmith');
INSERT INTO Gruppo VALUES ('g4', 'Cinefili', 'Film e Serie TV', '2023-04-05', 'JFKennedy');

--popolamento richieste
INSERT INTO richiesta ("idRichiesta","dataRichiesta","oraRichiesta",testo,username,"idGruppo")
 VALUES ('r1',CURRENT_DATE,CURRENT_TIME,'accettami per piacere','sjobs','g3');
 
INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r4', CURRENT_DATE, CURRENT_TIME, 'Accettami per favore', 'JohnDoe', 'g3');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r2', CURRENT_DATE, CURRENT_TIME, 'Mi piacerebbe unirmi', 'MarySmith', 'g1');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r3', CURRENT_DATE, CURRENT_TIME, 'Richiesta di partecipazione', 'JFKennedy', 'g2');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r5', CURRENT_DATE, CURRENT_TIME, 'Chiedo di essere accettato', 'alexsmith', 'g1');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r6', CURRENT_DATE, CURRENT_TIME, 'Accettate la mia richiesta', 'laurajones', 'g2');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r7', CURRENT_DATE, CURRENT_TIME, 'Sono interessato al gruppo', 'markbrown', 'g3');

INSERT INTO richiesta ("idRichiesta", "dataRichiesta", "oraRichiesta", testo, username, "idGruppo")
VALUES ('r8', CURRENT_DATE, CURRENT_TIME, 'Accettate la mia richiesta', 'sarahclark', 'g4');


-- popolamento Post
INSERT INTO Post ("idPost", foto, testo, "dataPubblicazione", "oraPubblicazione", "idGruppo", username)
VALUES ('p1', 'url_foto1.jpg', 'Testo del primo post', CURRENT_DATE, CURRENT_TIME, 'g3', 'JohnDoe');

INSERT INTO Post ("idPost", foto, testo, "dataPubblicazione", "oraPubblicazione", "idGruppo", username)
VALUES ('p2', 'url_foto2.png', 'Altra foto e testo', CURRENT_DATE, CURRENT_TIME, 'g1', 'MarySmith');

INSERT INTO Post ("idPost", foto, testo, "dataPubblicazione", "oraPubblicazione", "idGruppo", username)
VALUES ('p3', NULL, 'Solo testo, senza foto', CURRENT_DATE, CURRENT_TIME, 'g2', 'JFKennedy');

INSERT INTO Post ("idPost", foto, testo, "dataPubblicazione", "oraPubblicazione", "idGruppo", username)
VALUES ('p4', 'url_foto3.jpg', NULL, CURRENT_DATE, CURRENT_TIME, 'g1', 'alexsmith');

INSERT INTO Post ("idPost", foto, testo, "dataPubblicazione", "oraPubblicazione", "idGruppo", username)
VALUES ('p5', NULL, 'Un altro post senza foto', CURRENT_DATE, CURRENT_TIME, 'g4', 'sarahclark');


--popolamento amministratori
INSERT INTO amministra VALUES('JFKennedy','g4');
INSERT INTO amministra VALUES('markbrown','g1');

--popolamento interazioni

INSERT INTO interazione VALUES ('i1',CURRENT_DATE,CURRENT_TIME,'bel post!','commento','MarySmith','p4');
INSERT INTO interazione VALUES ('i2',CURRENT_DATE,CURRENT_TIME,'bel post!','like','MarySmith','p4');  -- c'è un errore commesso appositamente per verificare l'efficienza del trigger


