-- Projeto: Telecom Campaign Analytics
-- Campanha: Reativação Pré-pago 30+
-- Objetivo:
-- Identificar clientes pré-pagos sem recarga há mais de 30 dias,
-- aplicar consentimento de marketing e controle de pressão de contato.
-- Dados utilizados: base fictícia

WITH ultima_recarga AS (
  SELECT
    cliente_id,
    MAX(data_recarga) AS data_ultima_recarga
  FROM `SEU_PROJETO.Clientes_teste.Recargas`
  WHERE status_recarga = 'APROVADA'
  GROUP BY cliente_id
),

audiencia_comportamental AS (
  SELECT
    c.cliente_id,
    c.plano_nome,
    c.tipo_plano,
    c.canal_preferido,
    c.consentimento_marketing,
    u.data_ultima_recarga,
    DATE_DIFF(
      DATE '2026-07-27',
      u.data_ultima_recarga,
      DAY
    ) AS dias_sem_recarga
  FROM `SEU_PROJETO.Clientes_teste.Clientes` c
  LEFT JOIN ultima_recarga u
    ON c.cliente_id = u.cliente_id
  WHERE c.tipo_plano = 'PRE_PAGO'
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
    a.tipo_plano,
    a.canal_preferido,
    a.data_ultima_recarga,
    a.dias_sem_recarga
  FROM audiencia_comportamental a
  LEFT JOIN campanha_7d c
    ON a.cliente_id = c.cliente_id
  WHERE a.consentimento_marketing = TRUE
    AND c.cliente_id IS NULL
)

SELECT
  cliente_id,
  plano_nome,
  tipo_plano,
  canal_preferido,
  data_ultima_recarga,
  dias_sem_recarga
FROM audiencia_final
ORDER BY dias_sem_recarga DESC;
