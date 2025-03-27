set search_path to prod_sms_obj, "$user", public;
EXPLAIN (ANALYZE, BUFFERS, VERBOSE) 
 /*+ IndexScan(tfn tfn_unique) */ select tfn.tfn_nb from tfn tfn join tfn_nxx nxx on nxx.npa_cd = tfn.npa_cd and nxx.nxx_cd =tfn.nxx_cd where tfn.TFN_STTS_CD = 'S' AND nxx.nxx_stts_cd ='0'  AND (tfn.PRE_RESRV_LCK_TS is null OR tfn.PRE_RESRV_LCK_TS < current_timestamp) AND nxx.USAG_PC < 100 AND tfn.tfn_nb like any(array[$1,$2,$3,$4,$5,$6,$7,$8,$9,$10]) order by nxx.usag_pc limit $11 FOR UPDATE of tfn SKIP locked;
