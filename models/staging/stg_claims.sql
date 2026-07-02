select claim_id, policy_id, claim_number, strptime(claim_date, '%d/%m/%Y') as claim_date, claim_category, claim_amount, claim_status,
    case when settlement_date = '' then null else strptime(settlement_date, '%d/%m/%Y') end as settlement_date, settlement_amount, days_to_settlement
from {{ ref('raw_claims_2hr') }}