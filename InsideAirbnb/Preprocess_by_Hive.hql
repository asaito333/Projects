-- Create new table with new variables
create table newyork_f as 
select city_ref, cast(review_scores_rating as int), cast(regexp_replace(regexp_replace(price,'\\$',''),'\\,','') as int) price, availability_30, cast(host_response_rate as int), cast(host_acceptance_rate as int), accommodates, bathrooms, bedrooms, beds, minimum_nights,
case when room_type like 'Private room' then cast(1 as double) else (0) end as private_room,
case when room_type like 'Entire home/apt' then cast(1 as double) else (0) end as Entire_home,
case when regexp_extract(amenities,'TV',0) == 'TV' then cast(1 as double) else (0) end as TV,
case when regexp_extract(amenities,'Internet',0) == 'Internet' then cast(1 as double) else (0) end as Internet,
case when regexp_extract(amenities,'Air Conditioning',0) == 'Air Conditioning' then cast(1 as double) else (0) end as AirConditioning,
case when regexp_extract(amenities,'Kitchen',0) == 'Kitchen' then cast(1 as double) else (0) end as Kitchen
from newyork_temp 
;

-- Calculate avarage and standard deviation
create table newyork_avg as 
select city_ref,
avg(review_scores_rating) as avg_rating, 
stddev_pop(review_scores_rating) as std_rating, 

avg(price) as avg_price, 
stddev_pop(price) as std_price, 

avg(availability_30) as avg_avail, 
stddev_pop(availability_30) as std_avail, 

avg(host_response_rate) as avg_response, 
stddev_pop(host_response_rate) as std_response, 

avg(host_acceptance_rate) as avg_accep, 
stddev_pop(host_acceptance_rate) as std_accep, 

avg(accommodates) as avg_accom, 
stddev_pop(accommodates) as std_accom, 

avg(bathrooms) as avg_bath, 
stddev_pop(bathrooms) as std_bath, 

avg(bedrooms) as avg_bedroom, 
stddev_pop(bedrooms) as std_bedroom, 

avg(beds) as avg_bed, 
stddev_pop(beds) as std_bed, 

avg(minimum_nights) as avg_night, 
stddev_pop(minimum_nights) as std_night, 

avg(private_room) as avg_private, 
stddev_pop(private_room) as std_private, 

avg(Entire_home) as avg_entire, 
stddev_pop(Entire_home) as std_entire, 

avg(TV) as avg_tv, 
stddev_pop(TV) as std_tv, 

avg(Internet) as avg_internet, 
stddev_pop(Internet) as std_internet, 

avg(AirConditioning) as avg_air, 
stddev_pop(AirConditioning) as std_air, 

avg(Kitchen) as avg_kitchen, 
stddev_pop(Kitchen) as std_kitchen

from newyork_f 
group by city_ref
;

-- Standardize the variables
create table newyork_ff as
select 
((f.review_scores_rating - a.avg_rating)/ a.std_rating) as reviews_scores_rating_s,
((f.price - a.avg_price)/ a.std_price) as price_s,
((f.availability_30 - a.avg_avail)/ a.std_avail) as availability_30_s,
((f.host_response_rate - a.avg_response)/ a.std_response) as hoset_response_rate_s,
((f.host_acceptance_rate - a.avg_accep)/ a.std_accep) as host_acceptance_rate_s,
((f.accommodates - a.avg_accom)/ a.std_accom) as accommodates_s,
((f.bathrooms - a.avg_bath)/ a.std_bath) as bathrooms_s,
((f.bedrooms - a.avg_bedroom)/ a.std_bedroom) as bedrooms_s,
((f.beds - a.avg_bed)/ a.std_bed) as beds_s,
((f.minimum_nights - a.avg_night)/ a.std_night) as mimimum_nights_s,
((f.private_room - a.avg_private)/ a.std_private) as private_room_s,
((f.Entire_home - a.avg_entire)/ a.std_entire) as Entire_home_s,
((f.TV - a.avg_tv)/ a.std_tv) as TV_s,
((f.Internet - a.avg_internet)/ a.std_internet) as Internet_s,
((f.AirConditioning - a.avg_air)/ a.std_air) as AirConditioning_s,
((f.Kitchen - a.avg_kitchen)/ a.std_kitchen) as Kitchen_s
from newyork_f f left join newyork_avg a on (f.city_ref = a.city_ref);

