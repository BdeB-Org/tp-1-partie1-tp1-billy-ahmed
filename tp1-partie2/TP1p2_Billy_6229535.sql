-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Billy                      Votre DA: Cham
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_OUTIL;
DESC OUTILS_USAGER;
DESC OUTILS_EMPRUNT;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT PRENOM || ' ' || NOM_FAMILLE AS "Nom et nom de famille"
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT VILLE
FROM OUTILS_USAGER
ORDER BY VILLE;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
ORDER BY NOM, CODE_OUTIL;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT
FROM OUTILS_EMPRUNT
WHERE DATE_EMPRUNT < DATE '2014-01-01';

-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) LIKE '%J%';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT NOM, CODE_OUTIL
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT NOM, FABRICANT
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT CODE_OUTIL, NOM
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES NOT LIKE '%20 volt%';

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*) AS "Nombre d'outils non fabriqués par Makita"
FROM OUTILS_OUTIL
WHERE FABRICANT != 'Makita';

-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT PRENOM || ' ' || NOM_FAMILLE AS "Nom complet",  NUM_EMPRUNT, COALESCE(DATE_RETOUR - DATE_EMPRUNT,0) AS "Durée de l'emprunt", COALESCE(PRIX,0) AS "Prix de l'outil"
FROM  OUTILS_EMPRUNT A
JOIN  OUTILS_USAGER B ON A.NUM_USAGER = B.NUM_USAGER
JOIN  OUTILS_OUTIL C ON C.CODE_OUTIL = A.CODE_OUTIL
WHERE B.VILLE IN ('Vancouver', 'Regina');
    
-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT A.NOM, A.CODE_OUTIL
FROM OUTILS_EMPRUNT B
JOIN OUTILS_OUTIL A ON B.CODE_OUTIL = A.CODE_OUTIL
WHERE B.DATE_RETOUR IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT NOM_FAMILLE, COURRIEL
FROM OUTILS_USAGER
WHERE NUM_USAGER NOT IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);

-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT A.CODE_OUTIL, COALESCE(A.PRIX, 0) AS "Valeur de l'outil"
FROM OUTILS_OUTIL A
LEFT OUTER JOIN OUTILS_EMPRUNT B ON A.CODE_OUTIL = B.CODE_OUTIL
WHERE B.CODE_OUTIL IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT  NOM, COALESCE(PRIX, (SELECT AVG(PRIX) FROM OUTILS_OUTIL)) AS "Prix"
FROM OUTILS_OUTIL
WHERE FABRICANT = 'Makita' AND COALESCE(PRIX, (SELECT AVG(PRIX) FROM OUTILS_OUTIL)) > (SELECT AVG(PRIX) FROM OUTILS_OUTIL);


-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT A.NOM_FAMILLE, A.PRENOM, A.ADRESSE, B.NOM, B.CODE_OUTIL
FROM OUTILS_USAGER A
JOIN OUTILS_EMPRUNT C ON A.NUM_USAGER = C.NUM_USAGER
JOIN OUTILS_OUTIL B ON C.CODE_OUTIL = B.CODE_OUTIL
WHERE C.DATE_EMPRUNT > DATE '2014-01-01'
ORDER BY A.NOM_FAMILLE;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT A.NOM, A.PRIX
FROM OUTILS_OUTIL A
JOIN OUTILS_EMPRUNT B ON A.CODE_OUTIL = B.CODE_OUTIL
GROUP BY A.NOM, A.PRIX
HAVING COUNT(*) > 1;

-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT DISTINCT A.NOM_FAMILLE, A.ADRESSE, A.VILLE
FROM OUTILS_USAGER A
JOIN OUTILS_EMPRUNT B ON A.NUM_USAGER = B.NUM_USAGER;
--  IN
SELECT NOM_FAMILLE, ADRESSE, VILLE
FROM OUTILS_USAGER
WHERE NUM_USAGER IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);
--  EXISTS
SELECT NOM_FAMILLE, ADRESSE, VILLE
FROM OUTILS_USAGER A
WHERE EXISTS (SELECT 1 FROM OUTILS_EMPRUNT B WHERE B.NUM_USAGER = A.NUM_USAGER);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT FABRICANT AS "Marque", AVG(PRIX) AS "Prix moyen"
FROM OUTILS_OUTIL
GROUP BY FABRICANT;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT A.VILLE, SUM(B.PRIX) AS "Somme des prix"
FROM OUTILS_EMPRUNT C
JOIN OUTILS_USAGER A ON C.NUM_USAGER = A.NUM_USAGER
JOIN OUTILS_OUTIL B ON C.CODE_OUTIL = B.CODE_OUTIL
GROUP BY A.VILLE
ORDER BY SUM(B.PRIX) DESC;

-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('AV769', 'Ciseaux', 'Luxe', 'fabriqué en bois', '2001', '30');

-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('EF001', 'Scie', '2001');

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN ('AV769', 'EF001');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
