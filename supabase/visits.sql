-- Conflict Atlas: simple visit counter
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.
-- Counts one visit per browser per day. Visitors can't read or edit the table
-- directly; they can only call the two functions below.

create table if not exists public.site_counter (
  id          int primary key default 1 check (id = 1),
  total       bigint not null default 0,
  updated_at  timestamptz not null default now()
);
insert into public.site_counter (id, total) values (1, 0) on conflict (id) do nothing;

alter table public.site_counter enable row level security;
revoke all on public.site_counter from anon, authenticated;

create or replace function public.count_visit() returns bigint
language sql security definer set search_path = public as $$
  update public.site_counter set total = total + 1, updated_at = now()
  where id = 1 returning total
$$;

create or replace function public.visit_total() returns bigint
language sql stable security definer set search_path = public as $$
  select total from public.site_counter where id = 1
$$;

revoke all on function public.count_visit() from public;
revoke all on function public.visit_total() from public;
grant execute on function public.count_visit() to anon;
grant execute on function public.visit_total() to anon;
