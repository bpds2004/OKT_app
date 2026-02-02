alter table profiles enable row level security;
alter table patient_profiles enable row level security;
alter table health_units enable row level security;
alter table unit_profiles enable row level security;
alter table tests enable row level security;
alter table test_results enable row level security;
alter table identified_variables enable row level security;
alter table notifications enable row level security;

create policy "profiles_select_own"
  on profiles for select
  using (id = auth.uid());

create policy "profiles_insert_own"
  on profiles for insert
  with check (id = auth.uid());

create policy "profiles_update_own"
  on profiles for update
  using (id = auth.uid())
  with check (id = auth.uid());

create policy "profiles_select_unit_patients"
  on profiles for select
  using (
    exists (
      select 1
      from unit_profiles up
      join tests t on t.health_unit_id = up.health_unit_id
      where up.user_id = auth.uid()
        and t.patient_user_id = profiles.id
    )
  );

create policy "patient_profiles_select_own"
  on patient_profiles for select
  using (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UTENTE')
  );

create policy "patient_profiles_insert_own"
  on patient_profiles for insert
  with check (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UTENTE')
  );

create policy "patient_profiles_update_own"
  on patient_profiles for update
  using (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UTENTE')
  )
  with check (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UTENTE')
  );

create policy "unit_profiles_select_own"
  on unit_profiles for select
  using (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UNIDADE_SAUDE')
  );

create policy "unit_profiles_insert_own"
  on unit_profiles for insert
  with check (
    user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UNIDADE_SAUDE')
  );

create policy "health_units_select_authenticated"
  on health_units for select
  using (auth.uid() is not null);

create policy "health_units_update_unit"
  on health_units for update
  using (
    exists (
      select 1
      from unit_profiles up
      where up.user_id = auth.uid()
        and up.health_unit_id = health_units.id
    )
  )
  with check (
    exists (
      select 1
      from unit_profiles up
      where up.user_id = auth.uid()
        and up.health_unit_id = health_units.id
    )
  );

create policy "tests_select_own"
  on tests for select
  using (patient_user_id = auth.uid());

create policy "tests_insert_own"
  on tests for insert
  with check (
    patient_user_id = auth.uid()
    and exists (select 1 from profiles p where p.id = auth.uid() and p.role = 'UTENTE')
  );

create policy "tests_select_unit"
  on tests for select
  using (
    exists (
      select 1
      from unit_profiles up
      where up.user_id = auth.uid()
        and up.health_unit_id = tests.health_unit_id
    )
  );

create policy "tests_update_unit"
  on tests for update
  using (
    exists (
      select 1
      from unit_profiles up
      where up.user_id = auth.uid()
        and up.health_unit_id = tests.health_unit_id
    )
  )
  with check (
    exists (
      select 1
      from unit_profiles up
      where up.user_id = auth.uid()
        and up.health_unit_id = tests.health_unit_id
    )
  );

create policy "test_results_select_own"
  on test_results for select
  using (
    exists (
      select 1 from tests t
      where t.id = test_results.test_id
        and t.patient_user_id = auth.uid()
    )
  );

create policy "test_results_select_unit"
  on test_results for select
  using (
    exists (
      select 1
      from tests t
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where t.id = test_results.test_id
        and up.user_id = auth.uid()
    )
  );

create policy "test_results_insert_unit"
  on test_results for insert
  with check (
    exists (
      select 1
      from tests t
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where t.id = test_results.test_id
        and up.user_id = auth.uid()
    )
  );

create policy "test_results_update_unit"
  on test_results for update
  using (
    exists (
      select 1
      from tests t
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where t.id = test_results.test_id
        and up.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from tests t
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where t.id = test_results.test_id
        and up.user_id = auth.uid()
    )
  );

create policy "identified_variables_select_own"
  on identified_variables for select
  using (
    exists (
      select 1
      from test_results tr
      join tests t on t.id = tr.test_id
      where tr.id = identified_variables.test_result_id
        and t.patient_user_id = auth.uid()
    )
  );

create policy "identified_variables_select_unit"
  on identified_variables for select
  using (
    exists (
      select 1
      from test_results tr
      join tests t on t.id = tr.test_id
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where tr.id = identified_variables.test_result_id
        and up.user_id = auth.uid()
    )
  );

create policy "identified_variables_insert_unit"
  on identified_variables for insert
  with check (
    exists (
      select 1
      from test_results tr
      join tests t on t.id = tr.test_id
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where tr.id = identified_variables.test_result_id
        and up.user_id = auth.uid()
    )
  );

create policy "identified_variables_update_unit"
  on identified_variables for update
  using (
    exists (
      select 1
      from test_results tr
      join tests t on t.id = tr.test_id
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where tr.id = identified_variables.test_result_id
        and up.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1
      from test_results tr
      join tests t on t.id = tr.test_id
      join unit_profiles up on up.health_unit_id = t.health_unit_id
      where tr.id = identified_variables.test_result_id
        and up.user_id = auth.uid()
    )
  );

create policy "notifications_select_own"
  on notifications for select
  using (user_id = auth.uid());

create policy "notifications_update_own"
  on notifications for update
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
