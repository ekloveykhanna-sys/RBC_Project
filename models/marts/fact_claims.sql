select claim_id, policy_id, claim_number, claim_date, claim_category, claim_amount, claim_status,
settlement_date, settlement_amount, days_to_settlement
from {{ ref('stg_claims') }}