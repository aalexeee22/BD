--10. Crearea unei secven?e ce va fi utilizatã în inserarea înregistrãrilor în tabele (punctul 11).

create table LOCATIE
(
id_locatie int,
judet varchar(20),
localitate varchar(20),
strada varchar(20),
detalii varchar(50)
);

alter table LOCATIE
add constraint id_locatie_pk primary key(id_locatie);

create table UTILAJ
(
id_utilaj int,
nume varchar(50) not null, 
an_fabricatie date constraint an_fabricatie not null
);
alter table UTILAJ
add constraint id_utilaj_pk primary key(id_utilaj);

create table COLABORATORI
(
id_colaborator int,
nume varchar(100) not null, 
numar_telefon varchar(15) not null,
procent int default 10
);

alter table COLABORATORI
add constraint id_colaborator_pk primary key(id_colaborator);

create table CLIENT
(
id_client int,
nume varchar(100) not null, 
prenume varchar(100) not null, 
numar_telefon varchar(15) not null,
nr_lucrari_anterioare int
constraint nr_lucrari_anterioare_valid check(nr_lucrari_anterioare>=0)
);

alter table CLIENT
add constraint id_client_pk primary key(id_client);

create table OFERTA
(
id_oferta int,
pret int,
cod_colaborator int,
constraint oferta_fk foreign key (cod_colaborator) references COLABORATORI(id_colaborator)
);

alter table OFERTA
add constraint id_oferta_pk primary key(id_oferta);

create table FACTURA
(
id_factura int,
cod_oferta_acceptata int,
cod_client int,
constraint factura_fk_oferta foreign key (cod_oferta_acceptata) references OFERTA(id_oferta),
constraint factura_fk_client foreign key (cod_client) references CLIENT(id_client)
);

alter table FACTURA
add constraint id_factura_pk primary key(id_factura);

create table SEF
(
id_sef int, 
nume varchar(100) not null, 
prenume varchar(100) not null,
numar_telefon varchar(15) not null, 
varsta  int constraint varsta_valid check(varsta>=18),
experienta int constraint experienta_valid check(experienta>=0), 
salariu int constraint salariu_valid check(salariu>0)
);
alter table SEF
add constraint id_sef_pk primary key(id_sef);

create table LUCRARE
(
id_lucrare int,
nume varchar (50),
cod_locatie int not null,
cod_factura int not null,
cod_sef int not null,
constraint locatie_fk_lucrare foreign key (cod_locatie) references LOCATIE(id_locatie),
constraint factura_fk_lucrare foreign key (cod_factura) references FACTURA(id_factura),
constraint sef_fk_lucrare foreign key (cod_sef) references SEF(id_sef)
);

alter table LUCRARE
add constraint id_lucrare_pk primary key(id_lucrare);

create table RECENZIE
(
id_recenzie int,
cod_client int not null,
cod_lucrare int not null,
parere varchar(200),
constraint recenzie_fk_lucrare foreign key (cod_lucrare) references LUCRARE(id_lucrare),
constraint recenzie_fk_client foreign key (cod_client) references CLIENT(id_client)
);

alter table RECENZIE
add constraint id_recenzie_pk primary key(id_recenzie);

create table ECHIPA
(
id_echipa int,
cod_sef int not null,
constraint echipa_fk_sef foreign key (cod_sef) references SEF(id_sef)
);
alter table ECHIPA
add constraint id_echipa_pk primary key(id_echipa);

create table ANGAJAT
(
id_angajat int,
nume varchar(100) not null, 
prenume varchar(100) not null,
numar_telefon varchar(15) not null, 
varsta  int constraint varsta_validul check(varsta>=18),
specializare varchar(30),
experienta int constraint experienta_validul check(experienta>=0), 
salariu int constraint salariu_validul check(salariu>0),
cod_echipa int default NULL,
constraint angajat_fk_echipa foreign key (cod_echipa) references ECHIPA(id_echipa)
);

alter table ANGAJAT
add constraint id_angajat_pk primary key(id_angajat);

create table PROGRAMARE_UTILAJE
(
cod_utilaj int not null,
cod_locatie int not null,
data_inceput date not null,
data_terminare date not null,
constraint programare_pk_utilaje primary key (cod_utilaj,cod_locatie),
constraint programare_fk_utilaj foreign key (cod_utilaj) references UTILAJ(id_utilaj),
constraint programare_fk_locatie foreign key (cod_locatie) references LOCATIE(id_locatie)
);
 
--11. Crearea tabelelor în SQL ?i inserarea de date coerente în fiecare dintre acestea
--(minimum 5 înregistrãri în fiecare tabel neasociativ; minimum 10 înregistrãri în tabelele asociative). 

insert into LOCATIE
values(1,'Arges','Pitesti','Ionescu-Gion','bloc 4, ap. 5');
INSERT INTO LOCATIE
VALUES (2, 'Bucuresti', 'Bucuresti', 'Aleea Victoriei', 'Clãdirea 10, Ap. 3');
INSERT INTO LOCATIE
VALUES (3, 'Cluj-Napoca', 'Cluj', 'Strada Avram Iancu', 'Apartamentul 15');
INSERT INTO LOCATIE
VALUES (4, 'Timisoara', 'Timis', 'Piata Victoriei', 'Cladirea 5, Etaj 2, Ap. 7');
INSERT INTO LOCATIE
VALUES (5, 'Iasi', 'Iasi', 'Alexandru Ioan Cuza', 'Apartamentul 12');
INSERT INTO LOCATIE
VALUES (6, 'Brasov', 'Brasov', 'Piata Sfatului', 'Cladirea 8, Ap. 6');
INSERT INTO LOCATIE
VALUES (7, 'Constanta', 'Constanta', 'Bulevardul Mamaia', 'Cladirea 3, Etaj 4, Ap. 9');
INSERT INTO LOCATIE
VALUES (8, 'Sibiu', 'Sibiu', 'Piata Mare', 'Clãdirea 2, Ap. 1');
INSERT INTO LOCATIE
VALUES (9, 'Oradea', 'Bihor', 'Bulevardul Decebal', 'Blocul 5, Scara B, Ap. 7');
INSERT INTO LOCATIE
VALUES (10, 'Arges', 'Curtea de Arges', 'Bulevardul 1916', 'bloc 41, ap. 5');

insert into UTILAJ
values(1,'Bobcat','1.1.2015');
insert into UTILAJ
values(2, 'Caterpillar', '15.2.2016');
insert into UTILAJ
values(3, 'Komatsu', '10.5.2017');
insert into UTILAJ
values(4, 'John Deere', '7.9.2018');
insert into UTILAJ
values(5, 'Volvo', '3.12.2019');
insert into UTILAJ
values(6, 'Hitachi', '20.6.2020');
insert into UTILAJ
values(7, 'Kubota', '11.8.2021');
insert into UTILAJ
values(8, 'JCB', '25.3.2022');
insert into UTILAJ
values(9, 'Case', '9.7.2023');
insert into UTILAJ
values(10, 'Liebherr', '14.11.2024');

insert into COLABORATORI
values(1,'RRS','0710000000',15);
insert into COLABORATORI
values(2, 'FIRMA NO. 1', '0722222222', 8);
insert into COLABORATORI
values(3, 'Coste SRL', '0733333333', 12);
insert into COLABORATORI
values(4, 'Constructii', '0744444444', 6);
insert into COLABORATORI
values(5, 'SC Farul', '0755555555', 14);
insert into COLABORATORI
values(6, 'Patru Frati', '0766666666', 49);
insert into COLABORATORI
values(7, 'Popescu Marcel', '0777777777', 11);
insert into COLABORATORI
values(8, 'IoanPopaConstruct', '0788888888', 7);
insert into COLABORATORI
values(9, 'SRR', '0799999999', 13);
insert into COLABORATORI
values(10, 'Buldo', '0700000000', 50);

insert into CLIENT
values(1,'Popescu', 'Simina', '0712300300',5);
insert into CLIENT
values(2,'Pop', 'Cristina','073242354534',0);
insert into CLIENT
values(3, 'Popa', 'Maria', '0734567890', 2);
insert into CLIENT
values(4, 'Georgescu', 'Alexandru', '0745678901', 1);
insert into CLIENT
values(5, 'Dumitrescu', 'Ana', '07567890212', 4);
insert into CLIENT
values(6, 'Stefan', 'Cristina', '0767890123', 0);
insert into CLIENT
values(7, 'Voicu', 'Mihai', '0778901234', 5);
insert into CLIENT
values(8, 'Munteanu', 'Andreea', '0789012345', 3);
insert into CLIENT
values(9, 'Gheorghe', 'Cosmin', '0790123456', 1);
insert into CLIENT
values(10, 'Iliescu', 'George', '0701234567', 4);

insert into OFERTA
values(1,1200,NULL);
insert into OFERTA
values(2,21200,3);
insert into OFERTA
values(3,31200,4);
insert into OFERTA
values(4,123200,1);
insert into OFERTA
values(5,121200,NULL);
insert into OFERTA
values(6,14200,6);
insert into OFERTA
values(7,187600,7);
insert into OFERTA
values(8,124200,9);
insert into OFERTA
values(9,120530,NULL);
insert into OFERTA
values(10,414200,3);

insert into FACTURA
values(1,1,4);
insert into FACTURA
values(2,5,2);
insert into FACTURA
values(3,1,9);
insert into FACTURA
values(4,7,2);
insert into FACTURA
values(5,6,9);
insert into FACTURA
values(6,5,7);
insert into FACTURA
values(7,3,4);
insert into FACTURA
values(8,1,3);
insert into FACTURA
values(9,7,8);
insert into FACTURA
values(10,4,1);

insert into SEF
values(1, 'Vasilecu', 'Marian','072345678',39,15,2500);
insert into SEF 
values(2, 'Popescu', 'Andrei','07234567891', 42,12, 2800);
insert into SEF 
values(3, 'Enescu', 'Ana','07345678902', 37, 10, 2650);
insert into SEF 
values(4, 'Gicu', 'Alexandru','07456789013', 41, 14, 2900);
insert into SEF 
values(5, 'Dumitrascu', 'Alina','07567890124', 39, 11, 2700);
insert into SEF 
values(6, 'Maria', 'Ion','07678901235', 56, 29, 32550);
insert into SEF 
values(7, 'Voiculescu', 'Mihai','07789012346', 40, 13, 2850);
insert into SEF 
values(8, 'Teanu', 'Andrei','07890123457', 38, 10, 2700);
insert into SEF 
values(9, 'George', 'Cosmina','07901234568', 35, 8, 2500);
insert into SEF 
values(10, 'Ilie', 'Catalin','07012345679', 43, 15, 3000);

insert into LUCRARE
values(1,'excavare',4,9,1);
insert into LUCRARE 
values(2, 'fundatie', 3, 6,5);
insert into LUCRARE 
values(3, 'zidarie', 5, 8,4);
insert into LUCRARE 
values(4, 'instalatii sanitare', 2, 5,3);
insert into LUCRARE 
values(5, 'instalatii electrice', 1, 3,2);
insert into LUCRARE 
values(6, 'finisaje interioare', 4, 7,8);
insert into LUCRARE 
values(7, 'amenajare gradina', 2, 4,9);
insert into LUCRARE 
values(8, 'izolare termica', 3, 6,6);
insert into LUCRARE 
values(9, 'acoperis', 4, 8,7);
insert into LUCRARE 
values(10, 'pardoseala', 10, 3,10);

insert into RECENZIE
values(1,5,3,'Foarte lenti, dar a iesit bine.');
insert into RECENZIE
values(2, 4, 2, 'Servicii bune, dar pretul este cam mare.');
insert into RECENZIE
values(3, 3, 1, 'Nu sunt multumit de calitatea lucrarii.');
insert into RECENZIE 
values(4, 5, 3, 'Echipa foarte profesionista, a fost o experienta placuta.');
insert into RECENZIE 
values(5, 2, 4, 'Am intampinat probleme de comunicare cu personalul.');
insert into RECENZIE 
values(6, 4, 2, 'Recomand cu incredere, sunt foarte seriosi.');
insert into RECENZIE 
values(7, 3, 1, 'Au respectat termenul de finalizare al proiectului.');
insert into RECENZIE 
values(8, 5, 3, 'Lucrarea a fost realizata cu atentie la detalii.');
insert into RECENZIE 
values(9, 2, 4, 'Nu recomand, au facut multe greseli.');
insert into RECENZIE 
values(10, 4, 2, 'Am fost impresionat de promptitudinea lor.');

insert into  ECHIPA
values(1,4);
insert into  ECHIPA
values(2,7);
insert into  ECHIPA
values(3,5);
insert into  ECHIPA
values(4,9);
insert into  ECHIPA
values(5,8);
insert into  ECHIPA
values(6,10);
insert into  ECHIPA
values(7,1);
insert into  ECHIPA
values(8,3);
insert into  ECHIPA
values(9,2);
insert into  ECHIPA
values(10,6);

insert into ANGAJAT
values(1,'Raducu','Carmen','07344624343',27,'transprot', 4,2700,4);
insert into ANGAJAT 
values(2, 'Popa', 'Andreea', '07234567891', 30, 'administrativ', 5, 2900, 5);
insert into ANGAJAT 
values(3, 'Ilie', 'Marian', '07345678902', 28, 'resurse umane', 3, 2600, 3);
insert into ANGAJAT 
values(4, 'Gheorghe', 'Alin', '07456789013', 32, 'financiar', 6, 3100, 7);
insert into ANGAJAT 
values(5, 'Dumitrache', 'Ana-Maria', '07567890124', 29, 'marketing', 4, 2800, 10);
insert into ANGAJAT 
values(6, 'Stancu', 'Ionut', '07678901235', 26, 'vanzari', 2, 2500, 2);
insert into ANGAJAT 
values(7, 'Voinea', 'Mihai', '07789012346', 31, 'tehnologie', 5, 3000, 5);
insert into ANGAJAT 
values(8, 'Munteanu', 'Andreea', '07890123457', 27, 'productie', 3, 2700, 9);
insert into ANGAJAT 
values(9, 'Ghita', 'Cosmin', '07901234568', 25, 'calitate', 2, 2400, 8);
insert into ANGAJAT 
values(10, 'Iordache', 'Cristina', '07012345679', 33, 'logistica', 6, 3200, 6);

insert into PROGRAMARE_UTILAJE
values(4,8,'14.09.2022','16.05.2023');
insert into PROGRAMARE_UTILAJE 
values(3,7, '21.09.2023', '23.05.2024');
insert into PROGRAMARE_UTILAJE 
values(5,9, '28.09.2023', '30.05.2024');
insert into PROGRAMARE_UTILAJE 
values(2,6, '05.10.2023', '07.06.2024');
insert into PROGRAMARE_UTILAJE 
values(7,8, '12.10.2023', '14.06.2024');
insert into PROGRAMARE_UTILAJE 
values(1,7, '19.10.2022', '21.06.2023');
insert into PROGRAMARE_UTILAJE 
values(6,10, '26.10.2022', '28.06.2023');
insert into PROGRAMARE_UTILAJE 
values(2,6, '02.11.2022', '04.07.2023');
insert into PROGRAMARE_UTILAJE 
values(10,9, '09.11.2022', '11.07.2023');
insert into PROGRAMARE_UTILAJE 
values(9,8, '16.11.2023', '18.07.2024');
insert into PROGRAMARE_UTILAJE 
values(8,3, '12.10.2022', '14.06.2025');