SELECT CODPROD
     ,AD_PARTNUMBER AS "REFERENCIA"
     , DESCRPROD AS "DESCRIÇÃO"
     , CODGRUPOPROD
     ,CASE  WHEN CODGRUPOPROD =	10000000 THEN 'MAQUINAS'
            WHEN CODGRUPOPROD =	10100000 THEN 'TRATORES'
            WHEN CODGRUPOPROD =	10101000 THEN 'FARMALL'
            WHEN CODGRUPOPROD =	10102000 THEN 'QUANTUM'
            WHEN CODGRUPOPROD =	10103000 THEN 'PUMA'
            WHEN CODGRUPOPROD =	10104000 THEN 'MAGNUM'
            WHEN CODGRUPOPROD =	10105000 THEN 'STEIGER'
            WHEN CODGRUPOPROD =	10106000 THEN 'MAXXUM'
            WHEN CODGRUPOPROD =	10107000 THEN 'TRATOR AGRICOLA'
            WHEN CODGRUPOPROD =	10200000 THEN 'COLHEITADEIRAS'
            WHEN CODGRUPOPROD =	10201000 THEN 'AXIAL-FLOW '
            WHEN CODGRUPOPROD =	10202000 THEN 'COLHEITADEIRA'
            WHEN CODGRUPOPROD =	10300000 THEN 'COLHEDORAS'
            WHEN CODGRUPOPROD =	10301000 THEN 'CANA'
            WHEN CODGRUPOPROD =	10302000 THEN 'CAFE'
            WHEN CODGRUPOPROD =	10400000 THEN 'PULVERIZADORES'
            WHEN CODGRUPOPROD =	10401000 THEN 'PATRIOT'
            WHEN CODGRUPOPROD =	10402000 THEN 'PULVERIZADORES AGRICOLAS'
            WHEN CODGRUPOPROD =	20000000 THEN 'IMPLEMENTOS'
            WHEN CODGRUPOPROD =	20100000 THEN 'PLANTADEIRAS'
            WHEN CODGRUPOPROD =	20101000 THEN 'EASY RISER'
            WHEN CODGRUPOPROD =	20102000 THEN 'ASM 1200'
            WHEN CODGRUPOPROD =	20103000 THEN 'PLANTADORA'
            WHEN CODGRUPOPROD =	20104000 THEN 'ULTRA FLEX'
            WHEN CODGRUPOPROD =	20105000 THEN 'PST4'
            WHEN CODGRUPOPROD =	20106000 THEN 'PLANTADEIRAS'
            WHEN CODGRUPOPROD =	20200000 THEN 'PLATAFORMA'
            WHEN CODGRUPOPROD =	20201000 THEN 'PLATAFORMA DE CORTE'
            WHEN CODGRUPOPROD =	20202000 THEN 'PLATAFORMA DE MILHO'
            WHEN CODGRUPOPROD =	20203000 THEN 'PLATAFORMA DE FORRAGEM'
            WHEN CODGRUPOPROD =	20204000 THEN 'PLATAFORMA DE CEREAIS'
            WHEN CODGRUPOPROD =	20300000 THEN 'ARADOS'
            WHEN CODGRUPOPROD =	20301000 THEN 'SUBSOLADOR'
            WHEN CODGRUPOPROD =	20302000 THEN 'ESCARIFICADOR'
            WHEN CODGRUPOPROD =	20303000 THEN 'AIVECAS'
            WHEN CODGRUPOPROD =	20400000 THEN 'GRADES'
            WHEN CODGRUPOPROD =	20401000 THEN 'ARADORA'
            WHEN CODGRUPOPROD =	20402000 THEN 'NIVELADORA'
            WHEN CODGRUPOPROD =	20403000 THEN 'AIVECA'
            WHEN CODGRUPOPROD =	20500000 THEN 'PLAINA'
            WHEN CODGRUPOPROD =	20501000 THEN 'NIVELADORA'
            WHEN CODGRUPOPROD =	20502000 THEN 'TRASEIRA'
            WHEN CODGRUPOPROD =	20503000 THEN 'DIANTEIRA'
            WHEN CODGRUPOPROD =	20600000 THEN 'GUINCHOS'
            WHEN CODGRUPOPROD =	20601000 THEN 'FRONTAL'
            WHEN CODGRUPOPROD =	20602000 THEN 'TRASEIRO'
            WHEN CODGRUPOPROD =	20700000 THEN 'CARRETAS'
            WHEN CODGRUPOPROD =	20701000 THEN 'GRANELEIRAS'
            WHEN CODGRUPOPROD =	20702000 THEN 'PLATAFORMAS'
            WHEN CODGRUPOPROD =	20703000 THEN 'AGRICOLA'
            WHEN CODGRUPOPROD =	20704000 THEN 'TANQUE'
            WHEN CODGRUPOPROD =	20705000 THEN 'PRANCHA'
            WHEN CODGRUPOPROD =	20800000 THEN 'VAGÃO'
            WHEN CODGRUPOPROD =	20801000 THEN 'MISTURADOR'
            WHEN CODGRUPOPROD =	20802000 THEN 'FORRAGEIRO'
            WHEN CODGRUPOPROD =	20900000 THEN 'DISTRIBUIDOR'
            WHEN CODGRUPOPROD =	20901000 THEN 'DISTRIBUIDOR'
            WHEN CODGRUPOPROD =	21000000 THEN 'ENXADAS'
            WHEN CODGRUPOPROD =	21001000 THEN 'ROTATIVAS'
            WHEN CODGRUPOPROD =	21100000 THEN 'ENLEIRADOR'
            WHEN CODGRUPOPROD =	21101000 THEN 'ENLEIRADOR DE PALHA'
            WHEN CODGRUPOPROD =	21102000 THEN 'ENLEIRADOR PARA CAMA DE AVIARI'
            WHEN CODGRUPOPROD =	21200000 THEN 'COLHEDORA'
            WHEN CODGRUPOPROD =	21201000 THEN 'COLHEDORA DE FORRAGENS'
            WHEN CODGRUPOPROD =	21300000 THEN 'ADUBADORAS'
            WHEN CODGRUPOPROD =	21301000 THEN 'ADUBADORA'
            WHEN CODGRUPOPROD =	21400000 THEN 'ESCARIFICADOR'
            WHEN CODGRUPOPROD =	21401000 THEN 'ESCARIFICADOR'
            WHEN CODGRUPOPROD =	21500000 THEN 'ROCADEIRA'
            WHEN CODGRUPOPROD =	21501000 THEN 'ROCADEIRA HIDRAULICA'
            WHEN CODGRUPOPROD =	21600000 THEN 'SEMEADORA'
            WHEN CODGRUPOPROD =	21601000 THEN 'SEMEADORA ADUBADORA'
            WHEN CODGRUPOPROD =	21700000 THEN 'PA AGRICOLA'
            WHEN CODGRUPOPROD =	21701000 THEN 'CARREGADEIRA'
            WHEN CODGRUPOPROD =	21702000 THEN 'TRASEIRA'
            WHEN CODGRUPOPROD =	21800000 THEN 'ABASTECEDOR'
            WHEN CODGRUPOPROD =	21801000 THEN 'ABASTECEDOR DE PULVERIZADOR'
            WHEN CODGRUPOPROD =	21900000 THEN 'LAMINA AGRICOLA'
            WHEN CODGRUPOPROD =	21901000 THEN 'DIANTEIRA'
            WHEN CODGRUPOPROD =	22000000 THEN 'SUPORTES AGRICOLAS'
            WHEN CODGRUPOPROD =	22001000 THEN 'BIG BAG'
            WHEN CODGRUPOPROD =	22100000 THEN 'PERFURADOR'
            WHEN CODGRUPOPROD =	22101000 THEN 'PERFURADOR '
            WHEN CODGRUPOPROD =	22200000 THEN 'DESENSILADEIRA'
            WHEN CODGRUPOPROD =	22201000 THEN 'DESENSILADEIRA'
            WHEN CODGRUPOPROD =	22300000 THEN 'DESINTEGRADOR'
            WHEN CODGRUPOPROD =	22301000 THEN 'DESINTEGRADOR'
            WHEN CODGRUPOPROD =	22400000 THEN 'TRANSBORDOS'
            WHEN CODGRUPOPROD =	22401000 THEN 'TRANSBORDOS '
            WHEN CODGRUPOPROD =	22500000 THEN 'PULVERIZADORES'
            WHEN CODGRUPOPROD =	22501000 THEN 'PULVERIZADOR DE BARRA ACOPLADO'
            WHEN CODGRUPOPROD =	22502000 THEN 'PULVERIZADOR DE BARRA CARRETA'
            WHEN CODGRUPOPROD =	22503000 THEN 'PULVERIZADOR APLICADOR'
            WHEN CODGRUPOPROD =	22600000 THEN 'CLASSIFICADORES'
            WHEN CODGRUPOPROD =	22601000 THEN 'CLASSIFICADORES'
            WHEN CODGRUPOPROD =	22700000 THEN 'ENFARDADEIRAS'
            WHEN CODGRUPOPROD =	22701000 THEN 'ENFARDADERIAS'
            WHEN CODGRUPOPROD =	22800000 THEN 'EMBOLSADORA'
            WHEN CODGRUPOPROD =	22801000 THEN 'EMBOLSADORA'
            WHEN CODGRUPOPROD =	22900000 THEN 'ROLO'
            WHEN CODGRUPOPROD =	22901000 THEN 'ROLO'
            WHEN CODGRUPOPROD =	23000000 THEN 'RECOLHEDORA'
            WHEN CODGRUPOPROD =	23001000 THEN 'RECOLHEDORA DE AMENDOIM'
            WHEN CODGRUPOPROD =	23100000 THEN 'TERRACEADORES'
            WHEN CODGRUPOPROD =	23101000 THEN 'TERRACEADOR DE ARRASTO'
            WHEN CODGRUPOPROD =	23200000 THEN 'CULTIVADOR'
            WHEN CODGRUPOPROD =	23201000 THEN 'CULTIVADOR DE CANA'
            WHEN CODGRUPOPROD =	23202000 THEN 'CULTIVADOR DE MANDIOCA'
            WHEN CODGRUPOPROD =	23300000 THEN 'ELIMINADOR'
            WHEN CODGRUPOPROD =	23301000 THEN 'ELIMINADOR DE SOQUEIRAS'
            WHEN CODGRUPOPROD =	23400000 THEN 'TANDEM'
            WHEN CODGRUPOPROD =	23401000 THEN 'TANDEM DE ARRASTO'
            WHEN CODGRUPOPROD =	23500000 THEN 'ENGATE'
            WHEN CODGRUPOPROD =	23501000 THEN 'ENGATE TRASEIRO'
            WHEN CODGRUPOPROD =	23600000 THEN 'TANQUE'
            WHEN CODGRUPOPROD =	23601000 THEN 'TANQUE'
            WHEN CODGRUPOPROD =	23700000 THEN 'SEGADEIRAS'
            WHEN CODGRUPOPROD =	23701000 THEN 'DE DISCOS'
            WHEN CODGRUPOPROD =	23702000 THEN 'DE TAMBOR'
            WHEN CODGRUPOPROD =	23800000 THEN 'TRITURADOR'
            WHEN CODGRUPOPROD =	23801000 THEN 'FLORESTAL'
            WHEN CODGRUPOPROD = 30201000 THEN 'ADITIVOS'
            WHEN CODGRUPOPROD = 30200000 THEN 'ADITIVOS'
            WHEN CODGRUPOPROD = 30401000 THEN 'BATERIAS'
            WHEN CODGRUPOPROD = 30701000 THEN 'CORREIAS'
            WHEN CODGRUPOPROD = 31201000 THEN 'TRANSMISSAO'
            WHEN CODGRUPOPROD = 31301000 THEN 'GERAL'
            WHEN CODGRUPOPROD = 30600000 THEN 'CORRENTES'
            WHEN CODGRUPOPROD = 30700000 THEN 'CORREIAS'
            WHEN CODGRUPOPROD = 30801000 THEN 'FILTROS'
            WHEN CODGRUPOPROD = 31401000 THEN 'DESGASTE'
            WHEN CODGRUPOPROD = 31501000 THEN 'VIDROS'
            WHEN CODGRUPOPROD = 30000000 THEN 'PECAS'
            WHEN CODGRUPOPROD = 30501000 THEN 'PNEUS'
            WHEN CODGRUPOPROD = 30601000 THEN 'CORRENTES'
            WHEN CODGRUPOPROD = 30500000 THEN 'PNEUS'
            WHEN CODGRUPOPROD = 30800000 THEN 'FILTROS'
            WHEN CODGRUPOPROD = 30900000 THEN 'MOTOR'
            WHEN CODGRUPOPROD = 31000000 THEN 'ELETRICA'
            WHEN CODGRUPOPROD = 31100000 THEN 'HIDRAULICA'
            WHEN CODGRUPOPROD = 31200000 THEN 'TRANSMISSAO'
            WHEN CODGRUPOPROD = 31300000 THEN 'GERAL'
            WHEN CODGRUPOPROD = 31500000 THEN 'VIDROS'
            WHEN CODGRUPOPROD = 31101000 THEN 'HIDRAULICA'
            WHEN CODGRUPOPROD = 30400000 THEN 'BATERIAS'
            WHEN CODGRUPOPROD = 31400000 THEN 'DESGASTE'
            WHEN CODGRUPOPROD = 31001000 THEN 'ELETRICA'
            WHEN CODGRUPOPROD = 30100000 THEN 'ROLAMENTOS'
            WHEN CODGRUPOPROD = 30101000 THEN 'ROLAMENTOS'
            WHEN CODGRUPOPROD = 30901000 THEN 'MOTOR'
            WHEN CODGRUPOPROD = 31601000 THEN 'LUBRIFICANTES'
            WHEN CODGRUPOPROD = 31600000 THEN 'LUBRIFICANTES'
END AS "DESC_CODGRUPOPROD"
     , ICMSGERENCIA
     , NCM
     , AD_CODCEST
     , GRUPOICMS
     , GRUPOPIS
     , GRUPOCOFINS
     , USOPROD AS "USAR COMO"
FROM TGFPRO
WHERE --CODGRUPOPROD >= 10000000
  --AND CODGRUPOPROD <= 23801000
  --AND CODGRUPOPROD >= 30000000
  --AND CODGRUPOPROD <= 31601000
--AND
      USOPROD <> 'S'
  ORDER BY CODGRUPOPROD;