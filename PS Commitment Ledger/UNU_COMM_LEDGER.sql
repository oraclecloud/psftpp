
--SELECT * FROM PS_LEDGER_SET_LED WHERE BUSINESS_UNIT IN ('07380', '07384') AND LEDGER LIKE '%' AND LEDGER_SET LIKE '%';
--SELECT * FROM PS_LEDGER_SET_TBL WHERE LEDGER_SET IN ('Z') OR LEDGER_SET LIKE '%REG%' OR LEDGER_SET LIKE 'V%R %';
--Ledger
SELECT * FROM PS_LED_DEFN_TBL WHERE SETID = 'SHARE' AND LEDGER = 'EXT_COMMIT';
SELECT * FROM PS_LED_FLDS_TBL WHERE SETID = 'SHARE' AND LEDGER = 'EXT_COMMIT';

--Ledger Group
SELECT * FROM PS_LED_GRP_FLD_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'EXT_COMMIT';
SELECT * FROM PS_LED_GRP_LED_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'EXT_COMMIT';
SELECT * FROM PS_LED_GRP_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'EXT_COMMIT';
SELECT * FROM PS_BU_LED_GRP_TBL WHERE BUSINESS_UNIT = 'UNDP1' AND LEDGER_GROUP = 'EXT_COMMIT';

--SELECT * FROM PS_BUL_CNTL_BUD WHERE BUSINESS_UNIT = 'UNDP1' AND LEDGER_GROUP = 'EXT_COMMIT';
--Open Period(s)
--SELECT * FROM PS_FIN_BU_LGRP_TBL WHERE LEDGER_GROUP = 'EXT_COMMIT';

--SELECT * FROM PS_BU_LED_COMB_TBL WHERE BUSINESS_UNIT = 'UNUNI' AND LEDGER_GROUP = 'ACTUAL_REG' AND PROCESS_GROUP LIKE '%';
--SELECT * FROM PS_BU_LED_TBL WHERE BUSINESS_UNIT = 'UNDP1' AND LEDGER IN ('V_ACTAMR ', 'V_ACTAYR', 'V_ACTREG' ) OR LEDGER LIKE '%REG';

SELECT * FROM PS_JRNLGEN_REQUEST WHERE APPL_JRNL_ID = 'COMMITMENT' ORDER BY DTTM_STAMP_SEC DESC;
SELECT * FROM PS_JRNL_HEADER WHERE BUSINESS_UNIT = 'UNDP1' AND FISCAL_YEAR = '2014' AND LEDGER_GROUP = 'EXT_COMMIT' AND JOURNAL_ID LIKE 'COM%';
SELECT DISTINCT SYSTEM_SOURCE FROM PS_JRNL_HEADER WHERE BUSINESS_UNIT = 'UNDP1' AND FISCAL_YEAR = '2014' AND LEDGER_GROUP = 'EXT_COMMIT' AND JOURNAL_ID LIKE 'COM%';
SELECT * FROM PS_JRNL_LN WHERE BUSINESS_UNIT = 'UNDP1' AND JOURNAL_ID = 'COM5410988';

SELECT * FROM PSXLATITEM WHERE FIELDNAME = 'SYSTEM_SOURCE' ORDER BY 1,2;
SELECT * FROM PS_SOURCE_TBL ORDER BY 1,2;

SELECT * FROM PSPRCSRQST WHERE PRCSNAME = 'GL_JRNL_IMP';
SELECT * FROM PSPRCSRQST WHERE PRCSNAME = 'UN_JRNL_CNV';

SELECT * FROM PS_KSEC_EVENTS;
SELECT * FROM PS_KSEC_SUPER_USER;

--One can change the KK Amount Type options on the Journal for Ledger Group ACTUALS (under KK options) because, this ledger group has KK enabled.
--gray/ungray commitment control fields
SELECT COMMITMENT_CNTL, LEDGER_TYPE, A.* FROM PS_BU_LED_GRP_VW A WHERE BUSINESS_UNIT = 'UNUNI';
--One can change the KK Amount Type options on the Journal for Ledger Group ACTUALS (under KK options) because, this ledger group has KK enabled

--Verification  
SELECT ORA_DATABASE_NAME, SYSDATE FROM DUAL;
SELECT 'LED_DEFN_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_LED_DEFN_TBL WHERE SETID = 'SHARE' AND LEDGER = 'UNU_COMMIT';
SELECT 'LED_DEFN_TBL' AS TABLE_NAME, A.* FROM PS_LED_DEFN_TBL A WHERE SETID = 'SHARE' AND LEDGER = 'UNU_COMMIT' ORDER BY 1, 2;
SELECT 'LED_GRP_LED_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_LED_GRP_LED_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT' AND LEDGER LIKE '%';
SELECT 'LED_GRP_LED_TBL' AS TABLE_NAME, A.* FROM PS_LED_GRP_LED_TBL A WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT' AND LEDGER LIKE '%' ORDER BY 1, 2;
SELECT 'LED_GRP_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_LED_GRP_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT';
SELECT 'LED_GRP_TBL' AS TABLE_NAME, A.* FROM PS_LED_GRP_TBL A WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT' ORDER BY 1, 2;
SELECT 'LED_GRP_FLD_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_LED_GRP_FLD_TBL WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT' AND FIELD_SEQUENCE LIKE '%' AND CHARTFIELD LIKE '%';
SELECT 'LED_GRP_FLD_TBL' AS TABLE_NAME, A.* FROM PS_LED_GRP_FLD_TBL A WHERE SETID = 'SHARE' AND LEDGER_GROUP = 'UNU_COMMIT' AND FIELD_SEQUENCE LIKE '%' AND CHARTFIELD LIKE '%' ORDER BY 1, 2;
--SELECT 'BUS_UNIT_TBL_GL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_BUS_UNIT_TBL_GL WHERE BUSINESS_UNIT = 'UNUNI';
--SELECT 'BUS_UNIT_TBL_GL' AS TABLE_NAME, A.* FROM PS_BUS_UNIT_TBL_GL A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY 1, 2;
SELECT 'BU_LED_GRP_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_BU_LED_GRP_TBL WHERE BUSINESS_UNIT = 'UNUNI' AND LEDGER_GROUP = 'UNU_COMMIT' AND LEDGER LIKE '%';
SELECT 'BU_LED_GRP_TBL' AS TABLE_NAME, A.* FROM PS_BU_LED_GRP_TBL A WHERE BUSINESS_UNIT = 'UNUNI' AND LEDGER_GROUP = 'UNU_COMMIT' AND LEDGER LIKE '%' ORDER BY 1, 2;
--SELECT 'BU_LED_COMB_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_BU_LED_COMB_TBL WHERE BUSINESS_UNIT = 'UNUNI';
--SELECT 'BU_LED_COMB_TBL' AS TABLE_NAME, A.* FROM PS_BU_LED_COMB_TBL A WHERE BUSINESS_UNIT = 'UNUNI' ORDER BY 1, 2;
--SELECT 'BUL_CNTL_BUD' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_BUL_CNTL_BUD WHERE BUSINESS_UNIT = 'UNUNI' AND LEDGER_GROUP = 'UNU_COMMIT' AND KK_LEDGER_GROUP LIKE '%';
--SELECT 'BUL_CNTL_BUD' AS TABLE_NAME, A.* FROM PS_BUL_CNTL_BUD A WHERE BUSINESS_UNIT = 'UNUNI' AND LEDGER_GROUP = 'UNU_COMMIT' AND KK_LEDGER_GROUP LIKE '%' ORDER BY 1, 2;
SELECT 'LED_FLDS_TBL' AS TABLE_NAME, COUNT(1) AS ROW_COUNT FROM PS_LED_FLDS_TBL WHERE SETID = 'SHARE' AND LEDGER = 'UNU_COMMIT' AND FIELD_SEQUENCE LIKE '%';
SELECT 'LED_FLDS_TBL' AS TABLE_NAME, A.* FROM PS_LED_FLDS_TBL A WHERE SETID = 'SHARE' AND LEDGER = 'UNU_COMMIT' AND FIELD_SEQUENCE LIKE '%' ORDER BY 1, 2;