with policy_aggregates as (
    select
        policy_type,
        count(case when policy_status = 'Active' then 1 end) as active_policies,
        sum(cast(annual_premium as double)) as total_premiums
    from {{ ref('dim_policies') }}
    group by 1
),

claims_aggregates as (
    select
        p.policy_type,
        sum(coalesce(cast(c.settlement_amount as double), 0.0)) as total_settlements,
        sum(case when c.claim_status = 'Settled' then cast(c.days_to_settlement as integer) else 0 end) as total_settlement_days,
        count(case when c.claim_status = 'Settled' then 1 end) as settled_claims_count
    from {{ ref('dim_policies') }} p
    left join {{ ref('fact_claims') }} c on p.policy_id = c.policy_id
    group by 1
)

select
    p.policy_type,
    cast(p.active_policies as integer) as active_policies,
    coalesce(c.total_settlements, 0.0) as total_settlement_payouts,
    p.total_premiums,
    -- Safely calculate Loss Ratio preventing divide-by-zero
    round(
        case 
            when p.total_premiums = 0 then 0.0
            else coalesce(c.total_settlements, 0.0) / p.total_premiums 
        end, 2
    ) as loss_ratio,
    -- Safely calculate Average Days to Settlement
    round(
        case 
            when coalesce(c.settled_claims_count, 0) = 0 then 0.0
            else cast(c.total_settlement_days as double) / c.settled_claims_count 
        end, 1
    ) as avg_days_to_settlement
from policy_aggregates p
left join claims_aggregates c on p.policy_type = c.policy_type