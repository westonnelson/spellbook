{{ config(
  schema = 'aave_v2_ethereum'
  , alias='interest'
  , post_hook='{{ expose_spells(\'["ethereum"]\',
                                  "project",
                                  "aave_v2",
                                  \'["batwayne", "chuxinh"]\') }}'
  )
}}

select 
  a.reserve, 
  t.symbol,
  date_trunc('hour',a.evt_block_time) as hour, 
  avg(a.liquidityRate) / 1e27 as deposit_apy, 
  avg(a.stableBorrowRate) / 1e27 as stable_borrow_apy, 
  avg(a.variableBorrowRate) / 1e27 as variable_borrow_apy
from {{ source('aave_v2_ethereum', 'LendingPool_evt_ReserveDataUpdated') }} a
left join {{ ref('tokens_ethereum_erc20') }} t
on a.reserve=t.contract_address
group by 1,2,3
;