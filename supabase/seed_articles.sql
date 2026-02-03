insert into articles (slug, title, excerpt, content, cover_url, published, published_at)
values
(
  'como-funciona-o-okt',
  'Como funciona o OKT',
  'Uma visão clara sobre o teste OKT, desde a ligação BLE até à análise de dados.',
  'O OKT é um teste não invasivo que recolhe sinais através de um dispositivo Bluetooth Low Energy (BLE). A app inicia o teste, recebe a stream de dados e guarda o resultado no Supabase. A análise inicial resume os dados e permite que a unidade de saúde complemente o relatório com variáveis e recomendações. Esta abordagem garante rastreabilidade, histórico clínico e acesso seguro em múltiplos dispositivos.',
  null,
  true,
  now()
),
(
  'rastreios-salvam-tempo',
  'Rastreios salvam tempo',
  'Porque a deteção precoce reduz riscos e facilita decisões clínicas.',
  'Rastreios regulares aumentam a probabilidade de identificar alterações antes de se tornarem graves. O OKT ajuda a recolher sinais de forma consistente e segura, permitindo à equipa clínica comparar resultados ao longo do tempo. Isto reduz visitas desnecessárias e acelera decisões baseadas em dados.',
  null,
  true,
  now() - interval '1 day'
),
(
  'privacidade-e-dados-clinicos',
  'Privacidade e dados clínicos',
  'Como o Supabase e as políticas RLS protegem os seus dados.',
  'Os dados clínicos do OKT são guardados num PostgreSQL remoto com Row Level Security (RLS). Isso significa que cada utente só acede ao que lhe pertence, e as unidades de saúde apenas veem testes associados à sua unidade. A app utiliza apenas a anon key e nunca expõe chaves de serviço.',
  null,
  true,
  now() - interval '2 days'
),
(
  'sinais-que-merecem-atencao',
  'Sinais que merecem atenção',
  'Entenda quando deve realizar um novo teste ou contactar a unidade.',
  'Sintomas persistentes, alterações súbitas ou dúvidas sobre o seu estado de saúde são motivos para repetir o teste. O OKT permite registar estes momentos e partilhar o resultado com a unidade. Sempre que tiver dúvidas, contacte um profissional de saúde.',
  null,
  true,
  now() - interval '3 days'
),
(
  'como-preparar-uma-consulta',
  'Como preparar uma consulta',
  'Checklist prático para aproveitar melhor a sua consulta de saúde.',
  'Antes da consulta, reúna o histórico dos seus testes OKT, anote sintomas recentes e prepare perguntas claras. Leve também informações sobre medicação e exames anteriores. Uma preparação simples melhora a qualidade do atendimento e a clareza das recomendações.',
  null,
  true,
  now() - interval '4 days'
);
