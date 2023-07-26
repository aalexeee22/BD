--12. Formula?i �n limbaj natural ?i implementa?i 5 cereri SQL complexe ce vor utiliza, �n ansamblul lor, urm�toarele elemente: 
--� subcereri sincronizate �n care intervin cel pu?in 3 tabele 
--� subcereri nesincronizate �n clauza FROM 
--� grup�ri de date cu subcereri nesincronizate �n care intervin cel putin 3 tabele, func?ii grup, filtrare la nivel de grupuri (�n cadrul aceleia?i cereri)
--� ordon�ri ?i utilizarea func?iilor NVL ?i DECODE (�n cadrul aceleia?i cereri) 
--� utilizarea a cel pu?in 2 func?ii pe ?iruri de caractere, 2 func?ii pe date calendaristice, a cel pu?in unei expresii CASE 
--� utilizarea a cel pu?in 1 bloc de cerere (clauza WITH) 
--Observa?ie: �ntr-o cerere se vor reg�si mai multe elemente dintre cele enumerate mai sus, astfel �nc�t cele 5 cereri s� le cuprind� pe toate. 

--1.) Stabili?i nivelul de colaborare al unei firme externe, bazat pe procent ?i 
--afi?a?i id-ul, numele, datele de contact, suma care �i revine fiec�rui colaborator ?i nivelul de colaborare.
--� utilizarea a cel pu?in 1 bloc de cerere (clauza WITH) 
--� utilizarea a cel pu?in unei expresii CASE
--� utilizarea unei func?ii pe ?iruri de caractere(UPPER)
WITH salariu_colaborator as (
  select C.id_colaborator, C.nume, C.numar_telefon, C.procent, O.pret,
         (O.pret * C.procent / 100) as salariu_final
  from colaboratori C
  join OFERTA O on C.id_colaborator = O.cod_colaborator
)
select id_colaborator,UPPER(nume) as NUME, numar_telefon, procent, salariu_final as TOTAL_COLABORATOR,
       CASE
         WHEN procent >= 50 THEN 'nivel mare de colaborare'
         WHEN procent >= 25 THEN 'nivel mediu de colaborare'
         ELSE 'nivel scazut de colaborare'
       END AS nivel_colaborare
from salariu_colaborator;

--2.) S� se afi?eze primele 3 lucr�ri cu cele mai multe recenzii.
--� grup�ri de date cu subcereri nesincronizate in care intervin cel putin 3 tabele, func?ii
--grup(COUNT), filtrare la nivel de grupuri (in cadrul aceleiasi cereri)
--� utilizarea a cel pu?in 1 bloc de cerere (clauza WITH) 
--� utilizarea unei func?ii pe ?iruri de caractere(LOWER)

WITH lucrari_total AS (
  SELECT L.id_lucrare, L.nume,
    (SELECT COUNT(R.id_recenzie) FROM RECENZIE R WHERE R.cod_lucrare = L.id_lucrare) AS numar_recenzii
  FROM LUCRARE L
),
lucrari_sortate AS (
  SELECT id_lucrare, nume, numar_recenzii,
         ROW_NUMBER() OVER (ORDER BY numar_recenzii DESC) AS pozitie
  FROM lucrari_total
)
SELECT pozitie,id_lucrare, LOWER(nume), numar_recenzii
FROM lucrari_sortate
WHERE pozitie <= 3;

--3.)Actualiza?i salariile angaja?ilor ?i ?efilor cu o m�rire de 30% pentru angaja?ii care au o experien?� mai mare 
--sau egal� cu zece ani ?i dubla?i salariul ?efilor caree au o experien?� mai mare sau egal� cu 10 ani.
--Afi?a?i tipul func?iei(?ef/angajat), numele, prenumele, experien?a, salariul ?i salariul actualizat. 
---Cerin?a a utilizat:
--� ordon�ri ?i utilizarea func?iilor NVL ?i DECODE (�n cadrul aceleia?i cereri) 
--� utilizarea a cel pu?in unei expresii CASE
select tip, nume, prenume, experienta, salariu,
    NVL(
        DECODE(tip,
            'Angajat', CASE
                            WHEN experienta >= 10 THEN salariu * 1.3
                            ELSE salariu
                        END,
            'Sef', CASE
                        WHEN experienta >= 10 THEN salariu * 2
                        ELSE salariu
                    END
        ), salariu
    ) AS salariu_actualizat
FROM
(
    SELECT 'Angajat' AS tip, nume, prenume,salariu, experienta
    FROM ANGAJAT
    UNION ALL
    SELECT 'Sef' AS tip, nume,prenume, salariu, experienta
    FROM SEF
)ORDER BY salariu_actualizat DESC, nume ASC;


--4.)Afișați numele și prenumele, dar și salariul angajaților care au salariul mai mare
--decât salariul șefilor care au mai mult de 10 ani de experiență și fost și clienți care 
--au mai mult de o lucrare făcută la această firmă.
--• subcereri sincronizate în care intervin cel puțin 3 tabele 
insert into sef values
(11,'Iliescu','George','0701234567',40,13,3000);--am inserat un șef care sa satisfacă condițiile
delete from sef where id_sef=11;--l-am șters după executarea query-ului
select nume, prenume, salariu from angajat
where salariu>(select salariu from sef
                where experienta>10 and numar_telefon in (select numar_telefon from client
                                                    where nr_lucrari_anterioare>1));

--5.)Să seafișeze numele utilajelor care vor fi disponibile după anul 2023, 
--și ziua următoare în care vor fi disponibile (prima luni după terminarea lucrării unde sunt folosite).
--• subcereri nesincronizate în clauza FROM
--• utilizarea a cel pu?in 2 func?ii pe date calendaristice(EXTRACT și NEXT_DAY)

SELECT c1.nume, c2.urmatoarea_luni
FROM (
    SELECT nume, id_utilaj, an_fabricatie
    FROM utilaj
) c1
JOIN (
    SELECT cod_utilaj, NEXT_DAY(data_terminare, 'LUNI') AS urmatoarea_luni
    FROM programare_utilaje
    WHERE extract(year FROM data_terminare) =2023
) c2 ON c1.id_utilaj = c2.cod_utilaj;
--13. Implementarea a 3 opera?ii de actualizare ?i de suprimare a datelor utiliz�nd subcereri.

--1.)Se vor m�ri toate salariile angaja?ilor  din echipa Cosminei George pentru merite deosebite cu ultima lucrare.
UPDATE ANGAJAT
SET salariu = salariu * 1.1 -- cre?terea salariului cu 10%
WHERE cod_echipa = (
    SELECT id_echipa
    FROM ECHIPA
    WHERE cod_sef = (
        SELECT id_sef
        FROM SEF
        WHERE nume = 'George' and prenume='Cosmina'
    )
);
rollback;
select * from sef;

--2.)S� se ?tearg� toate ofertele care nu au fost acceptate.
DELETE FROM OFERTA
WHERE id_oferta NOT IN (
    SELECT cod_oferta_acceptata
    FROM FACTURA
);

--3.)S� se m�reasc� salariul ?efilor echipelor 4 ?i 6
UPDATE SEF
SET salariu = salariu + 1000
WHERE id_sef IN (
    SELECT cod_sef
    FROM ECHIPA
    WHERE cod_sef=4 or cod_sef=6
);

--14. Crearea unei vizualiz�ri complexe. Da?i un exemplu de opera?ie LMD permis� pe
--vizualizarea respectiv� ?i un exemplu de opera?ie LMD nepermis�.

--Un view �n care s� apar� ?eful  fiec�rui angajat.
CREATE VIEW Vizualizare_Complexa AS
SELECT A.id_angajat, A.nume, A.prenume, A.salariu, S.nume AS nume_sef
FROM ANGAJAT A
JOIN ECHIPA E ON A.cod_echipa = E.id_echipa
JOIN SEF S ON E.cod_sef = S.id_sef;

--O opera?ie LMD permis� este afi?area angaja?iilor cu salariul mai mare de 2600 lei.
SELECT * FROM Vizualizare_Complexa where salariu>2600;

--O opera?ie LMD nepermis� LMD este inser?ia, vizualizarea fiind creat� pe baza altor 
--tabele ?i neav�nd coresponden?� direct� cu un singur tabel din baza de date.
INSERT INTO Vizualizare_Complexa (id_angajat, nume, prenume, salariu, nume_sef) 
VALUES (1, 'Popescu', 'Numerge', 6000, 'Teanu');
SELECT * FROM Vizualizare_Complexa;

--15. Formula?i �n limbaj natural ?i implementa?i �n SQL: 
--o cerere ce utilizeaz� opera?ia outerjoin pe minimum 4 tabele, 
--S� se afi?eze id-ul clientilor, numele complet al acestora, ofertele acceptate, pre?ul acestora, numele lucr�rilor ?i al colaboratorilor.
SELECT id_client,c.nume||' '||c.prenume "Nume client",cod_oferta_acceptata,pret,l.nume "nume lucrare",co.nume "Nume colaboratori"
FROM OFERTA o
LEFT OUTER JOIN LUCRARE l ON o.id_oferta = l.cod_factura
LEFT OUTER JOIN FACTURA f ON f.id_factura = l.cod_factura
LEFT OUTER JOIN CLIENT c ON f.cod_client = c.id_client
LEFT OUTER JOIN COlaboratori co ON o.cod_colaborator = CO.id_colaborator
where c.nume is not null;


--o cerere ce utilizeaz� opera?ia division ?i 
--S�  se afi?eze toate ofertele refuzate.
SELECT O.id_oferta, O.pret, O.cod_colaborator
FROM OFERTA O
WHERE NOT EXISTS (
  SELECT F.cod_oferta_acceptata
  FROM FACTURA F
  WHERE F.cod_oferta_acceptata = O.id_oferta
);

--o cerere care implementeaz� analiza top-n.
-- S� se afi?eze primele 3 lucr�ri cu cele mai multe recenzii.
WITH lucrari_total AS (
  SELECT L.id_lucrare, L.nume,
    (SELECT COUNT(R.id_recenzie) FROM RECENZIE R WHERE R.cod_lucrare = L.id_lucrare) AS numar_recenzii
  FROM LUCRARE L
),
lucrari_sortate AS (
  SELECT id_lucrare, nume, numar_recenzii,
         ROW_NUMBER() OVER (ORDER BY numar_recenzii DESC) AS pozitie
  FROM lucrari_total
)
SELECT pozitie,id_lucrare, LOWER(nume), numar_recenzii
FROM lucrari_sortate
WHERE pozitie <= 3;