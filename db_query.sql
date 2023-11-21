--1- Selezionare tutte le software house americane (3)
SELECT * FROM `software_houses` WHERE country = "United States";
--Selezionare tutti i giocatori della città di 'Rogahnland' 
SELECT * FROM `players` WHERE city ="Rogahnland";
--Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT * FROM `players` WHERE name LIKE '%a'
--Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT * FROM `reviews` WHERE player_id = 800;
--Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT * FROM `tournaments` WHERE year=2015;
--Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT *
FROM awards
WHERE description LIKE '%facere%';
--Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogame_id FROM `category_videogame` WHERE category_id IN (2,6);
--Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT * FROM `reviews` WHERE rating >= 2 AND rating <=4;
--Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT * FROM `videogames` WHERE YEAR(release_date) = 2020;
--Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id FROM `reviews` WHERE videogame_id IN (SELECT videogame_id FROM reviews WHERE rating =5);


--BONUS 
--11- Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)
SELECT
    COUNT(*) AS numero_recensioni,
    AVG(rating) AS media_voti
FROM reviews
WHERE videogame_id = 412;
-- Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(*) AS videogames_number
FROM videogames
WHERE software_house_id = 1 AND YEAR(release_date) = 2018;



--GROUP BY
--1- Contare quante software house ci sono per ogni paese (3)
SELECT country, COUNT(*) AS numero_software_house
FROM software_houses
GROUP BY country;

--Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, COUNT(*) AS number_review
FROM reviews
GROUP BY videogame_id;
--Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
SELECT cp.pegi_label_id, COUNT(*) AS numero_videogiochi
FROM pegi_label_videogame cp
GROUP BY cp.pegi_label_id;

--Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(release_date) AS anno_rilascio, COUNT(*) AS numero_videogiochi
FROM videogames
GROUP BY YEAR(release_date);
-- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT dv.device_id, COUNT(*) AS numero_videogiochi
FROM device_videogame dv
GROUP BY dv.device_id;
--Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, AVG(rating) AS media_recensioni
FROM reviews
GROUP BY videogame_id
ORDER BY media_recensioni DESC;


--JOIN

--Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.*
FROM players
JOIN reviews ON players.id = reviews.player_id;
--Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)

--Mostrare le categorie di ogni videogioco (1718)
SELECT videogames.id AS id_videogioco, categories.name AS categoria
FROM videogames
LEFT JOIN category_videogame ON videogames.id = category_videogame.videogame_id
LEFT JOIN categories ON categories.id = category_videogame.category_id;
--Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM software_houses
JOIN videogames ON software_houses.id = videogames.software_house_id
WHERE YEAR(videogames.release_date) > 2020;
--Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT software_houses.id AS id_software_house,
       software_houses.name AS nome_software_house,
       awards.name AS nome_premio
FROM software_houses
JOIN videogames ON software_houses.id = videogames.software_house_id
JOIN award_videogame ON videogames.id = award_videogame.videogame_id
JOIN awards ON award_videogame.award_id = awards.id;
--Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT categories.id AS id_categoria, categories.name AS nome_categoria,
                pegi_labels.id AS id_classificazione_pegi, pegi_labels.name AS nome_classificazione_pegi
FROM categories
JOIN category_videogame ON categories.id = category_videogame.category_id
JOIN videogames ON category_videogame.videogame_id = videogames.id
JOIN reviews ON videogames.id = reviews.videogame_id
JOIN pegi_label_videogame ON videogames.id = pegi_label_videogame.videogame_id
JOIN pegi_labels ON pegi_label_videogame.pegi_label_id = pegi_labels.id
WHERE reviews.rating IN (4, 5);


--Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT videogames.id AS id_videogioco, videogames.name AS nome_videogioco
FROM players
JOIN player_tournament ON players.id = player_tournament.player_id
JOIN tournaments ON player_tournament.tournament_id = tournaments.id
JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames ON tournament_videogame.videogame_id = videogames.id
WHERE players.name LIKE 'S%';

-- Selezionare le città in cui è stato giocato il gioco dell'anno del 2018 (36)
SELECT DISTINCT tournaments.city
FROM tournaments
JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
JOIN award_videogame ON tournament_videogame.videogame_id = award_videogame.videogame_id
JOIN awards ON award_videogame.award_id = awards.id
WHERE tournaments.year = 2018 
AND awards.name = "Gioco dell'anno"

--Selezionare i giocatori che hanno giocato al gioco più atteso del 2018 in un torneo del 2019 (3306)
SELECT DISTINCT players.id, players.name
FROM players
JOIN player_tournament ON players.id = player_tournament.player_id
JOIN tournaments ON player_tournament.tournament_id = tournaments.id
JOIN tournament_videogame ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames ON tournament_videogame.videogame_id = videogames.id
JOIN awards ON awards.name = "Gioco più atteso"
WHERE tournaments.year = 2019