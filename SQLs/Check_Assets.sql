-----------------AM
--PS_VCHR_APAM_VW
--SELECT B.BUSINESS_UNIT, B.VOUCHER_ID, B.INVOICE_ID 
--FROM PS_VOUCHER B WHERE B.BUSINESS_UNIT LIKE '6%'
--AND ((B.MATCH_ACTION='N') OR (B.MATCH_ACTION='Y' AND B.MATCH_STATUS_VCHR IN ('M', 'O')) OR (B.MATCH_ACTION = 'Y' AND B.MATCH_STATUS_VCHR = 'T' AND B.CLOSE_STATUS = 'C')) 
--AND EXISTS (SELECT 'X' FROM PS_VCHR_ACCTG_LINE A WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT AND A.VOUCHER_ID = B.VOUCHER_ID AND A.ASSET_FLG = 'Y' AND A.AM_DISTRIB_STATUS IN ('M', 'N'));
--New One
SELECT B.BUSINESS_UNIT, B.VOUCHER_ID, B.INVOICE_ID 
FROM PS_VOUCHER B 
WHERE B.BUSINESS_UNIT LIKE '6%'
   AND ((B.MATCH_ACTION='N') OR (B.MATCH_ACTION='Y' AND B.MATCH_STATUS_VCHR IN ('M', 'O')) OR (B.MATCH_ACTION = 'Y' AND B.MATCH_STATUS_VCHR = 'T' AND B.CLOSE_STATUS = 'C')) 
   AND EXISTS (SELECT 'X' FROM PS_VCHR_ACCTG_LINE A WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT AND A.VOUCHER_ID = B.VOUCHER_ID AND A.ASSET_FLG = 'Y' 
                                                                                           AND A.AM_DISTRIB_STATUS IN ('M', 'N'))
   AND NOT EXISTS (SELECT 'X' FROM PS_RECV_VCHR_MTCH M, PS_RECV_LN_SHIP S WHERE M.BUSINESS_UNIT_AP = B.BUSINESS_UNIT AND M.VOUCHER_ID = B.VOUCHER_ID 
                                                                                                                                   AND S.BUSINESS_UNIT = M.BUSINESS_UNIT AND S.RECEIVER_ID = M.RECEIVER_ID
                                                                                                                                   AND S.RECV_LN_NBR = M.RECV_LN_NBR AND S.RECV_SHIP_SEQ_NBR = M.RECV_SHIP_SEQ_NBR
                                                                                                                                   AND S.MATCH_LINE_FLG = 'Y' AND S.RECV_LN_MATCH_OPT <> 'F');
--Find Assets which will not be depreciated
SELECT 'Assets_which_will_not_be_depreciated', BUSINESS_UNIT, COUNT(1) 
FROM PS_OPEN_TRANS 
WHERE BUSINESS_UNIT = 'UNUNI' AND CALC_DEPR_STATUS = 'H'
GROUP BY BUSINESS_UNIT;
--UNU Asset Profiles
SELECT PR.SETID, PR.PROFILE_ID, PD.BOOK, PD.EFFDT, PR.DESCR, PR.DEFAULT_DESCR, PR.FINANCIAL_ASSET_SW, PR.ASSET_TYPE, X1.XLATLONGNAME AS ASSET_TYPE_DESCR, PD.CATEGORY, PD.DEPR_STATUS, 
       PD.CONVENTION, PD.RETIRE_CONVENTION, PD.METHOD, 
       PD.CALCULATION_TYPE, PD.LIFE, PD.IMPAIR_FLG, PD.DEPR_IN_SERVICE_SW
FROM PS_PROFILE_TBL PR, PS_PROFILE_DET_TBL PD, PSXLATITEM X1
WHERE PR.SETID = PD.SETID
  AND PR.PROFILE_ID = PD.PROFILE_ID
  AND PD.EFFDT = (SELECT MAX(A_ED.EFFDT) FROM PS_PROFILE_DET_TBL A_ED WHERE PD.SETID = A_ED.SETID AND PD.PROFILE_ID = A_ED.PROFILE_ID AND PD.BOOK = A_ED.BOOK AND A_ED.EFFDT <= SYSDATE)
  AND X1.FIELDNAME = 'ASSET_TYPE'
  AND X1.FIELDVALUE = PR.ASSET_TYPE
  AND PR.SETID = 'UNUNI'
ORDER BY 1,2,3;
--Monitor AM Staging Tables
--FIN
SELECT INTFC_STATUS, LOAD_STATUS, COUNT(1) FROM PS_INTFC_FIN WHERE BUSINESS_UNIT = 'UNUNI'
GROUP BY INTFC_STATUS, LOAD_STATUS;
--PHY_A
SELECT INTFC_STATUS, LOAD_STATUS, COUNT(1) FROM PS_INTFC_PHY_A WHERE BUSINESS_UNIT = 'UNUNI'
GROUP BY INTFC_STATUS, LOAD_STATUS;
--PHY_B
SELECT INTFC_STATUS, LOAD_STATUS, COUNT(1) FROM PS_INTFC_PHY_B WHERE BUSINESS_UNIT = 'UNUNI'
GROUP BY INTFC_STATUS, LOAD_STATUS;
--Monitor Pre Interface Table
SELECT * FROM PS_INTFC_PRE_AM WHERE BUSINESS_UNIT_AM = 'UNUNI' ORDER BY DTTM_STAMP DESC;
--Group BY Accounting Date, Load Status and System Source
SELECT ACCOUNTING_DT, LOAD_STATUS, SYSTEM_SOURCE, COUNT(1) 
FROM PS_INTFC_PRE_AM WHERE BUSINESS_UNIT_AM = 'UNUNI'
GROUP BY ACCOUNTING_DT, LOAD_STATUS, SYSTEM_SOURCE 
ORDER BY ACCOUNTING_DT DESC, LOAD_STATUS, SYSTEM_SOURCE;
--Monitor RECV% Jobs (triggered by UNU user(s)) which have not run successfully
SELECT OPRID, PRCSNAME, PRCSJOBNAME, MAINJOBNAME, PRCSINSTANCE, JOBINSTANCE, MAINJOBINSTANCE,
            RUNSTATUS, (SELECT C.XLATLONGNAME FROM PSXLATITEM C WHERE C.FIELDNAME = 'RUNSTATUS' AND C.FIELDVALUE = PSPRCSRQST.RUNSTATUS)  RUNDESCR, 
            TO_CHAR(BEGINDTTM ,'DD-MON HH24:MI:SS') as BeginTm , 
            TO_CHAR(ENDDTTM,'DD-MON HH24:MI:SS') as EndTm , TO_CHAR(TO_DATE('00:00:00','HH24:MI:SS') + (ENDDTTM-BEGINDTTM),'HH24:MI:SS') as Hr_Min
FROM PSPRCSRQST
WHERE (PRCSJOBNAME LIKE '%RECV%' OR MAINJOBNAME LIKE '%RECV%')
     --AND TO_CHAR(rundttm,'YYYY-MM') = TO_CHAR(TRUNC(TRUNC(SYSDATE,'MM')-1,'MM'),'YYYY-MM')
     --AND TO_CHAR(rundttm,'YYYY-MM-DD') = TO_CHAR(TRUNC(TRUNC(SYSDATE, 'DD') -1, 'DD'), 'YYYY-MM-DD')
     AND RUNSTATUS IN (8, 10, 18, 19, 4, 3, 2)
    AND OPRID IN (SELECT DISTINCT B.OPRID FROM PSUSEREMAIL A, PSOPRDEFN B WHERE B.OPRID = PSPRCSRQST.OPRID AND A.OPRID = B.OPRID AND A.EMAILID LIKE '%unu.edu' AND B.ACCTLOCK = 0)
ORDER BY PRCSINSTANCE;
--UNU AM Journals
SELECT DESCR, A.* FROM PS_JRNL_HEADER A WHERE BUSINESS_UNIT = 'UNUNI' AND SOURCE = 'AM' ORDER BY BUSINESS_UNIT, DTTM_STAMP_SEC DESC, FISCAL_YEAR, ACCOUNTING_PERIOD;
--UNU AM Journal Account Details
SELECT DISTINCT HDR.JOURNAL_ID, HDR.DESCR, LN.ACCOUNT 
FROM PS_JRNL_HEADER HDR, PS_JRNL_LN LN 
WHERE LN.BUSINESS_UNIT = HDR.BUSINESS_UNIT
    AND LN.JOURNAL_ID = HDR.JOURNAL_ID
    AND LN.JOURNAL_DATE = HDR.JOURNAL_DATE
    AND LN.UNPOST_SEQ = HDR.UNPOST_SEQ
    AND HDR.BUSINESS_UNIT = 'UNUNI'
    AND HDR.SOURCE = 'AM' 
ORDER BY 1,3;
--UNU_AM_GL_AMT_DIFF_2013
SELECT '2013', A.BUSINESS_UNIT, A.JOURNAL_ID, TO_CHAR(A.JOURNAL_DATE,'YYYY-MM-DD') AS JOURNAL_DATE, A.LEDGER, 
            A.ACCOUNT, A.OPERATING_UNIT, A.DEPTID, A.FUND_CODE, A.CHARTFIELD2, A.PROJECT_ID, A.ACTIVITY_ID,
            A.MONETARY_AMOUNT, A.FOREIGN_AMOUNT, B.AMOUNT 
FROM PS_JRNL_LN A, PS_DIST_LN B 
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT 
    AND A.JOURNAL_ID = B.JOURNAL_ID 
    AND A.JOURNAL_DATE = B.JOURNAL_DATE 
    AND A.JOURNAL_LINE = B.JOURNAL_LINE 
    AND A.LEDGER = B.LEDGER 
    AND A.LEDGER = 'USD' 
    AND A.BUSINESS_UNIT = 'UNUNI' 
    AND B.GL_DISTRIB_STATUS = 'D' 
    AND A.MONETARY_AMOUNT <> B.AMOUNT 
    AND B.ACCOUNTING_DT BETWEEN TO_DATE('2013-01-01','YYYY-MM-DD') AND TO_DATE('2013-12-31','YYYY-MM-DD')
ORDER BY 1,2,3;
--UNU_AM_GL_AMT_DIFF_2014
SELECT '2014', A.BUSINESS_UNIT, A.JOURNAL_ID, TO_CHAR(A.JOURNAL_DATE,'YYYY-MM-DD') AS JOURNAL_DATE, A.LEDGER, 
            A.ACCOUNT, A.OPERATING_UNIT, A.DEPTID, A.FUND_CODE, A.CHARTFIELD2, A.PROJECT_ID, A.ACTIVITY_ID,
            A.MONETARY_AMOUNT, A.FOREIGN_AMOUNT, B.AMOUNT 
FROM PS_JRNL_LN A, PS_DIST_LN B 
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT 
    AND A.JOURNAL_ID = B.JOURNAL_ID 
    AND A.JOURNAL_DATE = B.JOURNAL_DATE 
    AND A.JOURNAL_LINE = B.JOURNAL_LINE 
    AND A.LEDGER = B.LEDGER 
    AND A.LEDGER = 'USD' 
    AND A.BUSINESS_UNIT = 'UNUNI' 
    AND B.GL_DISTRIB_STATUS = 'D' 
    AND A.MONETARY_AMOUNT <> B.AMOUNT 
    AND B.ACCOUNTING_DT BETWEEN TO_DATE('2014-01-01','YYYY-MM-DD') AND TO_DATE('2014-12-31','YYYY-MM-DD')
ORDER BY 1,2,3;
--UNU_AM_GL_AMT_DIFF_2015
SELECT '2015', A.BUSINESS_UNIT, A.JOURNAL_ID, TO_CHAR(A.JOURNAL_DATE,'YYYY-MM-DD') AS JOURNAL_DATE, A.LEDGER, 
            A.ACCOUNT, A.OPERATING_UNIT, A.DEPTID, A.FUND_CODE, A.CHARTFIELD2, A.PROJECT_ID, A.ACTIVITY_ID,
            A.MONETARY_AMOUNT, A.FOREIGN_AMOUNT, B.AMOUNT 
FROM PS_JRNL_LN A, PS_DIST_LN B 
WHERE A.BUSINESS_UNIT = B.BUSINESS_UNIT 
    AND A.JOURNAL_ID = B.JOURNAL_ID 
    AND A.JOURNAL_DATE = B.JOURNAL_DATE 
    AND A.JOURNAL_LINE = B.JOURNAL_LINE 
    AND A.LEDGER = B.LEDGER 
    AND A.LEDGER = 'USD' 
    AND A.BUSINESS_UNIT = 'UNUNI' 
    AND B.GL_DISTRIB_STATUS = 'D' 
    AND A.MONETARY_AMOUNT <> B.AMOUNT 
    AND B.ACCOUNTING_DT BETWEEN TO_DATE('2015-01-01','YYYY-MM-DD') AND TO_DATE('2015-12-31','YYYY-MM-DD')
ORDER BY 1,2,3;
--UNU_AM_NO_BASE_AMT
--Assets with zero base amount
SELECT 'UNU_AM_NO_BASE_AMT', A.BUSINESS_UNIT, A.ASSET_ID, B.PROFILE_ID
FROM PS_ASSET_ACQ_DET A, PS_ASSET B
WHERE A.BUSINESS_UNIT = 'UNUNI'
    AND A.TXN_AMOUNT <> 0
    AND A.AMOUNT = 0
    AND A.BUSINESS_UNIT = B.BUSINESS_UNIT
    AND A.ASSET_ID = B.ASSET_ID
    AND B.ASSET_STATUS = 'I'
    AND A.CAPITALIZATION_SW = '3'
ORDER BY 1, 2;
--UNU_AM_ASSETS_STUCK
--Assets pending processing
SELECT 'UNU_AM_ASSETS_STUCK', A.BUSINESS_UNIT, A.ASSET_ID, TO_CHAR(CAST((A.DTTM_STAMP) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') AS DTTM_STAMP, 
       A.TRANS_DT, A.ACCOUNTING_DT, A.TRANS_TYPE, A.MEM_IN_SERVICE_DT, A.CONVENTION, A.GROUP_ASSET_ID, A.EFFDT, 
	   A.TRANSFER_BU, A.TRANSFER_ASSET_ID, A.TRANSFER_BOOK, A.TRANS_IN_OUT, A.CALC_DEPR_STATUS, A.CALC_DIST_STATUS, 
	   A.OPRID, A.OPEN_TRANS_ID, 
	   TO_CHAR(CAST((A.MIN_DTTM_STAMP) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') AS MIN_DTTM_STAMP, 
       TO_CHAR(CAST((A.MAX_DTTM_STAMP) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') AS MAX_DTTM_STAMP, 
	   A.PROCESS_INSTANCE, A.REQUEST_ID
FROM PS_OPEN_TRANS A
WHERE A.BUSINESS_UNIT = 'UNUNI'     
     AND (A.CALC_DEPR_STATUS <> 'C' OR A.CALC_DIST_STATUS = 'P')
     AND A.ACCOUNTING_DT > TO_DATE('1901-01-01','YYYY-MM-DD')
     AND A.CALC_DIST_STATUS <> ' '
ORDER BY A.BUSINESS_UNIT, A.ASSET_ID, A.DTTM_STAMP DESC;
--UNU_RECEIPTS_NOT_MOVED
--Check to see if Receipts eligible for interfacing to AM have MOVED or not
SELECT 'UNU_RECEIPTS_NOT_MOVED', BUSINESS_UNIT, MOVE_STAT_AM, COUNT(1)
FROM PS_RECV_LN_SHIP 
WHERE BUSINESS_UNIT LIKE '6%'
AND MOVE_STAT_AM <> 'N'
GROUP BY BUSINESS_UNIT, MOVE_STAT_AM
ORDER BY BUSINESS_UNIT, MOVE_STAT_AM;
--Report on Pending Receipts
SELECT 'PENDING_RECEIPTS', A.* FROM PS_RECV_LN_SHIP A WHERE BUSINESS_UNIT LIKE '6%' AND MOVE_STAT_AM = 'P' ORDER BY RECEIPT_DTTM DESC;
--UNU_AM_RCVR_NOT_MOVED
--AM Receipts not interfaced
SELECT 'UNU_AM_RCVR_NOT_MOVED', A.BUSINESS_UNIT, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DISTRIB_SEQ_NUM, A.ACTUAL_COST, A.BUSINESS_UNIT_AM, 
       A.COST, A.CURRENCY_CD, A.DESCR, TO_CHAR(CAST((A.DTTM_STAMP) AS TIMESTAMP),'YYYY-MM-DD-HH24.MI.SS.FF') AS DTTM_STAMP, A.PROFILE_ID, A.QUANTITY, 
       A.SERIAL_ID, A.TAG_NUMBER, C.BUSINESS_UNIT_PO, C.PO_ID, C.LINE_NBR, C.SCHED_NBR, C.CATEGORY_ID, C.DESCR254_MIXED, C.DUE_DT, C.INV_ITEM_ID, 
       C.MERCH_AMT_BSE, C.OPRID, C.QTY_LN_ASSET_SUOM, C.QTY_SH_ACCPT_VUOM, C.QTY_SH_NETRCV_VUOM
FROM PS_RECV_LN_ASSET A, PS_RECV_LN_SHIP C
WHERE A.BUSINESS_UNIT = C.BUSINESS_UNIT
    AND A.RECEIVER_ID = C.RECEIVER_ID
    AND A.RECV_LN_NBR = C.RECV_LN_NBR
    AND A.RECV_SHIP_SEQ_NBR = C.RECV_SHIP_SEQ_NBR
    AND A.BUSINESS_UNIT LIKE '6%'
    AND A.RECV_AM_STATUS = 'O'
    AND C.RECV_SHIP_STATUS = 'R'
    AND C.MOVE_STAT_AM = 'P'
ORDER BY A.BUSINESS_UNIT, A.DTTM_STAMP DESC, A.RECEIVER_ID, A.RECV_LN_NBR, A.RECV_SHIP_SEQ_NBR, A.DISTRIB_LINE_NUM, A.DISTRIB_SEQ_NUM;
--Depreciation Process Log
SELECT HDR.PRCSNAME, HDR.PROCESS_INSTANCE, HDR.ERROR_CNT, LINE.SEQNO, LINE.BUSINESS_UNIT, LINE.ASSET_ID, 
       LINE.BOOK, LINE.DTTM_STAMP, LINE.TRANS_TYPE, LINE.TRANS_IN_OUT, LINE.ACCOUNTING_DT, LINE.CONVENTION, 
	   LINE.MESSAGE_SET_NBR, LINE.MESSAGE_NBR, LINE.PARM_1, LINE.PARM_2, LINE.PARM_3, MSG.MESSAGE_TEXT
FROM PS_AM_ERR_LOG_HDR HDR, (PS_AM_ERR_LOG_LINE LINE
          LEFT OUTER JOIN PSMSGCATDEFN MSG ON MSG.MESSAGE_SET_NBR = LINE.MESSAGE_SET_NBR AND MSG.MESSAGE_NBR = LINE.MESSAGE_NBR) 
WHERE HDR.PRCSNAME = LINE.PRCSNAME
    AND HDR.PROCESS_INSTANCE = LINE.PROCESS_INSTANCE
    AND LINE.BUSINESS_UNIT = 'UNUNI'
ORDER BY HDR.PROCESS_INSTANCE DESC;
--Assets Pending JGEN
SELECT 'PENDING_JGEN', A.* FROM PS_DIST_LN A WHERE BUSINESS_UNIT = 'UNUNI' AND BUSINESS_UNIT_GL = 'UNUNI' AND GL_DISTRIB_STATUS <> 'D'
ORDER BY A.BUSINESS_UNIT, A.ASSET_ID;
--UNU Assets where Receipt Quantity does not equal Quantity Interfaced to AM
SELECT 'QUANTITY_MISMATCH', RLA.*, A.ASSET_ID, A.DESCR
FROM ((((PS_RECV_LN_ASSET RLA LEFT OUTER JOIN PS_INTFC_PRE_AM PRE ON RLA.PRE_INTFC_ID = PRE.PRE_INTFC_ID AND RLA.PRE_INTFC_LINE_NUM = PRE.PRE_INTFC_LINE_NUM)
          LEFT OUTER JOIN PS_INTFC_FIN FIN ON PRE.INTFC_ID = FIN.INTFC_ID AND PRE.INTFC_LINE_NUM = FIN.INTFC_LINE_NUM)
          LEFT OUTER JOIN PS_INTFC_PHY_A PHYA ON PRE.INTFC_ID = PHYA.INTFC_ID AND PRE.INTFC_LINE_NUM = PHYA.INTFC_LINE_NUM)
          LEFT OUTER JOIN PS_ASSET A ON A.BUSINESS_UNIT = PHYA.BUSINESS_UNIT AND A.ASSET_ID = PHYA.ASSET_ID) 
WHERE (RLA.BUSINESS_UNIT_AM = 'UNUNI')
     AND RLA.QTY_MOVED_ASSET <>  RLA.QUANTITY 
     AND RLA.RECV_AM_STATUS = 'M'
     AND RLA.RECV_AM_STATUS <> 'X'
ORDER BY 1,2,3;
--UNU Cancelled Receipts
SELECT 'CANCELLED_RECEIPTS_FOR_AM', RLA.* FROM PS_RECV_LN_ASSET RLA
WHERE BUSINESS_UNIT_AM = 'UNUNI'
     AND QTY_MOVED_ASSET = 0
     AND RECV_AM_STATUS = 'X'
ORDER BY 1,2,3;
