alter table profiles enable row level security;
alter table patient_profiles enable row level security;
alter table health_units enable row level security;
alter table unit_profiles enable row level security;
alter table tests enable row level security;
alter table test_results enable row level security;
alter table identified_variables enable row level security;
alter table notifications enable row level security;

create policy "profiles_select_own" on profiles
  for select
  using (id = auth.uid());

create policy "profiles_insert_own" on profiles
  for insert
  with check (id = auth.uid());

create policy "profiles_update_own" on profiles
  for update
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "patient_profiles_select_own" on patient_profiles
  for select
  using (user_id = auth.uid());

create policy "patient_profiles_insert_own" on patient_profiles
  for insert
  with check (user_id = auth.uid());

create policy "patient_profiles_update_own" on patient_profiles
  for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "unit_profiles_select_own" on unit_profiles
  for select
  using (user_id = auth.uid());

create policy "unit_profiles_insert_own" on unit_profiles
  for insert
  with check (user_id = auth.uid());

create policy "unit_profiles_update_own" on unit_profiles
  for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "health_units_select_authenticated" on health_units
  for select
  using (auth.uid() is not null);

create policy "health_units_insert_unit" on health_units
  for insert
  with check (
    exists (select 1 from profiles where id = auth.uid() and role = 'UNIDADE_SAUDE')
  );

create policy "health_units_update_unit" on health_units
  for update
  using (
    exists (select 1 from profiles where id = auth.uid() and role = 'UNIDADE_SAUDE')
  )
  with check (
    exists (select 1 from profiles where id = auth.uid() and role = 'UNIDADE_SAUDE')
  );

create policy "tests_insert_patient" on tests
  for insert
  with check (patient_user_id = auth.uid());

create policy "tests_select_patient" on tests
  for select
  using (patient_user_id = auth.uid());

create policy "tests_select_unit" on tests
  for select
  using (
    exists (
      select 1 from unit_profiles
      where unit_profiles.user_id = auth.uid()
        and unit_profiles.health_unit_id = tests.health_unit_id
    )
  );

create policy "tests_update_unit" on tests
  for update
  using (
    exists (
      select 1 from unit_profiles
      where unit_profiles.user_id = auth.uid()
        and unit_profiles.health_unit_id = tests.health_unit_id
    )
  )
  with check (
    exists (
      select 1 from unit_profiles
      where unit_profiles.user_id = auth.uid()
        and unit_profiles.health_unit_id = tests.health_unit_id
    )
  );

create policy "results_select_patient" on test_results
  for select
  using (
    exists (
      select 1 from tests
      where tests.id = test_results.test_id
        and tests.patient_user_id = auth.uid()
    )
  );

create policy "results_select_unit" on test_results
  for select
  using (
    exists (
      select 1 from tests
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where tests.id = test_results.test_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "results_insert_unit" on test_results
  for insert
  with check (
    exists (
      select 1 from tests
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where tests.id = test_results.test_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "results_update_unit" on test_results
  for update
  using (
    exists (
      select 1 from tests
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where tests.id = test_results.test_id
        and unit_profiles.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from tests
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where tests.id = test_results.test_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "vars_select_patient" on identified_variables
  for select
  using (
    exists (
      select 1 from test_results
      join tests on tests.id = test_results.test_id
      where test_results.id = identified_variables.test_result_id
        and tests.patient_user_id = auth.uid()
    )
  );

create policy "vars_select_unit" on identified_variables
  for select
  using (
    exists (
      select 1 from test_results
      join tests on tests.id = test_results.test_id
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where test_results.id = identified_variables.test_result_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "vars_insert_unit" on identified_variables
  for insert
  with check (
    exists (
      select 1 from test_results
      join tests on tests.id = test_results.test_id
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where test_results.id = identified_variables.test_result_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "vars_update_unit" on identified_variables
  for update
  using (
    exists (
      select 1 from test_results
      join tests on tests.id = test_results.test_id
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where test_results.id = identified_variables.test_result_id
        and unit_profiles.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from test_results
      join tests on tests.id = test_results.test_id
      join unit_profiles on unit_profiles.health_unit_id = tests.health_unit_id
      where test_results.id = identified_variables.test_result_id
        and unit_profiles.user_id = auth.uid()
    )
  );

create policy "notifications_select_own" on notifications
  for select
  using (user_id = auth.uid());

create policy "notifications_insert_own" on notifications
  for insert
  with check (user_id = auth.uid());

create policy "notifications_update_own" on notifications
  for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
