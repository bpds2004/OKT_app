create extension if not exists "pgcrypto";

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('UTENTE', 'UNIDADE_SAUDE')),
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists patient_profiles (
  user_id uuid primary key references profiles(id) on delete cascade,
  phone text,
  nif text,
  birth_date date,
  address text,
  health_number text
);

create table if not exists health_units (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  code text unique not null
);

create table if not exists unit_profiles (
  user_id uuid primary key references profiles(id) on delete cascade,
  health_unit_id uuid not null references health_units(id) on delete cascade
);

create table if not exists tests (
  id uuid primary key default gen_random_uuid(),
  patient_user_id uuid not null references profiles(id) on delete cascade,
  health_unit_id uuid not null references health_units(id) on delete cascade,
  status text not null default 'PENDING' check (status in ('PENDING', 'DONE')),
  created_at timestamptz not null default now()
);

create table if not exists test_results (
  id uuid primary key default gen_random_uuid(),
  test_id uuid unique not null references tests(id) on delete cascade,
  summary text,
  risk_level text check (risk_level is null or risk_level in ('LOW', 'MEDIUM', 'HIGH', 'POSITIVE', 'NEGATIVE')),
  created_at timestamptz not null default now()
);

create table if not exists identified_variables (
  id uuid primary key default gen_random_uuid(),
  test_result_id uuid not null references test_results(id) on delete cascade,
  name text not null,
  significance text,
  recommendation text
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  message text not null,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists tests_patient_user_id_idx on tests (patient_user_id);
create index if not exists tests_health_unit_id_idx on tests (health_unit_id);
create index if not exists test_results_test_id_idx on test_results (test_id);
create index if not exists identified_variables_test_result_id_idx on identified_variables (test_result_id);
create index if not exists notifications_user_id_idx on notifications (user_id);
