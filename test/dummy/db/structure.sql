--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

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
-- Name: meta_type_members; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meta_type_members (
    id integer NOT NULL,
    meta_type_id integer,
    meta_type_property_id integer,
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: meta_type_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meta_type_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_type_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meta_type_members_id_seq OWNED BY meta_type_members.id;


--
-- Name: meta_type_properties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meta_type_properties (
    id integer NOT NULL,
    sid character varying,
    label character varying NOT NULL,
    property_type_sid character varying NOT NULL,
    required boolean DEFAULT false NOT NULL,
    system boolean DEFAULT false NOT NULL,
    dimension character varying,
    default_value character varying,
    choices character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: meta_type_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meta_type_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_type_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meta_type_properties_id_seq OWNED BY meta_type_properties.id;


--
-- Name: meta_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE meta_types (
    id integer NOT NULL,
    sid character varying NOT NULL,
    title character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: meta_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE meta_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE meta_types_id_seq OWNED BY meta_types.id;


--
-- Name: moos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE moos (
    id integer NOT NULL,
    title character varying,
    notess hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: moos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE moos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE moos_id_seq OWNED BY moos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: things; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE things (
    id integer NOT NULL,
    meta_type_id integer,
    name character varying,
    properties_hstore hstore,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: things_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE things_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: things_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE things_id_seq OWNED BY things.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE meta_type_members ALTER COLUMN id SET DEFAULT nextval('meta_type_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE meta_type_properties ALTER COLUMN id SET DEFAULT nextval('meta_type_properties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE meta_types ALTER COLUMN id SET DEFAULT nextval('meta_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE moos ALTER COLUMN id SET DEFAULT nextval('moos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE things ALTER COLUMN id SET DEFAULT nextval('things_id_seq'::regclass);


--
-- Name: meta_type_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meta_type_members
    ADD CONSTRAINT meta_type_members_pkey PRIMARY KEY (id);


--
-- Name: meta_type_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meta_type_properties
    ADD CONSTRAINT meta_type_properties_pkey PRIMARY KEY (id);


--
-- Name: meta_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meta_types
    ADD CONSTRAINT meta_types_pkey PRIMARY KEY (id);


--
-- Name: meta_types_sid_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meta_types
    ADD CONSTRAINT meta_types_sid_key UNIQUE (sid);


--
-- Name: meta_types_title_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY meta_types
    ADD CONSTRAINT meta_types_title_key UNIQUE (title);


--
-- Name: moos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY moos
    ADD CONSTRAINT moos_pkey PRIMARY KEY (id);


--
-- Name: things_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY things
    ADD CONSTRAINT things_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: meta_type_members_meta_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meta_type_members
    ADD CONSTRAINT meta_type_members_meta_type_id_fkey FOREIGN KEY (meta_type_id) REFERENCES meta_types(id);


--
-- Name: meta_type_members_meta_type_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY meta_type_members
    ADD CONSTRAINT meta_type_members_meta_type_property_id_fkey FOREIGN KEY (meta_type_property_id) REFERENCES meta_type_properties(id);


--
-- Name: things_meta_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY things
    ADD CONSTRAINT things_meta_type_id_fkey FOREIGN KEY (meta_type_id) REFERENCES meta_types(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120507130230');

INSERT INTO schema_migrations (version) VALUES ('20120507130237');

INSERT INTO schema_migrations (version) VALUES ('20120507130255');

INSERT INTO schema_migrations (version) VALUES ('20120507130303');

INSERT INTO schema_migrations (version) VALUES ('20120508143058');

INSERT INTO schema_migrations (version) VALUES ('20120603195829');