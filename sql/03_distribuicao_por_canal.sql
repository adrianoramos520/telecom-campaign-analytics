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
    u.data_ultima_recarga
  FROM `SEU_PROJETO.Clientes_teste.Clientes` c
  LEFT JOIN ultima_recarga u
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
    a.data_ultima_recarga
  FROM audiencia_com_consentimento a
  LEFT JOIN campanha_7d c
    ON a.cliente_id = c.cliente_id
  WHERE c.cliente_id IS NULL
)

SELECT
  canal_preferido,
  COUNT(DISTINCT cliente_id) AS quantidade_clientes,
  ROUND(
    SAFE_DIVIDE(
      COUNT(DISTINCT cliente_id),
      SUM(COUNT(DISTINCT cliente_id)) OVER ()
    ) * 100,
    2
  ) AS percentual_audiencia
FROM audiencia_final
GROUP BY canal_preferido
ORDER BY quantidade_clientes DESC;
