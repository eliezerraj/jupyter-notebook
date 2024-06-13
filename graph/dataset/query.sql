select * from account

# Merchant
SELECT json_agg(
           json_build_object(
               'id', id,
               'label','merchant',
               'properties',json_build_object('name', id)
           )
       ) AS result
FROM (select distinct(mcc) as id from payment p ) t

## Terminal
SELECT json_agg(
           json_build_object(
               'id', id,
               'label','terminal',
               'properties',json_build_object(	'name', terminal_name,
               									'status', status,
               									'coord_x',coord_x,
               									'coord_y',coord_x)
           )
       ) AS result
FROM terminal t 

## Person
SELECT json_agg(
           json_build_object(
               'id', person_id,
               'label','person',
               'properties',json_build_object(	'name', person_name,
               									'age', age,
               									'profession',profession,
               									'education_level',education_level)
           )
       ) AS result
FROM person

## Account
SELECT json_agg(
           json_build_object(
               'id', account_id,
               'label','account',
               'properties',json_build_object(	'name', account_id,
               									'person', person_id)
           )
       ) AS result
FROM account a 

## Card
SELECT json_agg(
           json_build_object(
               'id', card_number,
               'label','card',
               'properties',json_build_object(	'card_number', card_number,
               									'account', account_id,
               									'type', card_type,
               									'model', card_model,
               									'status', status)
           )
       ) AS result
FROM (select 	c.card_number,
				a.account_id, 
				c.card_type, 
				c.card_model, 
				c.status 
		from 	card c, 
				account a 
		where c.fk_account_id = a.id ) a 

## Account
SELECT json_agg(
           json_build_object(
               'id', account_id,
               'label','account',
               'properties',json_build_object(	'name', account_id,
               									'person', person_id)
           )
       ) AS result
FROM account a 

## Payment
SELECT json_agg(
           json_build_object(
               'id', id,
               'label','payment',
               'properties',json_build_object(	'transaction', id,
               									'currency', currency,
               									'amount',amount,
               									'type', card_type,
               									'model',card_model,
               									'payment_at' ,payment_at)
           )
       ) AS result
FROM (select 	p.id,
				p.currency, 
				p.amount,
				p.card_type,
				p.card_model,
				p.payment_at,
				p.mcc, 
				t.terminal_name,
				c.card_number 
		from 	payment p,
				terminal t,
				card c 
		where	p.fk_terminal_id = t.id
		and 	p.fk_card_id = c.id ) a 

select 	p.id,
		p.currency, 
		p.amount,
		p.card_type,
		p.card_model,
		p.payment_at,
		p.mcc, 
		t.terminal_name,
		c.card_number 
from 	payment p,
		terminal t,
		card c 
where	p.fk_terminal_id = t.id
and 	p.fk_card_id = c.id 


select *
from payment p 

========================================================
		
## Edge Account / Person
SELECT json_agg(
           json_build_object(
               'from_id', person_id,
               'to_id', account_id,
               'label','has',
               'properties',json_build_object('id', person_id || '-' || account_id || '-ACC-PER')
           )
       ) AS result
FROM account a 

## Edge Account / Card
SELECT json_agg(
           json_build_object(
               'from_id', account_id,
               'to_id', card_number,
               'label','issued',
               'properties',json_build_object('id', account_id || '-' || card_number || '-ACC-CARD')
           )
       ) AS result
FROM (select 	c.card_number,
				a.account_id, 
				c.card_type, 
				c.card_model, 
				c.status 
		from 	card c, 
				account a 
		where c.fk_account_id = a.id) a 
		
## Edge Payment / Card
SELECT json_agg(
           json_build_object(
               'from_id', id,
               'to_id', card_number,
               'label','payed',
               'properties',json_build_object('id', id || '-' || card_number || '-PAY-CARD')
           )
       ) AS result
FROM (select 	p.id,
				p.currency, 
				p.amount,
				p.card_type,
				p.card_model,
				p.payment_at,
				p.mcc, 
				t.terminal_name,
				c.card_number 
		from 	payment p,
				terminal t,
				card c 
		where	p.fk_terminal_id = t.id
		and 	p.fk_card_id = c.id ) a 
		
		
## Edge Payment / MCC
SELECT json_agg(
           json_build_object(
               'from_id', id,
               'to_id', mcc,
               'label','payed_at',
               'properties',json_build_object('id', id || '-' || mcc || '-PAY-MCC')
           )
       ) AS result
FROM (select 	p.id,
				p.currency, 
				p.amount,
				p.card_type,
				p.card_model,
				p.payment_at,
				p.mcc, 
				t.terminal_name,
				c.card_number 
		from 	payment p,
				terminal t,
				card c 
		where	p.fk_terminal_id = t.id
		and 	p.fk_card_id = c.id ) a 
	
## Edge Payment / MCC
SELECT json_agg(
           json_build_object(
               'from_id', id,
               'to_id', terminal_name,
               'label','payed_at',
               'properties',json_build_object('id', id || '-' || terminal_name || '-PAY-TERMINAL')
           )
       ) AS result
FROM (select 	p.id,
				p.currency, 
				p.amount,
				p.card_type,
				p.card_model,
				p.payment_at,
				p.mcc, 
				t.terminal_name,
				c.card_number 
		from 	payment p,
				terminal t,
				card c 
		where	p.fk_terminal_id = t.id
		and 	p.fk_card_id = c.id ) a 





=======

//Gremlin Terminal
select 'addV("Terminal").property(id,"' || terminal_name || '").' ||
'property("name","'|| terminal_name ||'").' ||
'property("coord_x",' || coord_x ||').' ||
'property("coord_y",' || coord_y ||').' ||
'as("' || terminal_name ||'").'
from terminal t 

//Gremlin Mcc
select 'addV("Merchant").property(id,"' || mcc || '").' ||
'property("name","' || mcc ||'").' ||
'as("' || mcc ||'").'
from (select distinct mcc
from payment)

//Gremlin Payment
select 'addV("Payment").property(id,' || id|| ').' ||
'property("card_number","'|| card_number ||'").' ||
'property("amount",' || amount ||').' ||
'property("payment_at","' || payment_at ||'").' ||
'as("' || id ||'").'
from payment t 
where t.fk_card_id <= 100 
order by payment_at
limit(80)

//Gremlin Payment - Edge
select 'V(' || id|| ').' ||
'addE("using").to(__.V("'|| terminal_name ||'")).' ||
'property(id,"'|| id || '-TERM")' ||
'.V(' || id|| ').' ||
'addE("to").to(__.V("'|| mcc ||'")).' ||
'property(id,"'|| id || '-MCC").'
from payment t
where t.fk_card_id <= 100 
order by payment_at
limit(80)

select 'V(' || id|| ').' ||
'addE("pay_with").to(__.V("'|| card_number ||'")).' ||
'property(id,"'|| id || '-CARD").' 
from payment t
where t.fk_card_id <= 100 
order by payment_at
limit(80)


//Gremlin Card
select 'addV("Card").property(id,"' || card_number|| '").' ||
'property("card_number","'|| card_number ||'").' ||
'as("' || card_number ||'").'
from card c 
order by id
limit(100)

//Gremlin Card - Edge
select 'V("' || card_number|| '").' ||
'addE("has_tx").to(__.V('|| ID  ||')).' ||
'property(id,"'|| id || '-TX").' 
from payment t
order by id
limit(80)


//-----

// Person
select 'addV("Person").property(id,"' || person_id|| '").' ||
		'property("person_id","'|| person_id ||'").' ||
		'property("person_name","'|| person_name ||'").' ||
		'property("age","'|| age ||'").' ||
		'property("salary_level","'|| salary_level ||'").' ||
		'property("education_level","'|| education_level ||'").' ||
		'as("' || person_id ||'").'
from person p 
where id <=60
order by p.id

// Card´s Account
select 'addV("Account").property(id,"' || account_id|| '").' ||
		'property("account_id","'|| account_id ||'").' ||
		'property("person_id","'|| person_id ||'").' ||
		'as("' || account_id ||'").'
from account a
where  a.person_id in (select person_id from person where id <=60 order by id)

// Edge between card and person
select 'V("' || p.person_id|| '").' ||
		'addE("has").to(__.V("'|| a.account_id  ||'")).' ||
		'property(id,"'|| p.person_id || '-' ||a.account_id ||'-ACC-PER").' 
from account a,
	person p 
where  a.person_id in (select person_id from person where id <=60 order by id)
and p.person_id = a.person_id

// Card
select 'addV("Card").property(id,"' || card_number|| '").' ||
		'property("card_number","'|| card_number ||'").' ||
		'as("' || card_number ||'").'
		from card c 
where c.fk_account_id in (select id
from account a
where a.person_id in (select person_id from person where id <=60 order by id))

// Edge between card and account
select 'V("' || a.account_id|| '").' ||
		'addE("issue").to(__.V("'|| c.card_number  ||'")).' ||
		'property(id,"'|| a.account_id || '-' ||c.card_number ||'-ACC-CARD").' 
from 	account a,
		card c 
where  a.id = c.fk_account_id
and c.fk_account_id in (select id
						from account a
						where a.person_id in (select person_id from person where id <=60 order by id))

// Payment						
select 'addV("Payment").property(id,' || id|| ').' ||
		'property("card_number","'|| card_number ||'").' ||
		'property("amount",' || amount ||').' ||
		'property("payment_at","' || payment_at ||'").' ||
		'as("' || id ||'").'
from payment p 
where p.fk_card_id in (select id 
						from card c
						where c.fk_account_id in (select id
													from account a
													where a.person_id in (select person_id from person where id <=60 order by id)))
order by p.payment_at

select 'V(' || id|| ').' ||
		'addE("using").to(__.V("'|| terminal_name ||'")).' ||
		'property(id,"'|| id || '-TERM")' ||
		'.V(' || id|| ').' ||
		'addE("to").to(__.V("'|| mcc ||'")).' ||
		'property(id,"'|| id || '-MCC").'
		from payment p 
where p.fk_card_id in (select id 
						from card c
						where c.fk_account_id in (select id
													from account a
													where a.person_id in (select person_id from person where id <=60 order by id)))
order by p.payment_at

select 'V(' || id|| ').' ||
		'addE("pay_with").to(__.V("'|| card_number ||'")).' ||
		'property(id,"'|| id || '-CARD").' 
		from payment p 
where p.fk_card_id in (select id 
						from card c
						where c.fk_account_id in (select id
													from account a
													where a.person_id in (select person_id from person where id <=60 order by id)))
order by p.payment_at

-----

--------------------

// ok Person
select 'addV("Person").property(id,"' || person_id|| '").' ||
		'property("person_id","'|| person_id ||'").' ||
		'property("person_name","'|| person_name ||'").' ||
		'property("age","'|| age ||'").' ||
		'property("salary_level","'|| salary_level ||'").' ||
		'property("education_level","'|| education_level ||'").' ||
		'as("' || person_id ||'").'
from person p 
where id in (select id 
				from person 
				where person_id  in (	select person_id 
										from account a
										where a.id in (	select fk_account_id 
														from card c
														where c.id in (select distinct (p.fk_card_id)
																		from payment p
																		order by fk_card_id
																		limit(10)
																		)
														)
				)
)

// ok Account
select 'addV("Account").property(id,"' || account_id|| '").' ||
		'property("account_id","'|| account_id ||'").' ||
		'property("person_id","'|| person_id ||'").' ||
		'as("' || account_id ||'").'
from account a
where  a.person_id in (select person_id 
						from account a
						where a.id in (	select fk_account_id 
										from card c
										where c.id in (select distinct (p.fk_card_id)
														from payment p
														order by fk_card_id
														limit(10)
														)
										)
)

// ok Card
select 'addV("Card").property(id,"' || card_number|| '").' ||
		'property("card_number","'|| card_number ||'").' ||
		'as("' || card_number ||'").'
		from card c 
where c.fk_account_id in (select fk_account_id 
							from card c
							where c.id in (select distinct (p.fk_card_id)
											from payment p
											order by fk_card_id
											limit(10))
							order by c.id )

// ok Payment						
select 'addV("Payment").property(id,' || id|| ').' ||
		'property("card_number","'|| card_number ||'").' ||
		'property("amount",' || amount ||').' ||
		'property("payment_at","' || payment_at ||'").' ||
		'as("' || id ||'").'
from payment p 
where p.fk_card_id in (select distinct (p.fk_card_id)
						from payment p
						order by fk_card_id
						limit(10))
order by p.payment_at

// ok Edge Person HAS account
select 'V("' || p.person_id|| '").' ||
		'addE("has").to(__.V("'|| a.account_id  ||'")).' ||
		'property(id,"'|| p.person_id || '-' ||a.account_id ||'-ACC-PER").' 
from account a,
	person p 
where  a.person_id in (
				select person_id 
										from account a
										where a.id in (	select fk_account_id 
														from card c
														where c.id in (select distinct (p.fk_card_id)
																		from payment p
																		order by fk_card_id
																		limit(10)
																		)
														)
)
and p.person_id = a.person_id

// ok Edge Payment pay_with Card
select 'V(' || id|| ').' ||
		'addE("pay_with").to(__.V("'|| card_number ||'")).' ||
		'property(id,"'|| id || '-CARD").' 
		from payment p 
where p.fk_card_id in (select distinct (p.fk_card_id)
						from payment p
						order by fk_card_id
						limit(10))
order by p.payment_at

// ok Edge Payment using Terminal and to MCC
select 'V(' || id|| ').' ||
		'addE("using").to(__.V("'|| terminal_name ||'")).' ||
		'property(id,"'|| id || '-TERM")' ||
		'.V(' || id|| ').' ||
		'addE("to").to(__.V("'|| mcc ||'")).' ||
		'property(id,"'|| id || '-MCC").'
		from payment p 
where p.fk_card_id in (select distinct (p.fk_card_id)
						from payment p
						order by fk_card_id
						limit(10))
order by p.payment_at

// Edge Account issue Card
select 'V("' || a.account_id|| '").' ||
		'addE("issue").to(__.V("'|| c.card_number  ||'")).' ||
		'property(id,"'|| a.account_id || '-' ||c.card_number ||'-ACC-CARD").' 
from 	account a,
		card c 
where  a.id = c.fk_account_id
and c.fk_account_id in (select fk_account_id 
							from card c
							where c.id in (select distinct (p.fk_card_id)
											from payment p
											order by fk_card_id
											limit(10))
							order by c.id 
						)
                        
----


