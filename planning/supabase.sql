-- Planning du mois : coffre chiffré, un rang par mot de passe.
-- À exécuter une fois dans l'éditeur SQL du projet Supabase (celui de Paper Soccer).
--
-- La page chiffre tout le planning dans le navigateur (AES-GCM, clé dérivée du mot de passe)
-- et n'envoie que ce bloc illisible. L'identifiant du rang est lui aussi dérivé du mot de passe :
-- sans lui, on ne peut ni trouver ni déchiffrer le rang. La table n'est jamais exposée directement,
-- seules les trois fonctions ci-dessous le sont.

create table if not exists public.planning_vault (
  id         text primary key check (id ~ '^[0-9a-f]{64}$'),
  data       text not null check (length(data) <= 700000),
  version    bigint not null default 1,
  updated_at timestamptz not null default now()
);
alter table public.planning_vault enable row level security;
revoke all on public.planning_vault from anon, authenticated;

create or replace function public.planning_get(p_id text)
returns table (data text, version bigint)
language sql stable security definer set search_path = ''
as $$
  select v.data, v.version from public.planning_vault v where v.id = p_id;
$$;

-- p_version = 0 : création (refusée au-delà de 20 rangs, pour éviter le remplissage par des inconnus).
-- Sinon : mise à jour seulement si la version en base est celle attendue. Renvoie la nouvelle version, ou -1 en cas de conflit.
create or replace function public.planning_put(p_id text, p_data text, p_version bigint)
returns bigint
language plpgsql security definer set search_path = ''
as $$
declare v bigint;
begin
  if p_version = 0 then
    if (select count(*) from public.planning_vault) >= 20 then
      raise exception 'planning_full';
    end if;
    insert into public.planning_vault (id, data) values (p_id, p_data)
      on conflict (id) do nothing returning version into v;
  else
    update public.planning_vault
       set data = p_data, version = version + 1, updated_at = now()
     where id = p_id and version = p_version
     returning version into v;
  end if;
  return coalesce(v, -1);
end $$;

create or replace function public.planning_delete(p_id text)
returns void
language sql security definer set search_path = ''
as $$
  delete from public.planning_vault where id = p_id;
$$;

revoke execute on function public.planning_get(text), public.planning_put(text, text, bigint), public.planning_delete(text) from public;
grant  execute on function public.planning_get(text), public.planning_put(text, text, bigint), public.planning_delete(text) to anon, authenticated;

notify pgrst, 'reload schema';
