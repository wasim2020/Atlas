-- Conflict Atlas: visitor ratings & comments
-- Run once in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run.

create table if not exists public.feedback (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  rating      smallint    not null check (rating between 1 and 5),
  name        text        check (char_length(name) <= 40),
  comment     text        check (char_length(comment) <= 600),
  lang        text        check (lang in ('ar','en')),
  approved    boolean     not null default false
);

alter table public.feedback enable row level security;

-- Visitors (anon) may only INSERT these four columns; "approved" always starts false.
revoke all on public.feedback from anon, authenticated;
grant insert (rating, name, comment, lang) on public.feedback to anon;
grant select (id, created_at, rating, name, comment) on public.feedback to anon;

drop policy if exists "anon insert" on public.feedback;
create policy "anon insert" on public.feedback
  for insert to anon with check (approved = false);

-- Visitors can read ONLY comments you approved.
drop policy if exists "anon read approved" on public.feedback;
create policy "anon read approved" on public.feedback
  for select to anon using (approved = true);

-- Global flood protection: at most 20 submissions per minute site-wide.
create or replace function public.feedback_throttle() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if (select count(*) from public.feedback where created_at > now() - interval '1 minute') >= 20 then
    raise exception 'rate limit';
  end if;
  return new;
end $$;
drop trigger if exists feedback_throttle on public.feedback;
create trigger feedback_throttle before insert on public.feedback
  for each row execute function public.feedback_throttle();

-- Public average rating (counts all ratings, shows no text).
create or replace function public.feedback_stats() returns json
language sql stable security definer set search_path = public as $$
  select json_build_object('avg', round(avg(rating)::numeric, 2), 'count', count(*))
  from public.feedback
$$;
revoke all on function public.feedback_stats() from public;
grant execute on function public.feedback_stats() to anon;

-- Moderation: Table Editor -> feedback -> tick "approved" on a row to publish it
-- (or delete the row to discard it).
