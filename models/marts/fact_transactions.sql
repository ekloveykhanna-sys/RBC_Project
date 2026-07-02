select transaction_id, policy_id, transaction_date, transaction_type, transaction_amount, transaction_status
from {{ ref('stg_transactions') }}