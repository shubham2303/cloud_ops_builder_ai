--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

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
    updated_at timestamp without time zone NOT NULL
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
    updated_at timestamp without time zone NOT NULL
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: batch_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY batch_details ALTER COLUMN id SET DEFAULT nextval('batch_details_id_seq'::regclass);


--
-- Name: batches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY batches ALTER COLUMN id SET DEFAULT nextval('batches_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards ALTER COLUMN id SET DEFAULT nextval('cards_id_seq'::regclass);


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
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_batch_details_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_batch_details_on_batch_id ON batch_details USING btree (batch_id);


--
-- Name: index_batch_details_on_n; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_batch_details_on_n ON batch_details USING btree (n);


--
-- Name: index_cards_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cards_on_batch_id ON cards USING btree (batch_id);


--
-- Name: index_cards_on_x; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cards_on_x ON cards USING btree (x);


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
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('20170201130227'),
('20170217085303');


