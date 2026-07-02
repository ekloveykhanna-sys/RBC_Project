cube(`Policies`, {
  sql: `
  SELECT *
  FROM read_csv_auto('C:/Users/nidhi/rbc_project/seeds/mart_policy_performance.csv')
`,

  measures: {
    count: { type: `count` },

    activePolicies: {
      type: `count`,
      filters: [{ sql: `${CUBE}.policy_status = 'Active'` }]
    },

    totalPremiumCollected: {
      sql: `total_premium_collected`,
      type: `sum`
    },

    totalClaimsPaid: {
      sql: `total_claims_paid`,
      type: `sum`
    },

    claimCount: {
      sql: `claim_count`,
      type: `sum`
    },

    avgSettlementDays: {
      sql: `avg_days_to_settlement`,
      type: `avg`
    },

    lossRatio: {
      sql: `sum(total_claims_paid) / nullif(sum(total_premium_collected), 0)`,
      type: `number`
    }
  },

  dimensions: {
    policyId: {
      sql: `policy_id`,
      type: `number`,
      primaryKey: true
    },

    policyNumber: {
      sql: `policy_number`,
      type: `string`
    },

    policyType: {
      sql: `policy_type`,
      type: `string`
    },

    policyStatus: {
      sql: `policy_status`,
      type: `string`
    },

    customerName: {
      sql: `customer_name`,
      type: `string`
    },

    customerSegment: {
      sql: `customer_segment`,
      type: `string`
    },

    state: {
      sql: `state`,
      type: `string`
    }
  }
});