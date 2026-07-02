select p.policy_id, p.customer_id, c.customer_name, c.state, c.customer_segment, p.policy_number,
p.policy_type, p.coverage_amount, p.annual_premium,p.policy_start_date, p.policy_status, 
case when p.policy_status = 'Active' then 1 else 0 end as is_active_policy
from {{ ref('stg_policies') }} p 
left join {{ ref('stg_customers') }} c on p.customer_id = c.customer_id