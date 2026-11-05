-- ─────────────────────────────────────────────────────────────────────────────
-- Lumo — Database Schema
-- Run this in Supabase SQL Editor before running seed.sql
-- ─────────────────────────────────────────────────────────────────────────────

-- ── Extensions ───────────────────────────────────────────────────────────────
create extension if not exists "uuid-ossp";

-- ── Profiles ─────────────────────────────────────────────────────────────────
-- Extends Supabase auth.users. Created automatically via trigger on sign-up.
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  display_name  text,
  avatar_url    text,
  role          text not null default 'buyer' check (role in ('buyer', 'broker', 'admin')),
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Users can read any profile"
  on public.profiles for select using (true);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- Auto-create profile on sign-up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, display_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'display_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── Properties ───────────────────────────────────────────────────────────────
create table if not exists public.properties (
  id              uuid primary key default uuid_generate_v4(),
  broker_id       uuid references public.profiles(id) on delete set null,
  title           text not null,
  title_am        text,
  price_etb       numeric not null,
  neighborhood    text not null,
  city            text not null default 'Addis Ababa',
  property_type   text not null check (property_type in ('apartment','villa','house','land','commercial','office')),
  purpose         text not null check (purpose in ('sale','rent')),
  bedrooms        int not null default 0,
  bathrooms       int not null default 1,
  area_sqm        numeric,
  description_en  text,
  description_am  text,
  amenities       text[] not null default '{}',
  latitude        numeric,
  longitude       numeric,
  is_verified     boolean not null default false,
  is_featured     boolean not null default false,
  status          text not null default 'pending_review'
                    check (status in ('draft','pending_review','under_review','approved','rejected')),
  review_note     text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

alter table public.properties enable row level security;

-- Buyers can read approved listings
create policy "Anyone can read approved properties"
  on public.properties for select
  using (status = 'approved');

-- Brokers can read their own listings regardless of status
create policy "Brokers can read own properties"
  on public.properties for select
  using (auth.uid() = broker_id);

-- Brokers can insert their own listings
create policy "Brokers can insert properties"
  on public.properties for insert
  with check (auth.uid() = broker_id);

-- Brokers can update their own draft/rejected listings
create policy "Brokers can update own properties"
  on public.properties for update
  using (auth.uid() = broker_id and status in ('draft','rejected'));

-- Full-text search index on title
create index if not exists properties_title_fts
  on public.properties using gin(to_tsvector('english', title));

-- ── Property Media ────────────────────────────────────────────────────────────
create table if not exists public.property_media (
  id            uuid primary key default uuid_generate_v4(),
  property_id   uuid not null references public.properties(id) on delete cascade,
  url           text not null,
  display_order int not null default 0,
  created_at    timestamptz not null default now()
);

alter table public.property_media enable row level security;

create policy "Anyone can read property media"
  on public.property_media for select using (true);

create policy "Brokers can insert media for own properties"
  on public.property_media for insert
  with check (
    exists (
      select 1 from public.properties p
      where p.id = public.property_media.property_id
        and p.broker_id = auth.uid()
    )
  );

-- Service role (SQL Editor / backend) can always insert media
create policy "Service role can insert media"
  on public.property_media for insert
  with check (true);

create index if not exists property_media_property_id_idx
  on public.property_media(property_id);

-- ── Exchange Rates ────────────────────────────────────────────────────────────
create table if not exists public.exchange_rates (
  id            uuid primary key default uuid_generate_v4(),
  currency_pair text not null,
  etb_per_usd   numeric not null,
  updated_at    timestamptz not null default now()
);

alter table public.exchange_rates enable row level security;

create policy "Anyone can read exchange rates"
  on public.exchange_rates for select using (true);

-- Seed the initial exchange rate
insert into public.exchange_rates (currency_pair, etb_per_usd)
values ('ETB_USD', 125.5)
on conflict do nothing;
