--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO aziz;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO aziz;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO aziz;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO aziz;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO aziz;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO aziz;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.admins (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.admins OWNER TO aziz;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO aziz;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO aziz;

--
-- Name: brands; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.brands (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.brands OWNER TO aziz;

--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.brands_id_seq OWNER TO aziz;

--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.categories OWNER TO aziz;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO aziz;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: parfums; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.parfums (
    id bigint NOT NULL,
    name character varying,
    prix numeric,
    brand_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    categorie character varying,
    description text,
    category integer,
    fragrance_class integer,
    disponible boolean DEFAULT true,
    category_id bigint
);


ALTER TABLE public.parfums OWNER TO aziz;

--
-- Name: parfums_id_seq; Type: SEQUENCE; Schema: public; Owner: aziz
--

CREATE SEQUENCE public.parfums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.parfums_id_seq OWNER TO aziz;

--
-- Name: parfums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aziz
--

ALTER SEQUENCE public.parfums_id_seq OWNED BY public.parfums.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: aziz
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO aziz;

--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: parfums id; Type: DEFAULT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.parfums ALTER COLUMN id SET DEFAULT nextval('public.parfums_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
277	image	ActiveStorage::VariantRecord	184	277	2025-07-30 12:38:00.961384
282	image	ActiveStorage::VariantRecord	189	282	2025-07-30 16:11:04.661742
284	image	ActiveStorage::VariantRecord	191	284	2025-07-30 16:42:31.059337
124	image	Brand	28	124	2025-07-26 16:48:18.486278
125	image	ActiveStorage::VariantRecord	78	125	2025-07-26 16:48:19.181359
126	image	ActiveStorage::VariantRecord	79	126	2025-07-26 16:48:25.217982
288	image	ActiveStorage::VariantRecord	195	288	2025-07-30 17:15:30.582344
289	image	Brand	36	289	2025-07-30 17:37:15.74352
296	image	ActiveStorage::VariantRecord	201	296	2025-07-30 17:55:23.767294
130	image	Brand	29	130	2025-07-26 16:57:38.863898
131	image	ActiveStorage::VariantRecord	82	131	2025-07-26 16:57:39.713649
297	image	Parfum	86	297	2025-07-30 17:56:56.387175
133	image	ActiveStorage::VariantRecord	84	133	2025-07-26 17:00:27.52509
298	image	ActiveStorage::VariantRecord	202	298	2025-07-30 17:56:56.978585
135	image	ActiveStorage::VariantRecord	86	135	2025-07-26 17:00:28.570618
136	image	Brand	30	136	2025-07-26 17:01:33.005395
137	image	ActiveStorage::VariantRecord	87	137	2025-07-26 17:01:44.878962
138	image	ActiveStorage::VariantRecord	88	138	2025-07-26 17:06:38.338605
299	image	ActiveStorage::VariantRecord	203	299	2025-07-30 17:57:01.081011
300	image	ActiveStorage::VariantRecord	204	300	2025-07-30 17:57:09.44431
139	image	Brand	20	139	2025-07-26 17:09:57.748388
141	image	ActiveStorage::VariantRecord	90	141	2025-07-26 17:18:10.696849
306	image	Parfum	87	306	2025-07-30 18:00:16.903853
143	image	ActiveStorage::VariantRecord	92	143	2025-07-26 17:18:12.18437
307	image	ActiveStorage::VariantRecord	209	307	2025-07-30 18:00:18.70579
144	image	ActiveStorage::VariantRecord	93	144	2025-07-26 17:18:12.649473
145	image	ActiveStorage::VariantRecord	94	145	2025-07-26 17:18:12.718595
308	image	ActiveStorage::VariantRecord	210	308	2025-07-30 18:00:21.852544
309	image	ActiveStorage::VariantRecord	211	309	2025-07-30 18:00:26.66753
148	image	Brand	31	148	2025-07-26 17:27:04.485097
149	image	ActiveStorage::VariantRecord	96	149	2025-07-26 17:27:05.520622
150	image	ActiveStorage::VariantRecord	97	150	2025-07-26 17:49:00.703246
310	image	ActiveStorage::VariantRecord	212	310	2025-07-30 18:00:41.130049
152	image	ActiveStorage::VariantRecord	99	152	2025-07-26 18:34:21.71826
153	image	Brand	32	153	2025-07-26 18:38:34.411335
154	image	ActiveStorage::VariantRecord	100	154	2025-07-26 18:38:35.935932
155	image	ActiveStorage::VariantRecord	101	155	2025-07-26 18:38:45.246419
316	image	Parfum	88	316	2025-07-30 18:11:27.159631
317	image	ActiveStorage::VariantRecord	217	317	2025-07-30 18:11:28.290713
318	image	ActiveStorage::VariantRecord	218	318	2025-07-30 18:11:35.367058
162	image	Brand	13	162	2025-07-26 18:55:55.053837
163	image	ActiveStorage::VariantRecord	106	163	2025-07-26 18:55:56.427891
164	image	ActiveStorage::VariantRecord	107	164	2025-07-26 18:56:02.247667
319	image	ActiveStorage::VariantRecord	219	319	2025-07-30 18:11:46.686452
320	image	ActiveStorage::VariantRecord	220	320	2025-07-31 11:58:19.918338
327	image	Brand	38	327	2025-07-31 12:40:06.222706
328	image	ActiveStorage::VariantRecord	225	328	2025-07-31 12:40:06.83011
329	image	Parfum	90	329	2025-07-31 12:41:02.639393
330	image	ActiveStorage::VariantRecord	226	330	2025-07-31 12:41:03.353514
331	image	ActiveStorage::VariantRecord	227	331	2025-07-31 12:41:14.941387
332	image	ActiveStorage::VariantRecord	228	332	2025-07-31 12:41:24.347287
334	image	ActiveStorage::VariantRecord	230	334	2025-07-31 13:23:45.584214
336	image	Parfum	91	336	2025-07-31 14:19:30.822747
337	image	ActiveStorage::VariantRecord	232	337	2025-07-31 14:19:32.765426
338	image	ActiveStorage::VariantRecord	233	338	2025-07-31 14:19:51.560962
340	image	ActiveStorage::VariantRecord	235	340	2025-07-31 14:20:20.414736
350	image	Parfum	94	350	2025-08-01 11:47:20.92583
351	image	ActiveStorage::VariantRecord	243	351	2025-08-01 11:47:22.931472
176	image	Brand	2	176	2025-07-26 19:00:37.787232
177	image	ActiveStorage::VariantRecord	114	177	2025-07-26 19:00:40.123518
178	image	Brand	14	178	2025-07-26 19:01:13.521545
179	image	ActiveStorage::VariantRecord	115	179	2025-07-26 19:01:15.59838
180	image	Brand	21	180	2025-07-26 19:01:43.983453
181	image	ActiveStorage::VariantRecord	116	181	2025-07-26 19:01:45.475844
182	image	Brand	22	182	2025-07-26 19:02:29.920906
183	image	ActiveStorage::VariantRecord	117	183	2025-07-26 19:02:32.016353
184	image	Brand	23	184	2025-07-26 19:03:02.96211
185	image	ActiveStorage::VariantRecord	118	185	2025-07-26 19:03:04.972231
186	image	Brand	24	186	2025-07-26 19:03:31.240048
187	image	ActiveStorage::VariantRecord	119	187	2025-07-26 19:03:33.206602
352	image	ActiveStorage::VariantRecord	244	352	2025-08-01 11:47:31.66381
355	image	Parfum	95	355	2025-08-01 13:48:28.536437
190	image	Brand	4	190	2025-07-26 19:04:33.476577
191	image	ActiveStorage::VariantRecord	121	191	2025-07-26 19:04:36.997011
192	image	Brand	19	192	2025-07-26 19:05:09.891176
193	image	ActiveStorage::VariantRecord	122	193	2025-07-26 19:05:12.865533
194	image	Brand	27	194	2025-07-26 19:05:49.654427
195	image	ActiveStorage::VariantRecord	123	195	2025-07-26 19:05:54.134704
196	image	Brand	12	196	2025-07-26 19:06:28.511281
197	image	ActiveStorage::VariantRecord	124	197	2025-07-26 19:06:32.093126
201	image	Brand	17	201	2025-07-26 19:08:02.784117
202	image	ActiveStorage::VariantRecord	127	202	2025-07-26 19:08:06.719709
203	image	Brand	6	203	2025-07-26 19:10:06.340619
204	image	ActiveStorage::VariantRecord	128	204	2025-07-26 19:10:12.275794
205	image	Brand	33	205	2025-07-26 19:11:35.979626
206	image	ActiveStorage::VariantRecord	129	206	2025-07-26 19:11:42.157939
212	image	ActiveStorage::VariantRecord	133	212	2025-07-27 14:41:08.36549
278	image	ActiveStorage::VariantRecord	185	278	2025-07-30 12:43:15.677771
279	image	ActiveStorage::VariantRecord	186	279	2025-07-30 12:43:21.707639
281	image	ActiveStorage::VariantRecord	187	281	2025-07-30 15:51:38.332309
283	image	ActiveStorage::VariantRecord	190	283	2025-07-30 16:28:07.839178
285	image	ActiveStorage::VariantRecord	192	285	2025-07-30 16:42:31.164769
287	image	ActiveStorage::VariantRecord	194	287	2025-07-30 17:15:24.349468
290	image	ActiveStorage::VariantRecord	196	290	2025-07-30 17:37:16.715459
223	image	Parfum	75	223	2025-07-28 12:25:54.892799
224	image	ActiveStorage::VariantRecord	142	224	2025-07-28 12:25:56.264912
225	image	ActiveStorage::VariantRecord	143	225	2025-07-28 12:25:58.441121
291	image	ActiveStorage::VariantRecord	197	291	2025-07-30 17:37:19.214746
292	image	Parfum	85	292	2025-07-30 17:40:48.173217
293	image	ActiveStorage::VariantRecord	198	293	2025-07-30 17:40:48.911411
294	image	ActiveStorage::VariantRecord	199	294	2025-07-30 17:40:54.750419
230	image	Brand	34	230	2025-07-28 16:07:30.574169
295	image	ActiveStorage::VariantRecord	200	295	2025-07-30 17:41:06.905544
311	image	ActiveStorage::VariantRecord	213	311	2025-07-30 18:08:51.668973
321	image	Parfum	89	321	2025-07-31 12:21:16.448906
234	image	ActiveStorage::VariantRecord	149	234	2025-07-28 16:14:22.596373
322	image	ActiveStorage::VariantRecord	221	322	2025-07-31 12:21:18.051431
236	image	Brand	35	236	2025-07-28 19:22:12.641912
323	image	ActiveStorage::VariantRecord	222	323	2025-07-31 12:21:25.832569
324	image	ActiveStorage::VariantRecord	223	324	2025-07-31 12:21:54.154315
333	image	ActiveStorage::VariantRecord	229	333	2025-07-31 13:23:45.482554
241	image	ActiveStorage::VariantRecord	154	241	2025-07-28 19:27:43.936886
242	image	ActiveStorage::VariantRecord	155	242	2025-07-28 19:28:16.235111
243	image	Parfum	79	243	2025-07-29 17:48:39.147523
244	image	ActiveStorage::VariantRecord	156	244	2025-07-29 17:48:45.329073
245	image	ActiveStorage::VariantRecord	157	245	2025-07-29 17:48:47.087183
335	image	ActiveStorage::VariantRecord	231	335	2025-07-31 14:08:50.490115
339	image	ActiveStorage::VariantRecord	234	339	2025-07-31 14:20:20.341033
342	image	Parfum	92	342	2025-07-31 14:46:10.371456
249	image	Parfum	81	249	2025-07-29 17:55:11.023089
250	image	ActiveStorage::VariantRecord	160	250	2025-07-29 17:55:12.199225
251	image	ActiveStorage::VariantRecord	161	251	2025-07-29 17:55:18.341951
252	image	ActiveStorage::VariantRecord	162	252	2025-07-29 17:55:23.69923
253	image	ActiveStorage::VariantRecord	163	253	2025-07-29 18:03:40.538871
343	image	ActiveStorage::VariantRecord	237	343	2025-07-31 14:46:11.748288
344	image	ActiveStorage::VariantRecord	238	344	2025-07-31 14:46:32.351201
345	image	ActiveStorage::VariantRecord	239	345	2025-07-31 14:46:47.353595
346	image	Parfum	93	346	2025-07-31 14:47:57.162426
265	image	ActiveStorage::VariantRecord	172	265	2025-07-30 11:30:04.981199
347	image	ActiveStorage::VariantRecord	240	347	2025-07-31 14:47:58.867997
267	image	ActiveStorage::VariantRecord	174	267	2025-07-30 11:47:38.066228
268	image	ActiveStorage::VariantRecord	175	268	2025-07-30 11:47:38.154416
269	image	ActiveStorage::VariantRecord	176	269	2025-07-30 11:47:54.709604
348	image	ActiveStorage::VariantRecord	241	348	2025-07-31 14:48:21.168436
349	image	ActiveStorage::VariantRecord	242	349	2025-07-31 14:48:39.941542
353	image	ActiveStorage::VariantRecord	245	353	2025-08-01 11:47:55.860422
354	image	ActiveStorage::VariantRecord	246	354	2025-08-01 11:48:14.355242
274	image	ActiveStorage::VariantRecord	181	274	2025-07-30 12:07:59.283454
275	image	ActiveStorage::VariantRecord	182	275	2025-07-30 12:07:59.377868
276	image	ActiveStorage::VariantRecord	183	276	2025-07-30 12:08:20.71013
356	image	ActiveStorage::VariantRecord	247	356	2025-08-01 13:48:30.389198
357	image	ActiveStorage::VariantRecord	248	357	2025-08-01 13:48:37.16858
358	image	ActiveStorage::VariantRecord	249	358	2025-08-01 13:48:56.632036
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
274	eomq29b4m6mgyavcb4nib0mv12mz	la nuit de l'homme.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	23834	MT5+zLJhfoNwDs/MXXV6hw==	2025-07-30 12:07:59.231122
281	5z2aeaunc0jv1htsfy03joif19en	chopard.png	image/png	{"identified":true,"width":225,"height":225,"analyzed":true}	local	3136	zhFztSScoDqA5eVPHdGY1Q==	2025-07-30 15:51:38.299734
288	rnfyeqq66ls7lbnw8pvgqo0j4sd3	mfk.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1867	//dgseAtM31ZcZlZyJ+MmQ==	2025-07-30 17:15:30.561467
306	o8nn3c1yoqwymzjjs1xgdqt719jt	y le parfum.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	26923	oLcLVrc3b/zjQzCW8t57/g==	2025-07-30 18:00:16.889454
126	8agovpsnf186kar0zub5c98lt5f0	By Kilian.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1637	4zdKa4hgpxIEzeKCCpgW2A==	2025-07-26 16:48:25.213443
307	4iwkadpmh6u5cam07onzypnih64r	y le parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	11904	dMCdMau4+dpIoREHMzH/0g==	2025-07-30 18:00:18.694053
308	5erg9qzkvwj2hnite8xna4agjvij	y le parfum.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	18979	JKn1SuCU0sFFu/jfTdT/yQ==	2025-07-30 18:00:21.848504
309	1pqkngbf69spm942lbmq96v3odtk	y le parfum.jpg	image/jpeg	{"identified":true,"width":75,"height":100,"analyzed":true}	local	2868	HjdzQDcGwGd/Vt8NFHrTEQ==	2025-07-30 18:00:26.656144
310	e0wyapkkv7rjz2zryr8oos8acsin	y le parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	11904	dMCdMau4+dpIoREHMzH/0g==	2025-07-30 18:00:41.124977
318	l465ozt3jhdxyb5lvgqtxv70ehfr	black sea.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	51477	zvc1RUcdc9x8Z1m/GNImNQ==	2025-07-30 18:11:35.357825
319	j5wzzseq7rq36yt2y2abtpem41z9	black sea.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	31939	vvJeUnyRBwlcLiumTTiRiw==	2025-07-30 18:11:46.682312
124	cl90bcoxhwu1ke27pd5zr0m1w7mj	By Kilian.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6718	vF/GXUSQRq+Y1iHJt6HkRw==	2025-07-26 16:48:18.470376
125	f3e2opv75y9coe892die4zrusso8	By Kilian.jpg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	4201	O6FtQCTdzDnsB0AGTfC8Bg==	2025-07-26 16:48:19.176441
316	3rcwcw3afs8qobqlschup39wlpty	black sea.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	81378	qIePpp7uWiXnxOFhRImPHA==	2025-07-30 18:11:27.156381
317	idlvazoha1kn5vlx7eat2ae7cahi	black sea.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	31939	vvJeUnyRBwlcLiumTTiRiw==	2025-07-30 18:11:28.283643
337	nh1r046twhohvxm9t4x3prkvs75m	Torino 21.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	23535	jE34/JpK9L8QCQhhDxIVkw==	2025-07-31 14:19:32.746492
336	1v3wlx6fgsewktk6l0l54a5ixbsg	Torino 21.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	51579	CPxfrOorCu+Dp+K4LXbUFw==	2025-07-31 14:19:30.806613
130	ydp7gu2menkbvgjhawxhvm8l8l0w	le labo.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7311	PWP6EyWILdtSeEBbO/FlQA==	2025-07-26 16:57:38.85267
338	fafgq1y5t52fkfzztljqkhqnbh3w	Torino 21.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	36583	GQXMxn3nY6h7l3U4wu/3cQ==	2025-07-31 14:19:51.553577
131	grfplk8gktkspzmn0boiu1bzwpye	le labo.jpg	image/jpeg	{"identified":true,"width":200,"height":200,"analyzed":true}	local	4542	fzq9vcCrr9piuEUU9HSEPg==	2025-07-26 16:57:39.704782
340	lq964vtuvx83ird6uj3bg8m0wrpj	Xerjoff.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6865	kOQijZHp0iLAJXNi7UxC1A==	2025-07-31 14:20:20.400954
349	vhc4519g8hi689c4q8yxlrdullh9	tuxedo.png	image/png	{"identified":true,"width":225,"height":300,"analyzed":true}	local	30724	ZTFKKkih95fxPPMlT5HyLw==	2025-07-31 14:48:39.933194
133	pm6ynl28xaz5mpc66cfsy8poclig	le labo.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1857	65k65ZMlwFzja6EO+qKRgA==	2025-07-26 17:00:27.510981
355	ynpqinzdoxzis3ihjos9kmz70g2t	baccarat rouge.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	68749	kFmmDHx5cEdkW4R69YL2yw==	2025-08-01 13:48:28.524217
135	80o2phnp3v71rfncyy7se88sp5zn	By Kilian.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1637	4zdKa4hgpxIEzeKCCpgW2A==	2025-07-26 17:00:28.557506
136	lithcu6vepq4lexyrm736o4eskzd	maison crivelli.jpg	image/jpeg	{"identified":true,"width":300,"height":293,"analyzed":true}	local	26874	EXi6o6Lkrg4eL+dMgHMSlg==	2025-07-26 17:01:33.002251
137	omgmamnn069r3b2gfaz2ypx70tmc	maison crivelli.jpg	image/jpeg	{"identified":true,"width":102,"height":100,"analyzed":true}	local	6374	W3Irp9ldrXYGRrTj8Dhl/w==	2025-07-26 17:01:44.871904
138	bx2dtfmsvwj4r4xqneftkxq3p6fp	le labo.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1857	65k65ZMlwFzja6EO+qKRgA==	2025-07-26 17:06:38.328401
139	qdni4yho3q36ltuzze1dr1qdas79	bvlgari.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4005	Utsv54wxuiT44hUrPMBm9w==	2025-07-26 17:09:57.744985
356	9txw88m97mfx58qpp2a80y10ya8e	baccarat rouge.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	32024	O0bg2mzVQwDp5o29jsJc7w==	2025-08-01 13:48:30.374884
141	ky8ri5fhpvsrarcnmfqbw68taxye	maison crivelli.jpg	image/jpeg	{"identified":true,"width":300,"height":293,"analyzed":true}	local	28418	zcmoBtYg39NPBtlABQWVyQ==	2025-07-26 17:18:10.681632
143	rxlqgqhd3vhjvvlt2560a9vqdqql	By Kilian.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6956	8m5lBlRgqa97Sjnf3jkVPA==	2025-07-26 17:18:12.175777
144	isqzrw30wadi6sf37j0zrg1lsihk	bvlgari.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4055	XSSbaUoXX9ZVhmoNZexytA==	2025-07-26 17:18:12.641007
145	2fx54q2j4c9zfve93i628ydy78wf	le labo.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7591	APGMlKTjOMsrLSY99DgTrg==	2025-07-26 17:18:12.698956
162	3h89ukv9pdgkqidkjo7oo5xdn7me	versace.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	8038	l/Ax2YvcEquXLupaXCJkKA==	2025-07-26 18:55:55.050135
163	91efhi5h29ipstoqumny02jhylg7	versace.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	9204	6lhsEnlzYbwbJ6FoJSzGdw==	2025-07-26 18:55:56.405144
164	vclxyud6etfsurdajpk3yjpd9rhz	versace.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	2084	rZWJHEYJheCXg/kqii731w==	2025-07-26 18:56:02.241212
203	hdxs1dwo7tuiw0hp3v2kpcbh78mo	ysl.jpg	image/jpeg	{"identified":true,"width":1000,"height":643,"analyzed":true}	local	62621	t+N91CAVtHzvV1HnU28Y3w==	2025-07-26 19:10:06.334659
206	aethejchueoboldofhz81dhy9af2	Viktor & rolf.png	image/png	{"identified":true,"width":400,"height":249,"analyzed":true}	local	6596	zGq6th6tL3V8nwPdgVGHGg==	2025-07-26 19:11:42.153509
275	l1cx34a0ogcv1affnjogleg6r0tz	ysl.jpg	image/jpeg	{"identified":true,"width":467,"height":300,"analyzed":true}	local	19722	jFI05nuUKRNnyldb0eo8fg==	2025-07-30 12:07:59.325136
276	2346v5g2pqhsfy72b3t9li0q016g	jean paul gaultier.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	9862	eNPoAFh4wMRunHUde1FHHg==	2025-07-30 12:08:20.69324
282	l3ipxrndp4joba1985d67gwwi28p	nishane.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6833	YoW0N9cJ6tNa5F2zvlBtfA==	2025-07-30 16:11:04.62875
287	yy0m91h4g3cw0okvjlravrt7bj63	mfk.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	9048	/XmL2vyl39PcRHWfYYBnRA==	2025-07-30 17:15:24.313237
224	2b0nx3oee0w4ueyd2z51wfw4101f	la nuit de l'homme.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	23834	MT5+zLJhfoNwDs/MXXV6hw==	2025-07-28 12:25:56.259516
225	4y7dez0rj7iby3z94yngovhbam4c	la nuit de l'homme.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	37101	K9nu7uVosDF9ATPVY/adiQ==	2025-07-28 12:25:58.432552
311	4z86r1kymkf3vpjsokmusc6jtwk2	Lorenzo Pazzaglia.png	image/png	{"identified":true,"width":340,"height":300,"analyzed":true}	local	57176	lEUM3BgUbuDTT4eJtYGU4A==	2025-07-30 18:08:51.66374
327	gvucjml3hkfl8410bxbi8upchdb4	chanel.jpg	image/jpeg	{"identified":true,"width":499,"height":234,"analyzed":true}	local	10101	QihL3o12u85+VrL+3TvWrA==	2025-07-31 12:40:06.216922
328	vls5vvsbhconhti049tq9e9c85sm	chanel.jpg	image/jpeg	{"identified":true,"width":400,"height":188,"analyzed":true}	local	8813	Guv8q+jMipgh65Xca5TgMQ==	2025-07-31 12:40:06.818227
329	f8fk84vp30nad4ss42i98pj6pecl	le-lion.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	36692	QZspf7PHAWWaP1puX5ntSQ==	2025-07-31 12:41:02.634239
330	qtegk3w2lryo1bkuvb6nwa9gd6vm	le-lion.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	17382	8undfMa849w8NJ7Zmalm5w==	2025-07-31 12:41:03.344554
331	zza4bvltcqtj5wc3ejkjpegm45te	le-lion.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	26834	f6gI6IFBLbMnJTmJU/48tw==	2025-07-31 12:41:14.933701
243	50ib2a08qerlybcfpkvspahbxwnv	ombré leather.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	30915	4gVK5nC9yKU3QqBrks95Qg==	2025-07-29 17:48:39.124105
244	m4kpe26ta2yuudumcrb7hw42iygk	ombré leather.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	14236	5k+xLAsSlUXAp9PaqibQMw==	2025-07-29 17:48:45.313374
245	4f1n7cbiark19nja9p6f5h8yg3rj	ombré leather.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	22085	pdCJFsuSM0pGy74dIJdmAQ==	2025-07-29 17:48:47.079424
253	3p9lixe2ob008anxfh2d14rjbdlk	ombré leather.jpg	image/jpeg	{"identified":true,"width":75,"height":100,"analyzed":true}	local	3142	tG8NBhrSF14WohIhQR2qtg==	2025-07-29 18:03:40.502225
265	8uw79pfx05reybzhdzsuuyn3ftvk	Viktor & rolf.png	image/png	{"identified":true,"width":100,"height":62,"analyzed":true}	local	1299	pFMedVPRTliPnUALk78phw==	2025-07-30 11:30:04.95081
332	mfdsox3ygsi18iva495ua3kamash	le-lion.jpg	image/jpeg	{"identified":true,"width":75,"height":100,"analyzed":true}	local	3634	VvIDZGaVlP32alWAUFBFIw==	2025-07-31 12:41:24.335049
339	p0spbird3tceuch62ypttp8hrwdn	Torino 21.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	23535	jE34/JpK9L8QCQhhDxIVkw==	2025-07-31 14:20:20.329085
350	5zbkij9cwop9291kiaizhq9xoejg	bleu de chanel.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	51294	KUC8nWpsnWTeoNDYq87e9Q==	2025-08-01 11:47:20.892909
351	epzxtd2e84b4txxwfu7k4atzicq8	bleu de chanel.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25646	w4TJ4huEuKMuxelg+0Xd+g==	2025-08-01 11:47:22.917893
352	72x1iydlrruiz573cs55j3pc4iet	bleu de chanel.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	38595	tsEBrF2eYZSAgzA4ja4LUg==	2025-08-01 11:47:31.658311
357	29qa9yntg6be9a8ladt2n9pnmzrg	baccarat rouge.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	50346	RI1Xej9udBZ2gAd4DOq7zg==	2025-08-01 13:48:37.162339
358	pw3bz9ljcx5o5p5k47ukggsamk7b	baccarat rouge.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	32024	O0bg2mzVQwDp5o29jsJc7w==	2025-08-01 13:48:56.62694
148	jv7dfwwl7ygp833ojnwpf9r7txzh	nishane.jpg	image/jpeg	{"identified":true,"width":900,"height":900,"analyzed":true}	local	23422	aLKVvhhrU5l1gkdVAFxL3Q==	2025-07-26 17:27:04.477262
149	i4k5e5pcp7ltnw5hwrr4k5kt0aqt	nishane.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	9865	Vnj0cbnqFvk2y6KrSeLoew==	2025-07-26 17:27:05.516693
204	8oga2s9093b56tn3pwy03tqcw9oc	ysl.jpg	image/jpeg	{"identified":true,"width":400,"height":257,"analyzed":true}	local	15943	8txW+sbX4plvvn0+/0U8ww==	2025-07-26 19:10:12.270852
205	9zblnnt75liz4kwpwc7ewiy3waz8	Viktor & rolf.png	image/png	{"identified":true,"width":1200,"height":748,"analyzed":true}	local	23785	V/HhZTI47Hy1X6263qYFaw==	2025-07-26 19:11:35.976826
277	w8fs1btp6iod2o31pksfp6oxh9ko	dolce & gabbana.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5486	Hn0740Uy3Tzg6uDVn6+1NQ==	2025-07-30 12:38:00.920913
283	cfbemk36387kdb0emxww8i0rd7id	giorgio armani.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5512	3buy8+uklTJroRfGHyT1Ew==	2025-07-30 16:28:07.811825
230	ahtgp5p6sca3yqmpv3fl0s7oi0c1	Lorenzo Pazzaglia.png	image/png	{"identified":true,"width":764,"height":674,"analyzed":true}	local	146701	Y9NcJqK41eu2/VdzlqxcwQ==	2025-07-28 16:07:30.562642
289	ix8eh7cpto8vypxk75pgss6noho3	amouage.jpg	image/jpeg	{"identified":true,"width":458,"height":458,"analyzed":true}	local	6554	pKWqLt3up/JUIaQH0HjH0Q==	2025-07-30 17:37:15.7325
320	8d0dkvefu9evjs2j9i1qnj43d5yf	frederic malle.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	12125	3mTFu8geZSsmgfbf3aQ8Vw==	2025-07-31 11:58:19.876304
333	idir2qinkfjewvyf6s1sp37f89dq	chanel.jpg	image/jpeg	{"identified":true,"width":499,"height":234,"analyzed":true}	local	10818	KkcGWQXtcmg74fEzPzlb6w==	2025-07-31 13:23:45.436941
353	mdgh611r65c795dp6q7ll87tuuxb	bleu de chanel.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25646	w4TJ4huEuKMuxelg+0Xd+g==	2025-08-01 11:47:55.846823
354	mrige5pcq4zi89uvdhd3mim10aqx	bleu de chanel.jpg	image/jpeg	{"identified":true,"width":75,"height":100,"analyzed":true}	local	5143	cgGxhH0C7YP8sIS8NNR7Vg==	2025-08-01 11:48:14.347242
267	ea64cnt5jlqn187rr0fp3d8t7shp	dior homme intense.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25406	m/T5wE1PbhdoHqEeQo1AUw==	2025-07-30 11:47:38.058719
269	iwx3shsh8jbt5otwxq7wc4kx154i	By Kilian.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6956	8m5lBlRgqa97Sjnf3jkVPA==	2025-07-30 11:47:54.706124
150	j9w55sen3gxt86lgkg3y2vigndk7	bvlgari.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1129	yYJNSu/CRDN7d2/soz8VQA==	2025-07-26 17:49:00.650642
278	bb0s033jva7d0m111kow1dprl0ue	bvlgari.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4055	XSSbaUoXX9ZVhmoNZexytA==	2025-07-30 12:43:15.649545
152	ir975oxjdo88i4784ngjot9pjnqh	maison crivelli.jpg	image/jpeg	{"identified":true,"width":100,"height":98,"analyzed":true}	local	6112	MEC1oLznI4Idx9KcvQffig==	2025-07-26 18:34:21.692178
153	lpks9a5cyp8xtlxh3i9tdc3rt74x	Xerjoff.jpg	image/jpeg	{"identified":true,"width":699,"height":699,"analyzed":true}	local	13886	q0Uqfdg0hXMQ0KZiGRIVFQ==	2025-07-26 18:38:34.394067
154	688071dhz5279p3nt9xn085p45ay	Xerjoff.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	9798	EthtvSJYuytYP5doXCJXRg==	2025-07-26 18:38:35.928026
155	5cvi3xtzl9dmmd4dqpn8s6s2m16x	Xerjoff.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1833	y2JGhUZvwBRNQN8qbr1I9w==	2025-07-26 18:38:45.241573
279	m0v81nzoczgu7bwhhvu27zyly1ro	le labo.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7591	APGMlKTjOMsrLSY99DgTrg==	2025-07-30 12:43:21.699341
177	iub6gf5igq7aeao64knyvn1710o2	dior.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	8330	0VJXvIwt5VkOW6o8woWtnw==	2025-07-26 19:00:40.113896
178	f3z84fmqvaacl4hgjrxa2oan4q6q	dolce & gabbana.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4495	XAiGa5MJBIGi1Fn13pWyag==	2025-07-26 19:01:13.517782
179	uc849ar33kmcjc2oxm7wlcwr6rkt	dolce & gabbana.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5486	Hn0740Uy3Tzg6uDVn6+1NQ==	2025-07-26 19:01:15.585809
180	jwouzjwwalliwkkob7fgd2a6370y	frederic malle.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	10462	+xl3wJWCyWFPOHyOaPm1mA==	2025-07-26 19:01:43.979292
181	xnmeojouzcttfet0ww36rcb2czsv	frederic malle.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	12125	3mTFu8geZSsmgfbf3aQ8Vw==	2025-07-26 19:01:45.468257
182	acorfirrh1p8v4s52fixvy6c8dhs	giorgio armani.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5343	aQsy1l7u6/D2s5DENEZ+5w==	2025-07-26 19:02:29.918298
183	5gs7dmnfrnt7jmefgyg4th8uj7wk	giorgio armani.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5512	3buy8+uklTJroRfGHyT1Ew==	2025-07-26 19:02:32.005205
184	wq3o9934g6m7mqto0zpqka2hf12h	givenchy.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4920	IMm2xWjzPlYnh3+q1tSRug==	2025-07-26 19:03:02.952919
185	1313fq4rba44jmsv2q41l7ihshbu	givenchy.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4991	ObTUw2JQ2z1OE1fdlo17Bg==	2025-07-26 19:03:04.965839
284	4ju5qgw2h6u0z6wo79n2ghqjnaw6	tom ford.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6169	sEwyDVODiNXhwDwsCLtk9A==	2025-07-30 16:42:31.023772
290	4d053tufqzxhk0y1p2fy449vcwt0	amouage.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	5102	Z+mMPqWE9BVIXa5ZRChdwQ==	2025-07-30 17:37:16.695038
291	38grombsdjkd5y43j56adkmyli8b	amouage.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	3678	ArYd8xq2RjwKgppyIueaOg==	2025-07-30 17:37:19.204893
292	9ubwqdewjy4crvkk8e7vlzmphwh0	interlude man.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	60625	cRZGBSIQm/Mx+9jv0cDEPA==	2025-07-30 17:40:48.169324
234	81gzakifdr0pennlqzdnn1y8mm17	Lorenzo Pazzaglia.png	image/png	{"identified":true,"width":400,"height":353,"analyzed":true}	local	70876	KTmlcL9o5gaGLiZuLgGfXA==	2025-07-28 16:14:22.590922
241	thjgmet8685p0jbbr2xbw6ecsq8m	chopard.png	image/png	{"identified":true,"width":225,"height":225,"analyzed":true}	local	3136	HWjE5WcxIU1IBNCVLZqZjQ==	2025-07-28 19:27:43.931357
249	ewi4h0h8vo5ep5gyoqavnm8qq7cx	dior homme intense.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	54186	/xA8A+GbP+j1ow1mjxvzGw==	2025-07-29 17:55:11.00436
268	0xurhgtru3w52wd1qre2btc8tls9	dior.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6026	tbaVBsMhONSBkl+YvWgQOA==	2025-07-30 11:47:38.141127
293	zghwf2qil8p743zew9s4ws437fi3	interlude man.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	27596	jjFDIu7KnB6tT/t+1REgQQ==	2025-07-30 17:40:48.906393
294	cxj1t0rv81s78edmfmj01hclyji6	interlude man.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	42892	BJMmvnVLRsLUNa3bkS6gtQ==	2025-07-30 17:40:54.741651
295	zsbtgfki9inzd01fvabu6kspxwzn	interlude man.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	27596	jjFDIu7KnB6tT/t+1REgQQ==	2025-07-30 17:41:06.89791
321	docac5b249pyjrmyf01q5agi7hyg	le beau le parfum.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	60079	Tb/z/rPXkNeQMXBsMMAEKQ==	2025-07-31 12:21:16.417792
322	03xq7hhcdj2olz3tg26qo665wj8y	le beau le parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25861	G7SR/LqaE9L9+YH4ILZYIw==	2025-07-31 12:21:18.031376
323	39ir09fxapc7ywho5ncloavg72zt	le beau le parfum.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	40610	A4vuQV31Oh17DXZ1nzcPhw==	2025-07-31 12:21:25.813533
324	yfhj5xt2im69ifwjk3ocyvj22hww	le beau le parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25861	G7SR/LqaE9L9+YH4ILZYIw==	2025-07-31 12:21:54.144806
334	pbblq8jjk78q6w3h1qvtih6ew08m	le-lion.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	17382	8undfMa849w8NJ7Zmalm5w==	2025-07-31 13:23:45.570045
342	hnv2q5x4bcuwz2awtqdpk98csgnd	375x500.10206.avif	image/avif	{"identified":true,"width":375,"height":500,"analyzed":true}	local	8718	PFHZXEHky8Nr0Bka3U2yAQ==	2025-07-31 14:46:10.354659
343	xq7jxqhxr8vqeyn626falvqd1lzg	375x500.10206.png	image/png	{"identified":true,"width":225,"height":300,"analyzed":true}	local	38462	hY2IxLK5hrPCu/EbVnDmng==	2025-07-31 14:46:11.736443
285	9c0r242n6uiet2csxbirszajbw0b	ombré leather.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	14236	5k+xLAsSlUXAp9PaqibQMw==	2025-07-30 16:42:31.147613
176	q74tuc6tv0z6perwcy2rqakga9ve	dior.jpg	image/jpeg	{"identified":true,"width":1200,"height":1200,"analyzed":true}	local	30104	tDg7V2Oh8MwJsI9oHO7/Og==	2025-07-26 19:00:37.784218
186	a6yytj2j4mjiomn4e39wmluzv3i8	gucci.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4293	4o6x7uQovCVa6eZAZhhiQg==	2025-07-26 19:03:31.234511
187	d7rh1bzdjhtgmj3jea24pfj5jpgr	gucci.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4292	/sULhWK5lsaw2LzT+ibNUA==	2025-07-26 19:03:33.202149
299	y8sh1o0407bt4cag7k17cd760nvy	Y eau de parfum.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	31333	8QHaaaUwsOBOISa3t/JDqA==	2025-07-30 17:57:01.076955
190	7n5rzbfowbpiupqonamz8qkbct69	jean paul gaultier.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	8827	3o7+dCaJw3h+9W/ora9Gzw==	2025-07-26 19:04:33.470488
191	atcgnj75dluhr11g0cug8szzkxgc	jean paul gaultier.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	9862	eNPoAFh4wMRunHUde1FHHg==	2025-07-26 19:04:36.988585
192	qinzrrmhmpx9d8ih4f89t163lspm	mfk.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	7695	5d9vLC7euEb9oGTvl/SN+w==	2025-07-26 19:05:09.887754
193	55uxiu9ui50d2jsoge0gccfk67hf	mfk.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	9048	/XmL2vyl39PcRHWfYYBnRA==	2025-07-26 19:05:12.860835
194	eklwl1swl0zkx499j6lqakmq5u47	parfums de marly.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	8357	GQW2+faYE1/KKP/4KP3ozg==	2025-07-26 19:05:49.649988
195	o78io8610awxwbdyzxkkm1xp7rb5	parfums de marly.jpg	image/jpeg	{"identified":true,"width":400,"height":400,"analyzed":true}	local	8578	W4UtkUKr6C0jGSEC2E495Q==	2025-07-26 19:05:54.127091
196	p69m42lquabned405rlx1gedx67s	tom ford.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5174	Zlg2bLLXCwjJhqt2HqwHEw==	2025-07-26 19:06:28.506988
197	r8bq4eorzpa9lmvdgif6zvmpkjfx	tom ford.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	6169	sEwyDVODiNXhwDwsCLtk9A==	2025-07-26 19:06:32.078743
296	kru4pjbyrzzq67nynx7n3007u4eh	parfums de marly.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	5856	HFCoVKrwjf+1Icx8W91I5w==	2025-07-30 17:55:23.715822
202	z5nt1729g5o88cfsz2djmfw0rjug	valentino.png	image/png	{"identified":true,"width":400,"height":400,"analyzed":true}	local	23656	zn98gjkmJVJlikQCPf+T5w==	2025-07-26 19:08:06.714993
250	p2766f3u924zctu3mlny9jrbqf7i	dior homme intense.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	25406	m/T5wE1PbhdoHqEeQo1AUw==	2025-07-29 17:55:12.180314
212	qijk4dw2ybeihvofgcu4t21njxsc	jean paul gaultier.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	2323	oHP+bfRe4HCrht2HMvCmpg==	2025-07-27 14:41:08.35451
201	9uyzm0bvfanplk5ho5ruhi8qr68m	valentino.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	local	17871	W4QEtJrQ3cwjuCBSczcWrQ==	2025-07-26 19:08:02.777621
297	y9yni3t382hech0zllmjxmer2w61	Y eau de parfum.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	43492	xc/B0MBrJIU3gF7jDv+Fjw==	2025-07-30 17:56:56.374209
298	26xnfyykse7y5z45hi46y9gi19j2	Y eau de parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	19411	Abjza3TYFwd83EXkf7QXmg==	2025-07-30 17:56:56.966593
300	ubi89uve9nvgsj8ucs52mh145x5n	Y eau de parfum.jpg	image/jpeg	{"identified":true,"width":225,"height":300,"analyzed":true}	local	19411	Abjza3TYFwd83EXkf7QXmg==	2025-07-30 17:57:09.438856
223	ha305lwfkmvcdk7aljsfjz8a94h5	la nuit de l'homme.jpg	image/jpeg	{"identified":true,"width":375,"height":500,"analyzed":true}	local	50640	3FEcyRBzxfYcjGsySHKxVg==	2025-07-28 12:25:54.887558
236	mbxaform9l6x4goem8jg7kq0rdzr	chopard.png	image/png	{"identified":true,"width":225,"height":225,"analyzed":true}	local	2827	WcDSPo3cSN7rBw6ERU9eRw==	2025-07-28 19:22:12.611077
242	bryjb9dca9gsmpzagisccylq48nr	tom ford.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	local	1697	Ohn2CEPmLczQiXldWjtMvA==	2025-07-28 19:28:16.231416
251	l7i0c2tdx21s0ag519audfsk6gcg	dior homme intense.jpg	image/jpeg	{"identified":true,"width":300,"height":400,"analyzed":true}	local	38519	FLrS1iiFJP/Hq9BhyZ0k1w==	2025-07-29 17:55:18.331818
252	0fvx5u8kqwsgkre3jiyh9c2m0zgw	dior homme intense.jpg	image/jpeg	{"identified":true,"width":75,"height":100,"analyzed":true}	local	5060	X/VqhGxp0Ub+11OV4Y3QFQ==	2025-07-29 17:55:23.694253
344	tmyrypc83gtjg83c596g8y3hr6d2	375x500.10206.png	image/png	{"identified":true,"width":300,"height":400,"analyzed":true}	local	58411	Gx6oaPAVJXZdqg820gphgA==	2025-07-31 14:46:32.345
335	6pu4299b641bcw432mxl67nh678z	gucci.jpg	image/jpeg	{"identified":true,"width":300,"height":300,"analyzed":true}	local	4292	/sULhWK5lsaw2LzT+ibNUA==	2025-07-31 14:08:50.470784
345	aqilgg1dg1uzzi3h795133alcnsp	375x500.10206.png	image/png	{"identified":true,"width":225,"height":300,"analyzed":true}	local	38462	SqHXprrQkWG7+8CcJbmyDg==	2025-07-31 14:46:47.343201
346	mt50pf7iucqv2yawcaqaszvhp9xd	tuxedo.avif	image/avif	{"identified":true,"width":375,"height":500,"analyzed":true}	local	8484	VTgSrYt+4WAjhGsuNfJ0dw==	2025-07-31 14:47:57.158898
347	xf0ar7hmbxl0qc6aa8c0jehm4qef	tuxedo.png	image/png	{"identified":true,"width":225,"height":300,"analyzed":true}	local	30724	oL2QMqN3OVCcT7Eb3KmH/w==	2025-07-31 14:47:58.86051
348	5tz3j014olhq29ra7203fh5wxx92	tuxedo.png	image/png	{"identified":true,"width":300,"height":400,"analyzed":true}	local	50936	gFoAJsHQCZu+pKQUvj+7ZQ==	2025-07-31 14:48:21.161251
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
211	306	58nLvjR5lLpeOdoWw8+s844W40I=
212	306	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
213	230	z484+i75QZTEJo5g2XmWWuoRCgQ=
78	124	IJEB01ESS0EZfBNcerfVmDyFrJc=
79	124	58nLvjR5lLpeOdoWw8+s844W40I=
82	130	IJEB01ESS0EZfBNcerfVmDyFrJc=
217	316	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
84	130	4qTwgb5xUi36XqZQgixDCXSJfwU=
218	316	AdwUXi+6z9A47bVAPl6DRy8ePAI=
86	124	4qTwgb5xUi36XqZQgixDCXSJfwU=
87	136	4qTwgb5xUi36XqZQgixDCXSJfwU=
88	130	58nLvjR5lLpeOdoWw8+s844W40I=
219	316	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
90	136	AdwUXi+6z9A47bVAPl6DRy8ePAI=
220	180	426A0poZUAaCQDt/5WVmxU47jQ0=
92	124	AdwUXi+6z9A47bVAPl6DRy8ePAI=
93	139	AdwUXi+6z9A47bVAPl6DRy8ePAI=
94	130	AdwUXi+6z9A47bVAPl6DRy8ePAI=
221	321	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
96	148	AdwUXi+6z9A47bVAPl6DRy8ePAI=
97	139	58nLvjR5lLpeOdoWw8+s844W40I=
222	321	AdwUXi+6z9A47bVAPl6DRy8ePAI=
99	136	58nLvjR5lLpeOdoWw8+s844W40I=
100	153	AdwUXi+6z9A47bVAPl6DRy8ePAI=
101	153	58nLvjR5lLpeOdoWw8+s844W40I=
223	321	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
225	327	AdwUXi+6z9A47bVAPl6DRy8ePAI=
226	329	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
106	162	AdwUXi+6z9A47bVAPl6DRy8ePAI=
107	162	58nLvjR5lLpeOdoWw8+s844W40I=
227	329	AdwUXi+6z9A47bVAPl6DRy8ePAI=
228	329	58nLvjR5lLpeOdoWw8+s844W40I=
229	327	426A0poZUAaCQDt/5WVmxU47jQ0=
230	329	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
231	186	426A0poZUAaCQDt/5WVmxU47jQ0=
232	336	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
114	176	AdwUXi+6z9A47bVAPl6DRy8ePAI=
115	178	AdwUXi+6z9A47bVAPl6DRy8ePAI=
116	180	AdwUXi+6z9A47bVAPl6DRy8ePAI=
117	182	AdwUXi+6z9A47bVAPl6DRy8ePAI=
233	336	AdwUXi+6z9A47bVAPl6DRy8ePAI=
118	184	AdwUXi+6z9A47bVAPl6DRy8ePAI=
119	186	AdwUXi+6z9A47bVAPl6DRy8ePAI=
234	336	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
235	153	426A0poZUAaCQDt/5WVmxU47jQ0=
237	342	v6IuqLJQWEPGNKISml/oZSS7Cdo=
121	190	AdwUXi+6z9A47bVAPl6DRy8ePAI=
122	192	AdwUXi+6z9A47bVAPl6DRy8ePAI=
123	194	AdwUXi+6z9A47bVAPl6DRy8ePAI=
124	196	AdwUXi+6z9A47bVAPl6DRy8ePAI=
238	342	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
239	342	y8X1uPS5Jv53b8o3gPRJhZY9KQ0=
127	201	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
128	203	AdwUXi+6z9A47bVAPl6DRy8ePAI=
129	205	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
240	346	v6IuqLJQWEPGNKISml/oZSS7Cdo=
241	346	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
133	190	58nLvjR5lLpeOdoWw8+s844W40I=
142	223	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
143	223	AdwUXi+6z9A47bVAPl6DRy8ePAI=
149	230	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
154	236	1LJEKsJ8wZq7l3fKDf7OWGYQhdo=
155	196	58nLvjR5lLpeOdoWw8+s844W40I=
156	243	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
157	243	AdwUXi+6z9A47bVAPl6DRy8ePAI=
160	249	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
161	249	AdwUXi+6z9A47bVAPl6DRy8ePAI=
162	249	58nLvjR5lLpeOdoWw8+s844W40I=
163	243	58nLvjR5lLpeOdoWw8+s844W40I=
172	205	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
174	249	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
175	176	426A0poZUAaCQDt/5WVmxU47jQ0=
176	124	426A0poZUAaCQDt/5WVmxU47jQ0=
181	223	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
182	203	426A0poZUAaCQDt/5WVmxU47jQ0=
183	190	426A0poZUAaCQDt/5WVmxU47jQ0=
184	178	426A0poZUAaCQDt/5WVmxU47jQ0=
185	139	426A0poZUAaCQDt/5WVmxU47jQ0=
186	130	426A0poZUAaCQDt/5WVmxU47jQ0=
187	236	z484+i75QZTEJo5g2XmWWuoRCgQ=
189	148	426A0poZUAaCQDt/5WVmxU47jQ0=
190	182	426A0poZUAaCQDt/5WVmxU47jQ0=
191	196	426A0poZUAaCQDt/5WVmxU47jQ0=
192	243	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
194	192	426A0poZUAaCQDt/5WVmxU47jQ0=
195	192	58nLvjR5lLpeOdoWw8+s844W40I=
196	289	AdwUXi+6z9A47bVAPl6DRy8ePAI=
197	289	426A0poZUAaCQDt/5WVmxU47jQ0=
198	292	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
199	292	AdwUXi+6z9A47bVAPl6DRy8ePAI=
200	292	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
201	194	426A0poZUAaCQDt/5WVmxU47jQ0=
202	297	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
203	297	AdwUXi+6z9A47bVAPl6DRy8ePAI=
204	297	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
209	306	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
210	306	AdwUXi+6z9A47bVAPl6DRy8ePAI=
242	346	y8X1uPS5Jv53b8o3gPRJhZY9KQ0=
243	350	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
244	350	AdwUXi+6z9A47bVAPl6DRy8ePAI=
245	350	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
246	350	58nLvjR5lLpeOdoWw8+s844W40I=
247	355	LtoSAYL4ZrQTjS8XJDwiSZvW12s=
248	355	AdwUXi+6z9A47bVAPl6DRy8ePAI=
249	355	wzYI6hb+UmWxzcS2LUnbMX+zIK8=
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.admins (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, created_at, updated_at) FROM stdin;
1	test@exemple.com	$2a$12$sdWn.AycF0OA5oeN6gBJGeduP69hPPZnEsYmx72vI15FQmhr/htK.	\N	\N	\N	2025-07-22 13:30:55.628863	2025-07-28 15:45:06.796685
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2025-07-21 02:31:46.246579	2025-07-21 02:31:46.246583
schema_sha1	a8f3b30b0620ef1d774736aed733c938b26d766b	2025-07-21 02:31:46.270314	2025-07-21 02:31:46.270317
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.brands (id, name, description, created_at, updated_at) FROM stdin;
4	Jean Paul Gaultier	\N	2025-07-22 18:46:12.6704	2025-07-26 19:04:33.606591
19	Maison Francis Kurkdjian	\N	2025-07-24 20:21:48.970436	2025-07-26 19:05:10.085189
27	Parfums de Marly	\N	2025-07-26 16:00:39.23823	2025-07-26 19:05:49.837068
12	Tom Ford	\N	2025-07-24 16:39:20.55802	2025-07-26 19:06:28.654346
17	Valentino	\N	2025-07-24 20:20:47.213828	2025-07-26 19:08:03.243182
6	Yves Saint Laurent	\N	2025-07-22 19:16:43.460116	2025-07-26 19:10:07.774423
28	By Kilian	\N	2025-07-26 16:48:18.379432	2025-07-26 16:48:18.698039
33	Viktor & Rolf	\N	2025-07-26 19:11:35.943525	2025-07-26 19:11:36.230801
29	Le Labo	\N	2025-07-26 16:57:23.780472	2025-07-26 16:57:38.997332
30	Maison Crivelli	\N	2025-07-26 17:01:32.974201	2025-07-26 17:01:33.142256
20	Bvlgari	\N	2025-07-24 20:22:11.518794	2025-07-26 17:09:57.969778
34	Lorenzo Pazzaglia	\N	2025-07-28 16:07:30.374637	2025-07-28 16:07:31.401344
31	Nishane	\N	2025-07-26 17:27:04.455565	2025-07-26 17:27:04.68725
32	Xerjoff 	\N	2025-07-26 18:38:34.318027	2025-07-26 18:38:34.989251
35	Chopard	\N	2025-07-28 19:22:12.565979	2025-07-28 19:22:12.820199
13	Versace	\N	2025-07-24 20:14:48.834942	2025-07-26 18:55:55.231096
36	Amouage	\N	2025-07-30 17:36:58.817598	2025-07-30 17:37:16.162808
2	Dior	\N	2025-07-22 18:10:47.029922	2025-07-26 19:00:38.958933
14	Dolce & Gabbana	\N	2025-07-24 20:19:30.129048	2025-07-26 19:01:13.673962
38	Chanel	\N	2025-07-31 12:40:06.172184	2025-07-31 12:40:06.384207
21	Frederic Malle	\N	2025-07-24 20:23:01.784115	2025-07-26 19:01:44.125616
22	Giorgio Armani	\N	2025-07-24 20:26:14.205863	2025-07-26 19:02:30.183468
23	Givenchy	\N	2025-07-24 20:26:48.023478	2025-07-26 19:03:03.112014
24	Gucci	\N	2025-07-24 20:26:59.281916	2025-07-26 19:03:31.354067
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: parfums; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.parfums (id, name, prix, brand_id, created_at, updated_at, categorie, description, category, fragrance_class, disponible, category_id) FROM stdin;
75	La nuit de L'homme	280.0	6	2025-07-28 12:25:54.823028	2025-07-28 12:25:55.323945	\N	Un parfum séductive au lavande et cardamome 	0	0	t	\N
89	Le beau Le Parfum	50.0	4	2025-07-31 12:21:16.217115	2025-07-31 12:21:18.004536	\N	Le Beau Le Parfum de Jean Paul Gaultier est un parfum Orientale boisé pour homme. C'est un nouveau parfum. Le Beau Le Parfum a été lancé en 2022. Le nez derrière ce parfum est Quentin Bisch. Les notes de tête sont Ananas, Iris, Gingembre et Cyprès; les notes de coeur sont Noix de Coco et Notes boisées; les notes de fond sont Fève de tonka, Bois de santal, Ambre et Ambre gris.	0	0	t	\N
85	Interlude man	170.0	36	2025-07-30 17:40:48.122536	2025-07-30 17:40:48.397509	\N	Best Amouage's seller	0	1	t	\N
79	Ombré Leather	550.0	12	2025-07-29 17:48:38.986888	2025-07-31 12:37:02.633326	\N	le cuir épicé comme vous l'avez jamais sentez !	0	0	f	\N
86	Y eau de parfum	50.0	6	2025-07-30 17:56:56.317579	2025-07-30 17:56:56.564532	\N	Un parfum frais masculin valable à tout les coup!	0	0	t	\N
92	La Nuit de L'Homme Le Parfum	50.0	6	2025-07-31 14:46:10.294167	2025-07-31 14:46:10.875353	\N	La Nuit de L'Homme Le Parfum de Yves Saint Laurent est un parfum Orientale Fougère pour homme. La Nuit de L'Homme Le Parfum a été lancé en 2010. Les notes de tête sont Poivre, Anis et Bergamote; les notes de coeur sont Notes fruitées, Lavande et Ciste de France; les notes de fond sont Vanille, Patchouli et Vétiver.	0	0	t	\N
90	Le lion	150.0	38	2025-07-31 12:41:02.572707	2025-07-31 12:41:32.167195	\N	Le Lion Eau de Parfum de Chanel est un parfum Orientale pour homme et femme. Le Lion Eau de Parfum a été lancé en 2020. Le nez derrière ce parfum est Olivier Polge. Les notes de tête sont Bergamote et Citron; les notes de coeur sont Ciste et Ambre; les notes de fond sont Patchouli, Vanille de Madagascar, Musc et Bois de santal.	2	2	f	\N
81	Dior Homme intense	450.0	2	2025-07-29 17:55:10.860299	2025-07-31 14:08:23.069821	\N	L'iris d'une manière masculine et séductive !	0	0	f	\N
87	Y le parfum	60.0	6	2025-07-30 17:58:37.355959	2025-07-30 18:03:13.576235	\N	Y Le Parfum de Yves Saint Laurent est un parfum Orientale Fougère pour homme. Y Le Parfum a été lancé en 2021. Les notes de tête sont Pomme, Aldéhydes, Pamplemousse et Gingembre; les notes de coeur sont Lavande, Sauge et Géranium; les notes de fond sont Fève de tonka, Cèdre, Résine oliban et Patchouli.	0	0	t	\N
91	Torino 21	150.0	32	2025-07-31 14:19:30.6148	2025-07-31 14:19:31.604356	\N	Torino21 de Xerjoff est un parfum Aromatique Vert pour homme et femme. Torino21 a été lancé en 2021. Les notes de tête sont Menthe, Citron, Basilic et Thym; les notes de coeur sont Cassis, Romarin, Lavande et Jasmin; les notes de fond sont Musc et Vervain.	2	1	t	\N
88	Black Sea	120.0	34	2025-07-30 18:10:00.349525	2025-07-30 18:11:27.462608	\N	Black Sea de Lorenzo Pazzaglia est un parfum pour homme et femme. Black Sea a été lancé en 2019. Le nez derrière ce parfum est Lorenzo Pazzaglia. Les notes de tête sont Sel, Notes d'ozone, Notes aquatiques, Myrte et Bergamote; les notes de coeur sont Notes marines, Sel, Ylang-ylang et Fleur d'oranger; les notes de fond sont Ambre gris, Algue, Musc blanc, Mousse de chêne et Patchouli.	2	1	t	\N
93	Tuxedo	90.0	6	2025-07-31 14:47:57.11968	2025-07-31 14:47:57.471817	\N	Tuxedo de Yves Saint Laurent est un parfum Chypré pour homme et femme. Tuxedo a été lancé en 2015. Le nez derrière ce parfum est Juliette Karagueuzoglou. Les notes de tête sont Feuille de violette, Coriandre et Bergamote; les notes de coeur sont Rose, Poivre noir et Muguet; les notes de fond sont Patchouli, Vanille bourbon et Ambre gris.	2	2	t	\N
94	Bleu de chanel	50.0	38	2025-08-01 11:47:20.541659	2025-08-01 11:47:22.203257	\N	Bleu de chanel eau de toilette.	0	0	t	\N
95	Baccarat Rouge 540 	150.0	19	2025-08-01 13:48:28.382349	2025-08-01 13:48:29.362525	\N	Baccarat Rouge 540 eau de parfum.	2	1	t	\N
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: aziz
--

COPY public.schema_migrations (version) FROM stdin;
20250721022109
20250721000745
20250720232602
20250720232416
20250720232057
20250722124246
20250722175201
20250727145410
20250730105021
20250731120452
20250801102325
20250801111338
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 358, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 358, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 249, true);


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.brands_id_seq', 38, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, false);


--
-- Name: parfums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aziz
--

SELECT pg_catalog.setval('public.parfums_id_seq', 95, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: parfums parfums_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.parfums
    ADD CONSTRAINT parfums_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: aziz
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: aziz
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: aziz
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: aziz
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: public; Owner: aziz
--

CREATE UNIQUE INDEX index_admins_on_email ON public.admins USING btree (email);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: aziz
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON public.admins USING btree (reset_password_token);


--
-- Name: index_parfums_on_brand_id; Type: INDEX; Schema: public; Owner: aziz
--

CREATE INDEX index_parfums_on_brand_id ON public.parfums USING btree (brand_id);


--
-- Name: index_parfums_on_category_id; Type: INDEX; Schema: public; Owner: aziz
--

CREATE INDEX index_parfums_on_category_id ON public.parfums USING btree (category_id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: parfums fk_rails_b6cea40c39; Type: FK CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.parfums
    ADD CONSTRAINT fk_rails_b6cea40c39 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: parfums fk_rails_ba1cc6c42b; Type: FK CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.parfums
    ADD CONSTRAINT fk_rails_ba1cc6c42b FOREIGN KEY (brand_id) REFERENCES public.brands(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: aziz
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- PostgreSQL database dump complete
--

