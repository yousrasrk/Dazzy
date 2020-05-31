create table Compte as select * from Compte@LD where id_site='S2';

create table client as (SELECT CLD.CIN, Nom , Prenom , Salaire , Tel , Adresse
from client@LD CLD 
LEFT JOIN Compte@LD C
ON C.CIN = CLD.CIN
where id_site = 'S2'  );

alter table Compte add constraint PK1_Compte primary key(Id_Compt);
alter table Compte add constraint FK1_Compte foreign key (CIN) references Client(CIN);
alter table Client add constraint PK1_Client primary key(CIN);

create view vsite as select * from site@LYOUSSEF;
Create table Talon_cheque as select * from Talon_cheque@LD TCD where TCD.id_Compt@LD in(select id_Compt from Compte);


alter table Talon_cheque add constraint PK1_Talon primary key(id_tallon);
alter table Talon_cheque  add constraint FK1_Talon foreign key (id_compt) references Compte(id_compt);
create table Deposer as select * from Deposer@LD where id_site='S2';
alter table Deposer add constraint PK1_deposer primary key(cin,id_cheque,id_site);
create materialized view MVDEPOSER
		refresh on demand 
		start with sysdate next (sysdate + 1)
		as select D.id_cheque,D.id_Site,D.cin
	 	from  deposer D union 
	 	select YD.id_cheque,YD.id_Site,YD.cin
	 	from deposer@LYOUSSEF YD union 
	 	select AD.id_cheque,AD.id_Site,AD.cin
	 	from deposer@LAMAL AD;




create TABLE Cheque AS
(
    SELECT *
    from Cheque@LD CQ
    where CQ.id_cheque in (
        select id_cheque from Deposer
    )
);
alter table Cheque add constraint PK_CHEQUE primary key(id_cheque);
create table echange as select * from echange@LD where id_echange like 'R%';
alter table echange add constraint PK_echange primary key(id_echange);
create table Personne as select * from Personne@LD;
alter table Personne add constraint PK_personne primary key(cin);
