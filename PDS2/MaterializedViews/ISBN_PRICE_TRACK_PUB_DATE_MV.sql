CREATE MATERIALIZED VIEW pds2.isbn_price_track_pub_date_mv (isbn,usa_price,canada_price,pub_date)
AS select ip.isbn, ip.usa_price,ip.canada_price, min(wip.price_pub_date) as pub_date
from (select isbn, usa_price, canada_price from isbn_price) ip, whouse_item_price_dw wip
where ip.isbn=wip.isbn and
ip.usa_price = wip.usa_price and
ip.canada_price = wip.canada_price and
wip.whse_nbr = 'IN' and
wip.price_pub_date is not null
group by ip.isbn, ip.usa_price,ip.canada_price
UNION
select ip.isbn, ip.usa_price, ip.canada_price, min(wip.price_pub_date)
from (select isbn, usa_price, canada_price from isbn_price) ip, whouse_item_price_dw wip
where ip.isbn = wip.isbn and
ip.usa_price = wip.usa_price and
ip.canada_price = wip.canada_price and
not exists (select 1
from whouse_item_price_dw wip2
where wip2.isbn = ip.isbn and
wip2.usa_price = ip.usa_price and
wip2.canada_price = ip.canada_price and
wip2.whse_nbr = 'IN' and
wip2.price_pub_date is not null)
group by ip.isbn, ip.usa_price, ip.canada_price;