--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: captions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE captions (
    id integer NOT NULL,
    text text,
    font character varying,
    top_left_x_pct double precision,
    top_left_y_pct double precision,
    width_pct double precision,
    height_pct double precision,
    gend_image_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: captions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE captions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: captions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE captions_id_seq OWNED BY captions.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: gend_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gend_images (
    id integer NOT NULL,
    id_hash character varying,
    src_image_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    content_type character varying,
    image bytea,
    height integer,
    size integer,
    width integer,
    work_in_progress boolean DEFAULT true,
    is_deleted boolean DEFAULT false,
    user_id integer,
    private boolean DEFAULT false,
    is_animated boolean DEFAULT false,
    error text,
    expires_at timestamp without time zone,
    image_hash text,
    average_color text,
    creator_ip text
);


--
-- Name: gend_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gend_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gend_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gend_images_id_seq OWNED BY gend_images.id;


--
-- Name: gend_thumbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE gend_thumbs (
    id integer NOT NULL,
    content_type character varying,
    gend_image_id integer,
    height integer,
    image bytea,
    size integer,
    width integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image_hash text,
    average_color text
);


--
-- Name: gend_thumbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE gend_thumbs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gend_thumbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE gend_thumbs_id_seq OWNED BY gend_thumbs.id;


--
-- Name: no_result_searches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE no_result_searches (
    id integer NOT NULL,
    query text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: no_result_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE no_result_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: no_result_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE no_result_searches_id_seq OWNED BY no_result_searches.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    id integer NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: src_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE src_images (
    id integer NOT NULL,
    id_hash character varying,
    url text,
    width integer,
    height integer,
    size integer,
    content_type character varying,
    image bytea,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    work_in_progress boolean DEFAULT true,
    is_deleted boolean DEFAULT false,
    name text,
    private boolean DEFAULT false,
    gend_images_count integer DEFAULT 0 NOT NULL,
    is_animated boolean DEFAULT false,
    error text,
    expires_at timestamp without time zone,
    image_hash text,
    average_color text,
    creator_ip text
);


--
-- Name: src_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE src_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: src_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE src_images_id_seq OWNED BY src_images.id;


--
-- Name: src_images_src_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE src_images_src_sets (
    src_image_id integer,
    src_set_id integer
);


--
-- Name: src_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE src_sets (
    id integer NOT NULL,
    name character varying,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_deleted boolean DEFAULT false,
    quality integer DEFAULT 0 NOT NULL
);


--
-- Name: src_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE src_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: src_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE src_sets_id_seq OWNED BY src_sets.id;


--
-- Name: src_thumbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE src_thumbs (
    id integer NOT NULL,
    src_image_id integer,
    width integer,
    height integer,
    size integer,
    image bytea,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    content_type character varying,
    image_hash text,
    average_color text
);


--
-- Name: src_thumbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE src_thumbs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: src_thumbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE src_thumbs_id_seq OWNED BY src_thumbs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying,
    password_digest character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_admin boolean DEFAULT false,
    api_token text,
    password_reset_token text,
    password_reset_expires_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY captions ALTER COLUMN id SET DEFAULT nextval('captions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gend_images ALTER COLUMN id SET DEFAULT nextval('gend_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY gend_thumbs ALTER COLUMN id SET DEFAULT nextval('gend_thumbs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY no_result_searches ALTER COLUMN id SET DEFAULT nextval('no_result_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_images ALTER COLUMN id SET DEFAULT nextval('src_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_sets ALTER COLUMN id SET DEFAULT nextval('src_sets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_thumbs ALTER COLUMN id SET DEFAULT nextval('src_thumbs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: captions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY captions
    ADD CONSTRAINT captions_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: gend_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gend_images
    ADD CONSTRAINT gend_images_pkey PRIMARY KEY (id);


--
-- Name: gend_thumbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY gend_thumbs
    ADD CONSTRAINT gend_thumbs_pkey PRIMARY KEY (id);


--
-- Name: no_result_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY no_result_searches
    ADD CONSTRAINT no_result_searches_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: src_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_images
    ADD CONSTRAINT src_images_pkey PRIMARY KEY (id);


--
-- Name: src_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_sets
    ADD CONSTRAINT src_sets_pkey PRIMARY KEY (id);


--
-- Name: src_thumbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY src_thumbs
    ADD CONSTRAINT src_thumbs_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_captions_on_gend_image_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_captions_on_gend_image_id ON captions USING btree (gend_image_id);


--
-- Name: index_gend_images_on_average_color; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_average_color ON gend_images USING btree (average_color);


--
-- Name: index_gend_images_on_error; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_error ON gend_images USING btree (error);


--
-- Name: index_gend_images_on_id_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gend_images_on_id_hash ON gend_images USING btree (id_hash);


--
-- Name: index_gend_images_on_image_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_image_hash ON gend_images USING btree (image_hash);


--
-- Name: index_gend_images_on_is_animated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_is_animated ON gend_images USING btree (is_animated);


--
-- Name: index_gend_images_on_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_is_deleted ON gend_images USING btree (is_deleted);


--
-- Name: index_gend_images_on_private; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_private ON gend_images USING btree (private);


--
-- Name: index_gend_images_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_images_on_user_id ON gend_images USING btree (user_id);


--
-- Name: index_gend_thumbs_on_average_color; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_thumbs_on_average_color ON gend_thumbs USING btree (average_color);


--
-- Name: index_gend_thumbs_on_gend_image_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_thumbs_on_gend_image_id ON gend_thumbs USING btree (gend_image_id);


--
-- Name: index_gend_thumbs_on_image_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gend_thumbs_on_image_hash ON gend_thumbs USING btree (image_hash);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_session_id ON sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON sessions USING btree (updated_at);


--
-- Name: index_src_images_on_average_color; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_average_color ON src_images USING btree (average_color);


--
-- Name: index_src_images_on_error; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_error ON src_images USING btree (error);


--
-- Name: index_src_images_on_gend_images_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_gend_images_count ON src_images USING btree (gend_images_count);


--
-- Name: index_src_images_on_id_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_src_images_on_id_hash ON src_images USING btree (id_hash);


--
-- Name: index_src_images_on_image_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_image_hash ON src_images USING btree (image_hash);


--
-- Name: index_src_images_on_is_animated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_is_animated ON src_images USING btree (is_animated);


--
-- Name: index_src_images_on_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_is_deleted ON src_images USING btree (is_deleted);


--
-- Name: index_src_images_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_name ON src_images USING btree (name);


--
-- Name: index_src_images_on_private; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_images_on_private ON src_images USING btree (private);


--
-- Name: index_src_images_src_sets_on_src_image_id_and_src_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_src_images_src_sets_on_src_image_id_and_src_set_id ON src_images_src_sets USING btree (src_image_id, src_set_id);


--
-- Name: index_src_sets_on_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_sets_on_is_deleted ON src_sets USING btree (is_deleted);


--
-- Name: index_src_sets_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_sets_on_name ON src_sets USING btree (name);


--
-- Name: index_src_sets_on_quality; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_sets_on_quality ON src_sets USING btree (quality);


--
-- Name: index_src_sets_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_sets_on_user_id ON src_sets USING btree (user_id);


--
-- Name: index_src_thumbs_on_average_color; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_thumbs_on_average_color ON src_thumbs USING btree (average_color);


--
-- Name: index_src_thumbs_on_image_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_src_thumbs_on_image_hash ON src_thumbs USING btree (image_hash);


--
-- Name: index_users_on_api_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_api_token ON users USING btree (api_token);


--
-- Name: index_users_on_is_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_is_admin ON users USING btree (is_admin);


--
-- Name: index_users_on_password_reset_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_password_reset_token ON users USING btree (password_reset_token);


--
-- Name: src_images_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX src_images_to_tsvector_idx ON src_images USING gin (to_tsvector('english'::regconfig, name));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20121201212212');

INSERT INTO schema_migrations (version) VALUES ('20121201215914');

INSERT INTO schema_migrations (version) VALUES ('20121206052011');

INSERT INTO schema_migrations (version) VALUES ('20121208064132');

INSERT INTO schema_migrations (version) VALUES ('20121208064414');

INSERT INTO schema_migrations (version) VALUES ('20121208070934');

INSERT INTO schema_migrations (version) VALUES ('20121209081928');

INSERT INTO schema_migrations (version) VALUES ('20121212063843');

INSERT INTO schema_migrations (version) VALUES ('20121213051820');

INSERT INTO schema_migrations (version) VALUES ('20121213070351');

INSERT INTO schema_migrations (version) VALUES ('20121218025528');

INSERT INTO schema_migrations (version) VALUES ('20121220054004');

INSERT INTO schema_migrations (version) VALUES ('20121220063250');

INSERT INTO schema_migrations (version) VALUES ('20121220065946');

INSERT INTO schema_migrations (version) VALUES ('20121222222948');

INSERT INTO schema_migrations (version) VALUES ('20130102025207');

INSERT INTO schema_migrations (version) VALUES ('20130102025223');

INSERT INTO schema_migrations (version) VALUES ('20130102044216');

INSERT INTO schema_migrations (version) VALUES ('20130105025257');

INSERT INTO schema_migrations (version) VALUES ('20130105065853');

INSERT INTO schema_migrations (version) VALUES ('20130109080014');

INSERT INTO schema_migrations (version) VALUES ('20130113054632');

INSERT INTO schema_migrations (version) VALUES ('20130116055207');

INSERT INTO schema_migrations (version) VALUES ('20130116055326');

INSERT INTO schema_migrations (version) VALUES ('20130116074545');

INSERT INTO schema_migrations (version) VALUES ('20130126072700');

INSERT INTO schema_migrations (version) VALUES ('20130308084654');

INSERT INTO schema_migrations (version) VALUES ('20130312050331');

INSERT INTO schema_migrations (version) VALUES ('20130511083437');

INSERT INTO schema_migrations (version) VALUES ('20130526045843');

INSERT INTO schema_migrations (version) VALUES ('20130527013239');

INSERT INTO schema_migrations (version) VALUES ('20130627041103');

INSERT INTO schema_migrations (version) VALUES ('20130627044401');

INSERT INTO schema_migrations (version) VALUES ('20130715032514');

INSERT INTO schema_migrations (version) VALUES ('20140723044551');

INSERT INTO schema_migrations (version) VALUES ('20150613203150');

INSERT INTO schema_migrations (version) VALUES ('20150619062758');

INSERT INTO schema_migrations (version) VALUES ('20150730035705');

INSERT INTO schema_migrations (version) VALUES ('20150818034625');

INSERT INTO schema_migrations (version) VALUES ('20150818040553');

INSERT INTO schema_migrations (version) VALUES ('20150818044048');

INSERT INTO schema_migrations (version) VALUES ('20151025062324');

INSERT INTO schema_migrations (version) VALUES ('20151025062928');

INSERT INTO schema_migrations (version) VALUES ('20151025063144');

INSERT INTO schema_migrations (version) VALUES ('20151025064342');

INSERT INTO schema_migrations (version) VALUES ('20151227053339');

INSERT INTO schema_migrations (version) VALUES ('20151227060507');

INSERT INTO schema_migrations (version) VALUES ('20160131055617');

INSERT INTO schema_migrations (version) VALUES ('20160203060839');

INSERT INTO schema_migrations (version) VALUES ('20160218045925');

INSERT INTO schema_migrations (version) VALUES ('20160224033002');

INSERT INTO schema_migrations (version) VALUES ('20160604043338');

INSERT INTO schema_migrations (version) VALUES ('20160604044147');

INSERT INTO schema_migrations (version) VALUES ('20160802032538');

