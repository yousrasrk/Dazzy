create table Compte as select * from  Compte@LDEYNA
where id_site = 'S3';


create table client as (SELECT CLD.CIN, Nom , Prenom , Salaire , Tel , Adresse
from client@LDEYNA CLD 
LEFT JOIN Compte C
ON C.CIN = CLD.CIN
where id_site = 'S3'  );

alter table  Compte 
ADD CONSTRAINT PK_Compte PRIMARY KEY(id_compt);

alter table  client
ADD CONSTRAINT PK_Client PRIMARY KEY(CIN);

create view VSITE as select * from site@LY;


alter table Compte 
add Constraint FK_Compte foreign key (CIN)
REFERENCES client(cin);


create TABLE Talon_cheque  AS
(
    SELECT *
    from Talon_cheque@LDEYNA T 
    where T.id_Compt in (
        select id_compt from Compte
    )
)

create table Deposer as select * from Deposer@LDEYNA
where id_site = 'S3';


alter table Deposer add constraint PK1_deposer primary key(cin,id_cheque,id_site);


create materialized view MVDEPOSER
		refresh on demand 
		start with sysdate next (sysdate + 1)
		as select D.id_cheque,D.id_Site,D.cin
	 	from  deposer D union 
	 	select YD.id_cheque,YD.id_Site,YD.cin
	 	from deposer@LYOUSRA1 YD union 
	 	select AD.id_cheque,AD.id_Site,AD.cin
	 	from deposer@LY AD;



create TABLE Cheque AS
(
    SELECT *
    from Cheque@LDEYNA C 
    where C.id_cheque in (
        select id_cheque from Deposer
    )
)


alter table Cheque add constraint PK_CHEQUE primary key(id_cheque);

create table echange as select * from echange@LDEYNA where id_echange LIKE 'C%';


alter table echange add constraint PK_echange primary key(id_echange);

create table Personne  as select * from  Personne@LDEYNA


alter table Personne add constraint PK_Personne(CIN);



