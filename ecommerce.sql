-- criação do banco de dados para o cenário de E-commerce
create database ecommerce;
use ecommerce;

-- ----------------------------------------------------------------------------
-- criar tabela cliente
create table clients(
		idClients int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        adress varchar(30),
        constraint unique_cpf_client unique (CPF)
); 

alter table clients auto_increment=1;
alter table clients modify adress varchar(100);
alter table clients modify CPF varchar(11);
alter table clients add column CNPJ char(15);
alter table clients add constraint unique_cnpj_client unique (CNPJ);

insert IGNORE into Clients (Fname, Minit,Lname, CPF, adress,CNPJ)
	values ('Maria','M','Silva',12345678900,'Rua silva de prata 29, Carangola - Cidade das flores', null),
           ('Joana','J','Almeida',12345958900,'Rua almeida de prata 30, Carangola - Cidade das matas', null),
           ('Otavio','O','Nice',12265678900,'Rua silva de ouro 298, Carangola - Cidade preta', null),
           ('Lais','L','martins',12345753200,'Rua martins de prata 589, Jardins - Cidade das flores',null),
           ('Kelly','K','Lly',00345678900,'Rua rosa de ouro 29, Dourados - Cidade das matas',null),
           ('Ademar','A','Silva',12755678900,'Rua deserta 1000, Amelia - Cidade alagada',null),
           ('Votorantim',null,null,null,'Rua alameda das perolas 1070, Magnolia - Campo dourado',654789321025891);



-- condição para que clinete seha somemnte pessoa física ou juridica (PF ou PJ)
alter table clients add constraint cnpj_ou_cpf_client check ((CPF is null and CNPJ is not null) or (CPF is not null and CNPJ is null));


insert IGNORE into Clients (Fname, Minit,Lname, CPF, adress,CNPJ)
	values ('Mosqueta',null,null,null,'Rua alameda das perolas 1070, Magnolia - Campo dourado',654789365025891);



           
			
			

 
 
-- ----------------------------------------------------------------------------
-- criar tabela produto
create table product(
		idProduct int auto_increment primary key,
        Pname varchar(10),
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos', 'Móveis') not null,
        avaliação float default 0,
        size varchar(10)
);

alter table product auto_increment=1;
alter table product modify Pname varchar(30);

insert into product (Pname, classification_kids, category, avaliação, size)
			values ('Fone de ouvido', false, 'Eletrônico', '4', null),
					('Mouse', false, 'Eletrônico', '7', null),
                    ('Barbie', true, 'Brinquedos', '9', null),
                    ('Camisa social', false, 'Vestimenta', '8', 'PP'),
                    ('Sofá reclinável', false, 'Móveis', '10', '3x1,4x1,6'),
                    ('Morango bandeja', false, 'Alimentos', '7', null);


				
                    






-- ----------------------------------------------------------------------------
-- criar tabela Payments
create table payments(
	idclient int,
    idPayment int unique,
    typePayment enum('Boleto','Um Cartão','Dois cartões'),
    idCard_1 int,
    idCard_2 int,
    primary key(idclient, idpayment),
    constraint fk_payment_client foreign key (idclient) references clients(idClients),
    constraint fk_payment_card_1 foreign key (idCard_1) references creditcards(idCard),
    constraint fk_payment_card_2 foreign key (idCard_2) references creditCards(idCard)
    -- constraint ck_client_card_1 check ((select idCard from creditCards where idCard=idCard_1) in (select idclient from creditCards where idclient=idclient))
    );
   
   select (select idCard from creditCards where idCard=1) in (select idclient from creditCards where idclient=6);

    
  
  insert into payments(idclient,idPayment, typePayment, idCard_1,idCard_2)
				values(1,1,'Um Cartão',1,null),
					  (1,2,'Dois Cartões',1,2),
                      (4,3,'Boleto',null, null),
                      (3,4,'Um cartão',3,null);
                
    


-- ----------------------------------------------------------------------------
-- criar tabela Cartões de crédito
create table creditCards(
	idCard int unique,
	idclient int,
    limitAvailable float,
    ExpirationDate date,
    verfificationStatus enum('Verificado','Não verificado') default 'Verificado',
    primary key (idclient, idCard),
	constraint fk_card_client foreign key (idclient) references clients(idClients)
    -- constraint ck_expirationdate check (CURRENT_DATE()<=ExpirationDate)
    );
       
select  current_date();
    
insert into creditCards(idCard, idclient,limitAvailable,ExpirationDate,verfificationStatus)
					values(1,1, 5000, '2025-08-15',default),
						  (2,1, 7800, '2026-09-15',default),
                          (3,4, 800, '2027-04-5',default),
                          (4,6, 15000, '2030-10-04',default);
                          

    









-- ----------------------------------------------------------------------------
-- criar tabela pedido
create table orders(
	idOrders int auto_increment primary key,
    idOrdesClient int,
    ordersStatus enum('Cancelado','Confirmado','Em procesamento') default 'Em procesamento',
    ordersDescription varchar(255),
    sendValue float default 10,
    idPayment int,
    constraint fk_orders_client foreign key (idOrdesClient) references clients(idClients),
    constraint fk_orders_payment foreign key (idPayment) references payments(idPayment)
    );
    

    
alter table orders auto_increment=1;


insert into orders (idOrdesClient, ordersStatus, ordersDescription, sendValue, idPayment)
			values (1, default, 'compra via aplicativo',null,1),
                   (2, default, 'compra via aplicativo',50,2),
                   (3, 'Confirmado', null,null,3),
                   (4, 'Cancelado', 'compra via web',150,4);
                   

                   


 
 
 
 
 
 
 
 
 
-- ----------------------------------------------------------------------------					  
-- criar tabela estoque
create table productStorage(
	idProStorage int auto_increment primary key,
    quantity int default 0,
    storageLocation varchar(255)
    );
    
alter table productStorage auto_increment=1;
    
    insert into productStorage (storageLocation, quantity)
				         values('Rio de janeiro',1000),
                               ('Rio de janeiro',500),
                               ('São paulo',56),
                               ('São paulo',785),
                               ('Brasilia',3259);
                               
                         


    
-- ----------------------------------------------------------------------------		    
-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
    );
    
    
    alter table supplier auto_increment=1;
    
    insert into supplier (SocialName, CNPJ, contact)
				   values('Almeida e Filhos','123456789012346','12345678963'),
						('Coca cola','123963789012346','12348578963'),
                        ('Clarice utilidades','123456789456346','12345671983');
    
    
    
    
    
 -- ----------------------------------------------------------------------------	   
-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15) not null,
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
    );
    
alter table seller auto_increment=1;
alter table seller modify CNPJ varchar(15);
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact)
            values('Tech eletronics',null, 123456789012345, null, 'Rio de janeiro','75321469809'),
                  ('Botique durgas',null, null, 123456987, 'Rio de janeiro','75321689809'),
                  ('Kids world',null, 123487789012345, null, 'São paulo','75981469809');
                  
    
    
    
    
 -- ----------------------------------------------------------------------------	
-- criar tabela productSeller
create table productSeller(
		idPseller int,
        idPproduct int,
        prodQuantity int default 1,
        primary key(idPseller, idPproduct),
        constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
        constraint fk_product_product foreign key (idPproduct) references product(idProduct)
        );
        
insert into productSeller(idPseller, idPproduct, prodQuantity)
                 values(4,6,80),
                       (5,4,10);
                       
select * from productSeller;

                        
        





-- ----------------------------------------------------------------------------        
-- criar tabela productOrder
create table productOrder(
		idPOproduct int,
        idPOordert int,
        poQuantity int default 1,
        poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
        primary key(idPOproduct, idPOordert),
        constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
        constraint fk_productorder_product foreign key (idPOordert) references orders(idOrders)
        );

insert into productOrder (idPOproduct, idPOordert, poQuantity, poStatus)
				  values(1,1,2, default),
                         (2,1,1, default),
                         (3,2,1, default);
                         
                  
                         
                         
                         
                         
        
  -- ----------------------------------------------------------------------------	      
	-- criar tabela storageLocation
create table storageLocation(
		idLproduct int,
        idLstorage int,
        location varchar(255) not null,
        primary key(idLproduct, idLstorage),
        constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
        constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProStorage)
        );
        
        
insert into storageLocation (idLproduct, idLstorage, location)
				      values(1,2,'RJ'),
							(2,3,'GO');
                            

                      
        


 -- ----------------------------------------------------------------------------	       
-- criar tabela productSupplier
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idproduct)
    );
        
insert ignore into productSupplier(idPsSupplier, idPsProduct, quantity)
                    values(1,1,500),
                          (1,2,400),
                          (2,4,633),
                          (3,3,5),
                          (2,5,10),
                          (2,6,69);
                          
                
                
 -- ----------------------------------------------------------------------------	       
-- criar tabela Entrega
create table delivery(
		idDelivery int auto_increment,
        idOrderDelivery int,
        Delivery_by varchar(20),
        Delivery_Status enum('Em processamento','Encaminhado','Produto em rota de entrega'),
        Cod_rastreio char(10) unique,
        primary key (idDelivery, idOrderDelivery),
        constraint fk_Order_Delivery foreign key (idOrderDelivery) references orders(IdOrders)
        );
        
        
insert into delivery(idOrderDelivery, Delivery_by, Delivery_Status, Cod_rastreio)
		      values(1,'Rapidinho','Em processamento','RP00215398'),
					(2,'Ligeirinho','Encaminhado','LG00215257'),
					(3,'Rapido Express','Produto em rota de entrega','RE00215129'),
					(4,'Rapidinho','Produto em rota de entrega','RP00215111');
                             
                       
        
 
 
 
 
 
 
 
        
-- -----------------------------------------------------------Consultas--------------------------------------------------------------

-- Quantos pedidos foram feitos por cada cliente?
select idOrdesClient as iD_Cliente, count(*) as Contagem_de_pedidos_por_cliente from orders group by idOrdesClient;

-- Algum vendedor também é fornecedor?
select v.SocialName as Nome_Social, v.CNPJ from seller v inner join supplier f on v.CNPJ=f.CNPJ;

-- Relação de nomes dos fornecedores e nomes dos produtos;
select p.idProduct, p.Pname as Nome_do_Produto, s.SocialName as Forcecido_por from product p inner join productsupplier ps on p.idProduct=ps.idPsProduct inner join supplier s on idPsSupplier=idSupplier;


-- Recuperações simples com SELECT Statement 
    -- (Nome das trasnportadoras que fazem entrega)
select distinct Delivery_by from delivery;

-- Filtros com WHERE Statement 
    -- (Produtos com avaliação maior que 7)
select Pname, avaliação from product where avaliação>7;


-- Crie expressões para gerar atributos derivados
    -- (Soma dos limites de cartão disponíveis para cada cliente com cartão cadastrado)
select idclient, sum(limitAvailable) as Limite_Total_disponível from creditcards group by idclient;


-- Defina ordenações dos dados com ORDER BY
 -- (Ordenação dos produtos por ordem descendente de avaliação)
select * from product order by avaliação desc;
   -- (Ordenação dos vendedores por ordem alfabética)
select * from  seller order by SocialName asc;



-- Condições de filtros aos grupos – HAVING Statement
 -- (Forncedores que apresentam mais que 2 pedidos de seus produtos realizados por clientes)
select s.SocialName as Fornecedor, count(*) as contagem from supplier s inner join productsupplier on idPsSupplier=idSupplier group by Fornecedor having contagem>2;


-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
 -- (clientes que possuem o cartão de crédito cadastrado no banco de dados)
 select c.idClients, concat(c.Fname,' ',c.Lname) as Cliente from clients c inner join creditcards cd where cd.idclient=c.idClients;
 