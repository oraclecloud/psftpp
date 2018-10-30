--Original UNU GL Fund Status Query - 2015
SELECT 'UNU_GL_FUND_STATUS', A.FISCAL_YEAR "Year", A.BUSINESS_UNIT "GL Bus Unit", A.OPERATING_UNIT "Oper Unit", C.DESCR "Oper Unit Description", 
       DECODE( A.DEPTID,' ',' ','B0' || SUBSTR( A.DEPTID, 1, 3)) "Budget DeptId", A.DEPTID "Detail DeptId", E.DESCR "DeptId Description", A.PROJECT_ID "Project", F.DESCR "Project Description", 
       A.FUND_CODE "Fund", D.DESCR "Fund Description", A.CHARTFIELD2 "Donor", G.DESCR "Donor Description", 
       DECODE(B.ACCOUNT_TYPE,'Q',DECODE(A.ACCOUNTING_PERIOD,0,'A - Opening Balance','B - Fund Balance Adjustment'),'R',DECODE(A.ACCOUNT,'51035','D - Income Transfers/Adjustments','C - Income'),'E','E - Expenditure', '') "Type", 
       A.ACCOUNT "Account", B.DESCR "Account Description", SUM(A.POSTED_BASE_AMT) "Amount (USD)"
FROM PS_LEDGER A, PS_GL_ACCOUNT_TBL B, PS_SET_CNTRL_REC B2, PS_OPER_UNIT_TBL C, PS_FUND_TBL D, PS_DEPT_TBL E, PS_PROJECT_ID_VW F, PS_CHARTFIELD2_TBL G
WHERE (B.ACCOUNT = A.ACCOUNT
   AND B2.SETCNTRLVALUE = A.BUSINESS_UNIT
   AND B2.RECNAME = 'GL_ACCOUNT_TBL'
   AND B2.SETID = B.SETID
   AND (A.BUSINESS_UNIT = 'UNUNI'
    AND A.LEDGER = 'USD'
    AND A.BUSINESS_UNIT = 'UNUNI'
    --AND A.OPERATING_UNIT LIKE :2
    --AND A.DEPTID LIKE '%11201%'
    --AND A.FUND_CODE LIKE :4
    --AND A.CHARTFIELD2 LIKE :5
    --AND A.PROJECT_ID LIKE :6
    AND A.FISCAL_YEAR = '2015'
    AND A.ACCOUNTING_PERIOD >= 0
    AND A.ACCOUNTING_PERIOD <= 999
    AND B.SETID = 'SHARE'
    AND B.EFFDT = (SELECT MAX(B_ED.EFFDT) FROM PS_GL_ACCOUNT_TBL B_ED WHERE B.SETID = B_ED.SETID AND B.ACCOUNT = B_ED.ACCOUNT AND B_ED.EFFDT <= SYSDATE)
    AND B.ACCOUNT = A.ACCOUNT
    AND B.ACCOUNT_TYPE IN ('R','E','Q')
    AND C.SETID = 'SHARE'
    AND C.OPERATING_UNIT = A.OPERATING_UNIT
    AND C.EFFDT = (SELECT MAX(C_ED.EFFDT) FROM PS_OPER_UNIT_TBL C_ED WHERE C.SETID = C_ED.SETID AND C.OPERATING_UNIT = C_ED.OPERATING_UNIT AND C_ED.EFFDT <= SYSDATE)
    AND D.SETID = 'UNUNI'
    AND D.FUND_CODE = A.FUND_CODE
    AND D.EFFDT = (SELECT MAX(D_ED.EFFDT) FROM PS_FUND_TBL D_ED WHERE D.SETID = D_ED.SETID AND D.FUND_CODE = D_ED.FUND_CODE AND D_ED.EFFDT <= SYSDATE)
    AND 'UNUNI' =  E.SETID (+)
    AND A.DEPTID =  E.DEPTID (+)
    AND (E.EFFDT IS NULL
     OR (E.EFFDT = (SELECT MAX(E_ED.EFFDT) FROM PS_DEPT_TBL E_ED WHERE E.SETID = E_ED.SETID AND E.DEPTID = E_ED.DEPTID AND E_ED.EFFDT <= SYSDATE)))
    AND A.PROJECT_ID =  F.PROJECT_ID (+)
    AND 'UNUNI' =  G.SETID (+)
    AND A.CHARTFIELD2 =  G.CHARTFIELD2 (+)
    AND (G.EFFDT IS NULL
     OR (G.EFFDT = (SELECT MAX(G_ED.EFFDT) FROM PS_CHARTFIELD2_TBL G_ED WHERE G.SETID = G_ED.SETID AND G.CHARTFIELD2 = G_ED.CHARTFIELD2 AND G_ED.EFFDT <= SYSDATE)))))
GROUP BY A.FISCAL_YEAR, A.BUSINESS_UNIT, A.OPERATING_UNIT, C.DESCR, DECODE(A.DEPTID,' ',' ','B0' || SUBSTR( A.DEPTID, 1, 3)), A.DEPTID, E.DESCR, A.PROJECT_ID, F.DESCR, A.FUND_CODE, D.DESCR, A.CHARTFIELD2, G.DESCR, 
         DECODE(B.ACCOUNT_TYPE,'Q',DECODE(A.ACCOUNTING_PERIOD,0, 'A - Opening Balance','B - Fund Balance Adjustment'), 'R', DECODE(A.ACCOUNT,'51035','D - Income Transfers/Adjustments','C - Income'), 'E', 'E - Expenditure', ''), 
         A.ACCOUNT,  B.DESCR
ORDER BY A.FISCAL_YEAR, A.BUSINESS_UNIT, A.OPERATING_UNIT, DECODE( A.DEPTID,' ',' ','B0' || SUBSTR( A.DEPTID, 1, 3)), A.DEPTID, A.PROJECT_ID, A.FUND_CODE, A.CHARTFIELD2,
         DECODE(B.ACCOUNT_TYPE,'Q',DECODE(A.ACCOUNTING_PERIOD,0,'A - Opening Balance','B - Fund Balance Adjustment'),'R',DECODE(A.ACCOUNT,'51035','D - Income Transfers/Adjustments','C - Income'),'E','E - Expenditure', ''),
         A.ACCOUNT;
--Actuals for Expense & Revenue ACCOUNTS ONLY from Ledger for all UNU Departments
--Included all CF's
--2015
SELECT X.FISCAL_YEAR, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, (SUBSTR(X1.ACCOUNT,1,LENGTH(X1.ACCOUNT)-2) || '00') AS ACCOUNT, X.PROJECT_ID, X.CHARTFIELD2, X1.DESCR, SUM(X.POSTED_BASE_AMT) AS TOTAL,
            SUM(X.PERIOD_0) PERIOD_0, SUM(X.JAN) JAN, SUM(X.FEB) FEB, SUM(X.MAR) MAR, SUM(X.APR) APR, SUM(X.MAY) MAY, SUM(X.JUN) JUN, 
            SUM(X.JUL) JUL, SUM(X.AUG) AUG, SUM(X.SEP) SEP, SUM(X.OCT) OCT, SUM(X.NOV) NOV, SUM(X.DEC) DEC
FROM (
SELECT ST.FISCAL_YEAR, ST.OPERATING_UNIT, ST.FUND_CODE, ST.DEPTID, ST.ACCOUNT, ST.PROJECT_ID, ST.CHARTFIELD2, ET.DESCR, SUM(ST.POSTED_BASE_AMT) AS POSTED_BASE_AMT,
   CASE ST.ACCOUNTING_PERIOD WHEN 0 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS PERIOD_0 
 , CASE ST.ACCOUNTING_PERIOD WHEN 1 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS JAN
 , CASE ST.ACCOUNTING_PERIOD WHEN 2 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS FEB 
 , CASE ST.ACCOUNTING_PERIOD WHEN 3 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS MAR 
 , CASE ST.ACCOUNTING_PERIOD WHEN 4 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS APR 
 , CASE ST.ACCOUNTING_PERIOD WHEN 5 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS MAY 
 , CASE ST.ACCOUNTING_PERIOD WHEN 6 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS JUN 
 , CASE ST.ACCOUNTING_PERIOD WHEN 7 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS JUL 
 , CASE ST.ACCOUNTING_PERIOD WHEN 8 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS AUG 
 , CASE ST.ACCOUNTING_PERIOD WHEN 9 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS SEP 
 , CASE ST.ACCOUNTING_PERIOD WHEN 10 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS OCT 
 , CASE ST.ACCOUNTING_PERIOD WHEN 11 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS NOV 
 , CASE ST.ACCOUNTING_PERIOD WHEN 12 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS DEC 
FROM PS_LEDGER ST, PS_GL_ACCOUNT_TBL ET
WHERE ET.SETID = 'SHARE'
    AND ET.ACCOUNT = ST.ACCOUNT
    AND ET.EFFDT = (SELECT MAX(CJ.EFFDT) FROM PS_GL_ACCOUNT_TBL CJ WHERE CJ.SETID = ET.SETID AND CJ.ACCOUNT = ET.ACCOUNT AND CJ.EFFDT <= sysdate) 
    AND ST.BUSINESS_UNIT = 'UNUNI'
    AND ST.LEDGER = 'USD'
    AND (ST.ACCOUNTING_PERIOD BETWEEN 1 AND 12)
    AND ST.FISCAL_YEAR = '2015'
    --AND ST.STATISTICS_CODE = ' '
    --AND ST.CURRENCY_CD = 'USD'
    AND ET.ACCOUNT_TYPE IN ('E', 'R')     
    --AND ST.DEPTID IN (SELECT D.DEPTID FROM PS_DEPT_TBL D WHERE SETID = 'UNUNI' AND EFF_STATUS = 'A' AND EFFDT = (SELECT MAX(C_ED.EFFDT) FROM PS_DEPT_TBL C_ED WHERE D.SETID = C_ED.SETID AND D.DEPTID = C_ED.DEPTID AND C_ED.EFFDT <= sysdate))
    --AND ST.DEPTID = '11901'
GROUP BY ST.FISCAL_YEAR, ST.OPERATING_UNIT, ST.FUND_CODE, ST.DEPTID, ST.ACCOUNT, ST.PROJECT_ID, ST.CHARTFIELD2, ET.DESCR, ST.ACCOUNTING_PERIOD) X, PS_GL_ACCOUNT_TBL X1
WHERE X1.SETID = 'SHARE'
    AND X1.ACCOUNT = (SUBSTR(X.ACCOUNT,1,LENGTH(X.ACCOUNT)-2) || '00')  
GROUP BY X.FISCAL_YEAR, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, X1.ACCOUNT, X.PROJECT_ID, X.CHARTFIELD2, X1.DESCR
ORDER BY X.FISCAL_YEAR, X.OPERATING_UNIT, X.FUND_CODE, X.DEPTID, X1.ACCOUNT, X.PROJECT_ID, X.CHARTFIELD2;
--UNU New TB
--Latest Version
--2015
SELECT X.FISCAL_YEAR, X.ACCOUNT, X.DESCR, SUM(X.PERIOD_0) AS "Opening Balance", SUM(X.DEBIT) AS "Debits", SUM(X.CREDIT) AS "Credits",
            SUM(X.PERIOD_YTD) AS "Movement", SUM(X.POSTED_BASE_AMT) AS "Closing Balance"           
FROM (SELECT ST.FISCAL_YEAR, ST.ACCOUNT, ET.DESCR, SUM(ST.POSTED_BASE_AMT) AS POSTED_BASE_AMT,
     CASE WHEN ST.ACCOUNTING_PERIOD = 0 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS PERIOD_0
   , CASE WHEN ST.ACCOUNTING_PERIOD > 0 THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS PERIOD_YTD
   , CASE WHEN (SUM(ST.POSTED_BASE_AMT) > 0.00 AND ST.ACCOUNTING_PERIOD > 0) THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS DEBIT
   , CASE WHEN (SUM(ST.POSTED_BASE_AMT) < 0.00 AND ST.ACCOUNTING_PERIOD > 0) THEN SUM(ST.POSTED_BASE_AMT) ELSE 0 END AS CREDIT
FROM  PS_LEDGER ST, PS_GL_ACCOUNT_TBL ET
WHERE ET.SETID = 'SHARE'
    AND ET.ACCOUNT = ST.ACCOUNT
    AND ET.EFFDT = (SELECT MAX(CJ.EFFDT) FROM PS_GL_ACCOUNT_TBL CJ WHERE CJ.SETID = ET.SETID AND CJ.ACCOUNT = ET.ACCOUNT AND CJ.EFFDT <= sysdate)
    AND ST.BUSINESS_UNIT = 'UNUNI'
    AND ST.LEDGER = 'USD'    
    AND ST.FISCAL_YEAR = '2015'
    --AND ((ST.ACCOUNTING_PERIOD BETWEEN 1 and 12 AND ET.ACCOUNT_TYPE IN ('E', 'R')) OR (ST.ACCOUNTING_PERIOD BETWEEN 0 and 12 AND ET.ACCOUNT_TYPE NOT IN ('E', 'R')))        
    AND ((ST.ACCOUNTING_PERIOD BETWEEN 1 and 12 AND ET.ACCOUNT_TYPE IN ('E', 'R')) OR (ST.ACCOUNTING_PERIOD BETWEEN 0 and 12 AND ET.ACCOUNT_TYPE NOT IN ('E', 'R'))
             OR ST.ACCOUNTING_PERIOD IN ('100', '998'))
	AND ST.STATISTICS_CODE = ' '
    --AND (ST.ACCOUNTING_PERIOD BETWEEN 0 AND 12)
    --AND ET.ACCOUNT_TYPE NOT IN ('E', 'R')    
GROUP BY ST.FISCAL_YEAR, ST.ACCOUNT, ET.DESCR, ST.ACCOUNTING_PERIOD) X
GROUP BY X.FISCAL_YEAR, X.ACCOUNT, X.DESCR
ORDER BY X.FISCAL_YEAR, X.ACCOUNT, X.DESCR;
