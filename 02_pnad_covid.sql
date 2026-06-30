-- SQL Server
-- IMPORTANTE: Importação dos dados ocorreu no arquivo 01_pnad_covid.ipynb

-- usando o banco de dados criado no arquivo 01_pnad_covid.ipynb
use pnad_covid_db;

-- deletando tabelas criadas nesta query, caso exista, para que sejam criadas novamente
-- essa tabela será usada para visão criada no Power Bi
drop table if exists tb_pnad_covid;
go

-- união de todas as tabelas em uma cte
with 
uniao_bases as (
	select 'pnad_covid_052020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,null as B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,null as B008,null as B009A,null as B009B,null as B009C,null as B009D,null as B009E,null as B009F from pnad_covid_052020 union all 
	select 'pnad_covid_062020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,null as B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,null as B008,null as B009A,null as B009B,null as B009C,null as B009D,null as B009E,null as B009F from pnad_covid_062020 union all 
	select 'pnad_covid_072020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,B008,B009A,B009B,B009C,B009D,B009E,B009F from pnad_covid_072020 union all 
	select 'pnad_covid_082020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,B008,B009A,B009B,B009C,B009D,B009E,B009F from pnad_covid_082020 union all 
	select 'pnad_covid_092020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,B008,B009A,B009B,B009C,B009D,B009E,B009F from pnad_covid_092020 union all 
	select 'pnad_covid_102020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,B008,B009A,B009B,B009C,B009D,B009E,B009F from pnad_covid_102020 union all 
	select 'pnad_covid_112020' as base, ano,uf,V1013,V1022,A002,A003,B0011,B0012,B0013,B0014,B0015,B0016,B0017,B0018,B0019,B00110,B00111,B00112,B00113,B002,B0041,B0042,B0043,B0044,B0045,B0046,B007,B008,B009A,B009B,B009C,B009D,B009E,B009F from pnad_covid_112020 
), 

-- tratamento dos dados conforme dicionário 
base_tratada as (
	select 
		-- qual o arquivo de origem do dado
		base, 

		-- quando ocorreu pesquisa (yyyy-mm-dd)
		cast(concat(ano, '-', case when len(V1013) = 1 then '0' end, V1013, '-01') as date) as periodo_pesquisa,
		
		-- identificação de quem respondeu pesquisa
		case
			when uf = 11 then 'Rondônia'
			when uf = 12 then 'Acre'
			when uf = 13 then 'Amazonas'
			when uf = 14 then 'Roraima'
			when uf = 15 then 'Pará'
			when uf = 16 then 'Amapá'
			when uf = 17 then 'Tocantins'
			when uf = 21 then 'Maranhão'
			when uf = 22 then 'Piauí'
			when uf = 23 then 'Ceará'
			when uf = 24 then 'Rio Grande do Norte'
			when uf = 25 then 'Paraíba'
			when uf = 26 then 'Pernambuco'
			when uf = 27 then 'Alagoas'
			when uf = 28 then 'Sergipe'
			when uf = 29 then 'Bahia'
			when uf = 31 then 'Minas Gerais'
			when uf = 32 then 'Espírito Santo'
			when uf = 33 then 'Rio de Janeiro'
			when uf = 35 then 'São Paulo'
			when uf = 41 then 'Paraná'
			when uf = 42 then 'Santa Catarina'
			when uf = 43 then 'Rio Grande do Sul'
			when uf = 50 then 'Mato Grosso do Sul'
			when uf = 51 then 'Mato Grosso'
			when uf = 52 then 'Goiás'
			when uf = 53 then 'Distrito Federal'
		end as uf,
		CASE 
			WHEN uf IN (11,12,13,14,15,16,17) THEN 'Norte'
			WHEN uf IN (21,22,23,24,25,26,27,28,29) THEN 'Nordeste'
			WHEN uf IN (31,32,33,35) THEN 'Sudeste'
			WHEN uf IN (41,42,43) THEN 'Sul'
			WHEN uf IN (50,51,52,53) THEN 'Centro-Oeste'
		END AS regiao, -- região do país
		case  
			when A002 between 0 and 17 then '0-17 anos'
			when A002 between 18 and 30 then '18-30 anos'
			when A002 between 31 and 40 then '31-40 anos'
			when A002 between 41 and 50 then '41-50 anos'
			when A002 between 51 and 60 then '51-60 anos'
			when A002 between 61 and 70 then '61-70 anos'
			when A002 between 71 and 80 then '71-80 anos'
			when A002 >= 81 then '81 anos ou mais'
		end as faixa_etaria, -- organizado idade em faixas etárias
		case 
			when A003 = 1 then 'Homem'
			when A003 = 2 then 'Mulher'
		end as sexo,
		
		-- pesquisa sintomas covid-19
		case 
			when B0011 = 1 then 'Sim'
			when B0011 = 2 then 'Não '
			when B0011 = 3 then 'Não sabe' 
			when B0011 = 9 then 'Ignorado' 
		end as teve_febre,
		case 
			when B0012 = 1 then 'Sim'
			when B0012 = 2 then 'Não '
			when B0012 = 3 then 'Não sabe' 
			when B0012 = 9 then 'Ignorado' 
		end as teve_tosse,
		case 
			when B0013 = 1 then 'Sim'
			when B0013 = 2 then 'Não '
			when B0013 = 3 then 'Não sabe' 
			when B0013 = 9 then 'Ignorado' 
		end as teve_dor_garganta,
		case 
			when B0014 = 1 then 'Sim'
			when B0014 = 2 then 'Não '
			when B0014 = 3 then 'Não sabe' 
			when B0014 = 9 then 'Ignorado' 
		end as teve_dificuldade_respirar,
		case 
			when B0015 = 1 then 'Sim'
			when B0015 = 2 then 'Não '
			when B0015 = 3 then 'Não sabe' 
			when B0015 = 9 then 'Ignorado' 
		end as teve_dor_cabeca,
		case 
			when B0016 = 1 then 'Sim'
			when B0016 = 2 then 'Não '
			when B0016 = 3 then 'Não sabe' 
			when B0016 = 9 then 'Ignorado' 
		end as teve_dor_peito,
		case 
			when B0017 = 1 then 'Sim'
			when B0017 = 2 then 'Não '
			when B0018 = 3 then 'Não sabe' 
			when B0018 = 9 then 'Ignorado' 
		end as teve_nausea,
		case 
			when B0018 = 1 then 'Sim'
			when B0018 = 2 then 'Não '
			when B0018 = 3 then 'Não sabe' 
			when B0018 = 9 then 'Ignorado' 
		end as teve_coriza,
		case 
			when B0019 = 1 then 'Sim'
			when B0019 = 2 then 'Não '
			when B0019 = 3 then 'Não sabe' 
			when B0019 = 9 then 'Ignorado' 
		end as teve_fadiga,
		case 
			when B00110 = 1 then 'Sim'
			when B00110 = 2 then 'Não '
			when B00110 = 3 then 'Não sabe' 
			when B00110 = 9 then 'Ignorado' 
		end as teve_dor_olhos,
		case 
			when B00111 = 1 then 'Sim'
			when B00111 = 2 then 'Não '
			when B00111 = 3 then 'Não sabe' 
			when B00111 = 9 then 'Ignorado' 
		end as teve_perda_sentidos,
		case 
			when B00112 = 1 then 'Sim'
			when B00112 = 2 then 'Não '
			when B00112 = 3 then 'Não sabe' 
			when B00112 = 9 then 'Ignorado' 
		end as teve_dor_muscular,
		case 
			when B00113 = 1 then 'Sim'
			when B00113 = 2 then 'Não '
			when B00113 = 3 then 'Não sabe' 
			when B00113 = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as teve_diarreia,

		-- em caso de sintomas covid-19, se procurou ajuda
		case 
			when B002 = 1 then 'Sim'
			when B002 = 2 then 'Não '
			when B002 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_estabelecimento_saude,
		case 
			when B0041 = 1 then 'Sim'
			when B0041 = 2 then 'Não '
			when B0041 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_amb_ubs,
		case 
			when B0042 = 1 then 'Sim'
			when B0042 = 2 then 'Não '
			when B0042 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_ps_sus,
		case 
			when B0043 = 1 then 'Sim'
			when B0043 = 2 then 'Não '
			when B0043 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_hosp_sus,
		case 
			when B0044 = 1 then 'Sim'
			when B0044 = 2 then 'Não '
			when B0044 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_amb_privado,
		case 
			when B0045 = 1 then 'Sim'
			when B0045 = 2 then 'Não '
			when B0045 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_ps_privado,
		case 
			when B0046 = 1 then 'Sim'
			when B0046 = 2 then 'Não '
			when B0046 = 9 then 'Ignorado' 
			else 'Não aplicável'
		end as foi_em_hosp_privado,

		-- se possui convenio
		case 
			when B007 = 1 then 'Sim'
			when B007 = 2 then 'Não '
			when B007 = 9 then 'Ignorado' 
		end as possui_convenio,

		-- resultado teste covid	
		case 
			when B008 = 1 then 'Sim'
			when B008 = 2 then 'Não '
			when B008 = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as fez_exame,
		case 
			when B009A = 1 then 'Sim'
			when B009A = 2 then 'Não '
			when B009A = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as fez_exame_cotonete,
		case 
			when B009B = 1 then 'Positivo'
			when B009B = 2 then 'Negativo'
			when B009B = 3 then 'Inconclusivo' 
			when B009B = 4 then 'Ainda não recebeu o resultado' 
			when B009B = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as result_exame_cotonete,
		case 
			when B009C = 1 then 'Sim'
			when B009C = 2 then 'Não '
			when B009C = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as fez_exame_coleta_dedo,
		case 
			when B009D = 1 then 'Positivo'
			when B009D = 2 then 'Negativo'
			when B009D = 3 then 'Inconclusivo' 
			when B009D = 4 then 'Ainda não recebeu o resultado' 
			when B009D = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as result_exame_coleta_dedo,
		case 
			when B009E = 1 then 'Sim'
			when B009E = 2 then 'Não '
			when B009E = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as fez_exame_coleta_braco,
		case 
			when B009F = 1 then 'Positivo'
			when B009F = 2 then 'Negativo'
			when B009F = 3 then 'Inconclusivo' 
			when B009F = 4 then 'Ainda não recebeu o resultado' 
			when B009F = 9 then 'Ignorado' 
			else 'N/A' -- não aplicável porque os meses 5 e 6 não tiveram essa pergunta na pesquisa
		end as result_exame_coleta_braco

	from uniao_bases
)

-- tabela final
select *
	-- se teve pelo menos 1 sintoma, é classificado como sintomático 
	,case when 
		 teve_febre = 'Sim'
      or teve_tosse = 'Sim'
      or teve_dor_garganta = 'Sim'
      or teve_dificuldade_respirar = 'Sim'
      or teve_dor_cabeca = 'Sim'
      or teve_dor_peito = 'Sim'
      or teve_nausea = 'Sim'
      or teve_coriza = 'Sim'
      or teve_fadiga = 'Sim'
      or teve_dor_olhos = 'Sim'
      or teve_perda_sentidos = 'Sim'
      or teve_dor_muscular = 'Sim'
      or teve_diarreia = 'Sim'
	  	then 'Sim' else 'Não' 
	end as sintomatico
	
	-- se teve resultado positivo em pelo menos 1 exame covid
	,case when 
		 result_exame_cotonete = 'Positivo'
      or result_exame_coleta_dedo = 'Positivo'
      or result_exame_coleta_braco = 'Positivo'
	  	then 'Sim' else 'Não' 
	end as positivo_covid
	
into tb_pnad_covid -- salvando dados em uma tabela 
from base_tratada;

-- resultado final da tabela
select count(*) 
from tb_pnad_covid; -- 2650459

SELECT TOP 10 
	  -- colunas usadas na analise no power bi
	   periodo_pesquisa
      ,uf
	  ,regiao
      ,faixa_etaria
      ,sexo
      ,teve_febre
      ,teve_tosse
      ,teve_dor_garganta
      ,teve_dificuldade_respirar
      ,teve_dor_cabeca
      ,teve_dor_peito
      ,teve_nausea
      ,teve_coriza
      ,teve_fadiga
      ,teve_dor_olhos
      ,teve_perda_sentidos
      ,teve_dor_muscular
      ,teve_diarreia
      ,foi_estabelecimento_saude
      ,foi_em_amb_ubs
      ,foi_em_ps_sus
      ,foi_em_hosp_sus
      ,foi_em_amb_privado
      ,foi_em_ps_privado
      ,foi_em_hosp_privado
      ,possui_convenio
	  ,fez_exame
	  ,sintomatico
	  ,positivo_covid

	  -- colunas não usadas na analise no power bi
	  ,base
	  ,fez_exame_cotonete
	  ,result_exame_cotonete
	  ,fez_exame_coleta_dedo
	  ,result_exame_coleta_dedo
	  ,fez_exame_coleta_braco
	  ,result_exame_coleta_braco
  FROM tb_pnad_covid;
