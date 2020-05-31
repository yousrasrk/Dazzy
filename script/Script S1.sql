


create table Site as select * from Site@LD;

Create table Personne as select * from Personne@LD;

create table Compte as select * from Compte@LD where id_Site='S1';


create table client as (SELECT CLD.CIN, Nom , Prenom , Salaire , Tel , Adresse
from client@LD CLD 
LEFT JOIN Compte C
ON C.CIN = CLD.CIN
where id_site = 'S1'  );


alter table site add constraint PK_SITE primary key(id_site);

insert into site values('S1','dina','dina'); --test primary key

alter table compte add constraint PK_COMPTE primary key(id_compt);

alter table client add constraint PK_Client primary key(CIN);



create view VSITE as select * from site;
 -- pour qu'elles recuperent les contraintes pendant la creation 

alter table compte add constraint FK_Compte foreign key(CIN) references Client(CIN);

create table Credit as select * from Credit@LD;

alter table credit add constraint PK_Credit primary key(id_cred);


	create materialized view MVCOMPTE 
		refresh on demand 
		start with sysdate next (sysdate + 1)
	 	as select C.id_compt,C.id_site,C.cin,C.d_creation,C.solde,C.type  
	 	from  Compte C union 
	 	select YC.id_compt,YC.id_site,YC.cin,YC.d_creation,YC.solde,YC.type 
	 	from Compte@LY YC union 
	 	select LC.id_compt,LC.id_site,LC.cin,LC.d_creation,LC.solde,LC.type 
	 	from Compte@LAM LC;

alter materialized view MVcompte add constraint PK_MVCOMPTE primary key(id_compt);

-- NO NEED an3mlo TRIGGER alter table credit add constraint FK_Crediter foreign key(id_compt) references MVCompte(id_compt);



Create table TALON_cheque  as select * from TALON_cheque@LD TCD where TCD.id_compt IN ( select id_compt from compte);


alter table TALON_cheque add constraint PK_TALONCHEQUE primary key(id_tallon);


alter table TALON_cheque add constraint FK_TC foreign key(id_compt) references Compte(id_compt);


Create table deposer as select * from deposer@LD where id_site='S1';

alter table deposer add constraint PK_deposer primary key(id_Site,id_cheque,cin);


		create materialized view MVDEPOSER
		refresh on demand 
		start with sysdate next (sysdate + 1)
		as select D.id_cheque,D.id_Site,D.cin
	 	from  deposer D union 
	 	select YD.id_cheque,YD.id_Site,YD.cin
	 	from deposer@LY YD union 
	 	select AD.id_cheque,AD.id_Site,AD.cin
	 	from deposer@LAM AD;



create TABLE Cheque AS
(
    SELECT *
    from Cheque@LD C 
    where C.id_cheque in (
        select id_cheque from Deposer
    )
);


alter table Cheque add constraint PK_CHEQUE primary key(id_cheque);



Create table echange as select * from echange@LD where id_echange like 'T%';
alter table echange add constraint PK_Echange primary key(id_echange);


	Create table Personne as select * from personne@LD;



alter table Personne add constraint PK_personne primary key(cin);



create view VPERSONNE
		as select D.CIN,D.Nom ,D.Prenom
	 	from  Personne D union 
	 	select YD.CIN,YD.Nom ,YD.Prenom
	 	from Personne@LY YD union 
	 	select AD.CIN,AD.Nom ,AD.Prenom
	 	from Personne@LAM AD;


create view VClient
		as select C.CIN,C.Nom ,C.Prenom,C.Salaire,C.Tel,C.Adresse
	 	from  Client C union 
	 	select Cy.CIN,Cy.Nom ,Cy.Prenom,Cy.Salaire,Cy.Tel,Cy.Adresse
	 	from Client@LY Cy union 
	 	select CD.CIN,CD.Nom ,CD.Prenom,CD.Salaire,CD.Tel,CD.Adresse
	 	from Client@LAM CD;



