
## D - Bonus Challenge ## 

select pp.product_id,
	   pp.price,
       concat(ph.level_text, " " , ph1.level_text, " - ", ph2.level_text) as product_name,
       ph1.parent_id as category_id,
       ph1.id as segment_id,
       ph.id as style_id,
       ph2.level_text as category_name,
       ph1.level_text as segment_name,
       ph.level_text as style_name
       
from product_hierarchy ph
join product_hierarchy ph1 on ph.parent_id = ph1.id
join product_hierarchy ph2 on ph1.parent_id = ph2.id
join product_prices as pp on ph.id = pp.id;