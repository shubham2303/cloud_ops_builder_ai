--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying,
    body text,
    resource_id character varying NOT NULL,
    resource_type character varying NOT NULL,
    author_type character varying,
    author_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role character varying
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: agent_tables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE agent_tables (
    id integer NOT NULL,
    migration_version character varying,
    migration_target character varying,
    extras json,
    agent_id integer
);


--
-- Name: agent_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE agent_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agent_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE agent_tables_id_seq OWNED BY agent_tables.id;


--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE agents (
    id integer NOT NULL,
    phone character varying,
    address text,
    birthplace character varying,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    dob date,
    lga character varying,
    first_name character varying,
    last_name character varying,
    amount double precision DEFAULT 0.0,
    last_downsync timestamp without time zone,
    last_coll_offline timestamp without time zone,
    last_coll_online timestamp without time zone
);


--
-- Name: agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE agents_id_seq OWNED BY agents.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: batch_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE batch_details (
    id integer NOT NULL,
    n character varying NOT NULL,
    amount integer NOT NULL,
    batch_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remaining_amount integer
);


--
-- Name: batch_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE batch_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batch_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE batch_details_id_seq OWNED BY batch_details.id;


--
-- Name: batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE batches (
    id integer NOT NULL,
    location character varying,
    net_worth integer NOT NULL,
    details json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    count integer,
    batch_details_count integer
);


--
-- Name: batches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE batches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE batches_id_seq OWNED BY batches.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE businesses (
    id integer NOT NULL,
    name character varying,
    address text,
    turnover double precision,
    year character varying,
    lga character varying,
    individual_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    amount double precision DEFAULT 0.0,
    uuid character varying
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE businesses_id_seq OWNED BY businesses.id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cards (
    id integer NOT NULL,
    x character varying NOT NULL,
    y text NOT NULL,
    z text NOT NULL,
    amount integer NOT NULL,
    usage integer DEFAULT 0 NOT NULL,
    batch_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cards_id_seq OWNED BY cards.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE collections (
    id integer NOT NULL,
    category_type character varying,
    subtype character varying,
    number character varying,
    amount double precision,
    period character varying,
    agent_id integer,
    individual_id integer,
    batch_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lga character varying,
    collectionable_type character varying,
    collectionable_id integer,
    uuid character varying
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: frauds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE frauds (
    id integer NOT NULL,
    error json,
    object_type character varying,
    object_id integer,
    agent_id integer,
    message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: frauds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE frauds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: frauds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE frauds_id_seq OWNED BY frauds.id;


--
-- Name: individuals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE individuals (
    id integer NOT NULL,
    phone character varying,
    address text,
    uuid character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    amount double precision DEFAULT 0.0,
    first_name character varying,
    last_name character varying,
    lga character varying
);


--
-- Name: individuals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE individuals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: individuals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE individuals_id_seq OWNED BY individuals.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tokens (
    id integer NOT NULL,
    device_id character varying,
    token character varying,
    expiry timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    agent_id integer
);


--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tokens_id_seq OWNED BY tokens.id;


--
-- Name: upsync_errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE upsync_errors (
    id integer NOT NULL,
    error json,
    agent_id integer,
    message character varying,
    code character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: upsync_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upsync_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upsync_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upsync_errors_id_seq OWNED BY upsync_errors.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE vehicles (
    id integer NOT NULL,
    vehicle_number character varying,
    lga character varying,
    individual_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    amount double precision DEFAULT 0.0,
    phone character varying
);


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE vehicles_id_seq OWNED BY vehicles.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: agent_tables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agent_tables ALTER COLUMN id SET DEFAULT nextval('agent_tables_id_seq'::regclass);


--
-- Name: agents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agents ALTER COLUMN id SET DEFAULT nextval('agents_id_seq'::regclass);


--
-- Name: batch_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY batch_details ALTER COLUMN id SET DEFAULT nextval('batch_details_id_seq'::regclass);


--
-- Name: batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY batches ALTER COLUMN id SET DEFAULT nextval('batches_id_seq'::regclass);


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses ALTER COLUMN id SET DEFAULT nextval('businesses_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards ALTER COLUMN id SET DEFAULT nextval('cards_id_seq'::regclass);


--
-- Name: collections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: frauds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY frauds ALTER COLUMN id SET DEFAULT nextval('frauds_id_seq'::regclass);


--
-- Name: individuals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY individuals ALTER COLUMN id SET DEFAULT nextval('individuals_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tokens ALTER COLUMN id SET DEFAULT nextval('tokens_id_seq'::regclass);


--
-- Name: upsync_errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upsync_errors ALTER COLUMN id SET DEFAULT nextval('upsync_errors_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles ALTER COLUMN id SET DEFAULT nextval('vehicles_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: agent_tables agent_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY agent_tables
    ADD CONSTRAINT agent_tables_pkey PRIMARY KEY (id);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: batch_details batch_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY batch_details
    ADD CONSTRAINT batch_details_pkey PRIMARY KEY (id);


--
-- Name: batches batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY batches
    ADD CONSTRAINT batches_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: frauds frauds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY frauds
    ADD CONSTRAINT frauds_pkey PRIMARY KEY (id);


--
-- Name: individuals individuals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY individuals
    ADD CONSTRAINT individuals_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: upsync_errors upsync_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upsync_errors
    ADD CONSTRAINT upsync_errors_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_agent_tables_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agent_tables_on_agent_id ON agent_tables USING btree (agent_id);


--
-- Name: index_agents_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agents_on_created_at ON agents USING btree (created_at);


--
-- Name: index_agents_on_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_agents_on_phone ON agents USING btree (phone);


--
-- Name: index_batch_details_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_batch_details_on_batch_id ON batch_details USING btree (batch_id);


--
-- Name: index_batch_details_on_n; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_batch_details_on_n ON batch_details USING btree (n);


--
-- Name: index_batch_details_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_batch_details_on_updated_at ON batch_details USING btree (updated_at);


--
-- Name: index_businesses_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_created_at ON businesses USING btree (created_at);


--
-- Name: index_businesses_on_individual_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_individual_id ON businesses USING btree (individual_id);


--
-- Name: index_businesses_on_lga; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_lga ON businesses USING btree (lga);


--
-- Name: index_businesses_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_updated_at ON businesses USING btree (updated_at);


--
-- Name: index_businesses_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_businesses_on_uuid ON businesses USING btree (uuid);


--
-- Name: index_cards_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cards_on_batch_id ON cards USING btree (batch_id);


--
-- Name: index_cards_on_x; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cards_on_x ON cards USING btree (x);


--
-- Name: index_collections_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_agent_id ON collections USING btree (agent_id);


--
-- Name: index_collections_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_batch_id ON collections USING btree (batch_id);


--
-- Name: index_collections_on_collectionable_type_and_collectionable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_collectionable_type_and_collectionable_id ON collections USING btree (collectionable_type, collectionable_id);


--
-- Name: index_collections_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_created_at ON collections USING btree (created_at);


--
-- Name: index_collections_on_individual_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_individual_id ON collections USING btree (individual_id);


--
-- Name: index_collections_on_lga; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_lga ON collections USING btree (lga);


--
-- Name: index_collections_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_collections_on_number ON collections USING btree (number);


--
-- Name: index_collections_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_collections_on_uuid ON collections USING btree (uuid);


--
-- Name: index_frauds_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_frauds_on_agent_id ON frauds USING btree (agent_id);


--
-- Name: index_frauds_on_object_type_and_object_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_frauds_on_object_type_and_object_id ON frauds USING btree (object_type, object_id);


--
-- Name: index_individuals_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_individuals_on_created_at ON individuals USING btree (created_at);


--
-- Name: index_individuals_on_lga; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_individuals_on_lga ON individuals USING btree (lga);


--
-- Name: index_individuals_on_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_individuals_on_phone ON individuals USING btree (phone);


--
-- Name: index_individuals_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_individuals_on_updated_at ON individuals USING btree (updated_at);


--
-- Name: index_individuals_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_individuals_on_uuid ON individuals USING btree (uuid);


--
-- Name: index_tokens_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tokens_on_agent_id ON tokens USING btree (agent_id);


--
-- Name: index_tokens_on_device_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tokens_on_device_id ON tokens USING btree (device_id);


--
-- Name: index_upsync_errors_on_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_upsync_errors_on_agent_id ON upsync_errors USING btree (agent_id);


--
-- Name: index_vehicles_on_individual_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicles_on_individual_id ON vehicles USING btree (individual_id);


--
-- Name: index_vehicles_on_individual_id_and_vehicle_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicles_on_individual_id_and_vehicle_number ON vehicles USING btree (individual_id, vehicle_number);


--
-- Name: index_vehicles_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vehicles_on_updated_at ON vehicles USING btree (updated_at);


--
-- Name: index_vehicles_on_vehicle_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vehicles_on_vehicle_number ON vehicles USING btree (vehicle_number);


--
-- Name: batch_details fk_rails_15d85007e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY batch_details
    ADD CONSTRAINT fk_rails_15d85007e9 FOREIGN KEY (batch_id) REFERENCES batches(id);


--
-- Name: cards fk_rails_4cb86a2ad5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT fk_rails_4cb86a2ad5 FOREIGN KEY (batch_id) REFERENCES batches(id);


--
-- Name: tokens fk_rails_9f5991200a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tokens
    ADD CONSTRAINT fk_rails_9f5991200a FOREIGN KEY (agent_id) REFERENCES agents(id);


--
-- Name: businesses fk_rails_c963c0661c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT fk_rails_c963c0661c FOREIGN KEY (individual_id) REFERENCES individuals(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170201130227'),
('20170217085303'),
('20170221060001'),
('20170221060010'),
('20170221064942'),
('20170221074310'),
('20170221074416'),
('20170221083740'),
('20170221083751'),
('20170221094253'),
('20170221112515'),
('20170221113223'),
('20170221115541'),
('20170221192836'),
('20170228074039'),
('20170228123354'),
('20170302090654'),
('20170303053729'),
('20170308075429'),
('20170308075723'),
('20170308093023'),
('20170308102147'),
('20170308102840'),
('20170308110429'),
('20170308113820'),
('20170309052546'),
('20170316064718'),
('20170320093241'),
('20170324060026'),
('20170411124417'),
('20170412055509'),
('20170413062445'),
('20170413065615'),
('20170414082110'),
('20170414091430'),
('20170427065359'),
('20170502073718'),
('20170502092954'),
('20170502094617'),
('20170502095000'),
('20170502101741');


