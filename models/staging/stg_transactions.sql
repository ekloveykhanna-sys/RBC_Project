select transaction_id, policy_id,strptime(transaction_date, '%d/%m/%Y') as transaction_date, transaction_type, transaction_amount, transaction_status
from {{ ref('raw_transactions_2hr') }}