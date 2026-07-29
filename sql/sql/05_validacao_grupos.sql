-- Projeto: Telecom Campaign Analytics
-- Campanha: Reativação Pré-pago 30+
-- Objetivo:
-- Verificar se os grupos de tratamento e controle possuem
-- características semelhantes antes da execução da campanha.
-- Dados utilizados: base fictícia

WITH ultima_recarga AS (
  SELECT
    cliente_id,
    MAX(data_recarga) AS data_ultima_recarga
  FROM `SEU_PROJETO.Clientes_teste.Recargas`
  WHERE status_recarga = 'APROVADA'
  GROUP BY cliente_id
),

audiencia_com_consentimento AS (
  SELECT
    c.cliente_id,
    c.plano_nome,
    c.canal_preferido,
    u.data_ultima_recarga,

    CASE
      WHEN u.data_ultima_recarga IS NULL THEN NULL
      ELSE DATE_DIFF(
        DATE '2026-07-27',
        u.data_ultima_recarga,
        DAY
      )
    END AS dias_sem_recarga

  FROM `SEU_PROJETO.Clientes_teste.Clientes` AS c

  LEFT JOIN ultima_recarga AS u
    ON c.cliente_id = u.cliente_id

  WHERE c.tipo_plano = 'PRE_PAGO'
    AND c.consentimento_marketing = TRUE
    AND (
      u.data_ultima_recarga IS NULL
      OR DATE_DIFF(
        DATE '2026-07-27',
        u.data_ultima_recarga,
        DAY
      ) > 30
    )
),

campanha_7d AS (
  SELECT DISTINCT
    cliente_id
  FROM `SEU_PROJETO.Clientes_teste.Contatos_Campanha`
  WHERE DATE(data_hora_disparo) >= DATE_SUB(
    DATE '2026-07-27',
    INTERVAL 7 DAY
  )
),

audiencia_final AS (
  SELECT
    a.cliente_id,
    a.plano_nome,
    a.canal_preferido,
    a.data_ultima_recarga,
    a.dias_sem_recarga
  FROM audiencia_com_consentimento AS a

  LEFT JOIN campanha_7d AS c
    ON a.cliente_id = c.cliente_id

  WHERE c.cliente_id IS NULL
),

randomizacao AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY canal_preferido
      ORDER BY FARM_FINGERPRINT(cliente_id)
    ) AS ordem_cliente,

    COUNT(*) OVER (
      PARTITION BY canal_preferido
    ) AS total_clientes_canal

  FROM audiencia_final
),

grupos AS (
  SELECT
    cliente_id,
    plano_nome,
    canal_preferido,
    data_ultima_recarga,
    dias_sem_recarga,

    CASE
      WHEN ordem_cliente <= CEIL(total_clientes_canal * 0.10)
        THEN 'CONTROLE'
      ELSE 'TRATAMENTO'
    END AS grupo_experimento

  FROM randomizacao
)

SELECT
  grupo_experimento,

  COUNT(DISTINCT cliente_id) AS quantidade_clientes,

  COUNTIF(data_ultima_recarga IS NULL)
    AS clientes_sem_historico_recarga,

  ROUND(
    AVG(dias_sem_recarga),
    2
  ) AS media_dias_sem_recarga,

  APPROX_QUANTILES(dias_sem_recarga, 2)[OFFSET(1)]
    AS mediana_dias_sem_recarga,

  MIN(dias_sem_recarga)
    AS minimo_dias_sem_recarga,

  MAX(dias_sem_recarga)
    AS maximo_dias_sem_recarga

FROM grupos
GROUP BY grupo_experimento
ORDER BY grupo_experimento;
