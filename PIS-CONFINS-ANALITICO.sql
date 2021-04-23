/*DROP VIEW AD_VW_APU_ANA_PISCOFINS;

/* Formatted on 15/04/2021 08:26:22 (QP5 v5.362) */
CREATE OR REPLACE FORCE VIEW AD_VW_APU_ANA_PISCOFINS
(
    TIPO,
    NOMECFOP,
    NOMECST,
    VLRTOTITEM,
    BASEPIS,
    VLRPIS,
    BASECOFINS,
    VLRCOFINS,
    ENTSAI,
    NUNOTA,
    CODPROD,
    DESCRPROD,
    NCM,
    CODTIPOPER,
    DESCROPER,
    DTFILTRO,
    CODEMP
)
BEQUEATH DEFINER
AS

    SELECT TIPO,
             NOMECFOP,
             NOMECST,
             VLRTOTITEM,
             BASEPIS,
             VLRPIS,
             BASECOFINS,
             VLRCOFINS,
             ENTSAI,
             NUMNOTA,
             NUNOTA,
             CODPROD,
             DESCRPROD,
             NCM,
             CODTIPOPER,
             (SELECT DESCROPER
                FROM TGFTOP TPO
               WHERE     CODTIPOPER = RESUMOAGRUPADO.CODTIPOPER
                     AND DHALTER = (SELECT MAX (DHALTER)
                                      FROM TGFTOP
                                     WHERE CODTIPOPER = TPO.CODTIPOPER))
                 AS DESCROPER,
             DTFILTRO,
             CODEMP
        FROM (  SELECT 'DADOS'              AS TIPO,
                       ENTSAI,
                       NOMECFOP,
                       NOMECST,
                       SUM (VLRTOTITEM)     AS VLRTOTITEM,
                       SUM (BASEPIS)        AS BASEPIS,
                       SUM (VLRPIS)         AS VLRPIS,
                       SUM (BASECOFINS)     AS BASECOFINS,
                       SUM (VLRCOFINS)      AS VLRCOFINS,
                       NUMNOTA,
                       NUNOTA,
                       CODPROD,
                       DESCRPROD,
                       NCM,
                       CODTIPOPER,
                       DTFILTRO,
                       CODEMP
                  FROM (SELECT (SELECT OPCAO
                                  FROM TDDOPC
                                 WHERE     NUCAMPO =
                                           (SELECT NUCAMPO
                                              FROM TDDCAM
                                             WHERE     NOMETAB = 'TGFIFE'
                                                   AND NOMECAMPO = 'CST')
                                       AND VALOR = NOTASCUPONSDIN.CST)
                                   AS NOMECST,
                               (SELECT    CAST (CODCFO AS VARCHAR (20))
                                       || ' - '
                                       || DESCRCFO
                                  FROM TGFCFO
                                 WHERE CODCFO = NOTASCUPONSDIN.CODCFO)
                                   AS NOMECFOP,
                               CASE
                                   WHEN NOTASCUPONSDIN.CODIMP = 6
                                   THEN
                                       NOTASCUPONSDIN.VLRTOT
                                   ELSE
                                       0
                               END
                                   AS VLRTOTITEM,
                               CASE
                                   WHEN NOTASCUPONSDIN.CODIMP = 6
                                   THEN
                                       NOTASCUPONSDIN.BASERED
                                   ELSE
                                       0
                               END
                                   AS BASEPIS,
                               CASE
                                   WHEN NOTASCUPONSDIN.CODIMP = 6
                                   THEN
                                       NOTASCUPONSDIN.VALOR
                                   ELSE
                                       0
                               END
                                   AS VLRPIS,
                               CASE
                                   WHEN NOTASCUPONSDIN.CODIMP = 7
                                   THEN
                                       NOTASCUPONSDIN.BASERED
                                   ELSE
                                       0
                               END
                                   AS BASECOFINS,
                               CASE
                                   WHEN NOTASCUPONSDIN.CODIMP = 7
                                   THEN
                                       NOTASCUPONSDIN.VALOR
                                   ELSE
                                       0
                               END
                                   AS VLRCOFINS,
                               ENTSAI,
                               NOTASCUPONSDIN.NUMNOTA,
                               NOTASCUPONSDIN.NUNOTA,
                               NOTASCUPONSDIN.CODPROD,
                               NOTASCUPONSDIN.DESCRPROD,
                               NOTASCUPONSDIN.NCM,
                               NOTASCUPONSDIN.CODTIPOPER,
                               NOTASCUPONSDIN.DTFILTRO,
                               NOTASCUPONSDIN.CODEMP

                         -----------
 FROM (SELECT DISTINCT *
                                  FROM (                           --C481/C485
                                        SELECT *
                                          FROM (SELECT DISTINCT
                                                       LIV.ENTSAI,
                                                       ITE.SEQUENCIA * 1.0
                                                           AS SEQUENCIA,
                                                       CAB.NUNOTA * 1.0
                                                           AS NUNOTA,
                                                       (  (  (CASE
                                                                  WHEN DIN.CODINC =
                                                                       0
                                                                  THEN
                                                                      ITE.VLRTOT
                                                                  ELSE
                                                                      0
                                                              END)
                                                           - (CASE
                                                                  WHEN DIN.CODINC =
                                                                       0
                                                                  THEN
                                                                      ITE.VLRDESC
                                                                  ELSE
                                                                      0
                                                              END))
                                                        - (  CAB.VLRDESCTOT
                                                           / (CASE
                                                                  WHEN   CAB.VLRDESCTOT
                                                                       + CAB.VLRNOTA =
                                                                       0
                                                                  THEN
                                                                      1
                                                                  ELSE
                                                                        CAB.VLRDESCTOT
                                                                      + CAB.VLRNOTA
                                                              END)))
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM TGFCAB CAB,
                                                       TGFITE ITE,
                                                       TGFPAR PAR,
                                                       TGFPRO PRO,
                                                       TGFTOP TPO,
                                                       TGFLIV LIV,
                                                       TGFECF ECF,
                                                       TGFMAQ MAQ,
                                                       TGFDIN DIN
                                                 WHERE /*CAB.CODEMP = :P_CODEMP
                                                   AND*/
                                                           CAB.STATUSNOTA = 'L'
                                                       AND ITE.NUNOTA =
                                                           CAB.NUNOTA
                                                       AND ITE.SEQUENCIA > 0
                                                       AND ITE.VLRTOT >= 0
                                                       AND ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       AND (   (NOT EXISTS
                                                                    (SELECT 1
                                                                       FROM TGFITE
                                                                            I2
                                                                      WHERE     I2.NUNOTA =
                                                                                ITE.NUNOTA
                                                                            AND I2.USOPROD =
                                                                                'D'))
                                                            OR (    (   (    NVL (
                                                                                 TPO.TIPOIMPKIT,
                                                                                 'P') =
                                                                             'P'
                                                                         AND (SELECT CASE
                                                                                         WHEN P.INTEIRO =
                                                                                              2
                                                                                         THEN
                                                                                             0
                                                                                         ELSE
                                                                                             P.INTEIRO
                                                                                     END    AS IMPITENSNFE
                                                                                FROM TSIPAR
                                                                                     P
                                                                               WHERE P.CHAVE =
                                                                                     'IMPITENSNFE') =
                                                                             0)
                                                                     OR (NVL (
                                                                             TPO.TIPOIMPKIT,
                                                                             'P') =
                                                                         'K'))
                                                                AND ITE.USOPROD <>
                                                                    'D')
                                                            OR (    (   (    NVL (
                                                                                 TPO.TIPOIMPKIT,
                                                                                 'P') =
                                                                             'P'
                                                                         AND (SELECT CASE
                                                                                         WHEN P.INTEIRO =
                                                                                              2
                                                                                         THEN
                                                                                             0
                                                                                         ELSE
                                                                                             P.INTEIRO
                                                                                     END    AS IMPITENSNFE
                                                                                FROM TSIPAR
                                                                                     P
                                                                               WHERE P.CHAVE =
                                                                                     'IMPITENSNFE') =
                                                                             1)
                                                                     OR (NVL (
                                                                             TPO.TIPOIMPKIT,
                                                                             'P') =
                                                                         'C'))
                                                                AND NOT EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFVAR
                                                                                VAR
                                                                          WHERE     VAR.NUNOTA =
                                                                                    ITE.NUNOTA
                                                                                AND VAR.NUNOTAORIG =
                                                                                    ITE.NUNOTA
                                                                                AND VAR.SEQUENCIAORIG =
                                                                                    ITE.SEQUENCIA))) /* CUPOM não pode imprimir Kit e Componentes juntos */
                                                       AND PAR.CODPARC =
                                                           CAB.CODPARC
                                                       AND PRO.CODPROD =
                                                           ITE.CODPROD
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       AND (   TPO.CUPOMFISCAL =
                                                               'S'
                                                            OR CAB.SERIENOTA =
                                                               'CF') /* pegando só cupom porque nota de acompanhamento também está na redução Z */
                                                       AND ECF.CODMAQ =
                                                           CAB.CODMAQ
                                                       AND ECF.CONTZ =
                                                           CAB.NROREDZ
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN
                                                       AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND LIV.CODEMP = :P_CODEMP*/
                                                       AND LIV.ORIGEM = 'Z'
                                                       AND ECF.NUECF = LIV.NUNOTA
                                                       AND ECF.CODEMP =
                                                           LIV.CODEMP
                                                       AND MAQ.CODMAQ =
                                                           ECF.CODMAQ
                                                       AND MAQ.MODDOC = '2D')
                                               CUPONS
                                         WHERE 'S' = 'S'
                                        UNION
                                        SELECT *
                                          FROM ( --A170 representação de itens de nota de serviço filtrada através do A100 que é a nota de serviço
                                                SELECT LIS.ENTSAI,
                                                       LIS.SEQUENCIA,
                                                       LIS.NUMNOTA,
                                                       LIS.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC = 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIS.DTMOV
                                                           AS DTFILTRO,
                                                       LIS.CODEMP
                                                  FROM TGFLIS LIS,
                                                       TGFITE ITE,
                                                       TGFDIN DIN,
                                                       TGFCAB CAB,
                                                       TGFTOP TPO
                                                 WHERE     EXISTS
                                                               ((SELECT DISTINCT
                                                                        LIS1.NUNOTA
                                                                   FROM TGFLIS
                                                                        LIS1
                                                                  WHERE /*LIS.DTMOV >=
                                                                           :P_PERIODOINI
                                                                    AND LIS1.DTMOV <=
                                                                           :P_PERIODOFIN
                                                                    AND LIS1.CODEMP =
                                                                           :P_CODEMP
                                                                    AND*/
                                                                            LIS1.ORIGEM <>
                                                                            'F'
                                                                        AND (   (    LIS1.ORIGEM =
                                                                                     'E'
                                                                                 AND LIS1.ENTSAI =
                                                                                     'E'
                                                                                 AND EXISTS
                                                                                         (SELECT 1
                                                                                            FROM TGFDIN
                                                                                                 D1
                                                                                           WHERE     D1.NUNOTA =
                                                                                                     LIS1.NUNOTA
                                                                                                 AND D1.CODIMP IN
                                                                                                         (6,
                                                                                                          7)
                                                                                                 AND ((    (   D1.VALOR <>
                                                                                                               0
                                                                                                            OR NVL (
                                                                                                                   D1.VLRCRED,
                                                                                                                   0) <>
                                                                                                               0)
                                                                                                       AND D1.CST IN
                                                                                                               (50,
                                                                                                                51,
                                                                                                                52,
                                                                                                                53,
                                                                                                                54,
                                                                                                                55,
                                                                                                                56,
                                                                                                                60,
                                                                                                                61,
                                                                                                                62,
                                                                                                                63,
                                                                                                                64,
                                                                                                                65,
                                                                                                                66)) /*CSTSEMCREDEFDCT OR D1.CST IN (70,71,72,73,74,75) CSTSEMCREDEFDCT*/
                                                                                                                    )))
                                                                             OR (    LIS1.ORIGEM =
                                                                                     'E'
                                                                                 AND LIS1.ENTSAI =
                                                                                     'S'
                                                                                 AND EXISTS
                                                                                         (SELECT 1
                                                                                            FROM TGFDIN
                                                                                           WHERE     NUNOTA =
                                                                                                     LIS1.NUNOTA
                                                                                                 AND CODIMP IN
                                                                                                         (6,
                                                                                                          7))))
                                                                        AND NOT EXISTS
                                                                                (SELECT LIV.NUNOTA
                                                                                   FROM TGFLIV
                                                                                        LIV
                                                                                  WHERE     LIV.NUNOTA =
                                                                                            LIS1.NUNOTA
                                                                                        AND LIV.ORIGEM =
                                                                                            LIS1.ORIGEM)
                                                                        AND LIS1.NUNOTA =
                                                                            LIS.NUNOTA))
                                                       AND ITE.NUNOTA =
                                                           LIS.NUNOTA
                                                       --AND LIS.CODEMP = :P_CODEMP
                                                       AND ITE.SEQUENCIA =
                                                           LIS.SEQUENCIA
                                                       AND LIS.ORIGEM = 'E'
                                                       AND LIS.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND LIS.NUNOTA =
                                                           CAB.NUNOTA
                                                       AND CAB.NUNOTA =
                                                           ITE.NUNOTA
                                                       AND CAB.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND LIS.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                UNION
                                                --C170 (itens) é encontrado através do C100 que é o resultado das notas
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC = 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM TGFLIV LIV,
                                                       TGFITE ITE,
                                                       TGFDIN DIN,
                                                       TGFCAB CAB,
                                                       TGFTOP TPO,
                                                       TGFPRO PRO
                                                       LEFT JOIN TGFIPI IPI
                                                           ON PRO.CODIPI =
                                                              IPI.CODIPI
                                                 WHERE     EXISTS
                                                               (SELECT 1
                                                                  FROM (SELECT DISTINCT
                                                                               LIV.ENTSAI,
                                                                                LIV.NUMNOTA,
                                                                               LIV.NUNOTA,
                                                                               LIV.ORIGEM,
                                                                               LIV.CODEMP,
                                                                               CAB.CODTIPOPER,
                                                                               NVL (
                                                                                   CASE
                                                                                       WHEN LIV.ORIGEM IN
                                                                                                ('E',
                                                                                                 'A')
                                                                                       THEN
                                                                                           CAB.STATUSNFE
                                                                                       ELSE
                                                                                           (SELECT CAB2.STATUSNFE
                                                                                              FROM TGFCAB
                                                                                                   CAB2
                                                                                             WHERE     CAB2.NUNOTA =
                                                                                                       ABS (
                                                                                                           LIV.NUNOTA)
                                                                                                   AND CAB2.STATUSNFE =
                                                                                                       'D')
                                                                                   END,
                                                                                   'N')
                                                                                   AS STATUSNFE
                                                                          FROM TGFLIV
                                                                               LIV
                                                                               LEFT JOIN
                                                                               TGFCAB
                                                                               CAB
                                                                                   ON     LIV.ORIGEM IN
                                                                                              ('E',
                                                                                               'A')
                                                                                      AND LIV.NUNOTA =
                                                                                          CAB.NUNOTA
                                                                               LEFT JOIN
                                                                               TGFTPV
                                                                               TPV
                                                                                   ON     CAB.CODTIPVENDA =
                                                                                          TPV.CODTIPVENDA
                                                                                      AND CAB.DHTIPVENDA =
                                                                                          TPV.DHALTER
                                                                               LEFT JOIN
                                                                               TGFTOP
                                                                               TPO
                                                                                   ON     CAB.CODTIPOPER =
                                                                                          TPO.CODTIPOPER
                                                                                      AND CAB.DHTIPOPER =
                                                                                          TPO.DHALTER,
                                                                               TGFRGM
                                                                               RGM
                                                                         WHERE /*LIV.CODEMP =
                                                                                  :P_CODEMP
                                                                           AND*/
                                                                                   RGM.CODEMP =
                                                                                   LIV.CODEMP
                                                                               AND (LIV.DHMOV BETWEEN RGM.DTINIREGIME
                                                                                                  AND NVL (
                                                                                                          RGM.DTFIMREGIME,
                                                                                                          SYSDATE))
                                                                               /*AND LIV.DHMOV BETWEEN :P_PERIODOINI
                                                                                                 AND :P_PERIODOFIN*/
                                                                               AND LIV.CODMODDOC IN
                                                                                       (1,
                                                                                        4,
                                                                                        55,
                                                                                        65,
                                                                                        901)
                                                                               AND /* PREOCUPAR COM C100,C190 */
                                                                                   (       LIV.ORIGEM =
                                                                                           'E'
                                                                                       AND LIV.ENTSAI =
                                                                                           'E'
                                                                                       AND CAB.TIPMOV <>
                                                                                           'D'
                                                                                       AND EXISTS
                                                                                               (SELECT 1
                                                                                                  FROM TGFDIN
                                                                                                       D1
                                                                                                 WHERE     D1.NUNOTA =
                                                                                                           LIV.NUNOTA
                                                                                                       AND D1.SEQUENCIA =
                                                                                                           LIV.SEQUENCIA
                                                                                                       AND D1.CODIMP IN
                                                                                                               (6,
                                                                                                                7)
                                                                                                       AND (   (    (   D1.VALOR <>
                                                                                                                        0
                                                                                                                     OR NVL (
                                                                                                                            D1.VLRCRED,
                                                                                                                            0) <>
                                                                                                                        0)
                                                                                                                AND D1.CST IN
                                                                                                                        (50,
                                                                                                                         51,
                                                                                                                         52,
                                                                                                                         53,
                                                                                                                         54,
                                                                                                                         55,
                                                                                                                         56,
                                                                                                                         60,
                                                                                                                         61,
                                                                                                                         62,
                                                                                                                         63,
                                                                                                                         64,
                                                                                                                         65,
                                                                                                                         66))
                                                                                                            OR (    (SELECT T.LOGICO    AS LOGICO
                                                                                                                       FROM TSIPAR
                                                                                                                            T
                                                                                                                      WHERE T.CHAVE =
                                                                                                                            'CSTSEMCREDEFDCT') =
                                                                                                                    'S'
                                                                                                                AND D1.CST IN
                                                                                                                        (70,
                                                                                                                         71,
                                                                                                                         72,
                                                                                                                         73,
                                                                                                                         74,
                                                                                                                         75))))
                                                                                    OR (    LIV.ORIGEM =
                                                                                            'E'
                                                                                        AND LIV.ENTSAI =
                                                                                            'E'
                                                                                        AND CAB.TIPMOV =
                                                                                            'D'
                                                                                        AND LIV.CODCFO IN
                                                                                                (1201,
                                                                                                 1202,
                                                                                                 1203,
                                                                                                 1204,
                                                                                                 1410,
                                                                                                 1411,
                                                                                                 1660,
                                                                                                 1661,
                                                                                                 1662,
                                                                                                 2201,
                                                                                                 2202,
                                                                                                 2203,
                                                                                                 2204,
                                                                                                 2410,
                                                                                                 2411,
                                                                                                 2660,
                                                                                                 2661,
                                                                                                 2662,
                                                                                                 3201,
                                                                                                 3202,
                                                                                                 3211,
                                                                                                 3503,
                                                                                                 3553)
                                                                                        AND EXISTS
                                                                                                (SELECT 1
                                                                                                   FROM TGFDIN
                                                                                                        D1
                                                                                                  WHERE     D1.NUNOTA =
                                                                                                            LIV.NUNOTA
                                                                                                        AND D1.SEQUENCIA =
                                                                                                            LIV.SEQUENCIA
                                                                                                        AND D1.CODIMP IN
                                                                                                                (6,
                                                                                                                 7)
                                                                                                        AND (   (    (   D1.VALOR <>
                                                                                                                         0
                                                                                                                      OR NVL (
                                                                                                                             D1.VLRCRED,
                                                                                                                             0) <>
                                                                                                                         0)
                                                                                                                 AND (   (    RGM.CODINCTRIB IN
                                                                                                                                  (1,
                                                                                                                                   3)
                                                                                                                          AND D1.CST IN
                                                                                                                                  (50,
                                                                                                                                   51,
                                                                                                                                   52,
                                                                                                                                   53,
                                                                                                                                   54,
                                                                                                                                   55,
                                                                                                                                   56,
                                                                                                                                   60,
                                                                                                                                   61,
                                                                                                                                   62,
                                                                                                                                   63,
                                                                                                                                   64,
                                                                                                                                   65,
                                                                                                                                   66))
                                                                                                                      OR (    RGM.CODINCTRIB IN
                                                                                                                                  (2,
                                                                                                                                   3)
                                                                                                                          AND D1.CST IN
                                                                                                                                  (98,
                                                                                                                                   99))))
                                                                                                             OR (    (SELECT T.LOGICO    AS LOGICO
                                                                                                                        FROM TSIPAR
                                                                                                                             T
                                                                                                                       WHERE T.CHAVE =
                                                                                                                             'CSTSEMCREDEFDCT') =
                                                                                                                     'S'
                                                                                                                 AND RGM.CODINCTRIB IN
                                                                                                                         (1,
                                                                                                                          3)
                                                                                                                 AND D1.CST IN
                                                                                                                         (70,
                                                                                                                          71,
                                                                                                                          72,
                                                                                                                          73,
                                                                                                                          74,
                                                                                                                          75)))))
                                                                                    OR /* PREOCUPAR COM C100,C180,C190 */
                                                                                       (    LIV.ORIGEM =
                                                                                            'E'
                                                                                        AND LIV.ENTSAI =
                                                                                            'S'
                                                                                        AND CAB.TIPMOV <>
                                                                                            'E'
                                                                                        AND EXISTS
                                                                                                (SELECT 1
                                                                                                   FROM TGFDIN
                                                                                                        D2
                                                                                                  WHERE     D2.NUNOTA =
                                                                                                            LIV.NUNOTA
                                                                                                        AND D2.SEQUENCIA =
                                                                                                            LIV.SEQUENCIA
                                                                                                        AND D2.CODIMP IN
                                                                                                                (6,
                                                                                                                 7)
                                                                                                        AND (   D2.CST <>
                                                                                                                49
                                                                                                             OR LIV.CODCFO =
                                                                                                                5927)))
                                                                                    OR (    LIV.ORIGEM =
                                                                                            'E'
                                                                                        AND LIV.ENTSAI =
                                                                                            'S'
                                                                                        AND CAB.TIPMOV =
                                                                                            'E'
                                                                                        AND LIV.CODCFO IN
                                                                                                (5201,
                                                                                                 5202,
                                                                                                 5205,
                                                                                                 5206,
                                                                                                 5207,
                                                                                                 5210,
                                                                                                 5410,
                                                                                                 5411,
                                                                                                 5660,
                                                                                                 5661,
                                                                                                 5662,
                                                                                                 6201,
                                                                                                 6202,
                                                                                                 6205,
                                                                                                 6206,
                                                                                                 6207,
                                                                                                 6210,
                                                                                                 6410,
                                                                                                 6411,
                                                                                                 6660,
                                                                                                 6661,
                                                                                                 6662,
                                                                                                 7201,
                                                                                                 7202,
                                                                                                 7205,
                                                                                                 7206,
                                                                                                 7207,
                                                                                                 7210,
                                                                                                 7211)
                                                                                        AND EXISTS
                                                                                                (SELECT 1
                                                                                                   FROM TGFDIN
                                                                                                        D2
                                                                                                  WHERE     D2.NUNOTA =
                                                                                                            LIV.NUNOTA
                                                                                                        AND D2.SEQUENCIA =
                                                                                                            LIV.SEQUENCIA
                                                                                                        AND D2.CODIMP IN
                                                                                                                (6,
                                                                                                                 7)
                                                                                                        AND D2.CST =
                                                                                                            49))
                                                                                    OR (    LIV.ORIGEM =
                                                                                            'A'
                                                                                        AND EXISTS
                                                                                                (SELECT 1
                                                                                                   FROM TGFDIN
                                                                                                        D3
                                                                                                  WHERE     D3.NUNOTA =
                                                                                                            LIV.NUNOTA
                                                                                                        AND D3.SEQUENCIA =
                                                                                                            LIV.SEQUENCIA
                                                                                                        AND D3.CODIMP IN
                                                                                                                (6,
                                                                                                                 7)
                                                                                                        AND D3.CST <>
                                                                                                            49
                                                                                                        AND (   LIV.ENTSAI =
                                                                                                                'S'
                                                                                                             OR D3.VALOR <>
                                                                                                                0
                                                                                                             OR NVL (
                                                                                                                    D3.VLRCRED,
                                                                                                                    0) <>
                                                                                                                0)))
                                                                                    OR (LIV.ORIGEM =
                                                                                        'C')))
                                                                       C100
                                                                 WHERE     (   C100.STATUSNFE <>
                                                                               'D'
                                                                            OR C100.ORIGEM <>
                                                                               'C'
                                                                            OR C100.CODTIPOPER <>
                                                                               NVL (
                                                                                   NVL (
                                                                                       (SELECT EMP.CODTIPOPERACOMP
                                                                                          FROM TGFEMP
                                                                                               EMP
                                                                                         WHERE EMP.CODEMP =
                                                                                               C100.CODEMP),
                                                                                       (SELECT INTEIRO
                                                                                          FROM TSIPAR
                                                                                         WHERE CHAVE =
                                                                                               'TOPIMPFISCAL')),
                                                                                   -1))
                                                                       AND C100.NUNOTA =
                                                                           LIV.NUNOTA)
                                                       AND ITE.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       --AND LIV.CODEMP = :P_CODEMP
                                                       AND ITE.SEQUENCIA =
                                                           LIV.SEQUENCIA
                                                       AND LIV.ORIGEM IN
                                                               ('E', 'A')
                                                       AND ITE.CODPROD =
                                                           PRO.CODPROD
                                                       AND ITE.USOPROD <> 'S'
                                                       /* AND LIV.DHMOV >=
                                                               :P_PERIODOINI
                                                        AND LIV.DHMOV <=
                                                               :P_PERIODOFIN*/
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND CAB.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND CAB.NUNOTA =
                                                           ITE.NUNOTA
                                                       AND CAB.NUNOTA =
                                                           DIN.NUNOTA
                                                UNION
                                                --C191/C195
                                                SELECT DISTINCT
                                                       LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                        LIV.NUMNOTA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC =
                                                                 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM TGFLIV LIV,
                                                       TGFCAB CAB,
                                                       TGFTOP TPO,
                                                       TGFPAR PAR,
                                                       TGFRGM RGM,
                                                       TGFITE ITE,
                                                       TGFDIN DIN
                                                 WHERE /*LIV.CODEMP = :P_CODEMP
                                                   AND */
                                                           RGM.CODEMP =
                                                           LIV.CODEMP
                                                       AND (LIV.DHMOV BETWEEN RGM.DTINIREGIME
                                                                          AND NVL (
                                                                                  RGM.DTFIMREGIME,
                                                                                  SYSDATE))
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN*/
                                                       AND ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       AND ITE.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           LIV.SEQUENCIA
                                                       AND LIV.CODMODDOC IN
                                                               (55, 65)
                                                       AND LIV.NUNOTA =
                                                           CAB.NUNOTA
                                                       AND CAB.TIPMOV IN ('D',
                                                                          'E',
                                                                          'C',
                                                                          'O')
                                                       AND ( /* PREOCUPAR COM C100,C190 */
                                                               (    LIV.ORIGEM =
                                                                    'E'
                                                                AND LIV.ENTSAI =
                                                                    'E'
                                                                AND CAB.TIPMOV <>
                                                                    'D'
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D1
                                                                          WHERE     D1.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D1.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D1.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND ((    (   D1.VALOR <>
                                                                                              0
                                                                                           OR NVL (
                                                                                                  D1.VLRCRED,
                                                                                                  0) <>
                                                                                              0)
                                                                                      AND D1.CST IN
                                                                                              (50,
                                                                                               51,
                                                                                               52,
                                                                                               53,
                                                                                               54,
                                                                                               55,
                                                                                               56,
                                                                                               60,
                                                                                               61,
                                                                                               62,
                                                                                               63,
                                                                                               64,
                                                                                               65,
                                                                                               66)) /*CSTSEMCREDEFDCT OR D1.CST IN (70,71,72,73,74,75) CSTSEMCREDEFDCT*/
                                                                                                   )))
                                                            OR (    LIV.ORIGEM =
                                                                    'E'
                                                                AND LIV.ENTSAI =
                                                                    'E'
                                                                AND CAB.TIPMOV =
                                                                    'D'
                                                                AND LIV.CODCFO IN
                                                                        (1201,
                                                                         1202,
                                                                         1203,
                                                                         1204,
                                                                         1410,
                                                                         1411,
                                                                         1660,
                                                                         1661,
                                                                         1662,
                                                                         2201,
                                                                         2202,
                                                                         2203,
                                                                         2204,
                                                                         2410,
                                                                         2411,
                                                                         2660,
                                                                         2661,
                                                                         2662,
                                                                         3201,
                                                                         3202,
                                                                         3211,
                                                                         3503,
                                                                         3553)
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D1
                                                                          WHERE     D1.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D1.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D1.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND ((    (   D1.VALOR <>
                                                                                              0
                                                                                           OR NVL (
                                                                                                  D1.VLRCRED,
                                                                                                  0) <>
                                                                                              0)
                                                                                      AND (   (    RGM.CODINCTRIB IN
                                                                                                       (1,
                                                                                                        3)
                                                                                               AND D1.CST IN
                                                                                                       (50,
                                                                                                        51,
                                                                                                        52,
                                                                                                        53,
                                                                                                        54,
                                                                                                        55,
                                                                                                        56,
                                                                                                        60,
                                                                                                        61,
                                                                                                        62,
                                                                                                        63,
                                                                                                        64,
                                                                                                        65,
                                                                                                        66))
                                                                                           OR (    RGM.CODINCTRIB IN
                                                                                                       (2,
                                                                                                        3)
                                                                                               AND D1.CST IN
                                                                                                       (98,
                                                                                                        99)))) /*CSTSEMCREDEFDCT OR (RGM.CODINCTRIB IN (1,3) AND D1.CST IN (70,71,72,73,74,75)) CSTSEMCREDEFDCT*/
                                                                                                              )))
                                                            OR /* PREOCUPAR COM C100,C180,C190 */
                                                               (    LIV.ORIGEM =
                                                                    'E'
                                                                AND LIV.ENTSAI =
                                                                    'S'
                                                                AND CAB.TIPMOV <>
                                                                    'E'
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D2
                                                                          WHERE     D2.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D2.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D2.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND (   D2.CST <>
                                                                                        49
                                                                                     OR LIV.CODCFO =
                                                                                        5927)))
                                                            OR (    LIV.ORIGEM =
                                                                    'E'
                                                                AND LIV.ENTSAI =
                                                                    'S'
                                                                AND CAB.TIPMOV =
                                                                    'E'
                                                                AND LIV.CODCFO IN
                                                                        (5201,
                                                                         5202,
                                                                         5205,
                                                                         5206,
                                                                         5207,
                                                                         5210,
                                                                         5410,
                                                                         5411,
                                                                         5660,
                                                                         5661,
                                                                         5662,
                                                                         6201,
                                                                         6202,
                                                                         6205,
                                                                         6206,
                                                                         6207,
                                                                         6210,
                                                                         6410,
                                                                         6411,
                                                                         6660,
                                                                         6661,
                                                                         6662,
                                                                         7201,
                                                                         7202,
                                                                         7205,
                                                                         7206,
                                                                         7207,
                                                                         7210,
                                                                         7211)
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D2
                                                                          WHERE     D2.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D2.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D2.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND D2.CST =
                                                                                    49))
                                                            OR (    LIV.ORIGEM =
                                                                    'A'
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D3
                                                                          WHERE     D3.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D3.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D3.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND D3.CST <>
                                                                                    49
                                                                                AND (   LIV.ENTSAI =
                                                                                        'S'
                                                                                     OR D3.VALOR <>
                                                                                        0
                                                                                     OR NVL (
                                                                                            D3.VLRCRED,
                                                                                            0) <>
                                                                                        0))))
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND CAB.CODPARC =
                                                           PAR.CODPARC
                                                UNION
                                                --C381/C385
                                                SELECT DISTINCT
                                                       LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUMNOTA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC =
                                                                 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM TGFLIV LIV
                                                       LEFT JOIN TGFCAB CAB
                                                           ON     LIV.ORIGEM =
                                                                  'E'
                                                              AND LIV.NUNOTA =
                                                                  CAB.NUNOTA
                                                       LEFT JOIN TGFTOP TPO
                                                           ON     CAB.CODTIPOPER =
                                                                  TPO.CODTIPOPER
                                                              AND CAB.DHTIPOPER =
                                                                  TPO.DHALTER,
                                                       TGFITE ITE,
                                                       TGFDIN DIN
                                                 WHERE /*LIV.DHMOV >=
                                                          :P_PERIODOINI
                                                   AND LIV.DHMOV <=
                                                          :P_PERIODOFIN
                                                   AND LIV.CODEMP = :P_CODEMP
                                                   AND*/
                                                           ITE.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           LIV.SEQUENCIA
                                                       AND ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       AND LIV.CODMODDOC = 2
                                                       AND LIV.ORIGEM <> 'D'
                                                       AND LIV.ORIGEM <> 'Z'
                                                       AND LIV.ORIGEM <> 'C'
                                                       AND LIV.ENTSAI = 'S'
                                                --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                --ORDER BY LIV.NUMNOTA, LIV.CODPARC;
                                                UNION
                                                --C395/C396
                                                SELECT DISTINCT
                                                       /*'C395/C396' AS REG
                                                       ,*/
                                                       LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUMNOTA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC =
                                                                 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       NVL (CAB.DTENTSAI,
                                                            CAB.DTNEG)
                                                           AS DTFILTRO,
                                                       CAB.CODEMP
                                                  FROM TGFCAB CAB,
                                                       TGFTOP TPO,
                                                       TGFITE ITE,
                                                       TGFLIV LIV,
                                                       TGFDIN DIN
                                                 WHERE     ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       /*AND NVL (CAB.DTENTSAI,
                                                                CAB.DTNEG) BETWEEN :P_PERIODOINI
                                                                               AND :P_PERIODOFIN
                                                       AND CAB.CODEMP = :P_CODEMP*/
                                                       AND CASE
                                                               WHEN     CAB.CODMODDOCNOTA
                                                                            IS NOT NULL
                                                                    AND CAB.CODMODDOCNOTA <>
                                                                        0
                                                               THEN
                                                                   CAB.CODMODDOCNOTA
                                                               ELSE
                                                                   TPO.CODMODDOC
                                                           END IN
                                                               (2 /*Consumidor Final*/
                                                                 ,
                                                                59    /*CF-e*/
                                                                  ,
                                                                903 /*2D CUPOM FISCAL*/
                                                                   ,
                                                                904 /*2E Bilhete de Passagem*/
                                                                   )
                                                       AND CAB.NUNOTA =
                                                           ITE.NUNOTA
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND CAB.TIPMOV = 'C'
                                                       AND LIV.NUNOTA =
                                                           ITE.NUNOTA
                                                       AND LIV.SEQUENCIA =
                                                           ITE.SEQUENCIA
                                                       AND EXISTS
                                                               (SELECT 1
                                                                  FROM TGFDIN D1
                                                                 WHERE     D1.NUNOTA =
                                                                           CAB.NUNOTA
                                                                       AND D1.CODIMP IN
                                                                               (6,
                                                                                7)
                                                                       AND D1.SEQUENCIA =
                                                                           ITE.SEQUENCIA
                                                                       AND ((    (   D1.VALOR <>
                                                                                     0
                                                                                  OR NVL (
                                                                                         D1.VLRCRED,
                                                                                         0) <>
                                                                                     0)
                                                                             AND D1.CST IN
                                                                                     (50,
                                                                                      51,
                                                                                      52,
                                                                                      53,
                                                                                      54,
                                                                                      55,
                                                                                      56,
                                                                                      60,
                                                                                      61,
                                                                                      62,
                                                                                      63,
                                                                                      64,
                                                                                      65,
                                                                                      66,
                                                                                      67)) /*CSTSEMCREDEFDCT OR D1.CST IN (70,71,72,73,74,75) CSTSEMCREDEFDCT*/
                                                                                          ))
                                                UNION
                                                --C501/505
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       CAB.NUMNOTA,
                                                       CAB.VLRNOTA
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM TGFLIV LIV
                                                       LEFT JOIN TGFCAB CAB
                                                           ON     LIV.ORIGEM IN
                                                                      ('E', 'A')
                                                              AND LIV.NUNOTA =
                                                                  CAB.NUNOTA
                                                       LEFT JOIN TGFTOP TPO
                                                           ON     CAB.CODTIPOPER =
                                                                  TPO.CODTIPOPER
                                                              AND CAB.DHTIPOPER =
                                                                  TPO.DHALTER
                                                       INNER JOIN TGFITE ITE
                                                           ON     ITE.NUNOTA =
                                                                  LIV.NUNOTA
                                                              AND ITE.SEQUENCIA =
                                                                  LIV.SEQUENCIA
                                                       INNER JOIN TGFDIN DIN
                                                           ON     ITE.NUNOTA =
                                                                  DIN.NUNOTA
                                                              AND ITE.SEQUENCIA =
                                                                  DIN.SEQUENCIA
                                                              AND DIN.CODIMP IN
                                                                      (6, 7)
                                                 WHERE /*LIV.DHMOV >=
                                                          :P_PERIODOINI
                                                   AND LIV.DHMOV <=
                                                          :P_PERIODOFIN
                                                   AND LIV.CODEMP = :P_CODEMP
                                                   AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                   AND*/
                                                           LIV.CODMODDOC IN
                                                               (6, 28, 29)
                                                       AND LIV.ORIGEM <> 'D'
                                                       AND LIV.ORIGEM <> 'F'
                                                       AND EXISTS
                                                               (SELECT 1
                                                                  FROM TGFDIN D1
                                                                 WHERE     D1.NUNOTA =
                                                                           LIV.NUNOTA
                                                                       AND D1.SEQUENCIA =
                                                                           LIV.SEQUENCIA
                                                                       AND D1.CODIMP IN
                                                                               (6,
                                                                                7)
                                                                       AND ((    (   D1.VALOR <>
                                                                                     0
                                                                                  OR NVL (
                                                                                         D1.VLRCRED,
                                                                                         0) <>
                                                                                     0)
                                                                             AND D1.CST IN
                                                                                     (50,
                                                                                      51,
                                                                                      52,
                                                                                      53,
                                                                                      54,
                                                                                      55,
                                                                                      56,
                                                                                      60,
                                                                                      61,
                                                                                      62,
                                                                                      63,
                                                                                      64,
                                                                                      65,
                                                                                      66)) /*CSTSEMCREDEFDCT OR D1.CST IN (70,71,72,73,74,75) CSTSEMCREDEFDCT*/
                                                                                          ))
                                                UNION
                                                --D101/D105
                                                --NOTAS
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC = 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               CODPROD)
                                                           AS NCM,
                                                       TPOCAB.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM (SELECT ENTSAI,
                                                               EMPPARC,
                                                               CODEMP,
                                                               CODPARC,
                                                               CODMODDOC,
                                                               ORIGEM,
                                                               SERIENOTA,
                                                               NUMNOTA,
                                                               NUNOTA,
                                                               DHMOV,
                                                               CODCFO,
                                                               CHAVENFE,
                                                               CHAVECTE,
                                                               CHAVECTEREF,
                                                               VLRCTB,
                                                               VLRIPI,
                                                               VLRICMS,
                                                               BASEICMS,
                                                               DTDOC,
                                                               DTENTSAIINFO,
                                                               UFORIGEM,
                                                               UFDESTINO,
                                                               SEQUENCIA
                                                          FROM TGFLIV) LIV
                                                       INNER JOIN
                                                       (SELECT CODTIPOPER,
                                                               NUMNOTA,
                                                               TIPFRETE,
                                                               TIPIPIEMB,
                                                               VLRNOTA,
                                                               VLRDESCTOT,
                                                               VLRDESCTOTITEM,
                                                               VLRMERCADORIA,
                                                               VLRFRETE,
                                                               VLRSEG,
                                                               BASESUBSTIT,
                                                               VLRSUBST,
                                                               VLRDESTAQUE,
                                                               IPIEMB,
                                                               VLREMB,
                                                               VLRJURO,
                                                               CODOBSPADRAO,
                                                               VLRIRF,
                                                               BASEINSS,
                                                               VLRINSS,
                                                               CODPARCTRANSP,
                                                               PESO,
                                                               PESOBRUTO,
                                                               ORDEMCARGA,
                                                               CODVEICULO,
                                                               UFVEICULO,
                                                               ANTT,
                                                               PLACA,
                                                               QTDVOL,
                                                               CODPARCREMETENTE,
                                                               CODPARCDEST,
                                                               CODPARCCONSIGNATARIO,
                                                               CODPARCREDESPACHO,
                                                               CHAVENFE,
                                                               STATUSNFE,
                                                               VLRPIS,
                                                               VLRCOFINS,
                                                               TIPMOV,
                                                               VLRLIQITEMNFE,
                                                               NUNOTA,
                                                               DHTIPOPER,
                                                               STATUSCTE
                                                          FROM TGFCAB) CAB
                                                           ON     LIV.NUNOTA =
                                                                  CAB.NUNOTA
                                                              AND LIV.ORIGEM IN
                                                                      ('E', 'A')
                                                       INNER JOIN
                                                       (SELECT BASENUMERACAO,
                                                               TIPOIMPKIT,
                                                               NATBCCRED,
                                                               INDNATFRT,
                                                               ATUALLIVFIS,
                                                               COMPLEMENTO,
                                                               CODTIPOPER,
                                                               DHALTER,
                                                               NFE,
                                                               TIPOCTE
                                                          FROM TGFTOP) TPOCAB
                                                           ON     LIV.ORIGEM IN
                                                                      ('E', 'A')
                                                              AND CAB.CODTIPOPER =
                                                                  TPOCAB.CODTIPOPER
                                                              AND CAB.DHTIPOPER =
                                                                  TPOCAB.DHALTER
                                                       INNER JOIN TGFITE ITE
                                                           ON     ITE.NUNOTA =
                                                                  LIV.NUNOTA
                                                              AND ITE.SEQUENCIA =
                                                                  LIV.SEQUENCIA,
                                                       TSIEMP EMP,
                                                       TGFDIN DIN
                                                 WHERE     ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       AND LIV.CODEMP =
                                                           EMP.CODEMP
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN
                                                       AND LIV.CODEMP = :P_CODEMP
                                                       AND (TPOCAB.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))*/
                                                       AND LIV.ENTSAI = 'E'
                                                       AND LIV.CODMODDOC IN (7,
                                                                             8,
                                                                             9,
                                                                             10,
                                                                             11,
                                                                             26,
                                                                             27,
                                                                             57,
                                                                             902)
                                                       AND LIV.ORIGEM <> 'D'
                                                       AND (   (    LIV.ORIGEM IN
                                                                        ('E', 'A')
                                                                AND LIV.ENTSAI =
                                                                    'E'
                                                                AND CAB.TIPMOV <>
                                                                    'D'
                                                                AND EXISTS
                                                                        (SELECT 1
                                                                           FROM TGFDIN
                                                                                D1
                                                                          WHERE     D1.NUNOTA =
                                                                                    LIV.NUNOTA
                                                                                AND D1.SEQUENCIA =
                                                                                    LIV.SEQUENCIA
                                                                                AND D1.CODIMP IN
                                                                                        (6,
                                                                                         7)
                                                                                AND (   D1.VALOR <>
                                                                                        0
                                                                                     OR NVL (
                                                                                            D1.VLRCRED,
                                                                                            0) <>
                                                                                        0)
                                                                                AND D1.CST IN
                                                                                        (50,
                                                                                         51,
                                                                                         52,
                                                                                         53,
                                                                                         54,
                                                                                         55,
                                                                                         56,
                                                                                         60,
                                                                                         61,
                                                                                         62,
                                                                                         63,
                                                                                         64,
                                                                                         65,
                                                                                         66)))
                                                            OR (LIV.ORIGEM = 'C'))
                                                UNION
                                                --D101/D105
                                                --FINANCEIROS PIS
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       LIV.VLRCTB
                                                           AS VLRTOT,
                                                       6
                                                           AS CODIMP     --PIS
                                                                    ,
                                                       LIV.VLRCTB
                                                           AS BASERED,
                                                         LIV.VLRCTB
                                                       * NAT.ALIQPIS
                                                       / 100
                                                           AS VALOR,
                                                       NAT.CSTPIS
                                                           AS CST,
                                                       LIV.CODCFO,
                                                       NULL
                                                           AS CODPROD,
                                                       'MOV. FINANCEIRA'
                                                           AS DESCRPROD,
                                                       'MOV. FINANCEIRA'
                                                           AS NCM,
                                                       TPOFIN.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM (SELECT ENTSAI,
                                                               EMPPARC,
                                                               CODEMP,
                                                               CODPARC,
                                                               CODMODDOC,
                                                               ORIGEM,
                                                               SERIENOTA,
                                                               NUMNOTA,
                                                               NUNOTA,
                                                               DHMOV,
                                                               CODCFO,
                                                               CHAVENFE,
                                                               CHAVECTE,
                                                               CHAVECTEREF,
                                                               VLRCTB,
                                                               VLRIPI,
                                                               VLRICMS,
                                                               BASEICMS,
                                                               DTDOC,
                                                               DTENTSAIINFO,
                                                               UFORIGEM,
                                                               UFDESTINO,
                                                               SEQUENCIA
                                                          FROM TGFLIV) LIV
                                                       INNER JOIN
                                                       (SELECT NUFIN,
                                                               CODTIPOPER,
                                                               DHTIPOPER,
                                                               CODNAT
                                                          FROM TGFFIN) FIN
                                                           ON     LIV.NUNOTA =
                                                                  FIN.NUFIN
                                                              AND LIV.ORIGEM =
                                                                  'F'
                                                       INNER JOIN
                                                       (SELECT BASENUMERACAO,
                                                               TIPOIMPKIT,
                                                               NATBCCRED,
                                                               INDNATFRT,
                                                               ATUALLIVFIS,
                                                               COMPLEMENTO,
                                                               CODTIPOPER,
                                                               DHALTER,
                                                               TEMPIS,
                                                               TEMCOFINS,
                                                               NFE,
                                                               USAALIQNATRATF100
                                                          FROM TGFTOP) TPOFIN
                                                           ON     LIV.ORIGEM =
                                                                  'F'
                                                              AND FIN.CODTIPOPER =
                                                                  TPOFIN.CODTIPOPER
                                                              AND FIN.DHTIPOPER =
                                                                  TPOFIN.DHALTER
                                                       INNER JOIN TGFNAT NAT
                                                           ON NAT.CODNAT =
                                                              FIN.CODNAT,
                                                       TSIEMP EMP
                                                 WHERE     LIV.CODEMP =
                                                           EMP.CODEMP
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN
                                                       AND LIV.CODEMP = :P_CODEMP
                                                       AND (TPOFIN.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))*/
                                                       AND LIV.ENTSAI = 'E'
                                                       AND LIV.CODMODDOC IN (7,
                                                                             8,
                                                                             9,
                                                                             10,
                                                                             11,
                                                                             26,
                                                                             27,
                                                                             57,
                                                                             902)
                                                       AND LIV.ORIGEM = 'F'
                                                       AND TPOFIN.TEMPIS = 'S'
                                                       AND TPOFIN.TEMCOFINS = 'S'
                                                       AND (   NAT.CSTPIS > 0
                                                            OR NAT.CSTCOFINS > 0
                                                            OR TPOFIN.USAALIQNATRATF100 =
                                                               'S')
                                                UNION
                                                --D101/D105
                                                --FINANCEIROS COFINS
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       LIV.NUMNOTA,
                                                       LIV.VLRCTB
                                                           AS VLRTOT,
                                                       7
                                                           AS CODIMP  --COFINS
                                                                    ,
                                                       LIV.VLRCTB
                                                           AS BASERED,
                                                         LIV.VLRCTB
                                                       * NAT.ALIQCOFINS
                                                       / 100
                                                           AS VALOR,
                                                       NAT.CSTCOFINS
                                                           AS CST,
                                                       LIV.CODCFO,
                                                       NULL
                                                           AS CODPROD,
                                                       'MOV. FINANCEIRA'
                                                           AS DESCRPROD,
                                                       'MOV. FINANCEIRA'
                                                           AS NCM,
                                                       TPOFIN.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM (SELECT ENTSAI,
                                                               EMPPARC,
                                                               CODEMP,
                                                               CODPARC,
                                                               CODMODDOC,
                                                               ORIGEM,
                                                               SERIENOTA,
                                                               NUMNOTA,
                                                               NUNOTA,
                                                               DHMOV,
                                                               CODCFO,
                                                               CHAVENFE,
                                                               CHAVECTE,
                                                               CHAVECTEREF,
                                                               VLRCTB,
                                                               VLRIPI,
                                                               VLRICMS,
                                                               BASEICMS,
                                                               DTDOC,
                                                               DTENTSAIINFO,
                                                               UFORIGEM,
                                                               UFDESTINO,
                                                               SEQUENCIA
                                                          FROM TGFLIV) LIV
                                                       INNER JOIN
                                                       (SELECT NUFIN,
                                                               CODTIPOPER,
                                                               NUMNOTA,
                                                               DHTIPOPER,
                                                               CODNAT
                                                          FROM TGFFIN) FIN
                                                           ON     LIV.NUNOTA =
                                                                  FIN.NUFIN
                                                              AND LIV.ORIGEM =
                                                                  'F'
                                                       INNER JOIN
                                                       (SELECT BASENUMERACAO,
                                                               TIPOIMPKIT,
                                                               NATBCCRED,
                                                               INDNATFRT,
                                                               ATUALLIVFIS,
                                                               COMPLEMENTO,
                                                               CODTIPOPER,
                                                               DHALTER,
                                                               TEMPIS,
                                                               TEMCOFINS,
                                                               NFE,
                                                               USAALIQNATRATF100
                                                          FROM TGFTOP) TPOFIN
                                                           ON     LIV.ORIGEM =
                                                                  'F'
                                                              AND FIN.CODTIPOPER =
                                                                  TPOFIN.CODTIPOPER
                                                              AND FIN.DHTIPOPER =
                                                                  TPOFIN.DHALTER
                                                       INNER JOIN TGFNAT NAT
                                                           ON NAT.CODNAT =
                                                              FIN.CODNAT,
                                                       TSIEMP EMP
                                                 WHERE     LIV.CODEMP =
                                                           EMP.CODEMP
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN
                                                       AND LIV.CODEMP = :P_CODEMP
                                                       AND (TPOFIN.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))*/
                                                       AND LIV.ENTSAI = 'E'
                                                       AND LIV.CODMODDOC IN (7,
                                                                             8,
                                                                             9,
                                                                             10,
                                                                             11,
                                                                             26,
                                                                             27,
                                                                             57,
                                                                             902)
                                                       AND LIV.ORIGEM = 'F'
                                                       AND TPOFIN.TEMPIS = 'S'
                                                       AND TPOFIN.TEMCOFINS = 'S'
                                                       AND (   NAT.CSTPIS > 0
                                                            OR NAT.CSTCOFINS > 0
                                                            OR TPOFIN.USAALIQNATRATF100 =
                                                               'S')
                                                UNION
                                                --D201/D205
                                                SELECT LIV.ENTSAI,
                                                       LIV.SEQUENCIA,
                                                       LIV.NUNOTA,
                                                       (CASE
                                                            WHEN DIN.CODINC = 0
                                                            THEN
                                                                ITE.VLRTOT
                                                            ELSE
                                                                0
                                                        END)
                                                           AS VLRTOT,
                                                       DIN.CODIMP,
                                                       DIN.BASERED,
                                                       DIN.VALOR,
                                                       DIN.CST,
                                                       ITE.CODCFO,
                                                       ITE.CODPROD,
                                                       (SELECT PRO.DESCRPROD
                                                          FROM TGFPRO PRO
                                                         WHERE ITE.CODPROD =
                                                               PRO.CODPROD)
                                                           AS DESCRPROD,
                                                       (SELECT P.NCM
                                                          FROM TGFPRO P
                                                         WHERE P.CODPROD =
                                                               ITE.CODPROD)
                                                           AS NCM,
                                                       TPO.CODTIPOPER,
                                                       LIV.DHMOV
                                                           AS DTFILTRO,
                                                       LIV.CODEMP
                                                  FROM (SELECT ENTSAI,
                                                               EMPPARC,
                                                               CODEMP,
                                                               CODPARC,
                                                               CODMODDOC,
                                                               ORIGEM,
                                                               SERIENOTA,
                                                               NUMNOTA,
                                                               NUNOTA,
                                                               DHMOV,
                                                               CODCFO,
                                                               CODTRIB,
                                                               ALIQICMS,
                                                               CHAVENFE,
                                                               CHAVECTE,
                                                               CHAVECTEREF,
                                                               VLRCTB,
                                                               VLRIPI,
                                                               VLRICMS,
                                                               BASEICMS,
                                                               DTDOC,
                                                               DTENTSAIINFO,
                                                               UFORIGEM,
                                                               UFDESTINO,
                                                               SEQUENCIA
                                                          FROM TGFLIV) LIV
                                                       LEFT JOIN
                                                       (SELECT CODTIPOPER,
                                                               NUMNOTA,
                                                               TIPFRETE,
                                                               TIPIPIEMB,
                                                               VLRNOTA,
                                                               VLRDESCTOT,
                                                               VLRDESCTOTITEM,
                                                               VLRMERCADORIA,
                                                               VLRFRETE,
                                                               VLRSEG,
                                                               BASESUBSTIT,
                                                               VLRSUBST,
                                                               VLRDESTAQUE,
                                                               IPIEMB,
                                                               VLREMB,
                                                               VLRJURO,
                                                               CODOBSPADRAO,
                                                               VLRIRF,
                                                               BASEINSS,
                                                               VLRINSS,
                                                               CODPARCTRANSP,
                                                               PESO,
                                                               PESOBRUTO,
                                                               ORDEMCARGA,
                                                               CODVEICULO,
                                                               UFVEICULO,
                                                               ANTT,
                                                               PLACA,
                                                               QTDVOL,
                                                               CODPARCREMETENTE,
                                                               CODPARCDEST,
                                                               CODPARCCONSIGNATARIO,
                                                               CODPARCREDESPACHO,
                                                               CHAVENFE,
                                                               STATUSNFE,
                                                               VLRPIS,
                                                               VLRCOFINS,
                                                               TIPMOV,
                                                               VLRLIQITEMNFE,
                                                               NUNOTA,
                                                               DHTIPOPER
                                                          FROM TGFCAB) CAB
                                                           ON     LIV.NUNOTA =
                                                                  CAB.NUNOTA
                                                              AND LIV.ORIGEM IN
                                                                      ('E', 'A')
                                                       LEFT JOIN
                                                       (SELECT NUFIN,
                                                               CODTIPOPER,
                                                               DHTIPOPER
                                                          FROM TGFFIN) FIN
                                                           ON     LIV.NUNOTA =
                                                                  FIN.NUFIN
                                                              AND LIV.ORIGEM =
                                                                  'F'
                                                       LEFT JOIN
                                                       (SELECT BASENUMERACAO,
                                                               TIPOIMPKIT,
                                                               NATBCCRED,
                                                               INDNATFRT,
                                                               ATUALLIVFIS,
                                                               COMPLEMENTO,
                                                               CODTIPOPER,
                                                               DHALTER,
                                                               NFE
                                                          FROM TGFTOP) TPOCAB
                                                           ON     LIV.ORIGEM IN
                                                                      ('E', 'A')
                                                              AND CAB.CODTIPOPER =
                                                                  TPOCAB.CODTIPOPER
                                                              AND CAB.DHTIPOPER =
                                                                  TPOCAB.DHALTER
                                                       LEFT JOIN
                                                       (SELECT BASENUMERACAO,
                                                               TIPOIMPKIT,
                                                               NATBCCRED,
                                                               INDNATFRT,
                                                               ATUALLIVFIS,
                                                               COMPLEMENTO,
                                                               CODTIPOPER,
                                                               DHALTER,
                                                               TEMPIS,
                                                               TEMCOFINS,
                                                               NFE
                                                          FROM TGFTOP) TPOFIN
                                                           ON     LIV.ORIGEM =
                                                                  'F'
                                                              AND FIN.CODTIPOPER =
                                                                  TPOFIN.CODTIPOPER
                                                              AND FIN.DHTIPOPER =
                                                                  TPOFIN.DHALTER,
                                                       TSIEMP EMP,
                                                       TGFITE ITE,
                                                       TGFTOP TPO,
                                                       TGFPRO PRO,
                                                       TGFDIN DIN
                                                 WHERE     LIV.CODEMP =
                                                           EMP.CODEMP
                                                       /*AND LIV.DHMOV >=
                                                              :P_PERIODOINI
                                                       AND LIV.DHMOV <=
                                                              :P_PERIODOFIN
                                                       AND LIV.CODEMP = :P_CODEMP*/
                                                       AND ITE.NUNOTA =
                                                           DIN.NUNOTA
                                                       AND ITE.SEQUENCIA =
                                                           DIN.SEQUENCIA
                                                       AND DIN.CODIMP IN (6, 7)
                                                       AND LIV.ENTSAI = 'S'
                                                       AND LIV.CODMODDOC IN (7,
                                                                             8,
                                                                             9,
                                                                             10,
                                                                             11,
                                                                             26,
                                                                             27,
                                                                             57,
                                                                             902)
                                                       AND LIV.ORIGEM <> 'D'
                                                       AND (   LIV.ORIGEM = 'F'
                                                            OR EXISTS
                                                                   (SELECT 1
                                                                      FROM TGFDIN
                                                                     WHERE     NUNOTA =
                                                                               LIV.NUNOTA
                                                                           AND CODIMP IN
                                                                                   (6,
                                                                                    7)))
                                                       AND (   (LIV.ORIGEM <> 'F')
                                                            OR (    TPOFIN.TEMPIS =
                                                                    'S'
                                                                AND TPOFIN.TEMCOFINS =
                                                                    'S'))
                                                       AND CAB.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND ITE.NUNOTA =
                                                           LIV.NUNOTA
                                                       AND LIV.SEQUENCIA =
                                                           ITE.SEQUENCIA
                                                       AND CAB.CODTIPOPER =
                                                           TPO.CODTIPOPER
                                                       AND CAB.DHTIPOPER =
                                                           TPO.DHALTER
                                                       --AND (TPO.CODTIPOPER = NVL(:CODTIPOPER, 0) OR 0 = NVL(:CODTIPOPER, 0))
                                                       AND (   (    CAB.TIPMOV =
                                                                    'T'
                                                                AND TPO.ATUALLIVFIS =
                                                                    'A'
                                                                AND LIV.ENTSAI =
                                                                    'E'
                                                                AND ITE.SEQUENCIA <
                                                                    0)
                                                            OR (    (   CAB.TIPMOV <>
                                                                        'T'
                                                                     OR TPO.ATUALLIVFIS <>
                                                                        'A'
                                                                     OR LIV.ENTSAI <>
                                                                        'E')
                                                                AND ITE.SEQUENCIA >
                                                                    0))
                                                       AND ITE.VLRTOT >= 0
                                                       AND TPO.ATUALLIVFIS <>
                                                           ('N')
                                                       AND ITE.CODPROD =
                                                           PRO.CODPROD
                                                       AND ITE.USOPROD <> 'S')
                                               NOTAS
                                         WHERE 'S' = 'S') TB_DIST) NOTASCUPONSDIN)
                       RESUMO
              GROUP BY NOMECST,
                       NOMECFOP,
                       ENTSAI,
                       NUNOTA,
                       CODPROD,
                       DESCRPROD,
                       NCM,
                       CODTIPOPER,
                       DTFILTRO,
                       CODEMP) RESUMOAGRUPADO
    ---------------------
ORDER BY TIPO,
             ENTSAI,
             NOMECFOP,
             NOMECST,
             CODPROD,
             NUNOTA;
