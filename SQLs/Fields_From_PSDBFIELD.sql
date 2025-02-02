--Version 2
--Add Page References
--LISTAGG/XMLAGG
SELECT DBF.FIELDNAME,
       CASE DBF.FIELDTYPE
         WHEN 0 THEN '0 - Char' WHEN 1 THEN '1 - Long Char' WHEN 2 THEN '2 - NBR' WHEN 3 THEN '3 - Sign NBR' WHEN 4 THEN '4 - Date' WHEN 5 THEN '5 - Time' WHEN 6 THEN '6 - Dttm'
         WHEN 7 THEN '7 - Img' WHEN 8 THEN '8 - Img/Attch' WHEN 9 THEN '9 - Img/Ref'
       ELSE 'Unknown' END "DB Field Type", DBF.LENGTH, DBF.OBJECTOWNERID || ' - ' || X1.XLATLONGNAME AS "DBField Object Ident",      
       CASE DBF.FORMAT
         WHEN 0 THEN CASE WHEN DBF.FIELDTYPE = 0 THEN '0 - Char(UpperCase)' WHEN DBF.FIELDTYPE = 6 THEN '6 - HH:MM' END
         WHEN 1 THEN '1 - Name' WHEN 2 THEN '2 - Phone Number North American (mandatory length 12 characters)'
         WHEN 3 THEN '3 - Zip/Postal Code North American (mandatory length 10 characters)' WHEN 4 THEN '4 - US Social Security Number (mandatory length 9 characters)'
         WHEN 5 THEN '5 - BLANK' WHEN 6 THEN '6 - Mixed Case' WHEN 7 THEN '7 - Raw/Binary'  WHEN 8 THEN '8 - Numbers Only' WHEN 9 THEN '9 - SIN (mandatory length 9 characters)'
         WHEN 10 THEN '10 - International Phone Number' WHEN 11 THEN '11 - Zip/Postal Code International' WHEN 12 THEN '12 - Time HH:MM:SS' WHEN 13 THEN '13 - Time HH:MM:SS.999999'
         WHEN 14 THEN '14 - Custom'
       ELSE 'Unknown' END "DB Field Format",
--       LISTAGG(PNLF.PNLNAME, ', ') WITHIN GROUP (ORDER BY PNLF.PNLNAME) AS PNL_LIST
       RTRIM(XMLAGG(XMLELEMENT(E, PNLD.PNLTYPE || '-' || PNLF.PNLNAME || '-' || PNLF.RECNAME || '-' || PNLD.OBJECTOWNERID, ' | ').EXTRACT('//text()') ORDER BY PNLF.PNLNAME).GETCLOBVAL(),',')
       AS "Type-Page-Rec-Owner"
FROM (((PSDBFIELD DBF LEFT OUTER JOIN PSXLATITEM X1 ON X1.FIELDNAME = 'OBJECTOWNERID' AND X1.FIELDVALUE = DBF.OBJECTOWNERID AND X1.EFF_STATUS = 'A')
      LEFT OUTER JOIN PSPNLFIELD PNLF ON PNLF.FIELDNAME = DBF.FIELDNAME AND PNLF.RECNAME <> ' ')
      LEFT OUTER JOIN PSPNLDEFN PNLD ON PNLD.PNLNAME = PNLF.PNLNAME)
WHERE 1 = 1
  AND ((DBF.FIELDNAME LIKE '%EMPL%ID' OR DBF.FIELDNAME LIKE '%EMPL%' OR DBF.FIELDNAME LIKE '%PERSON%' OR DBF.FIELDNAME LIKE '%PERS%' OR DBF.FIELDNAME LIKE '%APPLICANT%'
     OR DBF.FIELDNAME LIKE '%TEAM%MEMBER%' OR DBF.FIELDNAME LIKE '%MEMBER%' OR DBF.FIELDNAME LIKE '%MANAGER%' OR DBF.FIELDNAME LIKE '%APPLID%' OR DBF.FIELDNAME LIKE '%EMP%ID%'
     OR DBF.FIELDNAME LIKE '%CRDMEM%' OR DBF.FIELDNAME LIKE '%APPROVER%' OR DBF.FIELDNAME LIKE '%CSTDN%' OR DBF.FIELDNAME LIKE '%MGR%' OR DBF.FIELDNAME LIKE '%STDNT%'
     OR DBF.FIELDNAME LIKE '%TEAM%MBR%' OR DBF.FIELDNAME LIKE '%TEAM%MBR%' OR DBF.FIELDNAME LIKE '%SUPERVISOR%' OR DBF.FIELDNAME LIKE '%CM_NAME%' OR DBF.FIELDNAME LIKE '%APP_IDNT%'
     OR DBF.FIELDNAME LIKE '%BIDDER%' OR DBF.FIELDNAME LIKE '%BIRTHDATE%' OR DBF.FIELDNAME LIKE '%ATTN_TO%' OR DBF.FIELDNAME LIKE '%MNGR%' OR DBF.FIELDNAME LIKE '%EMP%'
     OR DBF.FIELDNAME LIKE '%CONTACT%' OR DBF.FIELDNAME LIKE '%CORD_ID%')
    AND DBF.FIELDNAME NOT LIKE '%TEMPLATE%' AND DBF.FIELDNAME <> 'AE_APPLID' AND DBF.FIELDNAME <> 'AE_DO_APPLID' AND DBF.FIELDNAME <> 'AE_APPLID2' AND DBF.FIELDNAME <> 'PNLUSETEMP'
    AND DBF.FIELDNAME NOT LIKE '%EXEMPTION%' AND DBF.FIELDNAME NOT LIKE '%EXEMPT%' AND DBF.FIELDNAME NOT LIKE 'TEMP_NBR%' AND DBF.FIELDNAME NOT LIKE 'TEMPNUM%'
    AND DBF.FIELDNAME NOT LIKE 'TEMP_TBL%' AND DBF.FIELDNAME NOT LIKE '%TEMP_TABLE%' AND DBF.FIELDNAME NOT LIKE '%TEMPTABLE%' AND DBF.FIELDNAME NOT LIKE '%TEMPTBL%'
    AND DBF.FIELDNAME NOT LIKE '%TEMP_TBL%' AND DBF.FIELDNAME NOT LIKE '%TEMPDIR%' AND DBF.FIELDNAME NOT LIKE '%EDEMPTI%' AND DBF.FIELDNAME NOT LIKE 'PT%' AND DBF.FIELDNAME NOT LIKE 'PORTAL%'
    AND DBF.FIELDNAME NOT LIKE 'EO%' AND DBF.FIELDNAME NOT LIKE '%URL%' AND DBF.FIELDNAME NOT LIKE 'ITEM%' AND DBF.FIELDNAME NOT LIKE 'RTBL%' AND DBF.FIELDNAME NOT LIKE 'SQL%'
    AND DBF.FIELDNAME NOT LIKE 'BCITEM%' AND DBF.FIELDNAME NOT LIKE 'TEMP_%' AND DBF.FIELDNAME NOT LIKE '%_SETID' AND DBF.FIELDNAME NOT LIKE '%_COMMENT' AND DBF.FIELDNAME NOT LIKE 'CUB_%'
    AND DBF.FIELDNAME NOT LIKE 'FUL_TEMP_LN%' AND DBF.FIELDNAME NOT LIKE 'GVT_TEMP_%' AND DBF.FIELDNAME NOT LIKE 'QS_TEMP%')
  AND DBF.LENGTH > 4
GROUP BY DBF.FIELDNAME, DBF.FIELDTYPE, DBF.LENGTH, DBF.OBJECTOWNERID, X1.XLATLONGNAME, DBF.FORMAT
ORDER BY DBF.FIELDNAME;
