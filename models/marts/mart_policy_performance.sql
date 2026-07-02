select
    p.policy_id,
    p.policy_number,
    p.policy_type,
    p.policy_status,
    p.customer_id,
    p.customer_name,
    p.state,
    p.customer_segment,
    p.coverage_amount,
    p.annual_premium,

    case 
        when p.policy_status = 'Active' then 1 
        else 0 
    end as is_active_policy,

    coalesce(sum(t.transaction_amount), 0) as total_premium_collected,
    coalesce(sum(c.settlement_amount), 0) as total_claims_paid,
    count(distinct c.claim_id) as claim_count,

    avg(c.days_to_settlement) as avg_days_to_settlement,

    case
        when coalesce(sum(t.transaction_amount), 0) = 0 then null
        else coalesce(sum(c.settlement_amount), 0) 
             / nullif(coalesce(sum(t.transaction_amount), 0), 0)
    end as loss_ratio

from {{ ref('dim_policies') }} p

left join {{ ref('fact_transactions') }} t
    on p.policy_id = t.policy_id
    and t.transaction_status = 'Completed'

left join {{ ref('fact_claims') }} c
    on p.policy_id = c.policy_id
    and c.claim_status = 'Settled'

group by
    p.policy_id,
    p.policy_number,
    p.policy_type,
    p.policy_status,
    p.customer_id,
    p.customer_name,
    p.state,
    p.customer_segment,
    p.coverage_amount,
    p.annual_premium