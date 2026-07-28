-- Projeto: Telecom Campaign Analytics
-- Etapa: Validação inicial da tabela de clientes
-- Autor: Adriano Ramos

-- Total de registros e clientes únicos
SELECT
  COUNT(*) AS total_registros,
  COUNT(DISTINCT cliente_id) AS clientes_distintos
FROM `gglobo-bq---qualiop-hdg-prd.Clientes_teste.Clientes`;


-- Distribuição por tipo de plano
SELECT
  tipo_plano,
  COUNT(*) AS quantidade_clientes
FROM `gglobo-bq---qualiop-hdg-prd.Clientes_teste.Clientes`
GROUP BY tipo_plano
ORDER BY quantidade_clientes DESC;


-- Validação de possíveis clientes duplicados
SELECT
  cliente_id,
  COUNT(*) AS quantidade
FROM `gglobo-bq---qualiop-hdg-prd.Clientes_teste.Clientes`
GROUP BY cliente_id
HAVING COUNT(*) > 1;
