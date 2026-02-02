create extension if not exists "pgcrypto";

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text check (role in ('UTENTE','UNIDADE_SAUDE')) not null,
  name text,
  created_at timestamp default now()
);

create table if not exists patient_profiles (
  user_id uuid primary key references profiles(id) on delete cascade,
  phone text,
  nif text,
  birth_date date,
  address text
);

create table if not exists health_units (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text,
  code text unique not null,
  created_at timestamp default now()
);

create table if not exists unit_profiles (
  user_id uuid primary key references profiles(id) on delete cascade,
  health_unit_id uuid references health_units(id) not null
);

create table if not exists tests (
  id uuid primary key default gen_random_uuid(),
  patient_user_id uuid references profiles(id) not null,
  health_unit_id uuid references health_units(id) not null,
  status text check (status in ('PENDING','IN_REVIEW','DONE')) not null default 'PENDING',
  created_at timestamp default now()
);

create table if not exists test_results (
  id uuid primary key default gen_random_uuid(),
  test_id uuid unique references tests(id) not null,
  summary text,
  risk_level text check (risk_level in ('BAIXO','MEDIO','ALTO')) not null default 'BAIXO',
  created_at timestamp default now()
);

create table if not exists identified_variables (
  id uuid primary key default gen_random_uuid(),
  test_result_id uuid references test_results(id) not null,
  name text not null,
  significance text,
  recommendation text
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) not null,
  title text not null,
  message text not null,
  read boolean default false,
  created_at timestamp default now()
);
