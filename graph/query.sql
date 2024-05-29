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
order by id


//Gremlin Edge

select 'V(' || id|| ').' ||
'addE("using").to(__.V("'|| terminal_name ||'")).' ||
'property(id,"'|| id || '-TERM")' ||
'.V(' || id|| ').' ||
'addE("to").to(__.V("'|| mcc ||'")).' ||
'property(id,"'|| id || '-MCC").'
from payment t
order by id

select 'V(' || id|| ').' ||
'addE("pay_with").to(__.V("'|| card_number ||'")).' ||
'property(id,"'|| id || '-CARD").' 
from payment t
order by id


//Gremlin Card

select 'addV("Card").property(id,"' || card_number|| '").' ||
'property("card_number","'|| card_number ||'").' ||
'as("' || card_number ||'").'
from (select distinct fk_card_id,card_number
from payment
order by fk_card_id)


select 'V("' || card_number|| '").' ||
'addE("has_tx").to(__.V('|| ID  ||')).' ||
'property(id,"'|| id || '-TX").' 
from payment t
order by id



