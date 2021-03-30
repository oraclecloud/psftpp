--Vendor Master
--Version 2
SELECT V.VENDOR_ID, V.NAME1, V.VENDOR_CLASS, X1.XLATLONGNAME AS VNDR_CLASS, V.VENDOR_STATUS, X2.XLATLONGNAME AS VNDR_STS, V.DEFAULT_LOC,
       VLC.VNDR_LOC AS VNDR_LOC_LOC, VLC.EFFDT, VLC.EFF_STATUS, VLC.REMIT_LOC, VLC.REMIT_ADDR_SEQ_NUM, VLCC.DESCR AS "Location Scroll Descr",
       VAD.NAME1 AS "Payment Alternate Name", VAD.ADDRESS1, VPAY.PYMNT_METHOD, VPAY.EFT_LAYOUT_CD,
       VPAY.SEQ_NUM, VPAY.BANK_CD, VPAY.BANK_ACCT_KEY, VPAY.CURRENCY_PYMNT, VPAY.CUR_RT_TYPE_PYMNT, VPAY.EFT_PYMNT_FMT_CD, X5.XLATLONGNAME AS EFT_PYMNT_CODE, VPAY.EFT_TRANS_HANDLING, X6.XLATLONGNAME AS EFT_TRANS_CD,
       VPAY.EFT_DOM_COSTS_CD AS "Domestic Costs", X7.XLATLONGNAME AS EFT_DOM_COST_DESCR,
       ACCT.DEFAULT_IND "Def Bank Acct", ACCT.DESCR "Vndr Bank Addr Descr", 
       ACCT.VNDR_LOC AS VNDR_LOC_ACCT, ACCT.BANK_ID_QUAL, ACCT.BNK_ID_NBR, ACCT.BRANCH_ID, ACCT.BANK_ACCT_TYPE, X4.XLATLONGNAME AS BANK_ACCT_TYPE_DESCR, ACCT.BANK_ACCOUNT_NUM,
       ACCT.CHECK_DIGIT, ACCT.DFI_ID_QUAL, ACCT.DFI_ID_NUM, ACCT.BENEFICIARY_BANK, ACCT.BENEF_BRANCH, ACCT.BANK_ACCT_SEQ_NBR, ACCT.COUNTRY, ACCT.STATE, 
       ACCT.POSTAL, ACCT.IBAN_CHECK_DIGIT, ACCT.IBAN_ID,
       VBNK.INTRMED_SEQ_NO, VBNK.INTRMED_ACCT_KEY, VBNK.INTRMED_DFI_ID, VBNK.INTRMED_PYMNT_MSG, VBNK.STL_ROUTING_METHOD, X3.XLATLONGNAME AS ROUTING_METHOD,
       IBAN.COUNTRY AS IBAN_CNTRY, IBCN.DESCR AS CNTRY_DESCR, IBAN.COUNTRY_2CHAR, IBAN.IBAN_ENTERABLE, IBAN.IBAN_BANKID_POS, IBAN.IBAN_BANKID_LEN, IBAN.IBAN_BANKID_PAD, 
       IBAN.IBAN_DFI_ID_POS, IBAN.IBAN_DFI_ID_LEN, IBAN.IBAN_DFI_ID_PAD, IBAN.IBAN_BRANCHID_POS, 
       IBAN.IBAN_BRANCHID_LEN, IBAN.IBAN_BRANCHID_PAD, IBAN.IBAN_ACCOUNT_POS, IBAN.IBAN_ACCOUNT_LEN, IBAN.IBAN_ACCOUNT_PAD, IBAN.IBAN_CHKDIGIT_POS, IBAN.IBAN_CHKDIGIT_LEN,
       V.CREATED_DTTM, V.CREATED_BY_USER, V.LAST_MODIFIED_DATE, V.ENTERED_BY
FROM (((((((((((((PS_VENDOR V 
       LEFT OUTER JOIN PS_VNDR_LOC_SCROL VLCC ON V.SETID = VLCC.SETID AND V.VENDOR_ID = VLCC.VENDOR_ID AND V.DEFAULT_LOC = VLCC.VNDR_LOC)
       LEFT OUTER JOIN PS_VENDOR_LOC VLC ON V.SETID = VLC.SETID AND V.VENDOR_ID = VLC.VENDOR_ID AND VLC.VNDR_LOC = VLCC.VNDR_LOC)       
--       LEFT OUTER JOIN PS_VENDOR_ADDR VAD ON V.SETID = VAD.SETID AND V.VENDOR_ID = VAD.VENDOR_ID AND VAS.ADDRESS_SEQ_NUM = VAD.ADDRESS_SEQ_NUM)
       LEFT OUTER JOIN PS_VENDOR_ADDR VAD ON V.SETID = VAD.SETID AND V.VENDOR_ID = VAD.VENDOR_ID AND VAD.ADDRESS_SEQ_NUM = VLC.REMIT_ADDR_SEQ_NUM)
--       LEFT OUTER JOIN PS_VENDOR_PAY VPAY ON V.SETID = VPAY.SETID AND V.VENDOR_ID = VPAY.VENDOR_ID AND VLCC.VNDR_LOC = VPAY.VNDR_LOC AND VPAY.SEQ_NUM = 1)
       LEFT OUTER JOIN PS_VENDOR_PAY VPAY ON V.SETID = VPAY.SETID AND V.VENDOR_ID = VPAY.VENDOR_ID AND VLC.VNDR_LOC = VPAY.VNDR_LOC AND VLC.EFFDT = VPAY.EFFDT)
       LEFT OUTER JOIN PSXLATITEM X5 ON X5.FIELDNAME = 'EFT_PYMNT_FMT_CD' AND X5.FIELDVALUE = VPAY.EFT_PYMNT_FMT_CD AND X5.EFF_STATUS = 'A')
       LEFT OUTER JOIN PSXLATITEM X6 ON X6.FIELDNAME = 'EFT_TRANS_HANDLING' AND X6.FIELDVALUE = VPAY.EFT_TRANS_HANDLING AND X6.EFF_STATUS = 'A')
       LEFT OUTER JOIN PSXLATITEM X7 ON X7.FIELDNAME = 'EFT_DOM_COSTS_CD' AND X7.FIELDVALUE = VPAY.EFT_DOM_COSTS_CD AND X7.EFF_STATUS = 'A')
       LEFT OUTER JOIN PS_VNDR_BANK_ACCT ACCT ON V.SETID = ACCT.SETID AND V.VENDOR_ID = ACCT.VENDOR_ID AND VLC.VNDR_LOC = ACCT.VNDR_LOC)
       LEFT OUTER JOIN PSXLATITEM X4 ON X4.FIELDNAME = 'BANK_ACCT_TYPE' AND X4.FIELDVALUE = ACCT.BANK_ACCT_TYPE)
       LEFT OUTER JOIN PS_IBAN_FORMAT_TBL IBAN ON ACCT.COUNTRY = IBAN.COUNTRY)
       LEFT OUTER JOIN PS_IBAN_COUNTRY_VW IBCN ON IBAN.COUNTRY = IBCN.COUNTRY)
       LEFT OUTER JOIN PS_VNDR_IBANK_ACCT VBNK ON ACCT.SETID = VBNK.SETID AND ACCT.VENDOR_ID = VBNK.VENDOR_ID AND ACCT.VNDR_LOC = VBNK.VNDR_LOC AND ACCT.EFFDT = VBNK.EFFDT AND ACCT.BANK_ACCT_SEQ_NBR = VBNK.BANK_ACCT_SEQ_NBR)
       LEFT OUTER JOIN PSXLATITEM X3 ON X3.FIELDNAME = 'STL_ROUTING_METHOD' AND X3.FIELDVALUE = VBNK.STL_ROUTING_METHOD)
       ,PSXLATITEM X1, PSXLATITEM X2
WHERE 1 = 1 
  AND (VLC.EFFDT = (SELECT MAX(VLC_ED.EFFDT) FROM PS_VENDOR_LOC VLC_ED WHERE VLC.SETID = VLC_ED.SETID AND VLC.VENDOR_ID = VLC_ED.VENDOR_ID AND VLC.VNDR_LOC = VLC_ED.VNDR_LOC AND VLC_ED.EFFDT <= SYSDATE) 
    OR VLC.EFFDT IS NULL)
  AND (ACCT.EFFDT = (SELECT MAX(ACCT_ED.EFFDT) FROM PS_VNDR_BANK_ACCT ACCT_ED WHERE ACCT.SETID = ACCT_ED.SETID AND ACCT.VENDOR_ID = ACCT_ED.VENDOR_ID AND ACCT.VNDR_LOC = ACCT_ED.VNDR_LOC AND ACCT_ED.EFFDT <= SYSDATE)
    OR ACCT.EFFDT IS NULL)
  AND (VBNK.EFFDT = (SELECT MAX(VBNK_ED.EFFDT) FROM PS_VNDR_IBANK_ACCT VBNK_ED WHERE VBNK.SETID = VBNK_ED.SETID AND VBNK.VENDOR_ID = VBNK_ED.VENDOR_ID AND VBNK.VNDR_LOC = VBNK_ED.VNDR_LOC AND VBNK_ED.EFFDT <= SYSDATE)
    OR VBNK.EFFDT IS NULL)
  AND (VAD.EFFDT = (SELECT MAX(VAD_ED.EFFDT) FROM PS_VENDOR_ADDR VAD_ED WHERE VAD_ED.SETID = VAD.SETID AND VAD_ED.VENDOR_ID = VAD.VENDOR_ID AND VAD_ED.ADDRESS_SEQ_NUM = VAD.ADDRESS_SEQ_NUM AND VAD_ED.EFFDT <= SYSDATE)
    OR VAD.EFFDT IS NULL)
  AND (VPAY.EFFDT = (SELECT MAX(VPAY_ED.EFFDT) FROM PS_VENDOR_PAY VPAY_ED WHERE VPAY_ED.SETID = VPAY.SETID AND VPAY_ED.VENDOR_ID = VPAY.VENDOR_ID AND VPAY_ED.VNDR_LOC = VPAY.VNDR_LOC AND VPAY_ED.SEQ_NUM = VPAY.SEQ_NUM 
                                                                            AND VPAY_ED.EFFDT <= SYSDATE)
    OR VPAY.EFFDT IS NULL)  
  AND X1.FIELDNAME = 'VENDOR_CLASS'
  AND X1.FIELDVALUE = V.VENDOR_CLASS
  AND X1.EFF_STATUS = 'A' 
  AND X2.FIELDNAME = 'VENDOR_STATUS'
  AND X2.FIELDVALUE = V.VENDOR_STATUS
  AND X2.EFF_STATUS = 'A'
  AND V.SETID = 'US001'
  AND VENDOR_STATUS = 'A'
--  AND V.VENDOR_ID = '0000000025'
ORDER BY 1,2;
