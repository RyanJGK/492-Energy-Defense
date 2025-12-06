--
-- PostgreSQL database dump
--

\restrict 8dYHMVOFhQOmSF9t0cEMG9JnpimMVqmUfZqFwYafVAasyXOA5waNf0hmkfwOFYg

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

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
-- Name: event_analyses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_analyses (
    id integer NOT NULL,
    event_type character varying(50) NOT NULL,
    event_id integer NOT NULL,
    risk_score integer NOT NULL,
    severity character varying(20) NOT NULL,
    reasoning text NOT NULL,
    recommended_action text NOT NULL,
    analyzed_at timestamp without time zone NOT NULL
);


ALTER TABLE public.event_analyses OWNER TO postgres;

--
-- Name: event_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_analyses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_analyses_id_seq OWNER TO postgres;

--
-- Name: event_analyses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_analyses_id_seq OWNED BY public.event_analyses.id;


--
-- Name: firewall_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.firewall_logs (
    id integer NOT NULL,
    src_ip character varying(45) NOT NULL,
    dst_ip character varying(45) NOT NULL,
    action character varying(20) NOT NULL,
    port integer NOT NULL,
    protocol character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    is_port_scan boolean,
    is_lateral_movement boolean,
    is_malicious_range boolean,
    is_connection_spike boolean
);


ALTER TABLE public.firewall_logs OWNER TO postgres;

--
-- Name: firewall_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.firewall_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.firewall_logs_id_seq OWNER TO postgres;

--
-- Name: firewall_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.firewall_logs_id_seq OWNED BY public.firewall_logs.id;


--
-- Name: login_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_events (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    src_ip character varying(45) NOT NULL,
    status character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    device_id character varying(255) NOT NULL,
    auth_method character varying(50) NOT NULL,
    is_burst_failure boolean,
    is_suspicious_ip boolean,
    is_admin boolean
);


ALTER TABLE public.login_events OWNER TO postgres;

--
-- Name: login_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.login_events_id_seq OWNER TO postgres;

--
-- Name: login_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_events_id_seq OWNED BY public.login_events.id;


--
-- Name: patch_levels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patch_levels (
    id integer NOT NULL,
    device_id character varying(255) NOT NULL,
    os character varying(100) NOT NULL,
    last_patch_date date NOT NULL,
    missing_critical integer,
    missing_high integer,
    update_failures integer,
    is_unsupported boolean,
    updated_at timestamp without time zone
);


ALTER TABLE public.patch_levels OWNER TO postgres;

--
-- Name: patch_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patch_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.patch_levels_id_seq OWNER TO postgres;

--
-- Name: patch_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.patch_levels_id_seq OWNED BY public.patch_levels.id;


--
-- Name: event_analyses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_analyses ALTER COLUMN id SET DEFAULT nextval('public.event_analyses_id_seq'::regclass);


--
-- Name: firewall_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firewall_logs ALTER COLUMN id SET DEFAULT nextval('public.firewall_logs_id_seq'::regclass);


--
-- Name: login_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_events ALTER COLUMN id SET DEFAULT nextval('public.login_events_id_seq'::regclass);


--
-- Name: patch_levels id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patch_levels ALTER COLUMN id SET DEFAULT nextval('public.patch_levels_id_seq'::regclass);


--
-- Data for Name: event_analyses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_analyses (id, event_type, event_id, risk_score, severity, reasoning, recommended_action, analyzed_at) FROM stdin;
1	login	1	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 05:49:10.958234
2	login	3	100	critical	Failed login attempt (+30); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:10.986513
3	login	2	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 05:49:10.995661
4	login	9	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:10.988056
5	login	6	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:10.991236
6	login	8	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:11.000571
7	login	7	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:10.989652
8	login	5	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 05:49:10.993121
9	login	4	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 05:49:10.994225
10	login	10	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 05:49:11.007234
11	firewall	2	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.066781
12	firewall	1	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.068694
13	firewall	4	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.070223
14	firewall	3	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.072431
15	firewall	6	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.08024
16	firewall	5	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.082057
17	firewall	8	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.074154
18	firewall	7	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.086933
19	firewall	9	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.095118
20	firewall	10	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.09634
21	firewall	12	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.099253
22	firewall	11	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.105239
23	firewall	14	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.109627
24	firewall	13	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.115535
25	firewall	16	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.121379
26	firewall	15	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.127261
27	firewall	17	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.131821
28	firewall	18	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.136491
29	firewall	19	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.13961
30	firewall	20	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.145519
31	firewall	21	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.151871
32	firewall	22	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 05:49:11.154702
33	firewall	23	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.15785
34	firewall	24	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.161679
35	firewall	25	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.165767
36	firewall	26	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.168635
37	firewall	27	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.173775
38	firewall	28	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.17791
39	firewall	29	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.18168
40	firewall	30	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.185571
41	firewall	31	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.1903
46	firewall	36	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.215279
50	patch	2	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 05:49:11.27152
54	patch	6	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 05:49:11.292611
1226	firewall	1142	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:58:25.819546
1228	firewall	1144	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 05:00:25.965409
1230	firewall	1146	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:02:26.113029
1232	firewall	1148	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:04:26.267457
1234	firewall	1150	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:06:26.423349
1236	firewall	1152	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:08:26.56676
1238	firewall	1154	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:10:26.725676
1240	firewall	1156	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:12:26.870413
1242	firewall	1158	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:14:27.024973
1244	firewall	1160	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:16:27.190228
1264	firewall	1162	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:03:23.905563
1266	firewall	1164	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:05:24.049972
1268	firewall	1166	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:07:24.204954
1270	firewall	1168	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:09:24.363329
1272	firewall	1170	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:11:24.530519
1274	firewall	1172	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:13:24.687298
1276	firewall	1174	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:15:24.834339
1278	firewall	1176	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:17:24.983799
1280	firewall	1178	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:19:25.146934
1282	firewall	1180	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:21:25.298032
1284	firewall	1182	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:23:25.441711
1286	firewall	1184	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:25:25.60198
1288	firewall	1186	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:27:25.752991
1290	firewall	1188	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:29:25.903358
1292	firewall	1190	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:31:26.059151
1662	firewall	1445	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:38:24.321209
1664	firewall	1447	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:40:24.478314
1666	firewall	1449	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:42:24.632969
1668	firewall	1451	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:44:24.782458
1670	firewall	1453	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:46:24.9325
1672	firewall	1455	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:48:25.079379
1674	firewall	1457	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:50:25.236269
1754	firewall	1514	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:39:24.377097
1756	firewall	1516	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:41:24.527252
1758	firewall	1518	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:43:24.680276
42	firewall	32	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.194972
47	firewall	37	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.218595
51	patch	3	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 05:49:11.276875
55	patch	8	50	high	5 high-priority patches missing (+35); Patches outdated by 268 days (+15)	Schedule emergency patching within 24 hours, restrict system access until patched	2025-11-20 05:49:11.297458
1227	firewall	1143	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:59:25.89038
1229	firewall	1145	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 05:01:26.041378
1231	firewall	1147	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:03:26.185541
1233	firewall	1149	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:05:26.352583
1235	firewall	1151	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:07:26.498635
1237	firewall	1153	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:09:26.657314
1239	firewall	1155	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:11:26.799593
1241	firewall	1157	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:13:26.951297
1243	firewall	1159	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 05:15:27.10541
1246	login	511	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 05:45:22.482296
1248	login	513	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 05:47:22.638569
1250	login	515	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 05:49:22.792556
1252	login	517	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 05:51:22.946352
1254	login	519	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 05:53:23.094535
1256	login	521	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 05:55:23.238781
1258	login	523	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 05:57:23.391852
1260	login	525	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 05:59:23.548361
1262	login	527	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:01:23.689353
1263	firewall	1161	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:02:23.831283
1265	firewall	1163	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:04:23.977152
1267	firewall	1165	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:06:24.12841
1269	firewall	1167	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:08:24.288972
1271	firewall	1169	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:10:24.448554
1273	firewall	1171	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:12:24.610106
1275	firewall	1173	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:14:24.763609
1277	firewall	1175	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 06:16:24.906121
1279	firewall	1177	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:18:25.064851
1281	firewall	1179	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:20:25.219142
1283	firewall	1181	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:22:25.37357
1285	firewall	1183	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:24:25.522891
1287	firewall	1185	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:26:25.680608
1289	firewall	1187	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:28:25.830253
1291	firewall	1189	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 06:30:25.974277
43	firewall	33	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.199395
1245	login	510	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 05:44:22.411703
1247	login	512	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 05:46:22.55385
1249	login	514	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 05:48:22.71737
1251	login	516	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 05:50:22.867158
1253	login	518	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 05:52:23.019488
1255	login	520	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 05:54:23.167926
1257	login	522	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 05:56:23.318256
1259	login	524	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 05:58:23.471328
1261	login	526	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:00:23.619256
1293	login	528	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 06:44:22.419351
1295	login	530	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 06:46:22.576122
1675	firewall	1458	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:51:25.315192
1677	firewall	1460	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:53:25.467568
1690	firewall	1462	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:26:23.436245
1692	firewall	1464	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:28:23.574242
1694	firewall	1466	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:30:23.724546
1696	firewall	1468	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:32:23.873891
1698	firewall	1470	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:34:24.020337
1700	firewall	1472	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:36:24.181101
1702	firewall	1474	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:38:24.327224
1704	firewall	1476	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:40:24.469986
1706	firewall	1478	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:42:24.615443
1708	firewall	1480	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:44:24.760454
1710	firewall	1482	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:46:24.907182
1712	firewall	1484	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:48:25.064477
1714	firewall	1486	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:50:25.217504
1716	firewall	1488	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:52:25.380952
1718	firewall	1490	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:54:25.524224
1720	firewall	1492	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:56:25.683055
1722	firewall	1494	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:58:25.8454
1724	firewall	1496	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:00:26.003341
1726	firewall	1498	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:02:26.16811
1728	firewall	1500	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:04:26.320362
1742	firewall	1502	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:27:23.459275
1744	firewall	1504	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:29:23.62318
1746	firewall	1506	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:31:23.780189
1748	firewall	1508	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:33:23.927143
1750	firewall	1510	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:35:24.074161
1752	firewall	1512	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:37:24.218198
44	firewall	34	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.204708
48	patch	1	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 05:49:11.2629
52	patch	5	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 05:49:11.282347
56	patch	9	50	high	5 critical patches missing (+50)	Schedule emergency patching within 24 hours, restrict system access until patched	2025-11-20 05:49:11.302787
1294	login	529	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 06:45:22.4905
1296	login	531	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 06:47:22.647846
1676	firewall	1459	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:52:25.393142
1679	login	644	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 15:15:22.487819
1681	login	646	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 15:17:22.635604
1683	login	648	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 15:19:22.805973
1685	login	650	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 15:21:22.95427
1687	login	652	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 15:23:23.099988
1729	login	654	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 16:14:22.410352
1731	login	656	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 16:16:22.558093
1733	login	658	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 16:18:22.72362
1735	login	660	80	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:20:22.892842
1737	login	662	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:22:23.042148
1739	login	664	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:24:23.194531
1760	firewall	1520	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:45:24.831586
1762	firewall	1522	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:47:24.981239
1764	firewall	1524	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:49:25.131388
1766	firewall	1526	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:51:25.283279
1768	firewall	1528	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:53:25.444286
1770	firewall	1530	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:55:25.60493
1772	firewall	1532	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:57:25.748206
1774	firewall	1534	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:59:25.895586
1775	firewall	1535	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:00:25.966072
1776	firewall	1536	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:01:26.039212
1777	firewall	1537	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:02:26.11845
1778	firewall	1538	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:03:26.200749
1779	firewall	1539	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:04:26.269652
1780	firewall	1540	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:05:26.342699
1781	firewall	1541	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:06:26.430273
1782	firewall	1542	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:07:26.505256
1783	firewall	1543	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:08:26.582219
1784	firewall	1544	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:09:26.66139
1785	login	666	100	critical	Failed login attempt (+30); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:14:22.413535
1786	login	667	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 17:15:22.492654
45	firewall	35	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 05:49:11.21072
49	patch	4	35	medium	6 high-priority patches missing (+35)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 05:49:11.266291
53	patch	7	35	medium	5 high-priority patches missing (+35)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 05:49:11.287203
57	login	54	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:12:55.232559
58	login	55	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 07:13:10.704882
59	login	56	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:13:26.932983
60	login	57	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:13:47.580988
61	login	58	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:14:06.559501
62	login	59	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:14:23.147072
63	login	60	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:14:38.339611
64	firewall	144	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:14:54.007041
65	firewall	143	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:15:10.990972
66	firewall	145	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:15:26.94245
67	firewall	146	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:15:41.593348
68	firewall	147	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:15:58.709034
69	firewall	148	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:16:13.697547
70	firewall	149	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:16:28.172553
71	firewall	150	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:16:43.584423
72	firewall	151	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:16:58.085054
73	firewall	152	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:17:13.897572
74	firewall	153	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:17:29.919895
75	firewall	154	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:17:47.345018
76	firewall	155	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:18:01.539649
77	firewall	156	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:18:18.168757
78	firewall	157	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:18:34.9199
79	firewall	158	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:18:50.259016
80	firewall	159	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:19:06.325056
81	firewall	160	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:19:22.764579
82	firewall	161	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:19:38.485185
83	firewall	162	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:19:54.452626
84	firewall	163	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:20:09.753837
85	firewall	164	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:20:25.770006
86	firewall	165	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:20:41.755158
87	firewall	166	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:20:57.549572
88	firewall	167	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:21:16.241008
89	firewall	168	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:21:33.58207
90	firewall	169	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:21:48.65519
91	firewall	170	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:22:04.060784
92	firewall	171	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:22:18.638923
93	firewall	172	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:22:33.534017
94	firewall	173	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:22:49.129722
95	firewall	174	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:23:05.619982
96	firewall	175	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:23:20.861168
97	firewall	176	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:23:38.431279
98	firewall	177	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:23:53.683041
99	firewall	178	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:24:09.293363
100	firewall	179	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:24:26.033228
1297	login	532	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 06:48:22.717446
1299	login	534	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:50:22.88054
1301	login	536	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:52:23.026889
1303	login	538	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:54:23.185103
1305	login	540	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:56:23.327425
1307	login	542	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:58:23.485581
1309	login	544	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:00:23.638206
1310	firewall	1191	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:01:23.817162
1312	firewall	1193	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:03:23.972186
1314	firewall	1195	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:05:24.116609
1316	firewall	1197	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:07:24.275322
1318	firewall	1199	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:09:24.426305
1320	firewall	1201	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:11:24.580153
1322	firewall	1203	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:13:24.722411
1324	firewall	1205	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:15:24.896371
1326	firewall	1207	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:17:25.04852
1328	firewall	1209	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:19:25.209362
1330	firewall	1211	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:21:25.36425
1332	firewall	1213	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:23:25.506843
1334	firewall	1215	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:25:25.658033
1347	firewall	1217	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:56:23.395832
1349	firewall	1219	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:58:23.551258
1351	firewall	1221	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:00:23.696687
1353	firewall	1223	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:02:23.855254
1355	firewall	1225	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:04:24.013892
1357	firewall	1227	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:06:24.166155
1359	firewall	1229	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:08:24.316416
1361	firewall	1231	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:10:24.462504
1363	firewall	1233	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:12:24.617122
1365	firewall	1235	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:14:24.769072
1367	firewall	1237	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:16:24.935045
1369	firewall	1239	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:18:25.079267
101	patch	32	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:24:40.926699
102	patch	33	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:24:53.228658
103	patch	34	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:25:05.540201
104	login	61	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:34:18.812903
105	login	62	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 07:34:31.743635
106	login	63	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:34:46.847101
107	login	64	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:35:02.061323
108	login	65	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 07:35:17.654923
109	login	66	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 07:35:32.013134
110	login	67	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 07:35:48.052584
111	login	68	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:36:03.782873
112	login	69	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 07:36:17.943693
113	login	70	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 07:36:31.668144
114	login	71	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:36:47.148692
115	login	72	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 07:37:03.906229
116	login	73	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:37:19.514171
117	login	74	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:37:36.519318
118	login	75	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:37:52.930751
119	login	76	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:38:09.509266
120	login	77	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 07:38:28.829074
121	firewall	181	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:38:46.250949
122	firewall	180	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:39:02.825366
123	firewall	182	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:39:20.233003
124	firewall	183	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:39:35.072369
125	firewall	184	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:39:50.723572
126	firewall	185	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:40:07.881257
127	firewall	186	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:40:23.623377
128	firewall	187	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:40:39.149105
129	firewall	188	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:40:56.407523
130	firewall	189	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:41:12.90966
131	firewall	190	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:41:29.217964
132	firewall	191	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:41:46.383138
133	firewall	192	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 07:42:01.194097
134	firewall	193	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:42:16.544092
135	firewall	194	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:42:31.509562
136	firewall	195	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:42:46.84505
137	firewall	196	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:43:03.312617
138	firewall	197	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:43:20.401693
139	firewall	198	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:43:36.616931
140	firewall	199	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:43:51.945542
141	firewall	200	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:44:06.988151
142	firewall	201	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:44:22.718549
143	firewall	202	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:44:39.134388
144	firewall	203	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:44:55.802596
145	firewall	204	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:45:11.354413
146	firewall	205	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:45:26.169685
147	firewall	206	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:45:43.042219
148	firewall	207	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 07:45:57.613337
167	firewall	208	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:07:54.685187
168	firewall	209	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:08:10.422025
169	firewall	210	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:08:24.913782
170	firewall	211	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:08:40.438725
171	firewall	212	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:08:55.930349
172	firewall	213	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:09:12.540908
173	firewall	214	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:09:28.309542
174	firewall	215	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:09:45.783847
175	firewall	216	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:10:02.334948
176	firewall	217	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:10:19.37106
1298	login	533	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:49:22.802934
1300	login	535	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:51:22.957402
1302	login	537	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 06:53:23.101228
1304	login	539	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 06:55:23.257764
1306	login	541	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:57:23.402085
1308	login	543	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 06:59:23.561834
1335	login	545	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 07:44:22.398685
1337	login	547	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 07:46:22.553481
1339	login	549	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:48:22.70777
1341	login	551	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:50:22.849495
1343	login	553	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:52:22.999925
1345	login	555	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:54:23.17141
1346	firewall	1216	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:55:23.310213
1348	firewall	1218	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:57:23.470024
1350	firewall	1220	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:59:23.619419
1352	firewall	1222	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:01:23.782888
1354	firewall	1224	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:03:23.937261
1356	firewall	1226	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:05:24.084015
1358	firewall	1228	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:07:24.237388
1360	firewall	1230	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:09:24.387495
1362	firewall	1232	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:11:24.538315
1364	firewall	1234	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:13:24.697867
1366	firewall	1236	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:15:24.847452
149	patch	35	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:46:11.887337
150	patch	36	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:46:24.332235
151	patch	37	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 07:46:36.231687
152	patch	38	50	high	9 high-priority patches missing (+35); Patches outdated by 187 days (+15)	Schedule emergency patching within 24 hours, restrict system access until patched	2025-11-20 07:46:48.441051
153	login	78	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:04:15.575338
154	login	79	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:04:30.337696
155	login	80	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:04:43.093674
156	login	81	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:04:57.927127
157	login	82	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:05:14.209172
158	login	83	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:05:27.92054
159	login	84	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:05:40.276223
160	login	85	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:05:55.361088
161	login	86	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:06:09.336154
162	login	87	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:06:27.784347
163	login	88	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:06:45.617368
164	login	89	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:07:02.290822
165	login	90	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:07:18.280916
166	login	91	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:07:35.380874
177	firewall	218	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 4444 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 08:10:35.590246
178	firewall	219	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:10:49.92044
179	firewall	220	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:11:07.773257
180	firewall	221	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:11:24.135354
181	firewall	222	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:11:38.18745
182	firewall	223	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:11:53.563809
183	firewall	224	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:12:08.293441
184	firewall	225	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:12:22.614512
185	firewall	226	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:12:37.778482
186	firewall	227	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:12:53.762183
187	firewall	228	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:13:09.696389
188	firewall	229	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:13:23.366907
189	firewall	230	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:13:37.963677
190	firewall	231	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 1337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 08:13:53.29724
191	firewall	232	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:14:09.851865
192	firewall	233	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:14:28.631303
193	firewall	234	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:14:44.554604
194	firewall	235	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:15:02.053681
195	firewall	236	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:15:17.555453
196	firewall	237	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:15:31.778148
197	firewall	238	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:15:48.224189
198	firewall	239	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:16:04.602847
199	firewall	240	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:16:19.468892
200	firewall	241	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:16:33.669851
278	firewall	292	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:11:13.309384
201	firewall	242	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:16:48.618218
202	firewall	243	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:17:03.885312
203	firewall	244	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:17:19.741474
204	firewall	245	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:17:35.784967
205	firewall	246	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:17:51.739606
206	firewall	247	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:18:07.337462
207	firewall	248	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:18:21.857573
208	firewall	249	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:18:38.391066
209	firewall	250	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:18:54.505523
210	firewall	251	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:19:08.975121
211	firewall	252	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:19:24.343662
212	patch	39	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 08:19:36.806526
213	login	92	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:34:18.978277
214	login	93	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 08:34:34.254467
215	login	94	80	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:34:48.647201
216	login	95	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 08:35:06.813858
217	login	96	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:35:21.291411
218	login	97	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 08:35:38.166481
219	login	98	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:35:52.164879
220	login	99	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 08:36:06.505655
221	login	100	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:36:23.09011
222	login	101	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:36:40.491137
223	login	102	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:36:58.349302
224	login	103	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:37:14.063093
225	login	104	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 08:37:30.910082
226	firewall	253	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:37:47.099793
227	firewall	254	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:38:03.05986
228	firewall	255	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:38:19.646041
229	firewall	256	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:38:35.318336
230	firewall	257	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:38:50.735388
231	firewall	258	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:39:07.195528
232	firewall	259	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:39:22.22223
233	firewall	260	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:39:42.571994
234	firewall	261	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:39:58.926067
235	firewall	262	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:40:14.809008
236	firewall	263	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 08:40:31.126068
237	firewall	264	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:40:48.378404
238	firewall	265	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:41:06.256233
279	firewall	293	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:11:29.342315
239	firewall	266	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:41:24.37901
240	firewall	267	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:41:39.593762
241	firewall	268	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:41:53.924915
242	firewall	269	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:42:09.576123
243	firewall	270	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:42:24.786372
244	firewall	271	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:42:40.619114
245	firewall	272	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:42:56.546644
246	firewall	273	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:43:11.500972
247	firewall	274	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:43:26.619361
248	firewall	275	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:43:41.631795
249	firewall	276	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:43:56.633978
250	firewall	277	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:44:13.318507
251	firewall	278	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 08:44:30.865476
252	patch	40	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 08:44:43.224132
253	login	105	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:04:17.900695
254	login	106	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 09:04:38.82652
255	login	107	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 09:04:52.805834
256	login	108	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:05:11.943494
257	login	109	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 09:05:26.398883
258	login	110	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:05:43.583472
259	login	111	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:06:00.241962
260	login	112	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:06:17.004685
261	login	113	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:06:34.738754
262	login	114	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:06:51.178926
263	login	115	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:07:07.765335
264	login	116	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:07:26.141787
265	firewall	279	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:07:44.603148
266	firewall	280	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:08:00.052683
267	firewall	281	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:08:16.135217
268	firewall	282	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 09:08:33.809938
269	firewall	283	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:08:49.839279
270	firewall	284	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:09:08.771822
271	firewall	285	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:09:24.80753
272	firewall	286	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:09:41.615244
273	firewall	287	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:09:55.818478
274	firewall	288	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:10:10.317981
275	firewall	289	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:10:26.476197
276	firewall	290	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:10:42.842192
277	firewall	291	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:10:58.063836
280	firewall	294	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:11:44.654802
281	firewall	295	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:12:02.274165
282	firewall	296	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:12:18.651057
283	firewall	297	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:12:32.79077
284	firewall	298	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:12:49.477013
285	firewall	299	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:13:05.788366
286	firewall	300	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:13:21.817123
287	firewall	301	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:13:38.596872
288	firewall	302	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:13:53.096913
289	firewall	303	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:14:09.439936
290	firewall	304	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:14:25.563852
291	firewall	305	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:14:40.102909
292	firewall	306	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:14:56.514478
293	firewall	307	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:15:13.838528
294	firewall	308	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:15:29.286505
295	firewall	309	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:15:43.759728
296	firewall	310	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:15:59.575429
297	firewall	311	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:16:14.768645
298	firewall	312	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:16:32.051585
299	firewall	313	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:16:47.028882
300	firewall	314	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:17:02.089399
301	firewall	315	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:17:16.673756
302	firewall	316	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:17:31.777805
322	firewall	317	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:39:02.462098
323	firewall	318	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:39:17.834451
324	firewall	319	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:39:33.649395
1311	firewall	1192	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:02:23.897969
1313	firewall	1194	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:04:24.04494
1315	firewall	1196	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:06:24.203163
1317	firewall	1198	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:08:24.350224
1319	firewall	1200	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 07:10:24.499693
1321	firewall	1202	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:12:24.649104
1323	firewall	1204	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:14:24.821861
1325	firewall	1206	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:16:24.973376
1327	firewall	1208	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:18:25.139351
1329	firewall	1210	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:20:25.286189
1331	firewall	1212	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:22:25.4368
1333	firewall	1214	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 07:24:25.577196
1336	login	546	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 07:45:22.470412
303	patch	41	35	medium	4 high-priority patches missing (+35)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 09:17:44.08659
304	patch	42	50	high	3 high-priority patches missing (+35); Patches outdated by 326 days (+15)	Schedule emergency patching within 24 hours, restrict system access until patched	2025-11-20 09:17:56.143852
305	login	117	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:34:21.56123
306	login	118	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 09:34:39.528232
307	login	119	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 09:34:55.673107
308	login	120	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:35:10.839709
309	login	121	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:35:25.134245
310	login	122	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 09:35:42.177999
311	login	123	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:36:00.252401
312	login	124	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:36:16.882769
313	login	125	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:36:33.671101
314	login	126	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 09:36:47.709857
315	login	127	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:37:02.28227
316	login	128	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 09:37:21.099222
317	login	129	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:37:39.055849
318	login	130	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:37:54.101931
319	login	131	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:38:09.860136
320	login	132	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:38:25.152896
321	login	133	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 09:38:43.285482
325	firewall	320	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:39:50.024151
326	firewall	321	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:40:06.883971
327	firewall	322	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:40:24.035526
328	firewall	323	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:40:40.200006
329	firewall	324	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:40:55.570088
330	firewall	325	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:41:12.194484
331	firewall	326	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:41:27.47343
332	firewall	327	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:41:41.261786
333	firewall	328	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:42:00.10241
334	firewall	329	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:42:17.30157
335	firewall	330	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:42:34.170103
336	firewall	331	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:42:49.811639
337	firewall	332	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 09:43:07.50481
338	firewall	333	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:43:24.070982
339	firewall	334	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:43:39.22363
340	firewall	335	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:43:54.625136
341	firewall	336	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:44:10.398171
342	firewall	337	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:44:27.389655
343	firewall	338	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 09:44:42.913824
344	firewall	339	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:44:59.695436
345	firewall	340	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:45:16.623872
346	firewall	341	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:45:32.276154
347	firewall	342	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:45:46.97701
348	firewall	343	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:46:01.656099
349	firewall	344	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:46:18.443891
350	firewall	345	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:46:34.664921
351	firewall	346	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:46:50.675769
352	firewall	347	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:47:06.810662
353	firewall	348	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:47:22.85294
354	firewall	349	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:47:38.240597
355	firewall	350	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:47:54.083324
356	firewall	351	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:48:10.7158
357	firewall	352	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:48:27.088531
358	firewall	353	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 09:48:41.861773
359	patch	43	50	high	3 critical patches missing (+50)	Schedule emergency patching within 24 hours, restrict system access until patched	2025-11-20 09:48:54.501417
360	patch	44	15	low	Patches outdated by 146 days (+15)	Continue normal patch management schedule, maintain update monitoring	2025-11-20 09:49:07.064757
361	login	135	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 10:04:16.775094
362	login	134	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:04:33.99251
363	login	136	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:04:49.988944
364	login	137	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 10:05:05.887601
365	login	138	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:05:21.275792
366	login	139	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:05:37.787623
367	login	140	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 10:05:55.756293
368	login	141	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 10:06:11.043545
369	login	142	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:06:29.589268
370	login	143	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:06:48.558831
371	login	144	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:07:07.918345
372	login	145	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:07:28.660056
373	login	146	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:07:50.794949
374	firewall	354	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:08:22.474716
375	firewall	355	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:08:22.475531
376	firewall	356	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:08:39.916052
377	firewall	357	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:08:58.713218
378	firewall	358	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:09:14.695049
379	firewall	359	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:09:31.670531
380	firewall	360	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:09:48.3285
381	firewall	361	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:10:05.902401
382	firewall	362	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:10:20.545515
383	firewall	363	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:10:37.490172
384	firewall	364	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:10:51.819486
386	firewall	366	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:11:24.667876
388	firewall	368	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:11:54.433401
390	firewall	370	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:12:25.656924
392	firewall	372	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:12:53.033476
394	firewall	374	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:13:24.985301
396	firewall	376	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:13:56.574052
398	firewall	378	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:14:27.107244
400	firewall	380	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:14:57.783164
402	firewall	382	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:15:32.264183
404	firewall	384	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:16:04.703267
406	firewall	386	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:16:37.696465
1338	login	548	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 07:47:22.639108
1340	login	550	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 07:49:22.779438
1342	login	552	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:51:22.92568
1344	login	554	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 07:53:23.090586
1376	login	556	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 08:44:22.412475
1378	login	558	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 08:46:22.571366
1380	login	560	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 08:48:22.724104
1382	login	562	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 08:50:22.882128
1384	login	564	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 08:52:23.03257
1386	login	566	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:54:23.185175
1388	login	568	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:56:23.341334
1420	login	570	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:44:22.416721
1422	login	572	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:46:22.573202
1424	login	574	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:48:22.729941
1426	login	576	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:50:22.889014
1428	login	578	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 09:52:23.047618
1430	login	580	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:54:23.193631
1432	login	582	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:56:23.362321
1434	login	584	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 09:58:23.52451
1436	login	586	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 10:00:23.671678
1678	login	643	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 15:14:22.405403
1680	login	645	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 15:16:22.561265
1682	login	647	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 15:18:22.717815
1684	login	649	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 15:20:22.874203
1686	login	651	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 15:22:23.027022
1688	login	653	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 15:24:23.180491
385	firewall	365	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:11:07.793286
387	firewall	367	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:11:39.263574
389	firewall	369	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:12:10.405215
391	firewall	371	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:12:39.499632
393	firewall	373	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:13:08.886921
395	firewall	375	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:13:41.759297
397	firewall	377	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:14:11.738126
399	firewall	379	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:14:42.157946
401	firewall	381	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:15:15.102262
403	firewall	383	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:15:48.679312
405	firewall	385	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:16:21.096906
407	firewall	387	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:16:54.046827
408	patch	45	15	low	Patches outdated by 92 days (+15)	Continue normal patch management schedule, maintain update monitoring	2025-11-20 10:17:06.909672
1368	firewall	1238	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:17:25.007834
1370	firewall	1240	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:19:25.152067
1372	firewall	1242	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:21:25.308323
1374	firewall	1244	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:23:25.466205
1377	login	557	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 08:45:22.498255
1379	login	559	80	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:47:22.656375
1381	login	561	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 08:49:22.806224
1383	login	563	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 08:51:22.952206
1385	login	565	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:53:23.105216
1387	login	567	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:55:23.261549
1389	login	569	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 08:57:23.417863
1390	firewall	1246	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:58:23.552686
1392	firewall	1248	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:00:23.718724
1394	firewall	1250	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:02:23.87343
1396	firewall	1252	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:04:24.025027
1398	firewall	1254	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:06:24.172324
1400	firewall	1256	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:08:24.316288
1402	firewall	1258	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:10:24.471519
1404	firewall	1260	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:12:24.620956
1406	firewall	1262	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:14:24.777174
1408	firewall	1264	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:16:24.928352
1410	firewall	1266	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:18:25.077606
1412	firewall	1268	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:20:25.227198
1414	firewall	1270	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:22:25.381861
1416	firewall	1272	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:24:25.533225
1689	firewall	1461	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:25:23.350258
409	patch	46	35	medium	Patches outdated by 77 days (+15); 2 update failures detected (+20)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 10:17:19.502663
410	login	147	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 10:34:21.164874
411	login	148	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 10:34:39.125365
412	login	149	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:34:54.065303
413	login	150	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 10:35:10.34149
414	login	151	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:35:26.360615
415	login	152	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:35:41.530352
416	login	153	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 10:35:59.068633
417	login	154	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 10:36:13.385761
418	login	155	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 10:36:27.208049
419	login	156	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:36:43.385896
420	login	157	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:36:58.358055
421	login	158	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:37:13.895554
422	login	159	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:37:31.254569
423	login	160	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 10:37:48.345612
424	firewall	388	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:38:04.9705
425	firewall	389	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:38:20.108952
426	firewall	390	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:38:36.468725
427	firewall	391	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:38:53.928709
428	firewall	392	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:39:12.15119
429	firewall	393	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:39:28.761512
430	firewall	394	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:39:42.789181
431	firewall	395	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:39:59.152336
432	firewall	396	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:40:16.639307
433	firewall	397	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:40:33.158834
434	firewall	398	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:40:52.32308
435	firewall	399	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:41:06.474421
436	firewall	400	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:41:23.16742
437	firewall	401	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:41:38.192479
438	firewall	402	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:41:53.313794
439	firewall	403	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:42:11.184828
440	firewall	404	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:42:25.483004
441	firewall	405	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:42:40.668403
442	firewall	406	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:42:56.800891
443	firewall	407	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:43:14.622269
444	firewall	408	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:43:32.435669
445	firewall	409	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:43:48.482914
446	firewall	410	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:44:03.938111
447	firewall	411	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:44:24.222442
448	firewall	412	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 10:44:41.475327
449	firewall	413	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:45:00.076147
450	firewall	414	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:45:16.695642
451	firewall	415	25	medium	Internal lateral movement detected (+25)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 10:45:32.977577
452	firewall	416	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 10:45:50.267248
454	firewall	418	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:46:23.810781
456	firewall	420	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:46:57.298937
458	firewall	422	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:47:27.827299
460	firewall	424	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:47:59.84686
462	firewall	426	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:48:31.421907
464	firewall	428	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:49:00.296395
466	firewall	430	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:49:31.306304
469	login	161	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:04:15.716111
471	login	163	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:04:46.095173
473	login	165	40	medium	Failed login attempt (+30); Login during 00:00-05:00 hours (+10)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:05:17.849864
475	login	167	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 11:05:46.763525
477	login	169	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:06:13.88858
479	login	171	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:06:50.853193
481	login	173	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:07:29.131877
1371	firewall	1241	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:20:25.230236
1373	firewall	1243	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:22:25.391629
1375	firewall	1245	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 08:24:25.539872
1391	firewall	1247	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 08:59:23.637768
1393	firewall	1249	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:01:23.799314
1395	firewall	1251	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:03:23.946379
1397	firewall	1253	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:05:24.097124
1399	firewall	1255	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:07:24.248506
1401	firewall	1257	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:09:24.394756
1403	firewall	1259	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 09:11:24.546813
1405	firewall	1261	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:13:24.694013
1407	firewall	1263	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:15:24.860661
1409	firewall	1265	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:17:25.001425
1411	firewall	1267	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:19:25.154809
1413	firewall	1269	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:21:25.302339
1415	firewall	1271	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:23:25.460612
1417	firewall	1273	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:25:25.614028
1419	firewall	1275	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:27:25.752437
1439	firewall	1277	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 1337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 10:03:24.008689
1441	firewall	1279	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:05:24.163163
1443	firewall	1281	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 1337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 10:07:24.31918
1445	firewall	1283	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:09:24.471366
1447	firewall	1285	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:11:24.633559
453	firewall	417	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:46:07.290631
455	firewall	419	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:46:40.691908
457	firewall	421	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:47:12.791868
459	firewall	423	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:47:43.608405
461	firewall	425	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:48:16.372794
463	firewall	427	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:48:45.846575
465	firewall	429	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:49:15.043392
467	firewall	431	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 10:49:48.531588
468	patch	47	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 10:50:00.560342
484	firewall	432	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:08:22.294317
486	firewall	435	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:08:56.007542
488	firewall	437	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:09:28.428082
490	firewall	439	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:09:58.88198
492	firewall	441	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:10:30.020924
494	firewall	443	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:11:04.812664
496	firewall	445	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:11:35.2339
498	firewall	447	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:12:09.45669
500	firewall	449	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:12:43.027975
502	firewall	451	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:13:17.793947
1418	firewall	1274	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 09:26:25.682325
1421	login	571	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:45:22.497664
1423	login	573	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:47:22.646261
1425	login	575	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:49:22.813372
1427	login	577	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 09:51:22.962601
1429	login	579	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 09:53:23.119151
1431	login	581	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 09:55:23.269232
1433	login	583	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 09:57:23.448234
1435	login	585	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 09:59:23.598155
1437	login	587	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 10:01:23.747791
1438	firewall	1276	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:02:23.928245
1440	firewall	1278	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:04:24.087412
1442	firewall	1280	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:06:24.235868
1444	firewall	1282	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:08:24.403338
1446	firewall	1284	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:10:24.550703
1448	firewall	1286	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:12:24.718021
1450	firewall	1288	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:14:24.865375
1452	firewall	1290	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:16:25.022224
1454	firewall	1292	25	medium	Internal lateral movement detected (+25)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 10:18:25.168212
1456	firewall	1294	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:20:25.3174
1458	firewall	1296	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:22:25.465536
1460	firewall	1298	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:24:25.634427
1462	firewall	1300	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:26:25.784749
1691	firewall	1463	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:27:23.504707
470	login	162	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 11:04:30.141397
472	login	164	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:05:03.118843
474	login	166	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:05:31.078268
476	login	168	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:05:59.390707
478	login	170	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:06:34.109619
480	login	172	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:07:09.59536
482	login	174	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:07:49.455052
483	firewall	433	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6667 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 11:08:06.694897
485	firewall	434	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:08:40.275807
487	firewall	436	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:09:12.196898
489	firewall	438	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:09:43.672038
491	firewall	440	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:10:14.395239
493	firewall	442	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:10:47.176505
495	firewall	444	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:11:20.108927
497	firewall	446	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:11:51.403645
499	firewall	448	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:12:27.868275
501	firewall	450	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:13:01.188806
503	firewall	452	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:13:34.520119
504	firewall	453	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:13:51.854325
505	firewall	454	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:14:08.389948
506	firewall	455	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:14:24.035206
507	firewall	456	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:14:40.987788
508	firewall	457	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:14:57.179934
509	firewall	458	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:15:13.006093
510	firewall	459	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:15:29.437033
511	firewall	460	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:15:44.885403
512	firewall	461	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:16:00.490553
513	firewall	462	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:16:15.670037
514	firewall	463	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:16:30.846026
515	firewall	464	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:16:46.857516
516	firewall	465	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:17:04.306844
517	firewall	466	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:17:19.979972
518	firewall	467	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:17:35.47357
519	firewall	468	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:17:51.487808
520	patch	48	20	low	3 update failures detected (+20)	Continue normal patch management schedule, maintain update monitoring	2025-11-20 11:18:04.235637
521	patch	49	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 11:18:16.871931
522	login	175	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:34:15.233626
523	login	176	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:34:30.103434
524	login	177	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:34:45.604491
525	login	178	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:35:00.061313
527	login	180	110	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:35:32.463688
529	login	182	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 11:36:03.67115
531	login	184	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 11:36:36.036573
533	login	186	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:37:03.285879
535	login	188	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:37:30.735536
537	login	190	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:38:02.624208
539	login	192	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:38:37.482776
567	login	194	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:04:18.912452
569	login	196	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 12:04:52.751783
571	login	198	110	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:05:30.161039
573	login	200	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:05:59.734566
575	login	202	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:06:28.27737
577	login	204	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:07:03.815229
579	login	206	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:07:31.283526
581	login	208	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:08:01.814717
583	login	210	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:08:35.521012
585	login	212	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:09:10.238582
1449	firewall	1287	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:13:24.792308
1451	firewall	1289	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:15:24.949506
1453	firewall	1291	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:17:25.09426
1455	firewall	1293	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:19:25.242173
1457	firewall	1295	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:21:25.388297
1459	firewall	1297	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:23:25.54893
1461	firewall	1299	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:25:25.7108
1463	firewall	1301	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 1337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 10:27:25.865535
1465	firewall	1303	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:29:26.009196
1467	firewall	1305	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:31:26.196202
1469	firewall	1307	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:33:26.347312
1471	firewall	1309	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:35:26.500541
1473	firewall	1311	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:37:26.653148
1475	firewall	1313	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:39:26.805536
1693	firewall	1465	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:29:23.653504
1695	firewall	1467	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:31:23.801593
1697	firewall	1469	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:33:23.948463
1699	firewall	1471	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:35:24.10152
1701	firewall	1473	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:37:24.260138
1703	firewall	1475	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:39:24.399527
1705	firewall	1477	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:41:24.542299
1707	firewall	1479	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:43:24.689911
526	login	179	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:35:16.031856
528	login	181	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:35:48.126381
530	login	183	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:36:18.860079
532	login	185	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 11:36:49.989517
534	login	187	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 11:37:15.258191
536	login	189	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:37:45.696239
538	login	191	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:38:20.092939
540	login	193	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 11:38:53.263371
541	firewall	469	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:39:08.986029
543	firewall	471	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:39:40.55756
545	firewall	473	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:40:12.299629
547	firewall	475	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:40:43.51741
549	firewall	477	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:41:16.955766
551	firewall	479	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:41:47.653529
553	firewall	481	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:42:19.775852
555	firewall	483	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:42:53.457449
557	firewall	485	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:43:24.556299
559	firewall	487	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:43:54.826027
561	firewall	489	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:44:29.284176
563	firewall	491	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:44:59.580962
565	firewall	493	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:45:32.05297
568	login	195	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 12:04:35.594902
570	login	197	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:05:10.539843
572	login	199	70	high	Failed login attempt (+30); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 12:05:44.61055
574	login	201	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:06:13.972162
576	login	203	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:06:46.201975
578	login	205	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:07:16.459617
580	login	207	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 12:07:49.523426
582	login	209	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:08:18.625447
584	login	211	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:08:52.498902
586	login	213	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:09:27.387983
587	firewall	496	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:09:45.853216
589	firewall	497	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:10:23.188665
591	firewall	499	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:10:54.276065
593	firewall	501	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:11:29.279475
595	firewall	503	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:11:59.829917
597	firewall	505	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:12:29.639242
599	firewall	507	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:13:02.634941
601	firewall	509	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:13:32.788525
603	firewall	511	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:14:01.802436
605	firewall	513	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:14:34.06663
542	firewall	470	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:39:24.742958
544	firewall	472	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:39:57.085578
546	firewall	474	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:40:27.345554
548	firewall	476	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:40:58.821192
550	firewall	478	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 11:41:33.751723
552	firewall	480	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:42:04.024878
554	firewall	482	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:42:36.830386
556	firewall	484	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:43:08.712296
558	firewall	486	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:43:39.963349
560	firewall	488	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:44:11.483036
562	firewall	490	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:44:44.42959
564	firewall	492	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:45:16.710249
566	firewall	494	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 11:45:48.347603
588	firewall	495	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:10:06.958026
590	firewall	498	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 12:10:38.04254
592	firewall	500	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:11:11.003405
594	firewall	502	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:11:44.35877
596	firewall	504	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:12:13.859967
598	firewall	506	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:12:46.478255
600	firewall	508	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:13:18.929233
602	firewall	510	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:13:46.797331
604	firewall	512	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:14:16.427624
606	firewall	514	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:14:48.825125
607	firewall	515	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:15:03.030395
608	firewall	516	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:15:20.446269
609	firewall	517	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:15:37.766014
610	firewall	518	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:15:55.374403
611	firewall	519	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:16:12.52456
612	firewall	520	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 31337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 12:16:27.547581
613	firewall	521	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:16:42.19605
614	firewall	522	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:16:56.584554
615	firewall	523	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:17:11.198323
616	firewall	524	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:17:27.399152
617	firewall	525	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:17:43.562516
618	firewall	526	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:17:58.931263
619	firewall	527	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:18:14.495851
620	firewall	528	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:18:29.155824
621	firewall	529	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:18:44.122309
622	firewall	530	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:19:00.679458
623	firewall	531	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:19:16.354192
737	login	250	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:34:28.153821
624	firewall	532	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:19:31.141454
626	firewall	534	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:20:02.151262
628	firewall	536	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:20:35.340775
631	login	214	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:34:15.796935
633	login	216	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:34:48.071152
635	login	218	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:35:19.176516
637	login	220	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:35:52.67824
639	login	222	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:36:22.463422
641	login	224	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:36:49.822642
643	login	226	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:37:19.803584
645	login	228	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:37:48.606596
647	login	230	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:38:19.249495
649	login	232	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:38:53.175259
692	login	235	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:04:33.090559
694	login	237	110	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:05:05.376103
696	login	239	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:05:37.329134
698	login	241	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:06:09.769831
700	login	243	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 13:06:40.60514
702	login	245	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:07:11.219943
704	login	247	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:07:45.945831
1464	firewall	1302	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 31337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 10:28:25.938603
1466	firewall	1304	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 10:30:26.101821
1468	firewall	1306	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:32:26.27121
1470	firewall	1308	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:34:26.426343
1472	firewall	1310	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:36:26.583271
1474	firewall	1312	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:38:26.723963
1476	firewall	1314	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:40:26.87944
1709	firewall	1481	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:45:24.832968
1711	firewall	1483	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:47:24.985473
1713	firewall	1485	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 15:49:25.143894
1715	firewall	1487	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:51:25.306141
1717	firewall	1489	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:53:25.453361
1719	firewall	1491	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:55:25.603577
1721	firewall	1493	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:57:25.760386
1723	firewall	1495	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 15:59:25.927317
1725	firewall	1497	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:01:26.088161
1787	login	668	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 17:16:22.567835
625	firewall	533	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:19:45.948804
627	firewall	535	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:20:19.410241
629	firewall	537	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:20:50.984475
630	patch	50	35	medium	Patches outdated by 282 days (+15); 1 update failures detected (+20)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 12:21:04.738073
632	login	215	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:34:31.738176
634	login	217	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:35:03.439142
636	login	219	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:35:37.056149
638	login	221	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:36:07.857445
640	login	223	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 12:36:36.386216
642	login	225	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 12:37:03.424086
644	login	227	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 12:37:36.289345
646	login	229	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:38:04.045097
648	login	231	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:38:34.896308
650	login	233	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 12:39:11.029489
651	firewall	538	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:39:27.545081
652	firewall	539	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:39:43.112104
653	firewall	540	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:40:00.612832
654	firewall	541	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:40:18.46698
655	firewall	542	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:40:35.222371
656	firewall	543	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:40:49.628719
657	firewall	544	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:41:07.017579
658	firewall	545	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:41:22.355026
659	firewall	546	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:41:38.07505
660	firewall	547	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:41:52.856938
661	firewall	548	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:42:08.855877
662	firewall	549	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:42:23.359813
663	firewall	550	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:42:37.961804
664	firewall	551	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:42:53.485398
665	firewall	552	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:43:08.49812
666	firewall	553	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:43:25.133047
667	firewall	554	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:43:42.111905
668	firewall	555	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:43:56.145102
669	firewall	556	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:44:11.276838
670	firewall	557	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:44:26.533661
671	firewall	558	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:44:40.758118
672	firewall	559	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:44:56.247119
673	firewall	560	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:45:12.957186
674	firewall	561	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 12:45:27.981791
675	firewall	562	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:45:43.964596
676	firewall	563	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:45:58.202606
677	firewall	564	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:46:14.139096
678	firewall	565	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:46:31.316232
738	login	251	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:34:41.638447
679	firewall	566	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:46:48.914706
681	firewall	568	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:47:19.55446
683	firewall	570	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:47:49.392357
685	firewall	572	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:48:21.075622
687	firewall	574	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:48:50.379242
689	firewall	576	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:49:18.944856
690	patch	51	35	medium	4 high-priority patches missing (+35)	Schedule patching within 1 week, monitor system for suspicious activity	2025-11-20 12:49:32.807374
707	firewall	578	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:08:35.509458
709	firewall	580	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:09:10.963922
711	firewall	582	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:09:42.724969
713	firewall	584	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:10:14.807189
715	firewall	586	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:10:45.728283
717	firewall	588	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:11:20.556141
1477	firewall	1315	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:41:26.978833
1479	firewall	1317	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:43:27.13325
1481	firewall	1319	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:45:27.290493
1497	firewall	1321	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:29:23.639305
1499	firewall	1323	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:31:23.786286
1501	firewall	1325	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:33:23.939404
1503	firewall	1327	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:35:24.095275
1505	firewall	1329	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:37:24.246366
1507	firewall	1331	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:39:24.406183
1509	firewall	1333	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:41:24.553488
1511	firewall	1335	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:43:24.700954
1513	firewall	1337	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:45:24.862319
1515	firewall	1339	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:47:25.010465
1517	firewall	1341	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:49:25.157043
1519	firewall	1343	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:51:25.306798
1521	firewall	1345	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:53:25.466428
1523	firewall	1347	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:55:25.613927
1525	firewall	1349	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 11:57:25.781808
1527	firewall	1351	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 11:59:25.928855
1529	firewall	1353	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:01:26.0802
1531	firewall	1355	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:03:26.234306
1533	firewall	1357	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:05:26.400335
1535	firewall	1359	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:07:26.539537
1537	firewall	1361	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:09:26.694318
1539	firewall	1363	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:11:26.851756
1554	firewall	1365	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:28:23.60059
1556	firewall	1367	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:30:23.752622
1558	firewall	1369	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:32:23.909208
1560	firewall	1371	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:34:24.055997
680	firewall	567	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:47:03.341897
682	firewall	569	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:47:33.963557
684	firewall	571	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:48:05.916973
686	firewall	573	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:48:35.566123
688	firewall	575	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 12:49:04.621574
691	login	234	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:04:17.048546
693	login	236	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:04:48.733654
695	login	238	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 13:05:20.558
697	login	240	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:05:51.250647
699	login	242	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:06:24.806212
701	login	244	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:06:55.928841
703	login	246	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:07:27.60181
705	login	248	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:08:04.700513
706	firewall	577	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:08:20.931795
708	firewall	579	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:08:51.62644
710	firewall	581	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:09:26.528005
712	firewall	583	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:09:57.568088
714	firewall	585	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:10:29.594562
716	firewall	587	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:11:03.629806
718	firewall	589	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:11:36.652713
719	firewall	590	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:11:51.211796
720	firewall	591	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:12:06.477965
721	firewall	592	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:12:22.760599
722	firewall	593	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:12:39.585007
723	firewall	594	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:12:56.229559
724	firewall	595	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:13:11.597082
725	firewall	596	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:13:26.640193
726	firewall	597	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:13:42.470089
727	firewall	598	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:13:59.862901
728	firewall	599	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:14:17.099349
729	firewall	600	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:14:33.099415
730	firewall	601	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:14:47.889193
731	firewall	602	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:15:02.39069
732	firewall	603	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:15:17.943855
733	firewall	604	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:15:34.136591
734	firewall	605	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:15:49.402719
735	firewall	606	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:16:05.524848
736	login	249	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:34:14.410784
739	login	252	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:34:54.944858
741	login	254	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:35:28.019361
743	login	256	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:35:56.707582
745	login	258	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:36:22.751571
747	login	260	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:36:50.748961
749	login	262	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:37:22.53055
751	login	264	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:37:53.249905
778	login	266	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 14:04:35.292872
779	firewall	633	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 14:21:36.454088
784	login	315	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 17:04:35.285313
785	firewall	752	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 17:20:36.382561
789	login	349	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 19:04:35.282973
1478	firewall	1316	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:42:27.057488
1480	firewall	1318	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 10:44:27.210477
1483	login	589	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 11:15:22.489964
1485	login	591	100	critical	Failed login attempt (+30); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:17:22.659401
1487	login	593	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 11:19:22.8012
1489	login	595	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 11:21:22.947805
1491	login	597	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:23:23.106094
1493	login	599	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:25:23.260286
1495	login	601	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:27:23.412143
1496	firewall	1320	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:28:23.56527
1498	firewall	1322	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:30:23.717286
1500	firewall	1324	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:32:23.861455
1502	firewall	1326	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:34:24.018327
1504	firewall	1328	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:36:24.165341
1506	firewall	1330	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:38:24.320209
1508	firewall	1332	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:40:24.480111
1510	firewall	1334	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:42:24.625341
1512	firewall	1336	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:44:24.77218
1514	firewall	1338	25	medium	Internal lateral movement detected (+25)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 11:46:24.942668
1516	firewall	1340	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:48:25.087245
1518	firewall	1342	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:50:25.238239
1520	firewall	1344	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:52:25.384407
1522	firewall	1346	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:54:25.538082
1524	firewall	1348	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 11:56:25.706221
1526	firewall	1350	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 11:58:25.853031
1528	firewall	1352	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:00:26.00868
1530	firewall	1354	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:02:26.158139
1532	firewall	1356	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:04:26.31585
1534	firewall	1358	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:06:26.47221
740	login	253	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:35:12.353071
742	login	255	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:35:41.957137
744	login	257	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 13:36:10.606242
746	login	259	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 13:36:37.468783
748	login	261	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:37:06.336063
750	login	263	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:37:39.036194
752	login	265	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 13:38:09.182858
753	firewall	607	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:38:25.460167
755	firewall	609	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:38:55.293027
757	firewall	611	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:39:25.427428
759	firewall	613	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:39:53.952126
761	firewall	615	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:40:23.9372
763	firewall	617	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:40:54.237513
765	firewall	619	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:41:24.745485
767	firewall	621	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:41:54.434658
769	firewall	623	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:42:24.6522
771	firewall	625	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:42:54.617562
773	firewall	627	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:43:25.670123
775	firewall	629	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:43:53.723151
777	firewall	631	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:44:22.766763
782	login	301	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 16:04:35.291458
783	firewall	707	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 16:18:36.230512
1482	login	588	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 11:14:22.408471
1484	login	590	80	critical	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:16:22.57826
1486	login	592	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 11:18:22.730245
1488	login	594	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 11:20:22.87628
1490	login	596	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 11:22:23.023338
1492	login	598	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:24:23.178338
1494	login	600	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 11:26:23.334468
1540	login	602	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 12:14:22.419163
1542	login	604	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 12:16:22.580499
1544	login	606	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 12:18:22.728295
1546	login	608	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:20:22.884209
1548	login	610	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:22:23.029989
1550	login	612	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:24:23.177336
1552	login	614	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:26:23.343206
1553	firewall	1364	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:27:23.524445
754	firewall	608	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:38:40.004356
756	firewall	610	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:39:10.483185
758	firewall	612	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:39:40.583728
760	firewall	614	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:40:08.439493
762	firewall	616	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 13:40:39.639124
764	firewall	618	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:41:09.707854
766	firewall	620	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:41:39.525702
768	firewall	622	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:42:09.824145
770	firewall	624	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:42:39.889444
772	firewall	626	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:43:10.168337
774	firewall	628	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:43:39.50252
776	firewall	630	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 13:44:07.994597
780	login	283	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 15:04:35.285208
781	firewall	668	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 15:22:36.492175
786	login	331	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 18:04:35.293414
787	firewall	781	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 31337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 18:22:36.497467
788	patch	52	0	low	System patch level acceptable	Continue normal patch management schedule, maintain update monitoring	2025-11-20 18:51:38.445717
790	login	364	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 19:16:36.082601
791	login	365	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 19:17:36.180785
792	login	366	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 19:18:36.253282
793	login	367	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 19:19:36.338118
794	login	368	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 19:20:36.415956
795	login	369	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 19:21:36.490287
796	login	370	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 19:22:36.564289
797	login	371	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 19:23:36.639512
798	login	372	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 19:24:36.719238
799	login	373	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 19:25:36.789313
800	firewall	810	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:26:36.938148
801	firewall	811	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:27:37.009891
802	firewall	812	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:28:37.08831
803	firewall	813	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:29:37.164174
804	firewall	814	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:30:37.235467
805	firewall	815	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:31:37.307056
806	firewall	816	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:32:37.378753
807	firewall	817	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:33:37.453439
808	firewall	818	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:34:37.531166
809	firewall	819	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:35:37.610556
810	firewall	820	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 31337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 19:36:37.684619
811	firewall	821	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:37:37.758401
812	firewall	822	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:38:37.83329
813	firewall	823	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:39:37.904681
814	firewall	824	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:40:37.973537
815	firewall	825	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:41:38.048502
816	firewall	826	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:42:38.120273
817	firewall	827	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 19:43:38.19086
818	login	374	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 19:44:38.259334
819	firewall	858	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 4444 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 20:27:41.136641
821	firewall	860	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 20:29:41.288452
823	firewall	862	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 20:31:41.447513
825	firewall	864	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:33:41.596837
827	firewall	866	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:35:41.739375
829	firewall	868	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:37:41.894515
831	firewall	870	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:39:42.041592
833	firewall	872	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:41:42.189052
835	firewall	874	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:43:42.3451
837	firewall	876	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:45:42.489682
839	firewall	878	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:47:42.638787
840	login	387	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:14:22.413723
1536	firewall	1360	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:08:26.618119
1538	firewall	1362	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:10:26.767462
1541	login	603	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 12:15:22.5093
1543	login	605	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 12:17:22.655434
1545	login	607	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 12:19:22.806547
1547	login	609	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 12:21:22.953971
1549	login	611	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:23:23.103337
1551	login	613	120	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 12:25:23.265393
1585	login	615	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 13:14:22.416779
1587	login	617	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 13:16:22.566617
1589	login	619	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 13:18:22.719333
1591	login	621	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 13:20:22.884057
1593	login	623	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 13:22:23.026276
1595	login	625	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 13:24:23.17297
1597	login	627	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 13:26:23.324591
1599	login	629	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 13:28:23.469272
1600	firewall	1396	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:29:23.614563
1602	firewall	1398	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:31:23.770529
1604	firewall	1400	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:33:23.921513
1606	firewall	1402	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:35:24.068218
1608	firewall	1404	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:37:24.219205
1610	firewall	1406	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:39:24.364213
820	firewall	859	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 20:28:41.21201
822	firewall	861	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 20:30:41.361342
824	firewall	863	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 20:32:41.517309
826	firewall	865	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:34:41.666522
828	firewall	867	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:36:41.822462
830	firewall	869	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:38:41.969406
832	firewall	871	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:40:42.110295
834	firewall	873	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:42:42.268294
836	firewall	875	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:44:42.418638
838	firewall	877	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 20:46:42.564328
841	login	388	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:15:22.487248
842	login	389	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:16:22.560182
843	login	390	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:17:22.637573
844	login	391	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:18:22.715749
845	login	392	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-20 21:19:22.787241
846	login	393	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-20 21:20:22.855025
847	login	394	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 21:21:22.932467
848	login	395	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 21:22:23.000195
849	login	396	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 21:23:23.070855
850	login	397	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 21:24:23.145478
851	login	398	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 21:25:23.218515
852	firewall	879	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:26:23.347183
853	firewall	880	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:27:23.417263
854	firewall	881	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:28:23.506508
855	firewall	882	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:29:23.583121
856	firewall	883	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:30:23.658379
857	firewall	884	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:31:23.732163
858	firewall	885	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:32:23.815075
859	firewall	886	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:33:23.886593
860	firewall	887	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:34:23.969809
861	firewall	888	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 4444 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 21:35:24.041325
862	firewall	889	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:36:24.121199
863	firewall	890	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:37:24.199498
864	firewall	891	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:38:24.271209
865	firewall	892	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 21:39:24.338337
866	firewall	893	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:40:24.408927
867	firewall	894	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:41:24.484576
868	firewall	895	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:42:24.552317
869	firewall	896	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:43:24.622446
870	firewall	897	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:44:24.691242
871	firewall	898	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:45:24.761482
873	firewall	900	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:47:24.918388
875	firewall	902	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:49:25.092388
877	firewall	904	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:51:25.243213
879	firewall	906	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:53:25.397624
882	login	400	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 22:15:22.492674
884	login	402	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 22:17:22.654675
886	login	404	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 22:19:22.799435
888	login	406	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:21:22.945252
890	login	408	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:23:23.085226
892	login	410	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:25:23.232817
893	firewall	908	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:26:23.402287
895	firewall	910	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:28:23.553488
897	firewall	912	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:30:23.712298
899	firewall	914	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:32:23.864697
901	firewall	916	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:34:24.016252
903	firewall	918	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:36:24.163822
905	firewall	920	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:38:24.309423
907	firewall	922	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:40:24.449271
909	firewall	924	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:42:24.595778
911	firewall	926	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:44:24.747621
913	firewall	928	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:46:24.900776
915	firewall	930	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:48:25.049008
917	firewall	932	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6667 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 22:50:25.202321
919	firewall	934	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:52:25.352948
921	firewall	936	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:54:25.514356
923	firewall	938	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:56:25.667342
925	firewall	940	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:58:25.811721
927	firewall	942	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:00:25.970321
929	firewall	944	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:02:26.134183
931	firewall	946	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:04:26.279804
933	firewall	948	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:06:26.443305
936	login	412	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 23:15:22.486276
938	login	414	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 23:17:22.635946
940	login	416	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 23:19:22.783788
942	login	418	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 23:21:22.936368
944	login	420	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 23:23:23.08023
945	firewall	950	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:24:23.220567
947	firewall	952	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:26:23.381891
949	firewall	954	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:28:23.537197
872	firewall	899	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:46:24.834422
874	firewall	901	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:48:25.004104
876	firewall	903	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:50:25.171193
878	firewall	905	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:52:25.320716
880	firewall	907	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 21:54:25.479392
894	firewall	909	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:27:23.477182
896	firewall	911	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:29:23.634186
898	firewall	913	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:31:23.785258
900	firewall	915	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:33:23.939418
902	firewall	917	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:35:24.087409
904	firewall	919	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:37:24.232305
906	firewall	921	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:39:24.379452
908	firewall	923	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:41:24.521338
910	firewall	925	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:43:24.670315
912	firewall	927	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:45:24.818174
914	firewall	929	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:47:24.979593
916	firewall	931	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:49:25.123515
918	firewall	933	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 22:51:25.274777
920	firewall	935	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:53:25.438302
922	firewall	937	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:55:25.589602
924	firewall	939	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:57:25.736397
926	firewall	941	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 22:59:25.886248
928	firewall	943	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:01:26.054127
930	firewall	945	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:03:26.209595
932	firewall	947	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:05:26.362183
934	firewall	949	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:07:26.516471
946	firewall	951	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:25:23.306133
948	firewall	953	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:27:23.458578
950	firewall	955	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:29:23.61644
952	firewall	957	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:31:23.768063
954	firewall	959	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 4444 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 23:33:23.924328
956	firewall	961	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:35:24.069186
958	firewall	963	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:37:24.218234
960	firewall	965	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:39:24.373797
962	firewall	967	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:41:24.524515
964	firewall	969	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:43:24.673174
966	firewall	971	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:45:24.827729
968	firewall	973	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:47:24.980125
970	firewall	975	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:49:25.141482
972	firewall	977	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:51:25.294322
974	firewall	979	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:53:25.436275
1555	firewall	1366	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:29:23.677098
1557	firewall	1368	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:31:23.82587
881	login	399	100	critical	Failed login attempt (+30); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:14:22.415287
883	login	401	100	critical	Failed login attempt (+30); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:16:22.570198
885	login	403	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 22:18:22.730305
887	login	405	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 22:20:22.873257
889	login	407	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:22:23.017305
891	login	409	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 22:24:23.165218
935	login	411	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-20 23:14:22.401269
937	login	413	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 23:16:22.562383
939	login	415	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-20 23:18:22.713963
941	login	417	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 23:20:22.862561
943	login	419	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-20 23:22:23.005004
1559	firewall	1370	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:33:23.983558
1561	firewall	1372	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:35:24.12443
1563	firewall	1374	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:37:24.274605
1565	firewall	1376	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:39:24.423457
1567	firewall	1378	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:41:24.586597
1569	firewall	1380	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:43:24.737417
1571	firewall	1382	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:45:24.893631
1573	firewall	1384	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:47:25.058345
1575	firewall	1386	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:49:25.212891
1577	firewall	1388	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:51:25.359231
1579	firewall	1390	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:53:25.509199
1581	firewall	1392	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:55:25.662261
1583	firewall	1394	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:57:25.829802
1586	login	616	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 13:15:22.497145
1588	login	618	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 13:17:22.640124
1590	login	620	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 13:19:22.801247
1592	login	622	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 13:21:22.957791
1594	login	624	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 13:23:23.102069
1596	login	626	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 13:25:23.241635
1598	login	628	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 13:27:23.394272
1638	login	630	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 14:14:22.414857
1640	login	632	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 14:16:22.570371
1642	login	634	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:18:22.723256
1644	login	636	40	medium	Failed login attempt (+30); Login during 00:00-05:00 hours (+10)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 14:20:22.880137
1646	login	638	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:22:23.032329
1648	login	640	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:24:23.177715
1650	login	642	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:26:23.326235
951	firewall	956	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:30:23.689414
953	firewall	958	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:32:23.84242
955	firewall	960	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:34:23.998486
957	firewall	962	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:36:24.143349
959	firewall	964	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:38:24.301441
961	firewall	966	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6667 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-20 23:40:24.449381
963	firewall	968	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:42:24.596634
965	firewall	970	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:44:24.758353
967	firewall	972	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:46:24.906326
969	firewall	974	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:48:25.067374
971	firewall	976	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:50:25.218498
973	firewall	978	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-20 23:52:25.363298
975	firewall	980	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:54:25.505681
976	firewall	981	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:55:25.580347
977	firewall	982	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:56:25.653853
978	firewall	983	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:57:25.735306
979	firewall	984	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:58:25.808096
980	firewall	985	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-20 23:59:25.888658
981	firewall	986	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:00:25.964906
982	firewall	987	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:01:26.057193
983	firewall	988	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:02:26.129924
984	firewall	989	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:03:26.204257
985	firewall	990	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:04:26.284788
986	firewall	991	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:05:26.361112
987	firewall	992	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:06:26.429492
988	firewall	993	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:07:26.501325
989	login	421	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:14:22.411572
990	login	422	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:15:22.487232
991	login	423	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 00:16:22.560854
992	login	424	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:17:22.632161
993	login	425	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 00:18:22.710349
994	login	426	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:19:22.795328
995	login	427	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:20:22.877357
996	login	428	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 00:21:22.94826
997	login	429	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 00:22:23.027646
998	login	430	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 00:23:23.09931
999	login	431	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 00:24:23.170715
1000	login	432	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 00:25:23.2397
1001	login	433	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 00:26:23.318052
1007	firewall	995	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:32:23.878937
1002	login	434	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 00:27:23.399697
1004	login	436	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 00:29:23.551199
1039	login	438	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:14:22.413036
1041	login	440	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 01:16:22.567188
1043	login	442	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 01:18:22.716508
1045	login	444	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:20:22.851213
1047	login	446	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:22:22.997613
1049	login	448	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 01:24:23.146172
1051	login	450	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:26:23.302638
1053	login	452	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:28:23.455478
1055	login	454	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:30:23.606091
1057	login	456	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:32:23.752884
1058	firewall	1027	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:33:23.902141
1060	firewall	1029	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:35:24.0453
1062	firewall	1031	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:37:24.223358
1064	firewall	1033	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:39:24.367116
1066	firewall	1035	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:41:24.524536
1068	firewall	1037	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:43:24.671495
1070	firewall	1039	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:45:24.821138
1072	firewall	1041	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:47:24.971141
1074	firewall	1043	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:49:25.124166
1076	firewall	1045	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:51:25.288818
1078	firewall	1047	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:53:25.441264
1080	firewall	1049	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:55:25.592589
1082	firewall	1051	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:57:25.742667
1084	firewall	1053	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:59:25.894313
1087	login	458	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 02:15:22.490915
1089	login	460	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 02:17:22.650403
1091	login	462	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 02:19:22.797933
1093	login	464	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 02:21:22.954435
1095	login	466	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:23:23.09655
1097	login	468	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 02:25:23.246287
1099	login	470	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:27:23.39922
1101	login	472	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:29:23.550034
1103	login	474	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:31:23.701772
1003	login	435	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 00:28:23.483818
1005	login	437	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 00:30:23.622958
1006	firewall	994	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:31:23.805221
1008	firewall	996	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:33:23.950421
1010	firewall	998	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:35:24.10641
1012	firewall	1000	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:37:24.272701
1014	firewall	1002	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:39:24.417995
1016	firewall	1004	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:41:24.571383
1018	firewall	1006	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:43:24.740529
1020	firewall	1008	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:45:24.881047
1022	firewall	1010	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:47:25.029608
1024	firewall	1012	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:49:25.193329
1026	firewall	1014	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:51:25.343146
1028	firewall	1016	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:53:25.490007
1030	firewall	1018	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:55:25.63839
1032	firewall	1020	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:57:25.784495
1034	firewall	1022	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:59:25.943317
1036	firewall	1024	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:01:26.096876
1038	firewall	1026	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:03:26.248381
1059	firewall	1028	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:34:23.97575
1061	firewall	1030	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:36:24.139229
1063	firewall	1032	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:38:24.295394
1065	firewall	1034	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:40:24.448082
1067	firewall	1036	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:42:24.592722
1069	firewall	1038	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 01:44:24.7437
1071	firewall	1040	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:46:24.898854
1073	firewall	1042	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:48:25.04543
1075	firewall	1044	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:50:25.207235
1077	firewall	1046	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:52:25.36526
1079	firewall	1048	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:54:25.520939
1081	firewall	1050	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:56:25.666369
1083	firewall	1052	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:58:25.816661
1085	firewall	1054	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:00:25.964435
1105	firewall	1056	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:33:23.932243
1107	firewall	1058	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:35:24.079253
1109	firewall	1060	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:37:24.237369
1111	firewall	1062	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:39:24.383463
1113	firewall	1064	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:41:24.554338
1115	firewall	1066	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:43:24.704717
1117	firewall	1068	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:45:24.850294
1009	firewall	997	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:34:24.025596
1011	firewall	999	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:36:24.200666
1013	firewall	1001	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:38:24.343289
1015	firewall	1003	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:40:24.499569
1017	firewall	1005	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:42:24.653241
1019	firewall	1007	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:44:24.809499
1021	firewall	1009	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:46:24.96144
1023	firewall	1011	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 00:48:25.107984
1025	firewall	1013	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:50:25.270226
1027	firewall	1015	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:52:25.41425
1029	firewall	1017	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:54:25.562376
1031	firewall	1019	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:56:25.710534
1033	firewall	1021	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 00:58:25.869515
1035	firewall	1023	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:00:26.024473
1037	firewall	1025	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 01:02:26.172437
1040	login	439	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:15:22.491443
1042	login	441	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:17:22.635268
1044	login	443	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 01:19:22.783207
1046	login	445	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 01:21:22.927272
1048	login	447	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:23:23.069554
1050	login	449	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:25:23.224236
1052	login	451	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 01:27:23.378891
1054	login	453	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:29:23.534327
1056	login	455	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 01:31:23.673132
1086	login	457	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 02:14:22.4132
1088	login	459	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 02:16:22.568415
1090	login	461	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 02:18:22.724262
1092	login	463	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 02:20:22.866212
1094	login	465	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 02:22:23.025349
1096	login	467	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 02:24:23.173844
1098	login	469	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 02:26:23.326461
1100	login	471	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:28:23.480196
1102	login	473	130	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 02:30:23.62631
1562	firewall	1373	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:36:24.198322
1564	firewall	1375	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:38:24.353279
1566	firewall	1377	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:40:24.511556
1568	firewall	1379	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 12:42:24.657962
1570	firewall	1381	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:44:24.806398
1789	login	670	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 17:18:22.727917
1104	firewall	1055	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:32:23.850493
1106	firewall	1057	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:34:24.006236
1108	firewall	1059	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:36:24.161524
1110	firewall	1061	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 1337 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 02:38:24.308423
1112	firewall	1063	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:40:24.466315
1114	firewall	1065	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:42:24.626287
1116	firewall	1067	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 02:44:24.781567
1118	firewall	1069	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:46:24.924844
1120	firewall	1071	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:48:25.081273
1122	firewall	1073	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:50:25.226177
1572	firewall	1383	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:46:24.970654
1574	firewall	1385	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:48:25.132372
1576	firewall	1387	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:50:25.286191
1578	firewall	1389	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:52:25.437577
1580	firewall	1391	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:54:25.58802
1582	firewall	1393	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:56:25.745258
1584	firewall	1395	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 12:58:25.901575
1601	firewall	1397	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:30:23.694776
1603	firewall	1399	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:32:23.849156
1605	firewall	1401	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:34:23.995414
1607	firewall	1403	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:36:24.146545
1609	firewall	1405	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:38:24.290714
1611	firewall	1407	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:40:24.437637
1613	firewall	1409	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:42:24.596673
1615	firewall	1411	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:44:24.739462
1617	firewall	1413	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:46:24.886536
1619	firewall	1415	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:48:25.051401
1621	firewall	1417	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:50:25.198165
1623	firewall	1419	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:52:25.350929
1625	firewall	1421	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:54:25.49598
1627	firewall	1423	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:56:25.636696
1629	firewall	1425	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:58:25.786452
1631	firewall	1427	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:00:25.951253
1633	firewall	1429	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:02:26.113914
1635	firewall	1431	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:04:26.253233
1637	firewall	1433	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:06:26.413465
1652	firewall	1435	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:28:23.578835
1654	firewall	1437	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:30:23.729421
1656	firewall	1439	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:32:23.879594
1658	firewall	1441	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:34:24.032723
1660	firewall	1443	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:36:24.17144
1119	firewall	1070	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:47:25.001805
1121	firewall	1072	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:49:25.153642
1123	firewall	1074	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:51:25.305013
1124	firewall	1075	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:52:25.376223
1125	firewall	1076	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:53:25.448441
1126	firewall	1077	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:54:25.523081
1127	firewall	1078	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:55:25.605551
1128	firewall	1079	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:56:25.684337
1129	firewall	1080	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:57:25.765199
1130	firewall	1081	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:58:25.84347
1131	firewall	1082	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 02:59:25.922109
1132	firewall	1083	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:00:25.997296
1133	login	475	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 03:14:22.405808
1134	login	476	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 03:15:22.490648
1135	login	477	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 03:16:22.571344
1136	login	478	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 03:17:22.653159
1137	login	479	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 03:18:22.721312
1138	login	480	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 03:19:22.800352
1139	login	481	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 03:20:22.877481
1140	login	482	70	high	Admin account targeted (+40); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 03:21:22.947433
1141	login	483	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 03:22:23.016452
1142	login	484	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 03:23:23.092199
1143	login	485	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 03:24:23.165
1144	login	486	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 03:25:23.238116
1145	login	487	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 03:26:23.312091
1146	login	488	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 03:27:23.389849
1147	login	489	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 03:28:23.459234
1148	firewall	1084	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:29:23.615398
1149	firewall	1085	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:30:23.6883
1150	firewall	1086	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:31:23.770407
1151	firewall	1087	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:32:23.840599
1152	firewall	1088	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:33:23.913296
1153	firewall	1089	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:34:23.990462
1154	firewall	1090	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 4444 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 03:35:24.061272
1155	firewall	1091	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:36:24.137714
1156	firewall	1092	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:37:24.211153
1157	firewall	1093	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:38:24.300788
1158	firewall	1094	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:39:24.388667
1159	firewall	1095	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:40:24.458429
1161	firewall	1097	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:42:24.612526
1163	firewall	1099	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:44:24.762641
1165	firewall	1101	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:46:24.91621
1167	firewall	1103	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:48:25.082614
1169	firewall	1105	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:50:25.243228
1171	firewall	1107	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:52:25.388245
1173	firewall	1109	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:54:25.536105
1175	firewall	1111	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:56:25.679336
1177	firewall	1113	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:58:25.838047
1179	firewall	1115	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 04:00:25.981832
1181	firewall	1117	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 04:02:26.133782
1203	firewall	1119	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:35:24.100648
1205	firewall	1121	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:37:24.255372
1207	firewall	1123	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:39:24.394856
1209	firewall	1125	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:41:24.544581
1211	firewall	1127	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:43:24.703681
1213	firewall	1129	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:45:24.850628
1215	firewall	1131	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:47:24.99655
1217	firewall	1133	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:49:25.145574
1219	firewall	1135	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:51:25.297887
1221	firewall	1137	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:53:25.448311
1223	firewall	1139	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:55:25.597472
1225	firewall	1141	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:57:25.745157
1612	firewall	1408	20	low	Unusual port 1337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:41:24.517878
1614	firewall	1410	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:43:24.666236
1616	firewall	1412	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:45:24.809287
1618	firewall	1414	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:47:24.962623
1620	firewall	1416	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:49:25.12119
1622	firewall	1418	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 13:51:25.277581
1624	firewall	1420	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:53:25.425265
1626	firewall	1422	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:55:25.568502
1628	firewall	1424	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:57:25.704403
1630	firewall	1426	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 13:59:25.862185
1632	firewall	1428	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:01:26.036882
1634	firewall	1430	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:03:26.182245
1636	firewall	1432	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:05:26.325155
1639	login	631	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 14:15:22.489223
1641	login	633	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:17:22.639298
1643	login	635	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 14:19:22.804315
1645	login	637	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 14:21:22.952198
1160	firewall	1096	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 03:41:24.534855
1162	firewall	1098	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:43:24.686727
1164	firewall	1100	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:45:24.835957
1166	firewall	1102	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 03:47:24.987996
1168	firewall	1104	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:49:25.169768
1170	firewall	1106	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:51:25.313664
1172	firewall	1108	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:53:25.464534
1174	firewall	1110	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:55:25.607182
1176	firewall	1112	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:57:25.764494
1178	firewall	1114	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 03:59:25.908186
1180	firewall	1116	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 04:01:26.058261
1183	login	491	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:15:22.483678
1185	login	493	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:17:22.637102
1187	login	495	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:19:22.779675
1189	login	497	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 04:21:22.938569
1191	login	499	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 04:23:23.080752
1193	login	501	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:25:23.233562
1195	login	503	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:27:23.392773
1197	login	505	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 04:29:23.546608
1199	login	507	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 04:31:23.702838
1201	login	509	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 04:33:23.866436
1202	firewall	1118	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:34:24.019357
1204	firewall	1120	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:36:24.183364
1206	firewall	1122	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:38:24.326314
1208	firewall	1124	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:40:24.465203
1210	firewall	1126	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:42:24.617898
1212	firewall	1128	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:44:24.778558
1214	firewall	1130	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:46:24.922116
1216	firewall	1132	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:48:25.0723
1218	firewall	1134	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:50:25.219684
1220	firewall	1136	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:52:25.376672
1222	firewall	1138	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:54:25.519224
1224	firewall	1140	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 04:56:25.670171
1647	login	639	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:23:23.106901
1649	login	641	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 14:25:23.253538
1727	firewall	1499	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:03:26.246619
1730	login	655	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 16:15:22.485227
1732	login	657	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 16:17:22.646506
1734	login	659	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 16:19:22.812346
1736	login	661	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:21:22.968898
1182	login	490	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:14:22.407509
1184	login	492	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 04:16:22.565309
1186	login	494	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 04:18:22.707789
1188	login	496	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 04:20:22.855997
1190	login	498	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:22:23.007728
1192	login	500	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:24:23.16212
1194	login	502	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 04:26:23.317292
1196	login	504	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 04:28:23.470312
1198	login	506	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 04:30:23.614322
1200	login	508	90	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 04:32:23.79355
1651	firewall	1434	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:27:23.500499
1653	firewall	1436	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:29:23.655274
1655	firewall	1438	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:31:23.803993
1657	firewall	1440	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:33:23.958222
1659	firewall	1442	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:35:24.104261
1661	firewall	1444	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 14:37:24.246206
1663	firewall	1446	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:39:24.403945
1665	firewall	1448	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:41:24.552507
1667	firewall	1450	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:43:24.703566
1669	firewall	1452	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:45:24.858213
1671	firewall	1454	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:47:25.008848
1673	firewall	1456	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 14:49:25.158154
1738	login	663	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:23:23.119199
1740	login	665	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 16:25:23.263527
1741	firewall	1501	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:26:23.382691
1743	firewall	1503	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:28:23.542353
1745	firewall	1505	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:30:23.694059
1747	firewall	1507	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:32:23.854095
1749	firewall	1509	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:34:23.997212
1751	firewall	1511	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:36:24.147746
1753	firewall	1513	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:38:24.297046
1755	firewall	1515	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:40:24.454817
1757	firewall	1517	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:42:24.602356
1759	firewall	1519	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:44:24.758489
1761	firewall	1521	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:46:24.904623
1763	firewall	1523	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:48:25.051671
1765	firewall	1525	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:50:25.202364
1767	firewall	1527	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6667 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 16:52:25.367698
1769	firewall	1529	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 16:54:25.516278
1771	firewall	1531	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:56:25.678779
1773	firewall	1533	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 16:58:25.819453
1796	firewall	1546	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:25:23.395878
1788	login	669	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 17:17:22.652569
1790	login	671	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:19:22.796074
1792	login	673	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:21:22.963983
1794	login	675	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:23:23.129636
1795	firewall	1545	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:24:23.291408
1797	firewall	1547	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:26:23.47117
1799	firewall	1549	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:28:23.622982
1801	firewall	1551	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:30:23.775234
1803	firewall	1553	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:32:23.923804
1805	firewall	1555	25	medium	Internal lateral movement detected (+25)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 17:34:24.071136
1807	firewall	1557	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:36:24.22276
1809	firewall	1559	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:38:24.397716
1811	firewall	1561	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:40:24.551725
1813	firewall	1563	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:42:24.705265
1815	firewall	1565	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:44:24.870971
1817	firewall	1567	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:46:25.016235
1819	firewall	1569	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:48:25.169604
1821	firewall	1571	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:50:25.309247
1823	firewall	1573	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:52:25.469428
1825	firewall	1575	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:54:25.628255
1827	firewall	1577	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:56:25.771043
1829	firewall	1579	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:58:25.938471
1831	firewall	1581	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:00:26.086688
1834	login	677	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 18:15:22.494543
1836	login	679	70	high	Failed login attempt (+30); Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 18:17:22.651454
1838	login	681	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:19:22.798405
1840	login	683	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:21:22.944446
1842	login	685	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:23:23.104597
1844	login	687	80	critical	Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:25:23.25135
1846	login	689	70	high	Failed login attempt (+30); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 18:27:23.405846
1848	login	691	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:29:23.549059
1850	login	693	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:31:23.705309
1852	login	695	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:33:23.851448
1853	firewall	1583	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:34:23.992277
1855	firewall	1585	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:36:24.13386
1857	firewall	1587	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:38:24.285568
1859	firewall	1589	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:40:24.430563
1861	firewall	1591	20	low	Unusual port 4444 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:42:24.590006
1863	firewall	1593	20	low	Repeated connection attempts/denials detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:44:24.737547
1865	firewall	1595	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:46:24.894555
1791	login	672	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:20:22.88014
1793	login	674	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 17:22:23.045254
1833	login	676	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 18:14:22.419987
1835	login	678	30	medium	Failed login attempt (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 18:16:22.572537
1837	login	680	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:18:22.729222
1839	login	682	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:20:22.868878
1841	login	684	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:22:23.025394
1843	login	686	50	high	Login during 00:00-05:00 hours (+10); Admin account targeted (+40)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 18:24:23.181456
1845	login	688	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 18:26:23.324018
1847	login	690	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 18:28:23.477648
1849	login	692	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:30:23.622758
1851	login	694	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 18:32:23.776594
1884	login	696	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:14:22.417484
1886	login	698	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:16:22.572269
1888	login	700	40	medium	Login during 00:00-05:00 hours (+10); Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:18:22.728263
1890	login	702	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:20:22.878178
1892	login	704	40	medium	Failed login attempt (+30); Login during 00:00-05:00 hours (+10)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:22:23.03402
1798	firewall	1548	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:27:23.544033
1800	firewall	1550	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:29:23.701613
1802	firewall	1552	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:31:23.845198
1804	firewall	1554	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:33:23.992648
1806	firewall	1556	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:35:24.146288
1808	firewall	1558	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:37:24.301577
1810	firewall	1560	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:39:24.473536
1812	firewall	1562	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:41:24.63029
1814	firewall	1564	20	low	Unusual port 6667 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:43:24.789405
1816	firewall	1566	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 17:45:24.94247
1818	firewall	1568	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:47:25.089402
1820	firewall	1570	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:49:25.238628
1822	firewall	1572	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:51:25.386249
1824	firewall	1574	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:53:25.547268
1826	firewall	1576	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:55:25.700935
1828	firewall	1578	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:57:25.858409
1830	firewall	1580	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 17:59:26.01321
1832	firewall	1582	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:01:26.156518
1854	firewall	1584	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:35:24.065222
1856	firewall	1586	20	low	Unusual port 31337 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:37:24.213889
1858	firewall	1588	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:39:24.36248
1860	firewall	1590	20	low	Unusual port 6697 detected (+20)	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:41:24.504187
1862	firewall	1592	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:43:24.659632
1864	firewall	1594	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:45:24.825402
1866	firewall	1596	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:47:24.965239
1868	firewall	1598	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:49:25.117818
1870	firewall	1600	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:51:25.260332
1872	firewall	1602	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:53:25.417346
1874	firewall	1604	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:55:25.569218
1876	firewall	1606	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:57:25.730343
1878	firewall	1608	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:59:25.896591
1880	firewall	1610	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 19:01:26.039858
1882	firewall	1612	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 19:03:26.183997
1885	login	697	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:15:22.494237
1887	login	699	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:17:22.646931
1889	login	701	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:19:22.802246
1891	login	703	40	medium	Admin account targeted (+40)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:21:22.956343
1867	firewall	1597	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 18:48:25.036501
1869	firewall	1599	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:50:25.185309
1871	firewall	1601	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:52:25.342149
1873	firewall	1603	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:54:25.496923
1875	firewall	1605	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:56:25.656747
1877	firewall	1607	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 18:58:25.808206
1879	firewall	1609	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 19:00:25.968988
1881	firewall	1611	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 19:02:26.114926
1883	firewall	1613	55	high	Repeated connection attempts/denials detected (+20); Port scanning activity detected (+35)	Block suspicious IP, investigate destination systems, review firewall rules	2025-11-21 19:04:26.262177
1893	login	705	60	high	Failed login attempt (+30); Suspicious source IP detected (+30)	Investigate login source, verify user identity, consider temporary account restriction	2025-11-21 19:23:23.108328
1894	login	706	0	low	Normal login activity detected	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:24:23.183164
1895	login	707	10	low	Login during 00:00-05:00 hours (+10)	Continue normal monitoring, log event for baseline analysis	2025-11-21 19:25:23.270765
1896	login	708	30	medium	Suspicious source IP detected (+30)	Monitor account for additional suspicious activity, verify with user if unexpected	2025-11-21 19:26:23.352191
1897	login	709	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 19:27:23.42885
1898	login	710	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 19:28:23.512185
1899	login	711	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 19:29:23.589048
1900	login	712	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 19:30:23.6612
1901	login	713	80	critical	Failed login attempt (+30); 3rd+ failure in short time window (+20); Suspicious source IP detected (+30)	IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP	2025-11-21 19:31:23.737499
1902	firewall	1614	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:32:23.886424
1903	firewall	1615	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:33:23.962155
1904	firewall	1616	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:34:24.048777
1905	firewall	1617	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:35:24.128284
1906	firewall	1618	40	medium	Repeated connection attempts/denials detected (+20); Unusual port 6697 detected (+20)	Monitor source IP, verify legitimacy of connection attempts, update IDS rules	2025-11-21 19:36:24.205747
1907	firewall	1619	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:37:24.278467
1908	firewall	1620	0	low	Normal firewall activity detected	Continue normal monitoring, maintain firewall logs for analysis	2025-11-21 19:38:24.353434
\.


--
-- Data for Name: firewall_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.firewall_logs (id, src_ip, dst_ip, action, port, protocol, "timestamp", is_port_scan, is_lateral_movement, is_malicious_range, is_connection_spike) FROM stdin;
1	203.0.113.254	192.168.1.199	ALLOW	80	UDP	2025-11-20 04:51:11.011951	f	f	f	f
2	203.0.113.63	192.168.1.143	DENY	6697	UDP	2025-11-19 10:27:11.012049	f	f	f	f
3	203.0.113.241	192.168.1.148	ALLOW	1337	UDP	2025-11-19 13:53:11.012088	f	f	f	f
4	203.0.113.142	192.168.1.96	ALLOW	31337	TCP	2025-11-20 00:43:11.012128	f	f	f	f
5	203.0.113.123	192.168.1.242	DENY	5432	ICMP	2025-11-19 01:19:11.012156	f	f	f	f
6	192.168.1.239	192.168.1.1	DENY	445	ICMP	2025-11-20 00:31:11.012183	f	f	f	f
7	192.168.1.237	192.168.1.77	DENY	443	UDP	2025-11-19 14:12:11.012208	f	f	f	f
8	192.168.1.212	192.168.1.67	ALLOW	1337	ICMP	2025-11-19 17:10:11.012239	f	f	f	f
9	192.168.1.63	192.168.1.208	ALLOW	1337	ICMP	2025-11-19 21:21:11.012267	f	f	f	f
10	203.0.113.22	192.168.1.38	ALLOW	8443	TCP	2025-11-19 12:51:11.012293	f	f	f	f
11	203.0.113.135	192.168.1.201	ALLOW	6697	TCP	2025-11-20 03:56:11.012331	f	f	f	f
12	203.0.113.207	192.168.1.25	ALLOW	31337	UDP	2025-11-19 17:11:11.012356	f	f	f	f
13	192.168.1.139	192.168.1.19	DENY	6697	ICMP	2025-11-20 04:43:11.012381	f	f	f	f
14	203.0.113.87	192.168.1.101	DENY	6667	UDP	2025-11-20 01:13:11.012403	f	f	f	f
15	203.0.113.105	192.168.1.77	ALLOW	139	TCP	2025-11-19 19:44:11.012428	f	f	f	f
16	203.0.113.9	192.168.1.86	ALLOW	6667	UDP	2025-11-19 17:06:11.012454	f	f	f	f
17	192.168.1.112	192.168.1.173	ALLOW	8080	TCP	2025-11-19 14:08:11.012477	f	f	f	f
18	192.168.1.122	192.168.1.143	ALLOW	8080	TCP	2025-11-20 05:04:11.012501	f	f	f	f
19	203.0.113.99	192.168.1.85	ALLOW	4444	ICMP	2025-11-19 01:37:11.012524	f	f	f	f
20	192.168.1.50	192.168.1.92	DENY	31337	UDP	2025-11-19 18:48:11.012547	f	f	f	f
21	192.168.1.8	192.168.1.95	ALLOW	8080	ICMP	2025-11-19 10:32:11.012586	f	f	f	f
22	203.0.113.133	192.168.1.188	DENY	445	ICMP	2025-11-19 07:54:11.012627	f	f	f	f
23	203.0.113.160	192.168.1.83	DENY	20	TCP	2025-11-20 05:48:45.012671	t	f	f	t
24	203.0.113.160	192.168.1.83	DENY	21	TCP	2025-11-20 05:47:59.012696	t	f	f	t
25	203.0.113.160	192.168.1.83	DENY	22	TCP	2025-11-20 05:47:17.012712	t	f	f	t
26	203.0.113.160	192.168.1.83	DENY	23	TCP	2025-11-20 05:46:18.012728	t	f	f	t
27	203.0.113.160	192.168.1.83	DENY	24	TCP	2025-11-20 05:45:30.012783	t	f	f	t
28	203.0.113.160	192.168.1.83	DENY	25	TCP	2025-11-20 05:47:10.012804	t	f	f	t
29	203.0.113.160	192.168.1.83	DENY	26	TCP	2025-11-20 05:46:44.012821	t	f	f	t
30	203.0.113.160	192.168.1.83	DENY	27	TCP	2025-11-20 05:46:06.012837	t	f	f	t
31	203.0.113.160	192.168.1.83	DENY	28	TCP	2025-11-20 05:48:27.012852	t	f	f	t
32	203.0.113.160	192.168.1.83	DENY	29	TCP	2025-11-20 05:45:38.012867	t	f	f	t
33	203.0.113.160	192.168.1.83	DENY	30	TCP	2025-11-20 05:47:01.012883	t	f	f	t
34	203.0.113.160	192.168.1.83	DENY	31	TCP	2025-11-20 05:48:08.012898	t	f	f	t
35	203.0.113.160	192.168.1.83	DENY	32	TCP	2025-11-20 05:47:44.012915	t	f	f	t
36	203.0.113.160	192.168.1.83	DENY	33	TCP	2025-11-20 05:48:56.012932	t	f	f	t
37	203.0.113.160	192.168.1.83	DENY	34	TCP	2025-11-20 05:47:08.012948	t	f	f	t
38	203.0.113.33	192.168.1.228	DENY	6667	ICMP	2025-11-20 00:29:10.990555	f	f	f	f
39	192.168.1.158	192.168.1.199	ALLOW	80	UDP	2025-11-19 21:15:10.990642	f	f	f	f
40	203.0.113.75	192.168.1.73	ALLOW	443	ICMP	2025-11-20 04:03:10.990672	f	f	f	f
41	192.168.1.87	192.168.1.51	DENY	1337	TCP	2025-11-19 13:35:10.9907	f	f	f	f
42	203.0.113.227	192.168.1.135	DENY	5432	UDP	2025-11-19 12:46:10.990724	f	f	f	f
43	192.168.1.26	192.168.1.212	ALLOW	4444	UDP	2025-11-19 23:43:10.990764	f	f	f	f
44	203.0.113.148	192.168.1.195	ALLOW	139	TCP	2025-11-19 21:11:10.990789	f	f	f	f
45	203.0.113.183	192.168.1.217	ALLOW	1337	ICMP	2025-11-19 04:20:10.990812	f	f	f	f
46	203.0.113.253	192.168.1.243	ALLOW	443	UDP	2025-11-20 05:03:10.990836	f	f	f	t
47	203.0.113.179	192.168.1.247	ALLOW	139	ICMP	2025-11-19 22:22:10.990859	f	f	f	f
48	192.168.1.207	192.168.1.250	ALLOW	22	TCP	2025-11-19 14:30:10.990882	f	f	f	t
49	203.0.113.225	192.168.1.117	ALLOW	135	TCP	2025-11-19 23:53:10.99092	f	f	f	f
50	192.168.1.239	192.168.1.89	ALLOW	22	ICMP	2025-11-19 05:45:10.990944	f	f	f	f
51	192.168.1.72	192.168.1.40	ALLOW	3389	TCP	2025-11-19 00:56:10.990968	f	t	f	f
52	192.168.1.129	192.168.1.157	ALLOW	3306	TCP	2025-11-19 04:18:10.99099	f	f	f	f
53	203.0.113.194	192.168.1.189	ALLOW	6697	ICMP	2025-11-19 21:14:10.991013	f	f	f	f
54	203.0.113.10	192.168.1.93	DENY	22	ICMP	2025-11-19 21:51:10.991036	f	f	f	f
55	203.0.113.22	192.168.1.24	DENY	6697	TCP	2025-11-19 05:56:10.991062	f	f	f	f
56	192.168.1.89	192.168.1.248	ALLOW	22	UDP	2025-11-19 22:16:10.991085	f	f	f	f
57	203.0.113.35	192.168.1.206	ALLOW	3389	TCP	2025-11-20 01:28:10.99111	f	f	f	f
58	203.0.113.94	192.168.1.190	DENY	6697	ICMP	2025-11-20 02:45:10.991133	f	f	f	f
59	203.0.113.246	192.168.1.135	DENY	445	TCP	2025-11-19 15:09:10.991155	f	f	f	f
60	192.168.1.66	192.168.1.184	ALLOW	6697	ICMP	2025-11-19 07:44:10.991177	f	f	f	f
61	203.0.113.105	192.168.1.251	ALLOW	135	ICMP	2025-11-19 10:12:10.991201	f	f	f	f
62	192.168.1.190	192.168.1.37	ALLOW	135	UDP	2025-11-19 22:24:10.991223	f	f	f	f
63	203.0.113.3	192.168.1.238	ALLOW	80	TCP	2025-11-19 11:45:10.991247	f	f	f	f
64	192.168.1.88	192.168.1.25	DENY	5432	UDP	2025-11-19 13:18:10.991269	f	f	f	f
65	203.0.113.250	192.168.1.164	ALLOW	8443	TCP	2025-11-20 04:46:10.99129	f	f	f	f
66	192.168.1.26	192.168.1.137	DENY	4444	ICMP	2025-11-19 20:31:10.991313	f	f	f	f
67	203.0.113.253	192.168.1.36	DENY	3389	UDP	2025-11-19 13:10:10.991338	f	f	f	f
68	203.0.113.190	192.168.1.239	DENY	20	TCP	2025-11-20 06:16:57.991359	t	f	f	t
69	203.0.113.190	192.168.1.239	DENY	21	TCP	2025-11-20 06:16:10.991377	t	f	f	t
70	203.0.113.190	192.168.1.239	DENY	22	TCP	2025-11-20 06:18:46.991393	t	f	f	t
71	203.0.113.190	192.168.1.239	DENY	23	TCP	2025-11-20 06:18:46.991409	t	f	f	t
72	203.0.113.190	192.168.1.239	DENY	24	TCP	2025-11-20 06:16:50.991425	t	f	f	t
73	203.0.113.190	192.168.1.239	DENY	25	TCP	2025-11-20 06:18:16.991442	t	f	f	t
74	203.0.113.190	192.168.1.239	DENY	26	TCP	2025-11-20 06:19:49.99146	t	f	f	t
75	203.0.113.190	192.168.1.239	DENY	27	TCP	2025-11-20 06:20:08.991479	t	f	f	t
76	203.0.113.190	192.168.1.239	DENY	28	TCP	2025-11-20 06:18:15.991503	t	f	f	t
77	203.0.113.190	192.168.1.239	DENY	29	TCP	2025-11-20 06:18:32.991539	t	f	f	t
78	203.0.113.190	192.168.1.239	DENY	30	TCP	2025-11-20 06:19:16.991564	t	f	f	t
79	203.0.113.190	192.168.1.239	DENY	31	TCP	2025-11-20 06:19:52.991583	t	f	f	t
80	203.0.113.190	192.168.1.239	DENY	32	TCP	2025-11-20 06:16:38.9916	t	f	f	t
81	203.0.113.190	192.168.1.239	DENY	33	TCP	2025-11-20 06:16:52.991616	t	f	f	t
82	203.0.113.190	192.168.1.239	DENY	34	TCP	2025-11-20 06:17:14.991631	t	f	f	t
83	192.168.1.129	192.168.1.168	ALLOW	443	UDP	2025-11-20 06:05:42.05526	f	f	f	f
84	203.0.113.95	192.168.1.28	DENY	139	UDP	2025-11-20 01:30:42.055375	f	f	f	f
85	203.0.113.162	192.168.1.236	DENY	5432	UDP	2025-11-19 10:41:42.055415	f	f	f	t
86	203.0.113.97	192.168.1.68	DENY	4444	UDP	2025-11-19 05:05:42.055444	f	f	f	f
87	192.168.1.12	192.168.1.226	ALLOW	445	ICMP	2025-11-19 08:18:42.055484	f	f	f	f
88	192.168.1.233	192.168.1.223	ALLOW	31337	ICMP	2025-11-19 23:51:42.05551	f	f	f	f
89	203.0.113.74	192.168.1.177	ALLOW	139	ICMP	2025-11-20 05:14:42.055538	f	f	f	f
90	203.0.113.71	192.168.1.125	ALLOW	1337	ICMP	2025-11-19 20:07:42.055572	f	f	f	f
91	203.0.113.21	192.168.1.89	DENY	5432	ICMP	2025-11-19 13:59:42.055601	f	f	f	f
92	203.0.113.217	192.168.1.227	ALLOW	8080	UDP	2025-11-19 23:49:42.055627	f	f	f	f
93	192.168.1.27	192.168.1.64	ALLOW	445	ICMP	2025-11-19 02:32:42.055654	f	f	f	f
94	203.0.113.10	192.168.1.134	DENY	443	ICMP	2025-11-19 18:37:42.055677	f	f	f	f
95	192.168.1.110	192.168.1.59	ALLOW	8443	TCP	2025-11-19 10:05:42.055701	f	f	f	f
96	203.0.113.83	192.168.1.176	DENY	20	TCP	2025-11-20 06:43:11.055723	t	f	f	t
97	203.0.113.83	192.168.1.176	DENY	21	TCP	2025-11-20 06:44:19.055757	t	f	f	t
98	203.0.113.83	192.168.1.176	DENY	22	TCP	2025-11-20 06:42:59.055775	t	f	f	t
99	203.0.113.83	192.168.1.176	DENY	23	TCP	2025-11-20 06:42:45.055792	t	f	f	t
100	203.0.113.83	192.168.1.176	DENY	24	TCP	2025-11-20 06:43:26.055811	t	f	f	t
101	203.0.113.83	192.168.1.176	DENY	25	TCP	2025-11-20 06:43:54.055827	t	f	f	t
102	203.0.113.83	192.168.1.176	DENY	26	TCP	2025-11-20 06:45:16.055845	t	f	f	t
103	203.0.113.83	192.168.1.176	DENY	27	TCP	2025-11-20 06:44:37.055861	t	f	f	t
104	203.0.113.83	192.168.1.176	DENY	28	TCP	2025-11-20 06:45:35.055877	t	f	f	t
105	203.0.113.83	192.168.1.176	DENY	29	TCP	2025-11-20 06:44:50.055895	t	f	f	t
106	203.0.113.83	192.168.1.176	DENY	30	TCP	2025-11-20 06:44:44.055911	t	f	f	t
107	203.0.113.83	192.168.1.176	DENY	31	TCP	2025-11-20 06:45:32.05593	t	f	f	t
108	203.0.113.83	192.168.1.176	DENY	32	TCP	2025-11-20 06:42:44.055946	t	f	f	t
109	203.0.113.83	192.168.1.176	DENY	33	TCP	2025-11-20 06:43:44.055962	t	f	f	t
110	203.0.113.83	192.168.1.176	DENY	34	TCP	2025-11-20 06:43:13.055977	t	f	f	t
111	192.168.1.82	192.168.1.24	DENY	31337	ICMP	2025-11-19 00:54:39.718126	f	f	f	f
112	203.0.113.173	192.168.1.61	ALLOW	6667	ICMP	2025-11-19 03:01:39.718223	f	f	f	f
113	203.0.113.62	192.168.1.79	DENY	135	TCP	2025-11-19 19:19:39.718263	f	f	f	f
114	203.0.113.72	192.168.1.222	DENY	443	ICMP	2025-11-20 05:47:39.718294	f	f	f	f
115	203.0.113.9	192.168.1.135	ALLOW	3306	ICMP	2025-11-19 13:50:39.718321	f	f	f	f
116	192.168.1.221	192.168.1.36	DENY	22	TCP	2025-11-19 11:04:39.718346	f	f	f	f
117	203.0.113.243	192.168.1.102	ALLOW	139	ICMP	2025-11-19 19:59:39.718372	f	f	f	f
118	192.168.1.242	192.168.1.216	ALLOW	6667	TCP	2025-11-19 05:16:39.718415	f	f	f	f
119	192.168.1.61	192.168.1.74	ALLOW	8443	UDP	2025-11-19 06:35:39.71845	f	f	f	f
120	192.168.1.191	192.168.1.214	DENY	1337	TCP	2025-11-19 03:51:39.718478	f	f	f	f
121	203.0.113.86	192.168.1.123	DENY	22	ICMP	2025-11-20 04:04:39.718505	f	f	f	f
122	203.0.113.233	192.168.1.175	DENY	135	TCP	2025-11-19 15:21:39.71853	f	f	f	t
123	203.0.113.177	192.168.1.145	ALLOW	3306	ICMP	2025-11-19 22:06:39.718555	f	f	f	f
124	203.0.113.40	192.168.1.46	DENY	1337	UDP	2025-11-20 02:09:39.718579	f	f	f	f
125	203.0.113.80	192.168.1.254	ALLOW	6697	UDP	2025-11-20 02:26:39.718603	f	f	f	t
126	203.0.113.197	192.168.1.97	ALLOW	22	ICMP	2025-11-19 16:07:39.718627	f	f	f	f
127	192.168.1.196	192.168.1.46	ALLOW	3389	ICMP	2025-11-20 06:37:39.718653	f	f	f	f
128	203.0.113.237	192.168.1.125	DENY	20	TCP	2025-11-20 06:53:12.718682	t	f	f	t
129	203.0.113.237	192.168.1.125	DENY	21	TCP	2025-11-20 06:49:33.718701	t	f	f	t
130	203.0.113.237	192.168.1.125	DENY	22	TCP	2025-11-20 06:52:23.718719	t	f	f	t
131	203.0.113.237	192.168.1.125	DENY	23	TCP	2025-11-20 06:52:15.718757	t	f	f	t
132	203.0.113.237	192.168.1.125	DENY	24	TCP	2025-11-20 06:49:47.718775	t	f	f	t
133	203.0.113.237	192.168.1.125	DENY	25	TCP	2025-11-20 06:51:04.718791	t	f	f	t
134	203.0.113.237	192.168.1.125	DENY	26	TCP	2025-11-20 06:53:21.718809	t	f	f	t
135	203.0.113.237	192.168.1.125	DENY	27	TCP	2025-11-20 06:51:06.718825	t	f	f	t
136	203.0.113.237	192.168.1.125	DENY	28	TCP	2025-11-20 06:52:12.718844	t	f	f	t
137	203.0.113.237	192.168.1.125	DENY	29	TCP	2025-11-20 06:52:49.718862	t	f	f	t
138	203.0.113.237	192.168.1.125	DENY	30	TCP	2025-11-20 06:49:18.718878	t	f	f	t
139	203.0.113.237	192.168.1.125	DENY	31	TCP	2025-11-20 06:52:47.718894	t	f	f	t
140	203.0.113.237	192.168.1.125	DENY	32	TCP	2025-11-20 06:50:44.71891	t	f	f	t
141	203.0.113.237	192.168.1.125	DENY	33	TCP	2025-11-20 06:50:43.718926	t	f	f	t
142	203.0.113.237	192.168.1.125	DENY	34	TCP	2025-11-20 06:52:55.718942	t	f	f	t
143	203.0.113.191	192.168.1.74	ALLOW	5432	TCP	2025-11-19 17:08:38.342472	f	f	f	f
144	192.168.1.90	192.168.1.154	ALLOW	5432	TCP	2025-11-19 16:22:38.342595	f	f	f	f
145	203.0.113.184	192.168.1.169	ALLOW	443	ICMP	2025-11-19 09:24:38.342628	f	f	f	f
146	192.168.1.199	192.168.1.103	ALLOW	5432	ICMP	2025-11-19 22:38:38.342654	f	f	f	f
147	192.168.1.250	192.168.1.207	DENY	443	ICMP	2025-11-20 05:03:38.342681	f	f	f	f
148	192.168.1.242	192.168.1.93	ALLOW	139	TCP	2025-11-20 05:36:38.342709	f	f	f	f
149	203.0.113.195	192.168.1.95	DENY	5432	TCP	2025-11-19 04:58:38.342752	f	f	f	f
150	192.168.1.195	192.168.1.100	ALLOW	6667	ICMP	2025-11-19 22:33:38.342783	f	f	f	f
151	192.168.1.152	192.168.1.71	ALLOW	8443	ICMP	2025-11-20 06:51:38.342812	f	f	f	f
152	192.168.1.248	192.168.1.138	ALLOW	445	UDP	2025-11-19 21:13:38.342838	f	f	f	t
153	192.168.1.157	192.168.1.207	DENY	445	TCP	2025-11-19 16:42:38.342865	f	f	f	t
154	203.0.113.163	192.168.1.33	ALLOW	3306	UDP	2025-11-19 02:27:38.342892	f	f	f	f
155	203.0.113.252	192.168.1.66	ALLOW	1337	TCP	2025-11-19 01:20:38.342919	f	f	f	f
156	203.0.113.97	192.168.1.133	ALLOW	443	ICMP	2025-11-19 21:52:38.342943	f	f	f	f
157	203.0.113.40	192.168.1.213	DENY	1337	TCP	2025-11-20 06:55:38.342966	f	f	f	f
158	192.168.1.180	192.168.1.24	ALLOW	31337	TCP	2025-11-19 20:56:38.34299	f	f	f	f
159	203.0.113.227	192.168.1.70	DENY	4444	UDP	2025-11-19 01:17:38.34305	f	f	f	f
160	203.0.113.34	192.168.1.51	DENY	3389	ICMP	2025-11-19 03:37:38.343075	f	f	f	f
161	203.0.113.115	192.168.1.30	DENY	6697	UDP	2025-11-19 14:44:38.3431	f	f	f	f
162	192.168.1.124	192.168.1.199	ALLOW	8080	TCP	2025-11-19 10:13:38.343124	f	f	f	f
163	192.168.1.180	192.168.1.244	ALLOW	5432	ICMP	2025-11-19 04:21:38.34315	f	f	f	f
164	192.168.1.226	192.168.1.181	ALLOW	5432	ICMP	2025-11-20 00:43:38.343175	f	f	f	f
165	203.0.113.216	192.168.1.72	DENY	20	TCP	2025-11-20 07:10:05.343199	t	f	f	t
166	203.0.113.216	192.168.1.72	DENY	21	TCP	2025-11-20 07:12:26.343218	t	f	f	t
167	203.0.113.216	192.168.1.72	DENY	22	TCP	2025-11-20 07:13:25.343236	t	f	f	t
168	203.0.113.216	192.168.1.72	DENY	23	TCP	2025-11-20 07:10:25.343265	t	f	f	t
169	203.0.113.216	192.168.1.72	DENY	24	TCP	2025-11-20 07:11:42.3433	t	f	f	t
170	203.0.113.216	192.168.1.72	DENY	25	TCP	2025-11-20 07:14:03.343326	t	f	f	t
171	203.0.113.216	192.168.1.72	DENY	26	TCP	2025-11-20 07:12:43.343351	t	f	f	t
172	203.0.113.216	192.168.1.72	DENY	27	TCP	2025-11-20 07:12:08.343379	t	f	f	t
173	203.0.113.216	192.168.1.72	DENY	28	TCP	2025-11-20 07:11:54.343396	t	f	f	t
174	203.0.113.216	192.168.1.72	DENY	29	TCP	2025-11-20 07:09:51.343412	t	f	f	t
175	203.0.113.216	192.168.1.72	DENY	30	TCP	2025-11-20 07:14:09.343429	t	f	f	t
176	203.0.113.216	192.168.1.72	DENY	31	TCP	2025-11-20 07:13:58.343448	t	f	f	t
177	203.0.113.216	192.168.1.72	DENY	32	TCP	2025-11-20 07:10:07.343467	t	f	f	t
178	203.0.113.216	192.168.1.72	DENY	33	TCP	2025-11-20 07:12:53.343497	t	f	f	t
179	203.0.113.216	192.168.1.72	DENY	34	TCP	2025-11-20 07:13:22.343545	t	f	f	t
180	192.168.1.244	192.168.1.61	ALLOW	445	TCP	2025-11-19 01:40:28.832642	f	f	f	f
181	192.168.1.248	192.168.1.89	DENY	8443	UDP	2025-11-19 21:59:28.832787	f	f	f	f
182	203.0.113.150	192.168.1.11	ALLOW	443	UDP	2025-11-20 04:44:28.832835	f	f	f	f
183	203.0.113.53	192.168.1.234	ALLOW	139	ICMP	2025-11-19 23:20:28.832877	f	f	f	f
184	192.168.1.56	192.168.1.147	ALLOW	445	ICMP	2025-11-19 15:15:28.832916	f	f	f	f
185	203.0.113.119	192.168.1.236	DENY	31337	TCP	2025-11-19 08:04:28.832953	f	f	f	f
186	203.0.113.52	192.168.1.79	DENY	1337	UDP	2025-11-19 15:44:28.832992	f	f	f	f
187	192.168.1.5	192.168.1.33	ALLOW	445	ICMP	2025-11-20 05:03:28.833029	f	f	f	f
188	203.0.113.146	192.168.1.209	ALLOW	22	UDP	2025-11-19 05:36:28.833065	f	f	f	f
189	203.0.113.122	192.168.1.145	ALLOW	6667	ICMP	2025-11-20 04:00:28.833104	f	f	f	f
190	192.168.1.199	192.168.1.54	ALLOW	445	TCP	2025-11-19 01:44:28.833142	f	f	f	f
191	192.168.1.203	192.168.1.33	ALLOW	6667	ICMP	2025-11-20 03:19:28.833181	f	f	f	f
192	203.0.113.137	192.168.1.190	ALLOW	5432	TCP	2025-11-19 12:05:28.833219	f	f	f	f
193	203.0.113.77	192.168.1.123	DENY	20	TCP	2025-11-20 07:38:14.833255	t	f	f	t
194	203.0.113.77	192.168.1.123	DENY	21	TCP	2025-11-20 07:38:23.833283	t	f	f	t
195	203.0.113.77	192.168.1.123	DENY	22	TCP	2025-11-20 07:37:07.83331	t	f	f	t
196	203.0.113.77	192.168.1.123	DENY	23	TCP	2025-11-20 07:37:18.833336	t	f	f	t
197	203.0.113.77	192.168.1.123	DENY	24	TCP	2025-11-20 07:37:49.833362	t	f	f	t
198	203.0.113.77	192.168.1.123	DENY	25	TCP	2025-11-20 07:35:58.833401	t	f	f	t
199	203.0.113.77	192.168.1.123	DENY	26	TCP	2025-11-20 07:37:13.833429	t	f	f	t
200	203.0.113.77	192.168.1.123	DENY	27	TCP	2025-11-20 07:37:32.833456	t	f	f	t
201	203.0.113.77	192.168.1.123	DENY	28	TCP	2025-11-20 07:35:20.833482	t	f	f	t
202	203.0.113.77	192.168.1.123	DENY	29	TCP	2025-11-20 07:36:52.83352	t	f	f	t
203	203.0.113.77	192.168.1.123	DENY	30	TCP	2025-11-20 07:34:43.833545	t	f	f	t
204	203.0.113.77	192.168.1.123	DENY	31	TCP	2025-11-20 07:36:27.83357	t	f	f	t
205	203.0.113.77	192.168.1.123	DENY	32	TCP	2025-11-20 07:37:08.833597	t	f	f	t
206	203.0.113.77	192.168.1.123	DENY	33	TCP	2025-11-20 07:37:43.833621	t	f	f	t
207	203.0.113.77	192.168.1.123	DENY	34	TCP	2025-11-20 07:36:45.833638	t	f	f	t
208	203.0.113.54	192.168.1.153	DENY	80	TCP	2025-11-20 03:28:35.383923	f	f	f	f
209	203.0.113.218	192.168.1.43	ALLOW	6697	UDP	2025-11-19 21:06:35.384037	f	f	f	f
210	192.168.1.192	192.168.1.101	ALLOW	445	TCP	2025-11-19 19:25:35.384081	f	f	f	f
211	192.168.1.190	192.168.1.68	DENY	31337	UDP	2025-11-19 09:01:35.384121	f	f	f	f
212	203.0.113.55	192.168.1.78	ALLOW	135	UDP	2025-11-19 11:20:35.384158	f	f	f	f
213	203.0.113.217	192.168.1.205	DENY	5432	UDP	2025-11-19 03:18:35.384193	f	f	f	f
214	203.0.113.218	192.168.1.202	ALLOW	135	TCP	2025-11-19 20:35:35.384229	f	f	f	f
215	192.168.1.149	192.168.1.214	DENY	3306	UDP	2025-11-20 00:42:35.384265	f	f	f	f
216	192.168.1.168	192.168.1.176	DENY	5432	TCP	2025-11-20 04:13:35.384304	f	f	f	f
217	192.168.1.86	192.168.1.80	ALLOW	5432	TCP	2025-11-19 10:57:35.384342	f	f	f	f
218	203.0.113.83	192.168.1.29	ALLOW	4444	UDP	2025-11-19 12:15:35.384378	f	f	f	t
219	203.0.113.175	192.168.1.226	ALLOW	135	TCP	2025-11-19 17:44:35.384415	f	f	f	f
220	203.0.113.122	192.168.1.186	DENY	3389	UDP	2025-11-20 07:25:35.384453	f	f	f	f
221	203.0.113.235	192.168.1.140	DENY	1337	ICMP	2025-11-20 07:35:35.38449	f	f	f	f
222	203.0.113.207	192.168.1.124	ALLOW	139	TCP	2025-11-19 22:33:35.384527	f	f	f	f
223	192.168.1.112	192.168.1.105	ALLOW	1337	TCP	2025-11-19 08:46:35.384564	f	f	f	f
224	203.0.113.178	192.168.1.58	ALLOW	22	ICMP	2025-11-20 00:17:35.3846	f	f	f	f
225	203.0.113.94	192.168.1.102	ALLOW	6697	TCP	2025-11-19 03:43:35.384638	f	f	f	f
226	203.0.113.165	192.168.1.170	ALLOW	8080	ICMP	2025-11-19 11:45:35.384676	f	f	f	f
227	192.168.1.36	192.168.1.99	ALLOW	80	UDP	2025-11-19 04:28:35.384749	f	f	f	f
228	192.168.1.86	192.168.1.9	ALLOW	6697	ICMP	2025-11-19 22:32:35.384787	f	f	f	f
229	203.0.113.74	192.168.1.240	ALLOW	135	TCP	2025-11-20 07:25:35.384822	f	f	f	f
230	203.0.113.191	192.168.1.89	ALLOW	139	UDP	2025-11-20 05:05:35.384859	f	f	f	f
231	192.168.1.135	192.168.1.211	DENY	1337	ICMP	2025-11-19 02:51:35.384897	f	f	f	t
232	203.0.113.197	192.168.1.227	DENY	5432	TCP	2025-11-19 03:27:35.384934	f	f	f	f
233	203.0.113.211	192.168.1.130	DENY	31337	UDP	2025-11-19 12:41:35.384972	f	f	f	f
234	192.168.1.185	192.168.1.220	DENY	443	TCP	2025-11-19 22:16:35.385008	f	f	f	f
235	203.0.113.219	192.168.1.242	DENY	22	TCP	2025-11-19 23:45:35.385051	f	f	f	f
236	192.168.1.31	192.168.1.228	ALLOW	5432	UDP	2025-11-19 14:02:35.385089	f	f	f	f
237	203.0.113.192	192.168.1.183	ALLOW	135	TCP	2025-11-19 02:36:35.385127	f	f	f	f
238	203.0.113.74	192.168.1.197	DENY	20	TCP	2025-11-20 08:05:04.385162	t	f	f	t
239	203.0.113.74	192.168.1.197	DENY	21	TCP	2025-11-20 08:07:19.385188	t	f	f	t
240	203.0.113.74	192.168.1.197	DENY	22	TCP	2025-11-20 08:06:17.385216	t	f	f	t
241	203.0.113.74	192.168.1.197	DENY	23	TCP	2025-11-20 08:06:35.385242	t	f	f	t
242	203.0.113.74	192.168.1.197	DENY	24	TCP	2025-11-20 08:03:32.385267	t	f	f	t
243	203.0.113.74	192.168.1.197	DENY	25	TCP	2025-11-20 08:06:21.385294	t	f	f	t
244	203.0.113.74	192.168.1.197	DENY	26	TCP	2025-11-20 08:05:49.385322	t	f	f	t
245	203.0.113.74	192.168.1.197	DENY	27	TCP	2025-11-20 08:07:23.385356	t	f	f	t
246	203.0.113.74	192.168.1.197	DENY	28	TCP	2025-11-20 08:05:06.385384	t	f	f	t
247	203.0.113.74	192.168.1.197	DENY	29	TCP	2025-11-20 08:03:11.385412	t	f	f	t
248	203.0.113.74	192.168.1.197	DENY	30	TCP	2025-11-20 08:07:08.38544	t	f	f	t
249	203.0.113.74	192.168.1.197	DENY	31	TCP	2025-11-20 08:06:32.385468	t	f	f	t
250	203.0.113.74	192.168.1.197	DENY	32	TCP	2025-11-20 08:06:41.385495	t	f	f	t
251	203.0.113.74	192.168.1.197	DENY	33	TCP	2025-11-20 08:04:18.385521	t	f	f	t
252	203.0.113.74	192.168.1.197	DENY	34	TCP	2025-11-20 08:05:17.385542	t	f	f	t
253	192.168.1.240	192.168.1.152	ALLOW	1337	UDP	2025-11-20 05:12:30.91348	f	f	f	f
254	192.168.1.106	192.168.1.180	ALLOW	8080	ICMP	2025-11-19 13:18:30.913573	f	f	f	f
255	192.168.1.49	192.168.1.199	ALLOW	5432	ICMP	2025-11-19 05:45:30.913603	f	f	f	f
256	192.168.1.218	192.168.1.203	DENY	6697	UDP	2025-11-20 08:12:30.913629	f	f	f	f
257	192.168.1.170	192.168.1.50	ALLOW	6697	UDP	2025-11-19 05:38:30.913656	f	f	f	f
258	192.168.1.154	192.168.1.102	ALLOW	6667	ICMP	2025-11-19 16:13:30.91368	f	f	f	f
259	192.168.1.156	192.168.1.49	ALLOW	6667	ICMP	2025-11-19 13:56:30.913705	f	f	f	f
260	203.0.113.8	192.168.1.178	ALLOW	3306	UDP	2025-11-20 01:10:30.913748	f	f	f	f
261	192.168.1.133	192.168.1.230	DENY	8443	TCP	2025-11-20 01:47:30.913772	f	f	f	f
262	192.168.1.64	192.168.1.109	ALLOW	31337	TCP	2025-11-19 02:51:30.913797	f	f	f	f
263	192.168.1.83	192.168.1.169	ALLOW	80	UDP	2025-11-19 08:15:30.913819	f	f	f	f
264	203.0.113.199	192.168.1.252	DENY	20	TCP	2025-11-20 08:33:14.913841	t	f	f	t
265	203.0.113.199	192.168.1.252	DENY	21	TCP	2025-11-20 08:35:08.91386	t	f	f	t
266	203.0.113.199	192.168.1.252	DENY	22	TCP	2025-11-20 08:33:06.913877	t	f	f	t
267	203.0.113.199	192.168.1.252	DENY	23	TCP	2025-11-20 08:36:26.913894	t	f	f	t
268	203.0.113.199	192.168.1.252	DENY	24	TCP	2025-11-20 08:34:21.913911	t	f	f	t
269	203.0.113.199	192.168.1.252	DENY	25	TCP	2025-11-20 08:34:37.913928	t	f	f	t
270	203.0.113.199	192.168.1.252	DENY	26	TCP	2025-11-20 08:37:17.913945	t	f	f	t
271	203.0.113.199	192.168.1.252	DENY	27	TCP	2025-11-20 08:36:37.913978	t	f	f	t
272	203.0.113.199	192.168.1.252	DENY	28	TCP	2025-11-20 08:35:48.913995	t	f	f	t
273	203.0.113.199	192.168.1.252	DENY	29	TCP	2025-11-20 08:34:40.914011	t	f	f	t
274	203.0.113.199	192.168.1.252	DENY	30	TCP	2025-11-20 08:32:39.914028	t	f	f	t
275	203.0.113.199	192.168.1.252	DENY	31	TCP	2025-11-20 08:34:54.914044	t	f	f	t
276	203.0.113.199	192.168.1.252	DENY	32	TCP	2025-11-20 08:36:41.91406	t	f	f	t
277	203.0.113.199	192.168.1.252	DENY	33	TCP	2025-11-20 08:33:54.914077	t	f	f	t
278	203.0.113.199	192.168.1.252	DENY	34	TCP	2025-11-20 08:35:31.914093	t	f	f	t
279	203.0.113.51	192.168.1.151	ALLOW	3306	ICMP	2025-11-20 00:10:26.146283	f	f	f	f
280	192.168.1.229	192.168.1.152	ALLOW	80	ICMP	2025-11-20 01:05:26.146397	f	f	f	f
281	192.168.1.209	192.168.1.42	DENY	4444	UDP	2025-11-20 07:37:26.146433	f	f	f	f
282	192.168.1.196	192.168.1.104	ALLOW	6697	TCP	2025-11-20 03:22:26.14646	f	f	f	t
283	192.168.1.190	192.168.1.244	ALLOW	1337	UDP	2025-11-20 02:08:26.146497	f	f	f	f
284	192.168.1.147	192.168.1.245	DENY	8080	TCP	2025-11-19 05:39:26.146538	f	f	f	t
285	192.168.1.51	192.168.1.195	ALLOW	1337	ICMP	2025-11-19 20:03:26.146576	f	f	f	f
286	203.0.113.18	192.168.1.82	DENY	443	ICMP	2025-11-19 20:45:26.146628	f	f	f	f
287	203.0.113.233	192.168.1.68	ALLOW	80	UDP	2025-11-19 23:25:26.146663	f	f	f	f
288	203.0.113.217	192.168.1.25	ALLOW	31337	TCP	2025-11-19 21:01:26.146687	f	f	f	f
289	192.168.1.230	192.168.1.75	ALLOW	8443	UDP	2025-11-19 07:07:26.14671	f	f	f	f
290	203.0.113.67	192.168.1.103	ALLOW	6697	UDP	2025-11-19 08:24:26.146756	f	f	f	f
291	192.168.1.235	192.168.1.165	ALLOW	22	UDP	2025-11-20 05:37:26.146788	f	f	f	f
292	192.168.1.224	192.168.1.193	ALLOW	6697	UDP	2025-11-19 05:22:26.146814	f	f	f	f
293	192.168.1.77	192.168.1.173	ALLOW	3389	ICMP	2025-11-20 04:17:26.14684	f	f	f	f
294	192.168.1.129	192.168.1.110	ALLOW	3306	ICMP	2025-11-19 08:50:26.146873	f	f	f	f
295	203.0.113.175	192.168.1.195	DENY	443	ICMP	2025-11-19 13:49:26.146897	f	f	f	t
296	192.168.1.5	192.168.1.194	ALLOW	80	UDP	2025-11-19 08:35:26.146921	f	f	f	f
297	192.168.1.14	192.168.1.28	ALLOW	445	TCP	2025-11-19 08:46:26.146942	f	f	f	f
298	203.0.113.114	192.168.1.131	ALLOW	1337	UDP	2025-11-20 08:57:26.146963	f	f	f	f
299	203.0.113.156	192.168.1.155	ALLOW	135	ICMP	2025-11-20 02:47:26.146986	f	f	f	t
300	203.0.113.96	192.168.1.91	ALLOW	139	ICMP	2025-11-20 06:38:26.14701	f	f	f	f
301	203.0.113.250	192.168.1.7	ALLOW	5432	UDP	2025-11-19 20:13:26.147032	f	f	f	f
302	203.0.113.69	192.168.1.63	DENY	20	TCP	2025-11-20 09:06:59.147054	t	f	f	t
303	203.0.113.69	192.168.1.63	DENY	21	TCP	2025-11-20 09:06:04.147073	t	f	f	t
304	203.0.113.69	192.168.1.63	DENY	22	TCP	2025-11-20 09:06:09.147094	t	f	f	t
305	203.0.113.69	192.168.1.63	DENY	23	TCP	2025-11-20 09:05:48.147118	t	f	f	t
306	203.0.113.69	192.168.1.63	DENY	24	TCP	2025-11-20 09:04:47.147136	t	f	f	t
307	203.0.113.69	192.168.1.63	DENY	25	TCP	2025-11-20 09:02:28.147153	t	f	f	t
308	203.0.113.69	192.168.1.63	DENY	26	TCP	2025-11-20 09:02:31.147169	t	f	f	t
309	203.0.113.69	192.168.1.63	DENY	27	TCP	2025-11-20 09:05:07.147189	t	f	f	t
310	203.0.113.69	192.168.1.63	DENY	28	TCP	2025-11-20 09:06:50.147214	t	f	f	t
311	203.0.113.69	192.168.1.63	DENY	29	TCP	2025-11-20 09:06:04.147231	t	f	f	t
312	203.0.113.69	192.168.1.63	DENY	30	TCP	2025-11-20 09:04:34.147247	t	f	f	t
313	203.0.113.69	192.168.1.63	DENY	31	TCP	2025-11-20 09:05:55.147268	t	f	f	t
314	203.0.113.69	192.168.1.63	DENY	32	TCP	2025-11-20 09:05:33.147292	t	f	f	t
315	203.0.113.69	192.168.1.63	DENY	33	TCP	2025-11-20 09:02:41.147312	t	f	f	t
316	203.0.113.69	192.168.1.63	DENY	34	TCP	2025-11-20 09:03:58.147328	t	f	f	t
317	192.168.1.236	192.168.1.183	ALLOW	80	UDP	2025-11-19 20:54:43.288686	f	f	f	f
318	203.0.113.227	192.168.1.101	ALLOW	8443	ICMP	2025-11-19 23:35:43.288819	f	f	f	f
319	192.168.1.184	192.168.1.95	DENY	3306	TCP	2025-11-20 03:58:43.288856	f	f	f	f
320	203.0.113.103	192.168.1.130	DENY	135	ICMP	2025-11-19 13:36:43.288892	f	f	f	f
321	203.0.113.229	192.168.1.225	ALLOW	8080	TCP	2025-11-20 02:16:43.288919	f	f	f	f
322	203.0.113.101	192.168.1.52	ALLOW	31337	UDP	2025-11-19 18:57:43.288944	f	f	f	f
323	192.168.1.19	192.168.1.104	DENY	445	UDP	2025-11-19 12:19:43.288967	f	f	f	t
324	192.168.1.145	192.168.1.49	ALLOW	135	ICMP	2025-11-20 01:56:43.288991	f	f	f	f
325	203.0.113.31	192.168.1.176	DENY	443	TCP	2025-11-20 05:51:43.289016	f	f	f	f
326	192.168.1.81	192.168.1.85	ALLOW	6667	TCP	2025-11-19 11:43:43.289041	f	f	f	f
327	203.0.113.74	192.168.1.155	ALLOW	8080	ICMP	2025-11-19 14:26:43.289065	f	f	f	f
328	203.0.113.3	192.168.1.14	ALLOW	3306	ICMP	2025-11-20 08:11:43.289089	f	f	f	f
329	192.168.1.76	192.168.1.106	DENY	443	UDP	2025-11-20 09:26:43.289113	f	f	f	f
330	203.0.113.15	192.168.1.48	DENY	443	UDP	2025-11-20 09:18:43.289137	f	f	f	t
331	203.0.113.167	192.168.1.70	ALLOW	3389	UDP	2025-11-19 18:41:43.289162	f	f	f	f
332	192.168.1.119	192.168.1.212	ALLOW	6697	UDP	2025-11-19 22:21:43.289188	f	f	f	t
333	203.0.113.132	192.168.1.115	DENY	443	TCP	2025-11-19 13:12:43.289214	f	f	f	t
334	192.168.1.156	192.168.1.251	ALLOW	4444	UDP	2025-11-19 21:50:43.289239	f	f	f	f
335	203.0.113.40	192.168.1.69	DENY	8443	ICMP	2025-11-19 14:50:43.289265	f	f	f	f
336	192.168.1.11	192.168.1.9	ALLOW	6697	UDP	2025-11-20 00:15:43.289288	f	f	f	f
337	192.168.1.78	192.168.1.182	DENY	80	TCP	2025-11-20 00:08:43.28931	f	f	f	f
338	192.168.1.250	192.168.1.86	ALLOW	1337	TCP	2025-11-19 18:51:43.289335	f	f	f	f
339	203.0.113.232	192.168.1.173	DENY	20	TCP	2025-11-20 09:33:45.289359	t	f	f	t
340	203.0.113.232	192.168.1.173	DENY	21	TCP	2025-11-20 09:38:40.289378	t	f	f	t
341	203.0.113.232	192.168.1.173	DENY	22	TCP	2025-11-20 09:35:58.289396	t	f	f	t
342	203.0.113.232	192.168.1.173	DENY	23	TCP	2025-11-20 09:38:34.289413	t	f	f	t
343	203.0.113.232	192.168.1.173	DENY	24	TCP	2025-11-20 09:38:35.289431	t	f	f	t
344	203.0.113.232	192.168.1.173	DENY	25	TCP	2025-11-20 09:35:22.289449	t	f	f	t
345	203.0.113.232	192.168.1.173	DENY	26	TCP	2025-11-20 09:36:16.289467	t	f	f	t
346	203.0.113.232	192.168.1.173	DENY	27	TCP	2025-11-20 09:34:18.289484	t	f	f	t
347	203.0.113.232	192.168.1.173	DENY	28	TCP	2025-11-20 09:36:33.289501	t	f	f	t
348	203.0.113.232	192.168.1.173	DENY	29	TCP	2025-11-20 09:38:16.289519	t	f	f	t
349	203.0.113.232	192.168.1.173	DENY	30	TCP	2025-11-20 09:34:22.289535	t	f	f	t
350	203.0.113.232	192.168.1.173	DENY	31	TCP	2025-11-20 09:36:43.289553	t	f	f	t
351	203.0.113.232	192.168.1.173	DENY	32	TCP	2025-11-20 09:36:06.28957	t	f	f	t
352	203.0.113.232	192.168.1.173	DENY	33	TCP	2025-11-20 09:35:21.289587	t	f	f	t
353	203.0.113.232	192.168.1.173	DENY	34	TCP	2025-11-20 09:33:52.289603	t	f	f	t
354	192.168.1.231	192.168.1.161	ALLOW	139	TCP	2025-11-19 17:40:50.797875	f	f	f	f
355	203.0.113.246	192.168.1.161	ALLOW	135	UDP	2025-11-19 16:35:50.797973	f	f	f	f
356	192.168.1.250	192.168.1.92	ALLOW	1337	TCP	2025-11-19 17:27:50.798012	f	f	f	f
357	203.0.113.83	192.168.1.79	DENY	3389	TCP	2025-11-20 03:21:50.798041	f	f	f	f
358	192.168.1.231	192.168.1.188	ALLOW	445	ICMP	2025-11-19 23:46:50.798066	f	f	f	f
359	203.0.113.84	192.168.1.248	DENY	445	TCP	2025-11-19 13:16:50.798091	f	f	f	f
360	203.0.113.103	192.168.1.182	ALLOW	135	TCP	2025-11-19 12:32:50.798126	f	f	f	f
361	192.168.1.69	192.168.1.233	DENY	443	TCP	2025-11-19 14:46:50.798151	f	f	f	f
362	203.0.113.170	192.168.1.160	ALLOW	139	UDP	2025-11-19 15:48:50.798175	f	f	f	f
363	192.168.1.105	192.168.1.224	DENY	443	ICMP	2025-11-19 06:56:50.7982	f	f	f	f
364	203.0.113.105	192.168.1.63	ALLOW	4444	ICMP	2025-11-19 20:17:50.798224	f	f	f	f
365	203.0.113.128	192.168.1.21	ALLOW	4444	TCP	2025-11-19 14:10:50.798248	f	f	f	f
366	192.168.1.176	192.168.1.120	ALLOW	31337	TCP	2025-11-19 10:48:50.79827	f	f	f	f
367	203.0.113.150	192.168.1.12	ALLOW	8080	TCP	2025-11-19 12:48:50.798293	f	f	f	f
368	203.0.113.124	192.168.1.105	ALLOW	139	ICMP	2025-11-19 07:08:50.798316	f	f	f	f
369	192.168.1.80	192.168.1.30	ALLOW	8080	TCP	2025-11-19 09:25:50.798339	f	f	f	t
370	192.168.1.207	192.168.1.60	ALLOW	4444	UDP	2025-11-20 00:29:50.798362	f	f	f	f
371	192.168.1.108	192.168.1.149	DENY	139	UDP	2025-11-20 05:13:50.798385	f	f	f	t
372	203.0.113.142	192.168.1.183	ALLOW	6667	TCP	2025-11-19 21:49:50.798408	f	f	f	f
373	203.0.113.202	192.168.1.134	DENY	20	TCP	2025-11-20 10:06:53.798429	t	f	f	t
374	203.0.113.202	192.168.1.134	DENY	21	TCP	2025-11-20 10:06:17.798448	t	f	f	t
375	203.0.113.202	192.168.1.134	DENY	22	TCP	2025-11-20 10:04:20.798464	t	f	f	t
376	203.0.113.202	192.168.1.134	DENY	23	TCP	2025-11-20 10:04:44.798481	t	f	f	t
377	203.0.113.202	192.168.1.134	DENY	24	TCP	2025-11-20 10:04:40.798497	t	f	f	t
378	203.0.113.202	192.168.1.134	DENY	25	TCP	2025-11-20 10:06:12.798514	t	f	f	t
379	203.0.113.202	192.168.1.134	DENY	26	TCP	2025-11-20 10:07:25.79853	t	f	f	t
380	203.0.113.202	192.168.1.134	DENY	27	TCP	2025-11-20 10:04:22.798547	t	f	f	t
381	203.0.113.202	192.168.1.134	DENY	28	TCP	2025-11-20 10:07:42.798564	t	f	f	t
382	203.0.113.202	192.168.1.134	DENY	29	TCP	2025-11-20 10:07:30.798581	t	f	f	t
383	203.0.113.202	192.168.1.134	DENY	30	TCP	2025-11-20 10:05:25.798597	t	f	f	t
384	203.0.113.202	192.168.1.134	DENY	31	TCP	2025-11-20 10:06:02.798614	t	f	f	t
385	203.0.113.202	192.168.1.134	DENY	32	TCP	2025-11-20 10:04:51.798631	t	f	f	t
386	203.0.113.202	192.168.1.134	DENY	33	TCP	2025-11-20 10:05:26.798647	t	f	f	t
387	203.0.113.202	192.168.1.134	DENY	34	TCP	2025-11-20 10:04:32.798664	t	f	f	t
388	192.168.1.8	192.168.1.103	DENY	4444	TCP	2025-11-19 19:17:48.348369	f	f	f	f
389	192.168.1.78	192.168.1.183	ALLOW	31337	TCP	2025-11-19 21:25:48.348448	f	f	f	f
390	192.168.1.19	192.168.1.181	ALLOW	22	ICMP	2025-11-19 17:21:48.348478	f	f	f	f
391	203.0.113.15	192.168.1.12	DENY	6667	ICMP	2025-11-19 06:21:48.348504	f	f	f	f
392	203.0.113.244	192.168.1.54	DENY	8443	TCP	2025-11-20 03:53:48.348529	f	f	f	f
393	203.0.113.48	192.168.1.128	DENY	8443	ICMP	2025-11-19 07:16:48.348554	f	f	f	t
394	192.168.1.218	192.168.1.26	ALLOW	443	TCP	2025-11-19 09:07:48.348579	f	f	f	f
395	203.0.113.191	192.168.1.99	ALLOW	443	UDP	2025-11-19 17:23:48.348603	f	f	f	f
396	203.0.113.243	192.168.1.24	DENY	22	TCP	2025-11-20 10:04:48.348627	f	f	f	f
397	203.0.113.166	192.168.1.195	ALLOW	3389	TCP	2025-11-20 04:23:48.348651	f	f	f	f
398	203.0.113.23	192.168.1.126	DENY	80	UDP	2025-11-19 04:42:48.348677	f	f	f	f
399	203.0.113.71	192.168.1.220	ALLOW	3306	TCP	2025-11-19 16:41:48.348718	f	f	f	t
400	203.0.113.195	192.168.1.66	ALLOW	6697	TCP	2025-11-19 21:17:48.348784	f	f	f	f
401	203.0.113.83	192.168.1.216	ALLOW	4444	UDP	2025-11-19 21:14:48.348822	f	f	f	f
402	203.0.113.101	192.168.1.77	ALLOW	135	TCP	2025-11-20 00:32:48.348855	f	f	f	f
403	192.168.1.235	192.168.1.133	DENY	31337	TCP	2025-11-19 16:39:48.348888	f	f	f	f
404	203.0.113.247	192.168.1.233	ALLOW	445	UDP	2025-11-19 18:51:48.348926	f	f	f	f
405	192.168.1.52	192.168.1.228	ALLOW	139	TCP	2025-11-20 02:28:48.348964	f	f	f	f
406	203.0.113.25	192.168.1.239	ALLOW	6697	ICMP	2025-11-19 16:10:48.349001	f	f	f	f
407	203.0.113.155	192.168.1.107	DENY	5432	TCP	2025-11-19 08:16:48.349038	f	f	f	f
408	192.168.1.193	192.168.1.17	DENY	4444	UDP	2025-11-20 06:04:48.349075	f	f	f	f
409	203.0.113.65	192.168.1.155	ALLOW	3389	ICMP	2025-11-19 10:31:48.349112	f	f	f	f
410	192.168.1.254	192.168.1.136	DENY	6697	UDP	2025-11-19 10:58:48.349148	f	f	f	f
411	192.168.1.6	192.168.1.127	ALLOW	135	ICMP	2025-11-19 22:12:48.349187	f	f	f	f
412	203.0.113.206	192.168.1.224	ALLOW	6697	TCP	2025-11-20 06:41:48.349236	f	f	f	t
413	203.0.113.80	192.168.1.217	ALLOW	6697	TCP	2025-11-19 10:02:48.349274	f	f	f	f
414	203.0.113.114	192.168.1.213	ALLOW	135	UDP	2025-11-20 00:06:48.349312	f	f	f	f
415	192.168.1.23	192.168.1.161	DENY	3389	ICMP	2025-11-19 14:01:48.349342	f	t	f	f
416	192.168.1.191	192.168.1.107	ALLOW	443	TCP	2025-11-20 04:19:48.349365	f	f	f	f
417	203.0.113.235	192.168.1.148	DENY	20	TCP	2025-11-20 10:36:15.349387	t	f	f	t
418	203.0.113.235	192.168.1.148	DENY	21	TCP	2025-11-20 10:37:34.349406	t	f	f	t
419	203.0.113.235	192.168.1.148	DENY	22	TCP	2025-11-20 10:35:59.349423	t	f	f	t
420	203.0.113.235	192.168.1.148	DENY	23	TCP	2025-11-20 10:36:21.349439	t	f	f	t
421	203.0.113.235	192.168.1.148	DENY	24	TCP	2025-11-20 10:36:46.349456	t	f	f	t
422	203.0.113.235	192.168.1.148	DENY	25	TCP	2025-11-20 10:33:21.349472	t	f	f	t
423	203.0.113.235	192.168.1.148	DENY	26	TCP	2025-11-20 10:33:48.349489	t	f	f	t
424	203.0.113.235	192.168.1.148	DENY	27	TCP	2025-11-20 10:37:21.349505	t	f	f	t
425	203.0.113.235	192.168.1.148	DENY	28	TCP	2025-11-20 10:33:05.349521	t	f	f	t
426	203.0.113.235	192.168.1.148	DENY	29	TCP	2025-11-20 10:34:26.349538	t	f	f	t
427	203.0.113.235	192.168.1.148	DENY	30	TCP	2025-11-20 10:35:19.349554	t	f	f	t
428	203.0.113.235	192.168.1.148	DENY	31	TCP	2025-11-20 10:34:41.34957	t	f	f	t
429	203.0.113.235	192.168.1.148	DENY	32	TCP	2025-11-20 10:34:55.349587	t	f	f	t
430	203.0.113.235	192.168.1.148	DENY	33	TCP	2025-11-20 10:36:39.349603	t	f	f	t
431	203.0.113.235	192.168.1.148	DENY	34	TCP	2025-11-20 10:35:50.349619	t	f	f	t
432	203.0.113.153	192.168.1.102	DENY	4444	ICMP	2025-11-20 01:18:49.459208	f	f	f	f
433	192.168.1.94	192.168.1.155	ALLOW	6667	TCP	2025-11-20 10:49:49.459338	f	f	f	t
434	192.168.1.35	192.168.1.146	ALLOW	3306	UDP	2025-11-19 19:36:49.459382	f	f	f	f
435	192.168.1.132	192.168.1.249	ALLOW	22	TCP	2025-11-20 09:16:49.459447	f	f	f	f
436	203.0.113.166	192.168.1.6	ALLOW	4444	UDP	2025-11-19 18:02:49.459489	f	f	f	f
437	192.168.1.200	192.168.1.46	ALLOW	8443	UDP	2025-11-20 06:42:49.459526	f	f	f	f
438	203.0.113.2	192.168.1.73	DENY	8443	ICMP	2025-11-19 08:03:49.459564	f	f	f	f
439	192.168.1.55	192.168.1.243	ALLOW	6697	UDP	2025-11-19 09:47:49.4596	f	f	f	f
440	192.168.1.45	192.168.1.17	DENY	443	UDP	2025-11-20 01:22:49.459637	f	f	f	f
441	203.0.113.122	192.168.1.161	ALLOW	8080	TCP	2025-11-19 17:15:49.45967	f	f	f	f
442	192.168.1.63	192.168.1.254	ALLOW	31337	TCP	2025-11-19 19:44:49.459706	f	f	f	f
443	192.168.1.79	192.168.1.237	ALLOW	445	UDP	2025-11-19 18:16:49.459772	f	f	f	t
444	192.168.1.160	192.168.1.106	ALLOW	5432	UDP	2025-11-19 05:10:49.459814	f	f	f	f
445	203.0.113.244	192.168.1.118	ALLOW	3389	ICMP	2025-11-19 22:28:49.459852	f	f	f	f
446	203.0.113.93	192.168.1.18	DENY	6697	TCP	2025-11-19 13:45:49.459892	f	f	f	f
447	203.0.113.13	192.168.1.47	ALLOW	443	ICMP	2025-11-20 07:34:49.45993	f	f	f	f
448	192.168.1.105	192.168.1.31	DENY	1337	UDP	2025-11-19 22:34:49.459969	f	f	f	f
449	203.0.113.247	192.168.1.77	ALLOW	139	TCP	2025-11-19 16:25:49.460005	f	f	f	f
450	192.168.1.97	192.168.1.149	DENY	5432	TCP	2025-11-19 08:15:49.460043	f	f	f	f
451	192.168.1.244	192.168.1.133	ALLOW	1337	TCP	2025-11-19 22:10:49.460079	f	f	f	f
452	203.0.113.181	192.168.1.59	DENY	3389	TCP	2025-11-20 00:13:49.460118	f	f	f	f
453	192.168.1.84	192.168.1.71	DENY	5432	UDP	2025-11-19 17:25:49.460154	f	f	f	f
454	203.0.113.124	192.168.1.138	DENY	20	TCP	2025-11-20 11:07:09.460188	t	f	f	t
455	203.0.113.124	192.168.1.138	DENY	21	TCP	2025-11-20 11:05:38.460216	t	f	f	t
456	203.0.113.124	192.168.1.138	DENY	22	TCP	2025-11-20 11:07:12.460242	t	f	f	t
457	203.0.113.124	192.168.1.138	DENY	23	TCP	2025-11-20 11:04:23.460269	t	f	f	t
458	203.0.113.124	192.168.1.138	DENY	24	TCP	2025-11-20 11:06:37.460295	t	f	f	t
459	203.0.113.124	192.168.1.138	DENY	25	TCP	2025-11-20 11:07:09.460321	t	f	f	t
460	203.0.113.124	192.168.1.138	DENY	26	TCP	2025-11-20 11:07:05.460347	t	f	f	t
461	203.0.113.124	192.168.1.138	DENY	27	TCP	2025-11-20 11:05:38.460373	t	f	f	t
462	203.0.113.124	192.168.1.138	DENY	28	TCP	2025-11-20 11:07:13.460398	t	f	f	t
463	203.0.113.124	192.168.1.138	DENY	29	TCP	2025-11-20 11:06:04.460437	t	f	f	t
464	203.0.113.124	192.168.1.138	DENY	30	TCP	2025-11-20 11:04:47.460464	t	f	f	t
465	203.0.113.124	192.168.1.138	DENY	31	TCP	2025-11-20 11:04:38.460489	t	f	f	t
466	203.0.113.124	192.168.1.138	DENY	32	TCP	2025-11-20 11:05:08.460515	t	f	f	t
467	203.0.113.124	192.168.1.138	DENY	33	TCP	2025-11-20 11:05:48.460545	t	f	f	t
468	203.0.113.124	192.168.1.138	DENY	34	TCP	2025-11-20 11:03:23.460572	t	f	f	t
469	192.168.1.97	192.168.1.101	DENY	3389	UDP	2025-11-19 17:21:53.266374	f	f	f	f
470	203.0.113.120	192.168.1.100	ALLOW	8080	TCP	2025-11-19 07:14:53.266465	f	f	f	f
471	203.0.113.207	192.168.1.190	ALLOW	4444	ICMP	2025-11-19 16:12:53.266515	f	f	f	f
472	203.0.113.20	192.168.1.102	ALLOW	1337	UDP	2025-11-19 13:52:53.266554	f	f	f	f
473	192.168.1.119	192.168.1.124	ALLOW	6667	TCP	2025-11-19 16:16:53.266591	f	f	f	f
474	203.0.113.52	192.168.1.102	ALLOW	6667	TCP	2025-11-20 00:00:53.266624	f	f	f	f
475	192.168.1.134	192.168.1.65	ALLOW	1337	TCP	2025-11-20 00:57:53.26665	f	f	f	f
476	192.168.1.167	192.168.1.218	DENY	139	TCP	2025-11-20 05:56:53.266672	f	f	f	f
477	192.168.1.21	192.168.1.145	DENY	6697	UDP	2025-11-20 11:15:53.266697	f	f	f	f
478	203.0.113.38	192.168.1.176	ALLOW	8080	UDP	2025-11-20 01:03:53.26672	f	f	f	f
479	192.168.1.24	192.168.1.97	ALLOW	139	ICMP	2025-11-20 06:59:53.266782	f	f	f	f
480	203.0.113.7	192.168.1.183	DENY	20	TCP	2025-11-20 11:36:58.266806	t	f	f	t
481	203.0.113.7	192.168.1.183	DENY	21	TCP	2025-11-20 11:34:28.266825	t	f	f	t
482	203.0.113.7	192.168.1.183	DENY	22	TCP	2025-11-20 11:33:55.266842	t	f	f	t
483	203.0.113.7	192.168.1.183	DENY	23	TCP	2025-11-20 11:38:38.266859	t	f	f	t
484	203.0.113.7	192.168.1.183	DENY	24	TCP	2025-11-20 11:37:52.266876	t	f	f	t
485	203.0.113.7	192.168.1.183	DENY	25	TCP	2025-11-20 11:35:47.266893	t	f	f	t
486	203.0.113.7	192.168.1.183	DENY	26	TCP	2025-11-20 11:37:08.266909	t	f	f	t
487	203.0.113.7	192.168.1.183	DENY	27	TCP	2025-11-20 11:35:25.266925	t	f	f	t
488	203.0.113.7	192.168.1.183	DENY	28	TCP	2025-11-20 11:37:54.266941	t	f	f	t
489	203.0.113.7	192.168.1.183	DENY	29	TCP	2025-11-20 11:38:53.266957	t	f	f	t
490	203.0.113.7	192.168.1.183	DENY	30	TCP	2025-11-20 11:36:07.266973	t	f	f	t
491	203.0.113.7	192.168.1.183	DENY	31	TCP	2025-11-20 11:38:29.266989	t	f	f	t
492	203.0.113.7	192.168.1.183	DENY	32	TCP	2025-11-20 11:38:52.267006	t	f	f	t
493	203.0.113.7	192.168.1.183	DENY	33	TCP	2025-11-20 11:37:10.267029	t	f	f	t
494	203.0.113.7	192.168.1.183	DENY	34	TCP	2025-11-20 11:34:44.267055	t	f	f	t
495	203.0.113.125	192.168.1.123	ALLOW	3306	UDP	2025-11-20 02:00:27.390645	f	f	f	f
496	192.168.1.173	192.168.1.126	ALLOW	8080	TCP	2025-11-19 15:28:27.390724	f	f	f	f
497	203.0.113.109	192.168.1.138	ALLOW	8443	TCP	2025-11-19 23:07:27.390809	f	f	f	f
498	192.168.1.200	192.168.1.254	ALLOW	6697	ICMP	2025-11-19 06:23:27.390835	f	f	f	t
499	203.0.113.207	192.168.1.65	ALLOW	8080	ICMP	2025-11-20 03:07:27.390861	f	f	f	t
500	203.0.113.149	192.168.1.12	ALLOW	6697	UDP	2025-11-20 10:58:27.390885	f	f	f	f
501	203.0.113.65	192.168.1.8	ALLOW	80	ICMP	2025-11-20 08:35:27.390908	f	f	f	f
502	192.168.1.36	192.168.1.200	ALLOW	443	TCP	2025-11-20 05:08:27.39093	f	f	f	f
503	192.168.1.188	192.168.1.150	ALLOW	3389	TCP	2025-11-20 05:00:27.390953	f	f	f	f
504	203.0.113.41	192.168.1.198	ALLOW	135	UDP	2025-11-20 09:03:27.390977	f	f	f	f
505	192.168.1.23	192.168.1.207	DENY	3389	ICMP	2025-11-20 03:09:27.391001	f	f	f	f
506	203.0.113.94	192.168.1.60	DENY	139	UDP	2025-11-19 18:05:27.391024	f	f	f	f
507	203.0.113.116	192.168.1.248	ALLOW	4444	TCP	2025-11-19 20:38:27.391058	f	f	f	f
508	203.0.113.214	192.168.1.149	DENY	443	TCP	2025-11-19 10:03:27.391081	f	f	f	f
509	203.0.113.177	192.168.1.109	ALLOW	80	ICMP	2025-11-19 08:35:27.391104	f	f	f	t
510	203.0.113.57	192.168.1.41	ALLOW	3306	TCP	2025-11-19 19:02:27.391127	f	f	f	f
511	192.168.1.193	192.168.1.64	ALLOW	80	ICMP	2025-11-20 05:56:27.391149	f	f	f	f
512	203.0.113.85	192.168.1.130	ALLOW	4444	TCP	2025-11-19 18:20:27.391172	f	f	f	f
513	203.0.113.241	192.168.1.149	ALLOW	3389	TCP	2025-11-20 10:53:27.391195	f	f	f	t
514	203.0.113.157	192.168.1.130	ALLOW	135	UDP	2025-11-20 10:43:27.391219	f	f	f	t
515	203.0.113.246	192.168.1.177	ALLOW	3389	TCP	2025-11-19 13:07:27.391241	f	f	f	f
516	192.168.1.144	192.168.1.139	ALLOW	3389	UDP	2025-11-20 03:36:27.391264	f	f	f	f
517	192.168.1.117	192.168.1.80	ALLOW	6667	TCP	2025-11-19 21:47:27.391287	f	f	f	f
518	203.0.113.86	192.168.1.238	ALLOW	3389	ICMP	2025-11-19 13:27:27.391309	f	f	f	f
519	192.168.1.103	192.168.1.10	ALLOW	1337	UDP	2025-11-19 17:32:27.391331	f	f	f	f
520	203.0.113.119	192.168.1.105	ALLOW	31337	ICMP	2025-11-20 01:18:27.391352	f	f	f	t
521	192.168.1.137	192.168.1.50	DENY	22	ICMP	2025-11-20 08:43:27.391375	f	f	f	f
522	203.0.113.108	192.168.1.146	ALLOW	22	ICMP	2025-11-20 02:06:27.391398	f	f	f	f
523	203.0.113.163	192.168.1.238	DENY	20	TCP	2025-11-20 12:09:14.391419	t	f	f	t
524	203.0.113.163	192.168.1.238	DENY	21	TCP	2025-11-20 12:04:46.391437	t	f	f	t
525	203.0.113.163	192.168.1.238	DENY	22	TCP	2025-11-20 12:06:47.391454	t	f	f	t
526	203.0.113.163	192.168.1.238	DENY	23	TCP	2025-11-20 12:06:14.39147	t	f	f	t
527	203.0.113.163	192.168.1.238	DENY	24	TCP	2025-11-20 12:05:47.391487	t	f	f	t
528	203.0.113.163	192.168.1.238	DENY	25	TCP	2025-11-20 12:06:35.391509	t	f	f	t
529	203.0.113.163	192.168.1.238	DENY	26	TCP	2025-11-20 12:05:31.391526	t	f	f	t
530	203.0.113.163	192.168.1.238	DENY	27	TCP	2025-11-20 12:07:51.391542	t	f	f	t
531	203.0.113.163	192.168.1.238	DENY	28	TCP	2025-11-20 12:04:31.391558	t	f	f	t
532	203.0.113.163	192.168.1.238	DENY	29	TCP	2025-11-20 12:07:46.391574	t	f	f	t
533	203.0.113.163	192.168.1.238	DENY	30	TCP	2025-11-20 12:08:46.39159	t	f	f	t
534	203.0.113.163	192.168.1.238	DENY	31	TCP	2025-11-20 12:04:50.391607	t	f	f	t
535	203.0.113.163	192.168.1.238	DENY	32	TCP	2025-11-20 12:07:43.391623	t	f	f	t
536	203.0.113.163	192.168.1.238	DENY	33	TCP	2025-11-20 12:05:14.391639	t	f	f	t
537	203.0.113.163	192.168.1.238	DENY	34	TCP	2025-11-20 12:08:20.391657	t	f	f	t
538	192.168.1.178	192.168.1.177	ALLOW	1337	ICMP	2025-11-19 16:52:11.032402	f	f	f	f
539	192.168.1.225	192.168.1.79	ALLOW	445	ICMP	2025-11-20 05:21:11.032466	f	f	f	f
540	192.168.1.85	192.168.1.6	ALLOW	8443	TCP	2025-11-19 17:24:11.032496	f	f	f	f
541	192.168.1.119	192.168.1.203	ALLOW	8443	ICMP	2025-11-19 18:20:11.032519	f	f	f	f
542	192.168.1.232	192.168.1.169	ALLOW	4444	ICMP	2025-11-20 07:15:11.032545	f	f	f	f
543	203.0.113.174	192.168.1.215	ALLOW	8080	ICMP	2025-11-20 02:25:11.032572	f	f	f	f
544	203.0.113.74	192.168.1.23	ALLOW	3306	ICMP	2025-11-20 08:16:11.032596	f	f	f	f
545	192.168.1.252	192.168.1.51	DENY	31337	TCP	2025-11-20 10:33:11.032619	f	f	f	f
546	203.0.113.20	192.168.1.217	DENY	80	TCP	2025-11-20 03:26:11.032644	f	f	f	f
547	203.0.113.11	192.168.1.91	ALLOW	22	ICMP	2025-11-20 03:03:11.032667	f	f	f	f
548	203.0.113.226	192.168.1.136	ALLOW	3389	TCP	2025-11-19 06:53:11.03269	f	f	f	f
549	203.0.113.204	192.168.1.101	ALLOW	8443	UDP	2025-11-20 10:02:11.032712	f	f	f	f
550	203.0.113.243	192.168.1.241	ALLOW	135	ICMP	2025-11-19 11:25:11.032749	f	f	f	f
551	192.168.1.44	192.168.1.95	ALLOW	1337	TCP	2025-11-20 07:22:11.032772	f	f	f	f
552	203.0.113.250	192.168.1.63	ALLOW	5432	TCP	2025-11-20 02:52:11.032793	f	f	f	f
553	192.168.1.120	192.168.1.173	DENY	3306	ICMP	2025-11-19 18:45:11.032815	f	f	f	f
554	192.168.1.251	192.168.1.18	ALLOW	5432	UDP	2025-11-19 13:35:11.032837	f	f	f	f
555	192.168.1.243	192.168.1.217	ALLOW	3306	ICMP	2025-11-20 10:18:11.03286	f	f	f	t
556	203.0.113.129	192.168.1.121	ALLOW	31337	ICMP	2025-11-19 06:44:11.032898	f	f	f	f
557	203.0.113.215	192.168.1.228	ALLOW	445	TCP	2025-11-19 13:08:11.032922	f	f	f	f
558	203.0.113.167	192.168.1.236	ALLOW	1337	ICMP	2025-11-19 15:19:11.032944	f	f	f	f
559	203.0.113.28	192.168.1.215	ALLOW	31337	ICMP	2025-11-19 22:31:11.032966	f	f	f	f
560	192.168.1.15	192.168.1.128	ALLOW	4444	TCP	2025-11-20 08:06:11.032988	f	f	f	f
561	192.168.1.86	192.168.1.22	ALLOW	8443	TCP	2025-11-20 08:12:11.033008	f	f	f	f
562	203.0.113.234	192.168.1.83	DENY	20	TCP	2025-11-20 12:34:46.033028	t	f	f	t
563	203.0.113.234	192.168.1.83	DENY	21	TCP	2025-11-20 12:36:15.033046	t	f	f	t
564	203.0.113.234	192.168.1.83	DENY	22	TCP	2025-11-20 12:39:11.033063	t	f	f	t
565	203.0.113.234	192.168.1.83	DENY	23	TCP	2025-11-20 12:38:29.03308	t	f	f	t
566	203.0.113.234	192.168.1.83	DENY	24	TCP	2025-11-20 12:38:39.033096	t	f	f	t
567	203.0.113.234	192.168.1.83	DENY	25	TCP	2025-11-20 12:36:38.033111	t	f	f	t
568	203.0.113.234	192.168.1.83	DENY	26	TCP	2025-11-20 12:37:32.033127	t	f	f	t
569	203.0.113.234	192.168.1.83	DENY	27	TCP	2025-11-20 12:34:27.033143	t	f	f	t
570	203.0.113.234	192.168.1.83	DENY	28	TCP	2025-11-20 12:37:50.033159	t	f	f	t
571	203.0.113.234	192.168.1.83	DENY	29	TCP	2025-11-20 12:35:27.033175	t	f	f	t
572	203.0.113.234	192.168.1.83	DENY	30	TCP	2025-11-20 12:36:24.033191	t	f	f	t
573	203.0.113.234	192.168.1.83	DENY	31	TCP	2025-11-20 12:36:54.033207	t	f	f	t
574	203.0.113.234	192.168.1.83	DENY	32	TCP	2025-11-20 12:34:24.033224	t	f	f	t
575	203.0.113.234	192.168.1.83	DENY	33	TCP	2025-11-20 12:34:44.03324	t	f	f	t
576	203.0.113.234	192.168.1.83	DENY	34	TCP	2025-11-20 12:37:58.033256	t	f	f	t
577	192.168.1.39	192.168.1.176	ALLOW	5432	ICMP	2025-11-20 09:51:04.703517	f	f	f	f
578	203.0.113.187	192.168.1.126	ALLOW	3306	TCP	2025-11-20 00:36:04.703584	f	f	f	f
579	203.0.113.4	192.168.1.198	DENY	139	UDP	2025-11-19 18:46:04.703614	f	f	f	f
580	192.168.1.126	192.168.1.88	ALLOW	3306	UDP	2025-11-19 09:53:04.70364	f	f	f	f
581	192.168.1.245	192.168.1.80	ALLOW	5432	ICMP	2025-11-19 15:37:04.703663	f	f	f	f
582	203.0.113.51	192.168.1.104	ALLOW	22	UDP	2025-11-20 08:19:04.703688	f	f	f	f
583	203.0.113.242	192.168.1.95	ALLOW	135	ICMP	2025-11-20 06:03:04.703711	f	f	f	f
584	192.168.1.83	192.168.1.212	ALLOW	80	ICMP	2025-11-19 15:25:04.703781	f	f	f	f
585	203.0.113.93	192.168.1.146	ALLOW	80	UDP	2025-11-20 01:57:04.703807	f	f	f	f
586	192.168.1.227	192.168.1.97	DENY	8443	ICMP	2025-11-19 16:18:04.70383	f	f	f	f
587	192.168.1.208	192.168.1.117	ALLOW	443	ICMP	2025-11-20 08:19:04.703854	f	f	f	f
588	203.0.113.69	192.168.1.156	DENY	139	UDP	2025-11-20 07:57:04.703879	f	f	f	f
589	203.0.113.135	192.168.1.20	DENY	8080	TCP	2025-11-19 21:04:04.703901	f	f	f	f
590	203.0.113.67	192.168.1.207	ALLOW	8443	UDP	2025-11-20 10:20:04.703924	f	f	f	f
591	192.168.1.92	192.168.1.3	DENY	4444	UDP	2025-11-20 08:22:04.703949	f	f	f	f
592	203.0.113.213	192.168.1.188	DENY	20	TCP	2025-11-20 13:07:41.703971	t	f	f	t
593	203.0.113.213	192.168.1.188	DENY	21	TCP	2025-11-20 13:03:27.703989	t	f	f	t
594	203.0.113.213	192.168.1.188	DENY	22	TCP	2025-11-20 13:05:12.704006	t	f	f	t
595	203.0.113.213	192.168.1.188	DENY	23	TCP	2025-11-20 13:04:36.704024	t	f	f	t
596	203.0.113.213	192.168.1.188	DENY	24	TCP	2025-11-20 13:07:32.70404	t	f	f	t
597	203.0.113.213	192.168.1.188	DENY	25	TCP	2025-11-20 13:03:30.704055	t	f	f	t
598	203.0.113.213	192.168.1.188	DENY	26	TCP	2025-11-20 13:06:46.704071	t	f	f	t
599	203.0.113.213	192.168.1.188	DENY	27	TCP	2025-11-20 13:03:50.704088	t	f	f	t
600	203.0.113.213	192.168.1.188	DENY	28	TCP	2025-11-20 13:05:59.704104	t	f	f	t
601	203.0.113.213	192.168.1.188	DENY	29	TCP	2025-11-20 13:08:02.70412	t	f	f	t
602	203.0.113.213	192.168.1.188	DENY	30	TCP	2025-11-20 13:04:48.704139	t	f	f	t
603	203.0.113.213	192.168.1.188	DENY	31	TCP	2025-11-20 13:03:25.704165	t	f	f	t
604	203.0.113.213	192.168.1.188	DENY	32	TCP	2025-11-20 13:03:29.70419	t	f	f	t
605	203.0.113.213	192.168.1.188	DENY	33	TCP	2025-11-20 13:07:20.704215	t	f	f	t
606	203.0.113.213	192.168.1.188	DENY	34	TCP	2025-11-20 13:03:46.704239	t	f	f	t
607	203.0.113.232	192.168.1.254	ALLOW	445	TCP	2025-11-19 20:09:09.189085	f	f	f	t
608	203.0.113.115	192.168.1.67	ALLOW	135	TCP	2025-11-20 04:09:09.189153	f	f	f	f
609	203.0.113.254	192.168.1.236	DENY	31337	TCP	2025-11-20 04:29:09.189182	f	f	f	f
610	192.168.1.99	192.168.1.128	DENY	22	TCP	2025-11-19 10:45:09.189207	f	f	f	f
611	203.0.113.99	192.168.1.21	DENY	3389	TCP	2025-11-20 02:51:09.189232	f	f	f	f
612	192.168.1.199	192.168.1.188	DENY	80	TCP	2025-11-19 10:37:09.189255	f	f	f	f
613	192.168.1.93	192.168.1.120	ALLOW	445	TCP	2025-11-19 22:45:09.18928	f	f	f	t
614	203.0.113.5	192.168.1.206	ALLOW	6697	TCP	2025-11-19 21:21:09.189303	f	f	f	f
615	203.0.113.75	192.168.1.63	DENY	5432	TCP	2025-11-20 08:22:09.189326	f	f	f	f
616	192.168.1.205	192.168.1.205	ALLOW	31337	ICMP	2025-11-19 12:46:09.189348	f	f	f	f
617	203.0.113.229	192.168.1.142	DENY	20	TCP	2025-11-20 13:34:45.189372	t	f	f	t
618	203.0.113.229	192.168.1.142	DENY	21	TCP	2025-11-20 13:34:40.189389	t	f	f	t
619	203.0.113.229	192.168.1.142	DENY	22	TCP	2025-11-20 13:33:34.189405	t	f	f	t
620	203.0.113.229	192.168.1.142	DENY	23	TCP	2025-11-20 13:37:37.189422	t	f	f	t
621	203.0.113.229	192.168.1.142	DENY	24	TCP	2025-11-20 13:35:50.189438	t	f	f	t
622	203.0.113.229	192.168.1.142	DENY	25	TCP	2025-11-20 13:34:43.189453	t	f	f	t
623	203.0.113.229	192.168.1.142	DENY	26	TCP	2025-11-20 13:36:39.189469	t	f	f	t
624	203.0.113.229	192.168.1.142	DENY	27	TCP	2025-11-20 13:36:12.189485	t	f	f	t
625	203.0.113.229	192.168.1.142	DENY	28	TCP	2025-11-20 13:34:24.189501	t	f	f	t
626	203.0.113.229	192.168.1.142	DENY	29	TCP	2025-11-20 13:37:56.189517	t	f	f	t
627	203.0.113.229	192.168.1.142	DENY	30	TCP	2025-11-20 13:35:12.189533	t	f	f	t
628	203.0.113.229	192.168.1.142	DENY	31	TCP	2025-11-20 13:36:32.189548	t	f	f	t
629	203.0.113.229	192.168.1.142	DENY	32	TCP	2025-11-20 13:33:23.189564	t	f	f	t
630	203.0.113.229	192.168.1.142	DENY	33	TCP	2025-11-20 13:33:09.18958	t	f	f	t
631	203.0.113.229	192.168.1.142	DENY	34	TCP	2025-11-20 13:34:16.189595	t	f	f	t
632	203.0.113.132	192.168.1.92	ALLOW	3306	UDP	2025-11-19 14:00:36.127554	f	f	f	f
633	192.168.1.236	192.168.1.167	ALLOW	135	TCP	2025-11-19 23:06:36.127653	f	f	f	f
634	192.168.1.171	192.168.1.244	DENY	6697	UDP	2025-11-20 03:44:36.127701	f	f	f	f
635	192.168.1.108	192.168.1.101	ALLOW	443	TCP	2025-11-20 07:13:36.127775	f	f	f	f
636	203.0.113.196	192.168.1.54	ALLOW	1337	TCP	2025-11-19 08:42:36.127814	f	f	f	f
637	192.168.1.65	192.168.1.156	ALLOW	443	ICMP	2025-11-19 12:23:36.127854	f	f	f	f
638	192.168.1.53	192.168.1.107	ALLOW	6697	TCP	2025-11-19 18:13:36.127892	f	f	f	f
639	192.168.1.244	192.168.1.92	DENY	3306	TCP	2025-11-20 10:53:36.127928	f	f	f	f
640	203.0.113.86	192.168.1.110	ALLOW	443	UDP	2025-11-20 07:21:36.127968	f	f	f	f
641	203.0.113.44	192.168.1.76	DENY	80	ICMP	2025-11-19 13:18:36.128006	f	f	f	f
642	203.0.113.92	192.168.1.122	ALLOW	22	TCP	2025-11-20 05:14:36.128041	f	f	f	f
643	203.0.113.211	192.168.1.196	ALLOW	5432	UDP	2025-11-19 16:10:36.128077	f	f	f	f
644	192.168.1.40	192.168.1.55	ALLOW	6667	UDP	2025-11-19 19:51:36.128116	f	f	f	f
645	203.0.113.1	192.168.1.191	ALLOW	22	ICMP	2025-11-19 11:24:36.128151	f	f	f	f
646	203.0.113.119	192.168.1.183	ALLOW	3306	TCP	2025-11-20 04:18:36.128187	f	f	f	f
647	203.0.113.204	192.168.1.182	DENY	443	ICMP	2025-11-19 15:33:36.128225	f	f	f	f
648	192.168.1.211	192.168.1.237	ALLOW	6697	TCP	2025-11-19 23:17:36.128261	f	f	f	f
649	192.168.1.119	192.168.1.210	ALLOW	8443	TCP	2025-11-19 18:59:36.128313	f	f	f	f
650	192.168.1.61	192.168.1.55	ALLOW	1337	ICMP	2025-11-19 11:39:36.128353	f	f	f	f
651	192.168.1.59	192.168.1.85	ALLOW	8080	TCP	2025-11-19 20:57:36.128388	f	f	f	f
652	192.168.1.146	192.168.1.94	ALLOW	443	UDP	2025-11-19 22:49:36.128424	f	f	f	f
653	203.0.113.98	192.168.1.134	DENY	20	TCP	2025-11-20 14:19:43.12846	t	f	f	t
654	203.0.113.98	192.168.1.134	DENY	21	TCP	2025-11-20 14:17:00.128488	t	f	f	t
655	203.0.113.98	192.168.1.134	DENY	22	TCP	2025-11-20 14:19:12.128515	t	f	f	t
656	203.0.113.98	192.168.1.134	DENY	23	TCP	2025-11-20 14:17:57.128541	t	f	f	t
657	203.0.113.98	192.168.1.134	DENY	24	TCP	2025-11-20 14:16:48.128568	t	f	f	t
658	203.0.113.98	192.168.1.134	DENY	25	TCP	2025-11-20 14:18:41.128595	t	f	f	t
659	203.0.113.98	192.168.1.134	DENY	26	TCP	2025-11-20 14:20:16.128621	t	f	f	t
660	203.0.113.98	192.168.1.134	DENY	27	TCP	2025-11-20 14:17:42.128647	t	f	f	t
661	203.0.113.98	192.168.1.134	DENY	28	TCP	2025-11-20 14:18:40.128674	t	f	f	t
662	203.0.113.98	192.168.1.134	DENY	29	TCP	2025-11-20 14:19:28.1287	t	f	f	t
663	203.0.113.98	192.168.1.134	DENY	30	TCP	2025-11-20 14:15:43.128726	t	f	f	t
664	203.0.113.98	192.168.1.134	DENY	31	TCP	2025-11-20 14:19:36.128771	t	f	f	t
665	203.0.113.98	192.168.1.134	DENY	32	TCP	2025-11-20 14:16:21.128796	t	f	f	t
666	203.0.113.98	192.168.1.134	DENY	33	TCP	2025-11-20 14:19:27.128822	t	f	f	t
667	203.0.113.98	192.168.1.134	DENY	34	TCP	2025-11-20 14:16:38.128848	t	f	f	t
668	192.168.1.102	192.168.1.61	ALLOW	6697	TCP	2025-11-19 10:32:36.140599	f	f	f	f
669	203.0.113.88	192.168.1.240	DENY	139	UDP	2025-11-19 23:51:36.140691	f	f	f	f
670	203.0.113.218	192.168.1.38	DENY	135	UDP	2025-11-20 00:45:36.14072	f	f	f	f
671	192.168.1.45	192.168.1.9	DENY	5432	UDP	2025-11-20 12:29:36.140764	f	f	f	f
672	192.168.1.140	192.168.1.97	ALLOW	3389	ICMP	2025-11-20 02:23:36.140787	f	f	f	f
673	192.168.1.200	192.168.1.86	ALLOW	6667	UDP	2025-11-20 10:23:36.140837	f	f	f	f
674	192.168.1.196	192.168.1.165	DENY	1337	UDP	2025-11-19 17:22:36.140883	f	f	f	f
675	203.0.113.239	192.168.1.60	ALLOW	8443	UDP	2025-11-19 12:34:36.140921	f	f	f	f
676	192.168.1.58	192.168.1.53	ALLOW	135	ICMP	2025-11-19 13:23:36.140953	f	f	f	f
677	203.0.113.226	192.168.1.16	ALLOW	4444	UDP	2025-11-19 11:27:36.140977	f	f	f	f
678	192.168.1.193	192.168.1.236	ALLOW	4444	ICMP	2025-11-19 15:40:36.141001	f	f	f	f
679	203.0.113.154	192.168.1.254	DENY	3306	ICMP	2025-11-19 11:06:36.141026	f	f	f	f
680	192.168.1.7	192.168.1.59	DENY	139	TCP	2025-11-20 14:05:36.14105	f	f	f	f
681	192.168.1.122	192.168.1.74	DENY	3306	UDP	2025-11-19 14:06:36.141071	f	f	f	f
682	203.0.113.56	192.168.1.132	ALLOW	135	ICMP	2025-11-20 14:34:36.141093	f	f	f	f
683	192.168.1.225	192.168.1.188	ALLOW	80	TCP	2025-11-19 14:56:36.141115	f	f	f	f
684	192.168.1.31	192.168.1.150	DENY	4444	UDP	2025-11-19 17:51:36.141139	f	f	f	f
685	203.0.113.165	192.168.1.137	ALLOW	3306	ICMP	2025-11-20 02:15:36.14116	f	f	f	t
686	192.168.1.59	192.168.1.63	ALLOW	8080	TCP	2025-11-20 06:48:36.141182	f	f	f	t
687	192.168.1.62	192.168.1.30	DENY	445	UDP	2025-11-19 17:43:36.141203	f	f	f	f
688	203.0.113.187	192.168.1.97	DENY	1337	TCP	2025-11-19 19:39:36.141224	f	f	f	f
689	192.168.1.216	192.168.1.65	ALLOW	6697	ICMP	2025-11-20 11:10:36.141247	f	f	f	f
690	203.0.113.41	192.168.1.33	ALLOW	8080	ICMP	2025-11-19 11:56:36.141269	f	f	f	f
691	192.168.1.20	192.168.1.162	ALLOW	31337	TCP	2025-11-20 08:00:36.141291	f	f	f	f
692	203.0.113.63	192.168.1.1	DENY	20	TCP	2025-11-20 15:16:42.141311	t	f	f	t
693	203.0.113.63	192.168.1.1	DENY	21	TCP	2025-11-20 15:21:27.141328	t	f	f	t
694	203.0.113.63	192.168.1.1	DENY	22	TCP	2025-11-20 15:19:48.141344	t	f	f	t
695	203.0.113.63	192.168.1.1	DENY	23	TCP	2025-11-20 15:18:16.141372	t	f	f	t
696	203.0.113.63	192.168.1.1	DENY	24	TCP	2025-11-20 15:18:58.141406	t	f	f	t
697	203.0.113.63	192.168.1.1	DENY	25	TCP	2025-11-20 15:16:46.141425	t	f	f	t
698	203.0.113.63	192.168.1.1	DENY	26	TCP	2025-11-20 15:20:03.141441	t	f	f	t
699	203.0.113.63	192.168.1.1	DENY	27	TCP	2025-11-20 15:17:16.141457	t	f	f	t
700	203.0.113.63	192.168.1.1	DENY	28	TCP	2025-11-20 15:19:26.141474	t	f	f	t
701	203.0.113.63	192.168.1.1	DENY	29	TCP	2025-11-20 15:20:32.141491	t	f	f	t
702	203.0.113.63	192.168.1.1	DENY	30	TCP	2025-11-20 15:19:19.141507	t	f	f	t
703	203.0.113.63	192.168.1.1	DENY	31	TCP	2025-11-20 15:21:13.141523	t	f	f	t
704	203.0.113.63	192.168.1.1	DENY	32	TCP	2025-11-20 15:20:11.141539	t	f	f	t
705	203.0.113.63	192.168.1.1	DENY	33	TCP	2025-11-20 15:19:15.141555	t	f	f	t
706	203.0.113.63	192.168.1.1	DENY	34	TCP	2025-11-20 15:17:40.141571	t	f	f	t
1246	203.0.113.178	192.168.1.195	DENY	22	TCP	2025-11-20 04:42:23.428252	f	f	f	f
1247	192.168.1.223	192.168.1.145	ALLOW	6667	ICMP	2025-11-21 06:59:23.428367	f	f	f	f
1248	203.0.113.134	192.168.1.126	DENY	8443	UDP	2025-11-21 03:40:23.428419	f	f	f	f
1249	192.168.1.76	192.168.1.121	ALLOW	8080	TCP	2025-11-21 05:48:23.428457	f	f	f	f
1250	203.0.113.68	192.168.1.83	ALLOW	8080	UDP	2025-11-20 09:17:23.428493	f	f	f	f
1251	192.168.1.101	192.168.1.236	ALLOW	80	TCP	2025-11-21 03:46:23.428532	f	f	f	f
1252	203.0.113.1	192.168.1.7	DENY	135	UDP	2025-11-21 05:41:23.42857	f	f	f	f
1253	203.0.113.211	192.168.1.170	ALLOW	1337	UDP	2025-11-21 05:41:23.428607	f	f	f	f
1254	192.168.1.102	192.168.1.78	DENY	31337	ICMP	2025-11-20 05:35:23.428642	f	f	f	f
1255	203.0.113.85	192.168.1.200	ALLOW	3389	UDP	2025-11-20 18:30:23.428693	f	f	f	f
1256	192.168.1.48	192.168.1.181	DENY	22	UDP	2025-11-20 21:09:23.428728	f	f	f	f
1257	192.168.1.5	192.168.1.128	ALLOW	1337	UDP	2025-11-21 02:05:23.428786	f	f	f	f
1258	203.0.113.249	192.168.1.164	ALLOW	6697	UDP	2025-11-21 08:20:23.428821	f	f	f	f
1259	203.0.113.17	192.168.1.47	ALLOW	443	TCP	2025-11-20 06:09:23.428858	f	f	f	f
1260	203.0.113.122	192.168.1.139	DENY	3306	ICMP	2025-11-20 10:35:23.428895	f	f	f	f
1261	203.0.113.109	192.168.1.130	DENY	20	TCP	2025-11-21 08:55:25.428929	t	f	f	t
1262	203.0.113.109	192.168.1.130	DENY	21	TCP	2025-11-21 08:57:02.428957	t	f	f	t
1263	203.0.113.109	192.168.1.130	DENY	22	TCP	2025-11-21 08:55:08.428984	t	f	f	t
1264	203.0.113.109	192.168.1.130	DENY	23	TCP	2025-11-21 08:55:00.429011	t	f	f	t
1265	203.0.113.109	192.168.1.130	DENY	24	TCP	2025-11-21 08:54:43.429037	t	f	f	t
1266	203.0.113.109	192.168.1.130	DENY	25	TCP	2025-11-21 08:54:40.429062	t	f	f	t
1267	203.0.113.109	192.168.1.130	DENY	26	TCP	2025-11-21 08:55:43.429089	t	f	f	t
1268	203.0.113.109	192.168.1.130	DENY	27	TCP	2025-11-21 08:53:49.429115	t	f	f	t
1269	203.0.113.109	192.168.1.130	DENY	28	TCP	2025-11-21 08:55:20.429139	t	f	f	t
1270	203.0.113.109	192.168.1.130	DENY	29	TCP	2025-11-21 08:55:30.429167	t	f	f	t
1271	203.0.113.109	192.168.1.130	DENY	30	TCP	2025-11-21 08:56:24.429196	t	f	f	t
1272	203.0.113.109	192.168.1.130	DENY	31	TCP	2025-11-21 08:53:29.429225	t	f	f	t
1273	203.0.113.109	192.168.1.130	DENY	32	TCP	2025-11-21 08:53:04.429252	t	f	f	t
1274	203.0.113.109	192.168.1.130	DENY	33	TCP	2025-11-21 08:53:26.42928	t	f	f	t
1275	203.0.113.109	192.168.1.130	DENY	34	TCP	2025-11-21 08:53:46.429306	t	f	f	t
1276	203.0.113.58	192.168.1.92	ALLOW	8080	UDP	2025-11-20 22:07:23.756413	f	f	f	f
1277	203.0.113.120	192.168.1.28	DENY	1337	TCP	2025-11-20 04:16:23.756481	f	f	f	t
1278	203.0.113.168	192.168.1.123	DENY	443	ICMP	2025-11-20 05:51:23.75651	f	f	f	f
1279	203.0.113.157	192.168.1.196	ALLOW	139	TCP	2025-11-20 23:21:23.756534	f	f	f	f
1280	203.0.113.14	192.168.1.182	DENY	445	ICMP	2025-11-20 09:40:23.756558	f	f	f	f
1281	203.0.113.80	192.168.1.233	ALLOW	1337	TCP	2025-11-20 11:24:23.756581	f	f	f	t
1282	192.168.1.71	192.168.1.193	DENY	31337	TCP	2025-11-21 06:41:23.756605	f	f	f	f
1283	192.168.1.45	192.168.1.180	ALLOW	31337	ICMP	2025-11-21 05:57:23.756628	f	f	f	f
1284	203.0.113.195	192.168.1.195	ALLOW	5432	UDP	2025-11-21 07:09:23.75665	f	f	f	t
1285	203.0.113.149	192.168.1.140	DENY	22	TCP	2025-11-20 06:45:23.756674	f	f	f	f
1286	192.168.1.207	192.168.1.3	ALLOW	139	ICMP	2025-11-20 14:03:23.7567	f	f	f	f
1287	203.0.113.95	192.168.1.227	ALLOW	6667	ICMP	2025-11-20 15:15:23.756725	f	f	f	f
1288	203.0.113.241	192.168.1.124	ALLOW	3389	TCP	2025-11-20 18:12:23.756837	f	f	f	f
1289	192.168.1.237	192.168.1.45	DENY	443	ICMP	2025-11-21 03:08:23.756863	f	f	f	t
1290	192.168.1.64	192.168.1.32	ALLOW	445	TCP	2025-11-20 16:01:23.756888	f	f	f	f
1291	203.0.113.62	192.168.1.11	ALLOW	445	UDP	2025-11-20 04:17:23.75691	f	f	f	f
1292	192.168.1.175	192.168.1.114	ALLOW	139	UDP	2025-11-21 06:04:23.756932	f	t	f	f
1293	203.0.113.188	192.168.1.87	ALLOW	4444	UDP	2025-11-21 08:09:23.756957	f	f	f	f
1294	192.168.1.213	192.168.1.28	ALLOW	445	ICMP	2025-11-21 04:13:23.75698	f	f	f	f
1295	203.0.113.169	192.168.1.16	ALLOW	135	TCP	2025-11-20 18:09:23.757003	f	f	f	f
1296	192.168.1.145	192.168.1.136	DENY	135	TCP	2025-11-21 09:23:23.757035	f	f	f	f
1297	203.0.113.86	192.168.1.229	ALLOW	80	UDP	2025-11-20 19:52:23.757059	f	f	f	f
1298	192.168.1.209	192.168.1.119	DENY	135	UDP	2025-11-20 17:38:23.757082	f	f	f	f
1299	203.0.113.8	192.168.1.24	ALLOW	5432	UDP	2025-11-20 15:26:23.757106	f	f	f	f
1300	192.168.1.148	192.168.1.178	ALLOW	3306	ICMP	2025-11-20 10:30:23.757129	f	f	f	f
1301	203.0.113.124	192.168.1.176	ALLOW	1337	TCP	2025-11-20 22:33:23.757152	f	f	f	t
1302	192.168.1.236	192.168.1.191	DENY	31337	TCP	2025-11-20 19:09:23.757175	f	f	f	t
1303	203.0.113.215	192.168.1.159	ALLOW	6697	UDP	2025-11-21 02:53:23.757201	f	f	f	f
1304	192.168.1.153	192.168.1.109	ALLOW	3306	ICMP	2025-11-20 15:52:23.757224	f	f	f	f
1305	203.0.113.149	192.168.1.136	DENY	20	TCP	2025-11-21 09:58:32.757246	t	f	f	t
1306	203.0.113.149	192.168.1.136	DENY	21	TCP	2025-11-21 09:57:08.757263	t	f	f	t
1307	203.0.113.149	192.168.1.136	DENY	22	TCP	2025-11-21 09:57:31.75728	t	f	f	t
1308	203.0.113.149	192.168.1.136	DENY	23	TCP	2025-11-21 10:00:02.757297	t	f	f	t
1309	203.0.113.149	192.168.1.136	DENY	24	TCP	2025-11-21 09:58:19.757314	t	f	f	t
1310	203.0.113.149	192.168.1.136	DENY	25	TCP	2025-11-21 09:59:14.75733	t	f	f	t
1311	203.0.113.149	192.168.1.136	DENY	26	TCP	2025-11-21 09:57:17.757346	t	f	f	t
1312	203.0.113.149	192.168.1.136	DENY	27	TCP	2025-11-21 09:58:58.757362	t	f	f	t
1313	203.0.113.149	192.168.1.136	DENY	28	TCP	2025-11-21 09:59:19.757378	t	f	f	t
1314	203.0.113.149	192.168.1.136	DENY	29	TCP	2025-11-21 09:56:38.757394	t	f	f	t
1315	203.0.113.149	192.168.1.136	DENY	30	TCP	2025-11-21 09:58:15.75741	t	f	f	t
1316	203.0.113.149	192.168.1.136	DENY	31	TCP	2025-11-21 10:00:17.757427	t	f	f	t
1317	203.0.113.149	192.168.1.136	DENY	32	TCP	2025-11-21 09:59:41.757443	t	f	f	t
1318	203.0.113.149	192.168.1.136	DENY	33	TCP	2025-11-21 09:57:27.757459	t	f	f	t
1319	203.0.113.149	192.168.1.136	DENY	34	TCP	2025-11-21 09:57:05.757475	t	f	f	t
1320	192.168.1.226	192.168.1.222	ALLOW	8443	UDP	2025-11-20 06:21:23.423	f	f	f	f
1321	203.0.113.9	192.168.1.45	DENY	135	ICMP	2025-11-20 23:42:23.423068	f	f	f	f
1322	203.0.113.23	192.168.1.36	ALLOW	80	ICMP	2025-11-20 18:21:23.423098	f	f	f	f
1323	192.168.1.44	192.168.1.90	ALLOW	5432	TCP	2025-11-20 12:58:23.423129	f	f	f	f
1324	192.168.1.137	192.168.1.238	ALLOW	80	UDP	2025-11-21 00:48:23.423153	f	f	f	f
1325	192.168.1.60	192.168.1.80	ALLOW	5432	TCP	2025-11-20 12:24:23.423183	f	f	f	f
1326	203.0.113.251	192.168.1.27	ALLOW	3306	UDP	2025-11-21 02:56:23.423218	f	f	f	f
707	203.0.113.73	192.168.1.22	ALLOW	6697	UDP	2025-11-20 15:50:35.938116	f	f	f	f
708	203.0.113.121	192.168.1.128	ALLOW	5432	TCP	2025-11-19 19:17:35.93822	f	f	f	f
709	203.0.113.213	192.168.1.229	ALLOW	8080	ICMP	2025-11-19 22:29:35.938263	f	f	f	f
710	203.0.113.45	192.168.1.38	ALLOW	3306	TCP	2025-11-20 09:25:35.938301	f	f	f	f
711	192.168.1.162	192.168.1.241	DENY	6667	TCP	2025-11-20 10:57:35.938338	f	f	f	f
712	192.168.1.75	192.168.1.164	DENY	5432	TCP	2025-11-19 19:13:35.938376	f	f	f	f
713	192.168.1.133	192.168.1.53	DENY	5432	UDP	2025-11-20 10:15:35.938412	f	f	f	f
714	192.168.1.105	192.168.1.254	ALLOW	80	ICMP	2025-11-19 21:16:35.938447	f	f	f	t
715	203.0.113.68	192.168.1.222	ALLOW	139	TCP	2025-11-19 16:29:35.938482	f	f	f	f
716	203.0.113.91	192.168.1.122	ALLOW	6697	ICMP	2025-11-20 11:47:35.938515	f	f	f	f
717	192.168.1.156	192.168.1.195	DENY	31337	UDP	2025-11-20 08:39:35.938548	f	f	f	t
718	203.0.113.183	192.168.1.61	ALLOW	443	UDP	2025-11-20 08:42:35.938584	f	f	f	f
719	192.168.1.44	192.168.1.1	ALLOW	443	TCP	2025-11-19 17:53:35.938622	f	f	f	f
720	203.0.113.134	192.168.1.57	DENY	443	TCP	2025-11-19 17:19:35.938657	f	f	f	f
721	192.168.1.131	192.168.1.51	ALLOW	3389	ICMP	2025-11-19 22:05:35.938692	f	f	f	f
722	203.0.113.110	192.168.1.75	DENY	3389	TCP	2025-11-20 05:45:35.938765	f	f	f	f
723	203.0.113.247	192.168.1.87	DENY	3389	ICMP	2025-11-19 18:28:35.938804	f	f	f	t
724	203.0.113.179	192.168.1.115	DENY	443	UDP	2025-11-20 02:18:35.938839	f	f	f	f
725	203.0.113.233	192.168.1.224	ALLOW	6697	ICMP	2025-11-20 04:00:35.938874	f	f	f	f
726	203.0.113.64	192.168.1.202	DENY	445	TCP	2025-11-20 14:28:35.938908	f	f	f	f
727	203.0.113.202	192.168.1.4	ALLOW	3389	UDP	2025-11-20 13:35:35.938942	f	f	f	f
728	192.168.1.63	192.168.1.235	ALLOW	8443	TCP	2025-11-20 06:45:35.938976	f	f	f	f
729	203.0.113.135	192.168.1.85	ALLOW	443	ICMP	2025-11-20 11:41:35.939012	f	f	f	t
730	203.0.113.94	192.168.1.225	DENY	3389	ICMP	2025-11-19 16:05:35.939046	f	f	f	f
731	203.0.113.105	192.168.1.187	ALLOW	1337	TCP	2025-11-19 19:17:35.939081	f	f	f	t
732	192.168.1.90	192.168.1.190	ALLOW	31337	TCP	2025-11-20 10:56:35.939116	f	f	f	f
733	203.0.113.164	192.168.1.59	ALLOW	135	UDP	2025-11-20 13:07:35.939152	f	f	f	f
734	192.168.1.79	192.168.1.28	ALLOW	22	ICMP	2025-11-19 20:06:35.939188	f	f	f	f
735	192.168.1.55	192.168.1.33	ALLOW	6667	ICMP	2025-11-20 00:54:35.93922	f	f	f	f
736	203.0.113.206	192.168.1.26	ALLOW	6667	UDP	2025-11-19 11:06:35.939251	f	f	f	f
737	203.0.113.115	192.168.1.136	DENY	20	TCP	2025-11-20 16:13:32.939284	t	f	f	t
738	203.0.113.115	192.168.1.136	DENY	21	TCP	2025-11-20 16:16:21.939309	t	f	f	t
739	203.0.113.115	192.168.1.136	DENY	22	TCP	2025-11-20 16:17:02.939333	t	f	f	t
740	203.0.113.115	192.168.1.136	DENY	23	TCP	2025-11-20 16:17:09.939357	t	f	f	t
741	203.0.113.115	192.168.1.136	DENY	24	TCP	2025-11-20 16:13:50.939381	t	f	f	t
742	203.0.113.115	192.168.1.136	DENY	25	TCP	2025-11-20 16:13:52.939405	t	f	f	t
743	203.0.113.115	192.168.1.136	DENY	26	TCP	2025-11-20 16:17:32.939428	t	f	f	t
744	203.0.113.115	192.168.1.136	DENY	27	TCP	2025-11-20 16:13:58.939451	t	f	f	t
745	203.0.113.115	192.168.1.136	DENY	28	TCP	2025-11-20 16:16:07.939476	t	f	f	t
746	203.0.113.115	192.168.1.136	DENY	29	TCP	2025-11-20 16:13:32.9395	t	f	f	t
747	203.0.113.115	192.168.1.136	DENY	30	TCP	2025-11-20 16:15:05.939526	t	f	f	t
748	203.0.113.115	192.168.1.136	DENY	31	TCP	2025-11-20 16:15:58.93955	t	f	f	t
749	203.0.113.115	192.168.1.136	DENY	32	TCP	2025-11-20 16:16:13.939574	t	f	f	t
750	203.0.113.115	192.168.1.136	DENY	33	TCP	2025-11-20 16:15:23.939597	t	f	f	t
751	203.0.113.115	192.168.1.136	DENY	34	TCP	2025-11-20 16:12:56.93962	t	f	f	t
752	203.0.113.21	192.168.1.141	ALLOW	4444	UDP	2025-11-19 22:10:36.044337	f	f	f	f
753	192.168.1.210	192.168.1.223	ALLOW	443	UDP	2025-11-19 23:51:36.044441	f	f	f	f
754	192.168.1.173	192.168.1.225	ALLOW	139	UDP	2025-11-19 20:34:36.044494	f	f	f	f
755	192.168.1.148	192.168.1.84	ALLOW	6667	ICMP	2025-11-20 02:04:36.044543	f	f	f	f
756	192.168.1.217	192.168.1.253	ALLOW	4444	UDP	2025-11-20 08:03:36.044588	f	f	f	f
757	192.168.1.241	192.168.1.191	DENY	3389	UDP	2025-11-20 03:38:36.04464	f	f	f	f
758	203.0.113.224	192.168.1.54	ALLOW	139	TCP	2025-11-20 04:32:36.044694	f	f	f	f
759	192.168.1.176	192.168.1.98	ALLOW	6667	UDP	2025-11-20 06:46:36.044779	f	f	f	f
760	203.0.113.115	192.168.1.249	ALLOW	139	ICMP	2025-11-20 04:30:36.04483	f	f	f	f
761	203.0.113.70	192.168.1.12	ALLOW	6667	TCP	2025-11-19 19:13:36.044867	f	f	f	f
762	203.0.113.145	192.168.1.196	ALLOW	6667	ICMP	2025-11-20 10:31:36.044897	f	f	f	f
763	192.168.1.127	192.168.1.108	ALLOW	445	UDP	2025-11-19 23:22:36.044921	f	f	f	t
764	203.0.113.156	192.168.1.106	ALLOW	3306	TCP	2025-11-20 02:24:36.044945	f	f	f	f
765	192.168.1.129	192.168.1.160	ALLOW	3389	ICMP	2025-11-19 21:54:36.044969	f	f	f	f
766	203.0.113.145	192.168.1.196	DENY	20	TCP	2025-11-20 17:17:12.044991	t	f	f	t
767	203.0.113.145	192.168.1.196	DENY	21	TCP	2025-11-20 17:18:17.045009	t	f	f	t
768	203.0.113.145	192.168.1.196	DENY	22	TCP	2025-11-20 17:17:51.045026	t	f	f	t
769	203.0.113.145	192.168.1.196	DENY	23	TCP	2025-11-20 17:17:32.045047	t	f	f	t
770	203.0.113.145	192.168.1.196	DENY	24	TCP	2025-11-20 17:17:14.045072	t	f	f	t
771	203.0.113.145	192.168.1.196	DENY	25	TCP	2025-11-20 17:17:06.045098	t	f	f	t
772	203.0.113.145	192.168.1.196	DENY	26	TCP	2025-11-20 17:15:47.045138	t	f	f	t
773	203.0.113.145	192.168.1.196	DENY	27	TCP	2025-11-20 17:15:16.045165	t	f	f	t
774	203.0.113.145	192.168.1.196	DENY	28	TCP	2025-11-20 17:14:41.045189	t	f	f	t
775	203.0.113.145	192.168.1.196	DENY	29	TCP	2025-11-20 17:18:15.045208	t	f	f	t
776	203.0.113.145	192.168.1.196	DENY	30	TCP	2025-11-20 17:16:51.045231	t	f	f	t
777	203.0.113.145	192.168.1.196	DENY	31	TCP	2025-11-20 17:19:27.045258	t	f	f	t
778	203.0.113.145	192.168.1.196	DENY	32	TCP	2025-11-20 17:19:03.045285	t	f	f	t
779	203.0.113.145	192.168.1.196	DENY	33	TCP	2025-11-20 17:15:52.045312	t	f	f	t
780	203.0.113.145	192.168.1.196	DENY	34	TCP	2025-11-20 17:18:27.045339	t	f	f	t
781	203.0.113.192	192.168.1.238	ALLOW	31337	ICMP	2025-11-19 13:19:36.144482	f	f	f	t
782	192.168.1.116	192.168.1.30	DENY	3306	UDP	2025-11-20 02:23:36.144553	f	f	f	f
783	192.168.1.26	192.168.1.149	ALLOW	8443	ICMP	2025-11-20 14:30:36.144581	f	f	f	f
784	192.168.1.184	192.168.1.228	ALLOW	445	ICMP	2025-11-19 16:56:36.144606	f	f	f	f
785	192.168.1.143	192.168.1.24	ALLOW	80	ICMP	2025-11-20 03:55:36.144631	f	f	f	f
786	192.168.1.166	192.168.1.93	ALLOW	5432	UDP	2025-11-20 01:27:36.144654	f	f	f	f
787	203.0.113.127	192.168.1.157	ALLOW	6667	TCP	2025-11-19 18:18:36.144678	f	f	f	f
788	192.168.1.140	192.168.1.195	DENY	139	UDP	2025-11-20 17:46:36.144701	f	t	f	f
789	192.168.1.177	192.168.1.211	ALLOW	6697	TCP	2025-11-19 21:02:36.144725	f	f	f	f
790	203.0.113.121	192.168.1.69	ALLOW	135	UDP	2025-11-19 13:22:36.144767	f	f	f	f
791	203.0.113.99	192.168.1.81	DENY	3389	ICMP	2025-11-20 04:56:36.144791	f	f	f	f
792	203.0.113.189	192.168.1.13	DENY	139	UDP	2025-11-20 17:48:36.144813	f	f	f	f
793	203.0.113.228	192.168.1.126	ALLOW	135	TCP	2025-11-20 01:59:36.144836	f	f	f	f
794	192.168.1.49	192.168.1.89	ALLOW	5432	TCP	2025-11-20 16:40:36.144858	f	f	f	f
795	203.0.113.211	192.168.1.184	DENY	20	TCP	2025-11-20 18:20:49.144879	t	f	f	t
796	203.0.113.211	192.168.1.184	DENY	21	TCP	2025-11-20 18:16:46.144897	t	f	f	t
797	203.0.113.211	192.168.1.184	DENY	22	TCP	2025-11-20 18:18:55.144914	t	f	f	t
798	203.0.113.211	192.168.1.184	DENY	23	TCP	2025-11-20 18:20:00.14493	t	f	f	t
799	203.0.113.211	192.168.1.184	DENY	24	TCP	2025-11-20 18:20:59.144946	t	f	f	t
800	203.0.113.211	192.168.1.184	DENY	25	TCP	2025-11-20 18:20:37.144963	t	f	f	t
801	203.0.113.211	192.168.1.184	DENY	26	TCP	2025-11-20 18:16:51.144979	t	f	f	t
802	203.0.113.211	192.168.1.184	DENY	27	TCP	2025-11-20 18:18:14.144995	t	f	f	t
803	203.0.113.211	192.168.1.184	DENY	28	TCP	2025-11-20 18:18:11.145011	t	f	f	t
804	203.0.113.211	192.168.1.184	DENY	29	TCP	2025-11-20 18:17:37.145027	t	f	f	t
805	203.0.113.211	192.168.1.184	DENY	30	TCP	2025-11-20 18:19:56.145043	t	f	f	t
806	203.0.113.211	192.168.1.184	DENY	31	TCP	2025-11-20 18:21:07.14506	t	f	f	t
807	203.0.113.211	192.168.1.184	DENY	32	TCP	2025-11-20 18:18:45.145076	t	f	f	t
808	203.0.113.211	192.168.1.184	DENY	33	TCP	2025-11-20 18:18:10.145092	t	f	f	t
809	203.0.113.211	192.168.1.184	DENY	34	TCP	2025-11-20 18:18:32.145107	t	f	f	t
810	192.168.1.82	192.168.1.205	DENY	4444	TCP	2025-11-19 22:38:36.794778	f	f	f	f
811	203.0.113.8	192.168.1.178	ALLOW	3389	ICMP	2025-11-20 16:06:36.794861	f	f	f	t
812	203.0.113.212	192.168.1.235	DENY	3389	ICMP	2025-11-20 10:59:36.79489	f	f	f	f
813	203.0.113.109	192.168.1.127	ALLOW	3306	TCP	2025-11-20 11:26:36.794917	f	f	f	f
814	203.0.113.131	192.168.1.69	ALLOW	139	UDP	2025-11-19 14:48:36.794943	f	f	f	f
815	203.0.113.77	192.168.1.131	DENY	443	TCP	2025-11-20 03:52:36.794969	f	f	f	f
816	192.168.1.205	192.168.1.254	ALLOW	6667	UDP	2025-11-19 23:31:36.794992	f	f	f	f
817	192.168.1.155	192.168.1.12	ALLOW	1337	UDP	2025-11-20 10:55:36.795023	f	f	f	f
818	203.0.113.45	192.168.1.38	ALLOW	4444	UDP	2025-11-19 16:41:36.79505	f	f	f	f
819	203.0.113.251	192.168.1.73	DENY	4444	ICMP	2025-11-20 13:40:36.795076	f	f	f	f
820	203.0.113.67	192.168.1.127	DENY	31337	TCP	2025-11-19 14:03:36.795101	f	f	f	t
821	192.168.1.189	192.168.1.240	ALLOW	139	ICMP	2025-11-19 18:23:36.795125	f	f	f	f
822	192.168.1.110	192.168.1.133	DENY	80	TCP	2025-11-19 14:07:36.79515	f	f	f	t
823	203.0.113.40	192.168.1.179	DENY	6697	ICMP	2025-11-20 16:29:36.795174	f	f	f	f
824	203.0.113.170	192.168.1.181	DENY	31337	ICMP	2025-11-20 11:56:36.795197	f	f	f	f
825	192.168.1.15	192.168.1.83	ALLOW	22	ICMP	2025-11-20 10:12:36.79522	f	f	f	f
826	192.168.1.139	192.168.1.37	DENY	3306	UDP	2025-11-19 18:10:36.795241	f	f	f	f
827	203.0.113.38	192.168.1.252	ALLOW	4444	ICMP	2025-11-19 23:31:36.79528	f	f	f	f
828	192.168.1.197	192.168.1.237	DENY	22	TCP	2025-11-20 09:43:36.795307	f	f	f	f
829	192.168.1.151	192.168.1.65	ALLOW	1337	ICMP	2025-11-20 05:54:36.795332	f	f	f	f
830	203.0.113.50	192.168.1.230	DENY	139	UDP	2025-11-20 00:17:36.795354	f	f	f	f
831	192.168.1.110	192.168.1.31	ALLOW	443	TCP	2025-11-20 11:12:36.795376	f	f	f	f
832	192.168.1.127	192.168.1.92	ALLOW	31337	TCP	2025-11-19 14:57:36.795397	f	f	f	f
833	192.168.1.205	192.168.1.66	ALLOW	80	ICMP	2025-11-19 22:00:36.795419	f	f	f	f
834	203.0.113.246	192.168.1.190	DENY	20	TCP	2025-11-20 19:24:47.795441	t	f	f	t
835	203.0.113.246	192.168.1.190	DENY	21	TCP	2025-11-20 19:23:50.795459	t	f	f	t
836	203.0.113.246	192.168.1.190	DENY	22	TCP	2025-11-20 19:23:56.795476	t	f	f	t
837	203.0.113.246	192.168.1.190	DENY	23	TCP	2025-11-20 19:24:07.795493	t	f	f	t
838	203.0.113.246	192.168.1.190	DENY	24	TCP	2025-11-20 19:22:59.795509	t	f	f	t
839	203.0.113.246	192.168.1.190	DENY	25	TCP	2025-11-20 19:22:03.795524	t	f	f	t
840	203.0.113.246	192.168.1.190	DENY	26	TCP	2025-11-20 19:25:23.79554	t	f	f	t
841	203.0.113.246	192.168.1.190	DENY	27	TCP	2025-11-20 19:23:56.795563	t	f	f	t
842	203.0.113.246	192.168.1.190	DENY	28	TCP	2025-11-20 19:23:56.795579	t	f	f	t
843	203.0.113.246	192.168.1.190	DENY	29	TCP	2025-11-20 19:22:06.795596	t	f	f	t
844	203.0.113.246	192.168.1.190	DENY	30	TCP	2025-11-20 19:24:02.795612	t	f	f	t
845	203.0.113.246	192.168.1.190	DENY	31	TCP	2025-11-20 19:22:49.795628	t	f	f	t
846	203.0.113.246	192.168.1.190	DENY	32	TCP	2025-11-20 19:24:37.795645	t	f	f	t
847	203.0.113.246	192.168.1.190	DENY	33	TCP	2025-11-20 19:22:17.79566	t	f	f	t
848	203.0.113.246	192.168.1.190	DENY	34	TCP	2025-11-20 19:21:38.795676	t	f	f	t
849	203.0.113.191	192.168.1.55	ALLOW	31337	TCP	2025-11-19 16:53:39.48742	f	f	f	f
850	192.168.1.45	192.168.1.105	DENY	22	UDP	2025-11-20 16:19:39.487495	f	f	f	f
851	192.168.1.235	192.168.1.181	ALLOW	443	TCP	2025-11-20 01:18:39.487524	f	f	f	f
852	203.0.113.128	192.168.1.206	ALLOW	139	UDP	2025-11-20 07:59:39.487576	f	f	f	f
853	203.0.113.252	192.168.1.26	ALLOW	445	UDP	2025-11-20 06:21:39.487624	f	f	f	t
854	203.0.113.3	192.168.1.252	DENY	8080	ICMP	2025-11-19 18:41:39.487665	f	f	f	f
855	203.0.113.110	192.168.1.69	ALLOW	5432	UDP	2025-11-20 00:26:39.487718	f	f	f	f
856	192.168.1.155	192.168.1.254	ALLOW	6667	UDP	2025-11-20 18:24:39.487779	f	f	f	f
857	203.0.113.216	192.168.1.204	ALLOW	6667	TCP	2025-11-19 22:45:39.48782	f	f	f	f
858	192.168.1.209	192.168.1.55	ALLOW	4444	UDP	2025-11-20 08:07:39.487857	f	f	f	t
859	203.0.113.52	192.168.1.19	ALLOW	6697	UDP	2025-11-20 11:56:39.487897	f	f	f	f
860	192.168.1.173	192.168.1.205	DENY	22	ICMP	2025-11-19 19:42:39.487933	f	f	f	f
861	192.168.1.60	192.168.1.99	ALLOW	443	TCP	2025-11-19 22:19:39.487973	f	f	f	f
862	203.0.113.57	192.168.1.135	DENY	4444	TCP	2025-11-20 02:24:39.48801	f	f	f	f
863	203.0.113.180	192.168.1.31	ALLOW	8443	UDP	2025-11-19 22:55:39.488046	f	f	f	f
864	203.0.113.121	192.168.1.195	DENY	20	TCP	2025-11-20 20:07:17.488081	t	f	f	t
865	203.0.113.121	192.168.1.195	DENY	21	TCP	2025-11-20 20:05:19.488109	t	f	f	t
866	203.0.113.121	192.168.1.195	DENY	22	TCP	2025-11-20 20:06:15.488136	t	f	f	t
867	203.0.113.121	192.168.1.195	DENY	23	TCP	2025-11-20 20:04:58.488171	t	f	f	t
868	203.0.113.121	192.168.1.195	DENY	24	TCP	2025-11-20 20:04:21.488196	t	f	f	t
869	203.0.113.121	192.168.1.195	DENY	25	TCP	2025-11-20 20:05:51.488221	t	f	f	t
870	203.0.113.121	192.168.1.195	DENY	26	TCP	2025-11-20 20:07:48.488246	t	f	f	t
871	203.0.113.121	192.168.1.195	DENY	27	TCP	2025-11-20 20:08:07.488276	t	f	f	t
872	203.0.113.121	192.168.1.195	DENY	28	TCP	2025-11-20 20:07:18.488303	t	f	f	t
873	203.0.113.121	192.168.1.195	DENY	29	TCP	2025-11-20 20:06:02.48832	t	f	f	t
874	203.0.113.121	192.168.1.195	DENY	30	TCP	2025-11-20 20:06:55.488337	t	f	f	t
875	203.0.113.121	192.168.1.195	DENY	31	TCP	2025-11-20 20:07:16.488353	t	f	f	t
876	203.0.113.121	192.168.1.195	DENY	32	TCP	2025-11-20 20:08:05.488369	t	f	f	t
877	203.0.113.121	192.168.1.195	DENY	33	TCP	2025-11-20 20:05:29.488385	t	f	f	t
878	203.0.113.121	192.168.1.195	DENY	34	TCP	2025-11-20 20:05:27.488402	t	f	f	t
879	203.0.113.107	192.168.1.110	ALLOW	3389	ICMP	2025-11-20 12:46:23.223627	f	f	f	f
880	203.0.113.39	192.168.1.89	ALLOW	22	UDP	2025-11-20 02:58:23.223689	f	f	f	f
881	192.168.1.206	192.168.1.134	ALLOW	6667	ICMP	2025-11-19 20:35:23.223716	f	f	f	f
882	192.168.1.206	192.168.1.66	DENY	3306	TCP	2025-11-20 20:09:23.223755	f	f	f	f
883	203.0.113.227	192.168.1.214	DENY	5432	ICMP	2025-11-20 19:25:23.223781	f	f	f	f
884	192.168.1.113	192.168.1.53	DENY	22	ICMP	2025-11-19 16:25:23.223805	f	f	f	f
885	203.0.113.249	192.168.1.175	ALLOW	3389	ICMP	2025-11-20 07:07:23.223828	f	f	f	f
886	203.0.113.201	192.168.1.212	DENY	3389	UDP	2025-11-20 05:25:23.223851	f	f	f	f
887	203.0.113.155	192.168.1.216	ALLOW	8080	UDP	2025-11-20 10:13:23.223874	f	f	f	f
888	192.168.1.120	192.168.1.12	ALLOW	4444	TCP	2025-11-20 16:52:23.223898	f	f	f	t
889	203.0.113.141	192.168.1.23	ALLOW	6667	ICMP	2025-11-19 22:22:23.22392	f	f	f	f
890	192.168.1.203	192.168.1.178	ALLOW	8443	ICMP	2025-11-20 01:41:23.223943	f	f	f	f
891	203.0.113.132	192.168.1.152	ALLOW	3306	ICMP	2025-11-20 03:53:23.223966	f	f	f	f
892	203.0.113.203	192.168.1.106	DENY	445	UDP	2025-11-20 18:29:23.223989	f	f	f	f
893	203.0.113.155	192.168.1.103	DENY	20	TCP	2025-11-20 21:21:04.22401	t	f	f	t
894	203.0.113.155	192.168.1.103	DENY	21	TCP	2025-11-20 21:24:48.224029	t	f	f	t
895	203.0.113.155	192.168.1.103	DENY	22	TCP	2025-11-20 21:23:32.224045	t	f	f	t
896	203.0.113.155	192.168.1.103	DENY	23	TCP	2025-11-20 21:20:33.224062	t	f	f	t
897	203.0.113.155	192.168.1.103	DENY	24	TCP	2025-11-20 21:24:21.224078	t	f	f	t
898	203.0.113.155	192.168.1.103	DENY	25	TCP	2025-11-20 21:20:52.224121	t	f	f	t
899	203.0.113.155	192.168.1.103	DENY	26	TCP	2025-11-20 21:22:21.224147	t	f	f	t
900	203.0.113.155	192.168.1.103	DENY	27	TCP	2025-11-20 21:23:53.224172	t	f	f	t
901	203.0.113.155	192.168.1.103	DENY	28	TCP	2025-11-20 21:22:35.224196	t	f	f	t
902	203.0.113.155	192.168.1.103	DENY	29	TCP	2025-11-20 21:21:27.224221	t	f	f	t
903	203.0.113.155	192.168.1.103	DENY	30	TCP	2025-11-20 21:21:04.224253	t	f	f	t
904	203.0.113.155	192.168.1.103	DENY	31	TCP	2025-11-20 21:24:25.224284	t	f	f	t
905	203.0.113.155	192.168.1.103	DENY	32	TCP	2025-11-20 21:23:03.224308	t	f	f	t
906	203.0.113.155	192.168.1.103	DENY	33	TCP	2025-11-20 21:23:22.224337	t	f	f	t
907	203.0.113.155	192.168.1.103	DENY	34	TCP	2025-11-20 21:22:09.224368	t	f	f	t
908	192.168.1.198	192.168.1.45	DENY	139	TCP	2025-11-20 22:19:23.23848	f	f	f	f
909	192.168.1.236	192.168.1.134	ALLOW	6697	ICMP	2025-11-20 00:12:23.238571	f	f	f	f
910	203.0.113.83	192.168.1.151	ALLOW	135	UDP	2025-11-20 21:57:23.238622	f	f	f	f
911	192.168.1.15	192.168.1.120	ALLOW	31337	UDP	2025-11-20 15:02:23.238664	f	f	f	f
912	192.168.1.201	192.168.1.237	DENY	3389	UDP	2025-11-20 01:28:23.2387	f	f	f	f
913	203.0.113.109	192.168.1.162	DENY	135	TCP	2025-11-20 21:51:23.238728	f	f	f	f
914	192.168.1.119	192.168.1.27	ALLOW	8080	ICMP	2025-11-20 10:50:23.238787	f	f	f	f
915	203.0.113.126	192.168.1.153	DENY	139	UDP	2025-11-19 19:12:23.23883	f	f	f	f
916	203.0.113.85	192.168.1.5	ALLOW	6697	TCP	2025-11-20 05:02:23.238875	f	f	f	f
917	203.0.113.5	192.168.1.181	ALLOW	4444	ICMP	2025-11-20 19:18:23.238917	f	f	f	f
918	192.168.1.37	192.168.1.204	DENY	445	UDP	2025-11-20 03:08:23.238956	f	f	f	f
919	192.168.1.99	192.168.1.17	ALLOW	3389	UDP	2025-11-20 17:26:23.239	f	f	f	f
920	203.0.113.232	192.168.1.224	ALLOW	31337	UDP	2025-11-20 11:55:23.239044	f	f	f	f
921	203.0.113.241	192.168.1.123	DENY	6697	UDP	2025-11-20 17:38:23.239088	f	f	f	f
922	203.0.113.101	192.168.1.188	ALLOW	31337	TCP	2025-11-20 19:43:23.239132	f	f	f	f
923	192.168.1.231	192.168.1.242	DENY	8443	TCP	2025-11-20 21:49:23.239171	f	f	f	f
924	203.0.113.3	192.168.1.86	ALLOW	1337	ICMP	2025-11-20 09:56:23.239215	f	f	f	f
925	192.168.1.164	192.168.1.38	DENY	445	UDP	2025-11-20 13:14:23.239256	f	f	f	f
926	192.168.1.124	192.168.1.170	ALLOW	8080	TCP	2025-11-20 04:40:23.239299	f	f	f	f
927	203.0.113.184	192.168.1.163	ALLOW	3389	TCP	2025-11-20 08:06:23.239344	f	f	f	f
928	192.168.1.209	192.168.1.57	DENY	445	UDP	2025-11-20 05:52:23.239388	f	f	f	f
929	192.168.1.223	192.168.1.227	DENY	8080	ICMP	2025-11-19 20:30:23.239426	f	f	f	f
930	203.0.113.32	192.168.1.14	ALLOW	3389	ICMP	2025-11-20 14:02:23.239487	f	f	f	f
931	192.168.1.254	192.168.1.129	ALLOW	3306	ICMP	2025-11-20 10:43:23.23953	f	f	f	f
932	203.0.113.216	192.168.1.134	DENY	6667	ICMP	2025-11-20 10:23:23.239577	f	f	f	t
933	203.0.113.183	192.168.1.73	ALLOW	443	TCP	2025-11-20 16:00:23.239621	f	f	f	f
934	203.0.113.144	192.168.1.181	DENY	80	UDP	2025-11-20 09:25:23.239662	f	f	f	f
935	203.0.113.143	192.168.1.248	DENY	20	TCP	2025-11-20 22:24:38.239701	t	f	f	t
936	203.0.113.143	192.168.1.248	DENY	21	TCP	2025-11-20 22:20:52.239757	t	f	f	t
937	203.0.113.143	192.168.1.248	DENY	22	TCP	2025-11-20 22:20:44.239792	t	f	f	t
938	203.0.113.143	192.168.1.248	DENY	23	TCP	2025-11-20 22:23:24.239824	t	f	f	t
939	203.0.113.143	192.168.1.248	DENY	24	TCP	2025-11-20 22:24:12.239852	t	f	f	t
940	203.0.113.143	192.168.1.248	DENY	25	TCP	2025-11-20 22:24:04.23988	t	f	f	t
941	203.0.113.143	192.168.1.248	DENY	26	TCP	2025-11-20 22:23:19.23991	t	f	f	t
942	203.0.113.143	192.168.1.248	DENY	27	TCP	2025-11-20 22:21:47.239939	t	f	f	t
943	203.0.113.143	192.168.1.248	DENY	28	TCP	2025-11-20 22:21:18.239964	t	f	f	t
944	203.0.113.143	192.168.1.248	DENY	29	TCP	2025-11-20 22:20:26.239991	t	f	f	t
945	203.0.113.143	192.168.1.248	DENY	30	TCP	2025-11-20 22:24:03.240018	t	f	f	t
946	203.0.113.143	192.168.1.248	DENY	31	TCP	2025-11-20 22:21:34.240046	t	f	f	t
947	203.0.113.143	192.168.1.248	DENY	32	TCP	2025-11-20 22:21:04.240075	t	f	f	t
948	203.0.113.143	192.168.1.248	DENY	33	TCP	2025-11-20 22:21:49.240105	t	f	f	t
949	203.0.113.143	192.168.1.248	DENY	34	TCP	2025-11-20 22:20:25.240133	t	f	f	t
950	203.0.113.65	192.168.1.81	ALLOW	3306	TCP	2025-11-20 10:43:23.085519	f	f	f	f
951	203.0.113.50	192.168.1.172	ALLOW	445	TCP	2025-11-20 08:08:23.085587	f	f	f	f
952	203.0.113.226	192.168.1.33	ALLOW	5432	TCP	2025-11-20 06:52:23.085627	f	f	f	f
953	203.0.113.178	192.168.1.76	ALLOW	8443	ICMP	2025-11-20 22:47:23.085656	f	f	f	f
954	192.168.1.215	192.168.1.227	ALLOW	8080	ICMP	2025-11-19 18:04:23.085681	f	f	f	f
955	203.0.113.83	192.168.1.90	ALLOW	5432	TCP	2025-11-20 04:33:23.085717	f	f	f	f
956	192.168.1.222	192.168.1.90	ALLOW	445	TCP	2025-11-20 13:56:23.08576	f	f	f	f
957	192.168.1.132	192.168.1.21	DENY	3306	TCP	2025-11-20 22:10:23.085789	f	f	f	f
958	203.0.113.121	192.168.1.134	ALLOW	4444	TCP	2025-11-19 18:51:23.085824	f	f	f	f
959	192.168.1.230	192.168.1.212	ALLOW	4444	TCP	2025-11-20 17:47:23.08585	f	f	f	t
960	192.168.1.57	192.168.1.240	ALLOW	139	ICMP	2025-11-20 22:39:23.085877	f	f	f	f
961	203.0.113.71	192.168.1.85	ALLOW	3389	TCP	2025-11-20 02:40:23.085914	f	f	f	f
962	192.168.1.109	192.168.1.98	ALLOW	6667	TCP	2025-11-19 22:14:23.08594	f	f	f	f
963	203.0.113.97	192.168.1.97	ALLOW	3389	TCP	2025-11-20 03:15:23.085963	f	f	f	f
964	203.0.113.129	192.168.1.122	DENY	3389	TCP	2025-11-20 20:17:23.085995	f	f	f	t
965	192.168.1.68	192.168.1.116	ALLOW	3306	UDP	2025-11-20 20:23:23.086025	f	f	f	f
966	203.0.113.245	192.168.1.120	ALLOW	6667	TCP	2025-11-20 14:53:23.086049	f	f	f	t
967	203.0.113.70	192.168.1.107	DENY	4444	TCP	2025-11-19 20:09:23.086078	f	f	f	f
968	203.0.113.17	192.168.1.158	ALLOW	3389	UDP	2025-11-20 03:51:23.08611	f	f	f	f
969	203.0.113.92	192.168.1.252	ALLOW	139	ICMP	2025-11-20 07:14:23.086135	f	f	f	f
970	192.168.1.252	192.168.1.61	DENY	4444	UDP	2025-11-20 08:02:23.08616	f	f	f	f
971	203.0.113.73	192.168.1.42	ALLOW	1337	TCP	2025-11-20 01:06:23.086196	f	f	f	f
972	203.0.113.82	192.168.1.111	ALLOW	8080	ICMP	2025-11-20 01:12:23.086221	f	f	f	f
973	203.0.113.177	192.168.1.37	ALLOW	4444	UDP	2025-11-20 01:56:23.086258	f	f	f	f
974	192.168.1.192	192.168.1.223	ALLOW	1337	TCP	2025-11-20 06:49:23.086295	f	f	f	f
975	203.0.113.4	192.168.1.192	DENY	6697	ICMP	2025-11-20 06:04:23.086322	f	f	f	f
976	192.168.1.120	192.168.1.33	ALLOW	22	TCP	2025-11-20 19:56:23.086346	f	f	f	f
977	192.168.1.115	192.168.1.212	DENY	1337	UDP	2025-11-20 21:16:23.086378	f	f	f	f
978	192.168.1.222	192.168.1.58	ALLOW	31337	TCP	2025-11-20 11:05:23.086406	f	f	f	f
979	203.0.113.193	192.168.1.4	DENY	20	TCP	2025-11-20 23:19:56.086429	t	f	f	t
980	203.0.113.193	192.168.1.4	DENY	21	TCP	2025-11-20 23:20:09.08645	t	f	f	t
981	203.0.113.193	192.168.1.4	DENY	22	TCP	2025-11-20 23:20:18.086476	t	f	f	t
982	203.0.113.193	192.168.1.4	DENY	23	TCP	2025-11-20 23:18:52.086495	t	f	f	t
983	203.0.113.193	192.168.1.4	DENY	24	TCP	2025-11-20 23:20:31.086513	t	f	f	t
984	203.0.113.193	192.168.1.4	DENY	25	TCP	2025-11-20 23:21:27.08653	t	f	f	t
985	203.0.113.193	192.168.1.4	DENY	26	TCP	2025-11-20 23:21:48.08655	t	f	f	t
986	203.0.113.193	192.168.1.4	DENY	27	TCP	2025-11-20 23:21:48.086575	t	f	f	t
987	203.0.113.193	192.168.1.4	DENY	28	TCP	2025-11-20 23:22:47.086592	t	f	f	t
988	203.0.113.193	192.168.1.4	DENY	29	TCP	2025-11-20 23:18:39.086608	t	f	f	t
989	203.0.113.193	192.168.1.4	DENY	30	TCP	2025-11-20 23:20:42.086625	t	f	f	t
990	203.0.113.193	192.168.1.4	DENY	31	TCP	2025-11-20 23:22:24.086648	t	f	f	t
991	203.0.113.193	192.168.1.4	DENY	32	TCP	2025-11-20 23:18:38.086671	t	f	f	t
992	203.0.113.193	192.168.1.4	DENY	33	TCP	2025-11-20 23:22:28.086688	t	f	f	t
993	203.0.113.193	192.168.1.4	DENY	34	TCP	2025-11-20 23:22:04.086704	t	f	f	t
994	192.168.1.161	192.168.1.111	DENY	22	ICMP	2025-11-20 21:50:23.629214	f	f	f	f
995	203.0.113.254	192.168.1.109	DENY	3306	TCP	2025-11-20 16:01:23.629301	f	f	f	f
996	192.168.1.15	192.168.1.182	DENY	5432	ICMP	2025-11-20 02:43:23.629332	f	f	f	t
997	203.0.113.89	192.168.1.186	DENY	31337	UDP	2025-11-20 09:18:23.629357	f	f	f	f
998	203.0.113.195	192.168.1.210	DENY	3306	TCP	2025-11-20 11:48:23.629383	f	f	f	f
999	203.0.113.19	192.168.1.178	DENY	3389	UDP	2025-11-19 22:07:23.629421	f	f	f	f
1000	203.0.113.123	192.168.1.6	ALLOW	6667	UDP	2025-11-19 21:31:23.629448	f	f	f	f
1001	192.168.1.172	192.168.1.218	DENY	5432	UDP	2025-11-20 07:53:23.629486	f	f	f	f
1002	192.168.1.206	192.168.1.224	DENY	1337	UDP	2025-11-20 22:27:23.629511	f	f	f	f
1003	203.0.113.176	192.168.1.225	ALLOW	139	UDP	2025-11-20 03:13:23.629536	f	f	f	f
1004	192.168.1.126	192.168.1.42	DENY	5432	TCP	2025-11-19 19:37:23.629559	f	f	f	t
1005	192.168.1.127	192.168.1.12	ALLOW	443	ICMP	2025-11-20 04:34:23.629581	f	f	f	f
1006	192.168.1.139	192.168.1.234	DENY	443	UDP	2025-11-20 20:46:23.629604	f	f	f	f
1007	203.0.113.119	192.168.1.202	ALLOW	5432	TCP	2025-11-21 00:16:23.629627	f	f	f	f
1008	192.168.1.88	192.168.1.37	ALLOW	8080	ICMP	2025-11-20 10:27:23.62965	f	f	f	f
1009	192.168.1.11	192.168.1.42	ALLOW	443	UDP	2025-11-20 05:56:23.629671	f	f	f	f
1010	203.0.113.223	192.168.1.244	ALLOW	5432	TCP	2025-11-20 11:26:23.629693	f	f	f	f
1011	192.168.1.9	192.168.1.84	ALLOW	135	ICMP	2025-11-20 14:41:23.629715	f	f	f	f
1012	203.0.113.212	192.168.1.123	DENY	20	TCP	2025-11-21 00:29:22.629753	t	f	f	t
1013	203.0.113.212	192.168.1.123	DENY	21	TCP	2025-11-21 00:30:17.629771	t	f	f	t
1014	203.0.113.212	192.168.1.123	DENY	22	TCP	2025-11-21 00:28:00.629788	t	f	f	t
1015	203.0.113.212	192.168.1.123	DENY	23	TCP	2025-11-21 00:26:35.629804	t	f	f	t
1016	203.0.113.212	192.168.1.123	DENY	24	TCP	2025-11-21 00:25:30.62982	t	f	f	t
1017	203.0.113.212	192.168.1.123	DENY	25	TCP	2025-11-21 00:26:53.629843	t	f	f	t
1018	203.0.113.212	192.168.1.123	DENY	26	TCP	2025-11-21 00:28:56.629869	t	f	f	t
1019	203.0.113.212	192.168.1.123	DENY	27	TCP	2025-11-21 00:28:24.629892	t	f	f	t
1020	203.0.113.212	192.168.1.123	DENY	28	TCP	2025-11-21 00:29:56.629908	t	f	f	t
1021	203.0.113.212	192.168.1.123	DENY	29	TCP	2025-11-21 00:29:44.629924	t	f	f	t
1022	203.0.113.212	192.168.1.123	DENY	30	TCP	2025-11-21 00:27:21.629942	t	f	f	t
1023	203.0.113.212	192.168.1.123	DENY	31	TCP	2025-11-21 00:29:13.629967	t	f	f	t
1024	203.0.113.212	192.168.1.123	DENY	32	TCP	2025-11-21 00:26:35.629995	t	f	f	t
1025	203.0.113.212	192.168.1.123	DENY	33	TCP	2025-11-21 00:28:31.630016	t	f	f	t
1026	203.0.113.212	192.168.1.123	DENY	34	TCP	2025-11-21 00:26:00.630032	t	f	f	t
1027	192.168.1.235	192.168.1.62	ALLOW	445	TCP	2025-11-20 18:46:23.755768	f	f	f	f
1028	203.0.113.115	192.168.1.36	ALLOW	135	TCP	2025-11-20 01:46:23.755834	f	f	f	f
1029	203.0.113.116	192.168.1.166	ALLOW	8443	ICMP	2025-11-20 00:20:23.755863	f	f	f	f
1030	192.168.1.106	192.168.1.164	DENY	22	TCP	2025-11-20 17:04:23.755887	f	f	f	f
1031	203.0.113.248	192.168.1.177	ALLOW	22	TCP	2025-11-21 00:28:23.755912	f	f	f	f
1032	203.0.113.21	192.168.1.240	ALLOW	31337	UDP	2025-11-20 18:39:23.755936	f	f	f	f
1033	192.168.1.75	192.168.1.130	DENY	8080	UDP	2025-11-21 01:32:23.755959	f	f	f	f
1034	192.168.1.132	192.168.1.136	ALLOW	443	TCP	2025-11-20 23:34:23.755982	f	f	f	f
1035	203.0.113.202	192.168.1.172	DENY	8443	ICMP	2025-11-20 07:07:23.756005	f	f	f	f
1036	203.0.113.63	192.168.1.234	ALLOW	3389	TCP	2025-11-21 00:37:23.756029	f	f	f	f
1037	192.168.1.229	192.168.1.102	ALLOW	8443	UDP	2025-11-20 21:20:23.756052	f	f	f	f
1038	192.168.1.153	192.168.1.93	ALLOW	139	TCP	2025-11-20 13:11:23.756076	f	f	f	f
1039	203.0.113.61	192.168.1.123	ALLOW	6667	UDP	2025-11-19 23:21:23.756099	f	f	f	f
1040	203.0.113.237	192.168.1.107	DENY	20	TCP	2025-11-21 01:27:47.756121	t	f	f	t
1041	203.0.113.237	192.168.1.107	DENY	21	TCP	2025-11-21 01:31:40.756139	t	f	f	t
1042	203.0.113.237	192.168.1.107	DENY	22	TCP	2025-11-21 01:32:04.756156	t	f	f	t
1043	203.0.113.237	192.168.1.107	DENY	23	TCP	2025-11-21 01:29:35.756172	t	f	f	t
1044	203.0.113.237	192.168.1.107	DENY	24	TCP	2025-11-21 01:27:45.756189	t	f	f	t
1045	203.0.113.237	192.168.1.107	DENY	25	TCP	2025-11-21 01:30:23.756206	t	f	f	t
1046	203.0.113.237	192.168.1.107	DENY	26	TCP	2025-11-21 01:29:14.756222	t	f	f	t
1047	203.0.113.237	192.168.1.107	DENY	27	TCP	2025-11-21 01:32:00.756239	t	f	f	t
1048	203.0.113.237	192.168.1.107	DENY	28	TCP	2025-11-21 01:28:24.756256	t	f	f	t
1049	203.0.113.237	192.168.1.107	DENY	29	TCP	2025-11-21 01:31:21.756272	t	f	f	t
1050	203.0.113.237	192.168.1.107	DENY	30	TCP	2025-11-21 01:28:49.756288	t	f	f	t
1051	203.0.113.237	192.168.1.107	DENY	31	TCP	2025-11-21 01:31:47.756304	t	f	f	t
1052	203.0.113.237	192.168.1.107	DENY	32	TCP	2025-11-21 01:29:15.75632	t	f	f	t
1053	203.0.113.237	192.168.1.107	DENY	33	TCP	2025-11-21 01:29:20.756336	t	f	f	t
1054	203.0.113.237	192.168.1.107	DENY	34	TCP	2025-11-21 01:30:29.756352	t	f	f	t
1055	192.168.1.131	192.168.1.116	ALLOW	5432	TCP	2025-11-20 07:41:23.705146	f	f	f	f
1056	203.0.113.163	192.168.1.221	DENY	4444	TCP	2025-11-20 14:45:23.705247	f	f	f	f
1057	203.0.113.196	192.168.1.158	DENY	5432	ICMP	2025-11-19 22:58:23.705293	f	f	f	f
1058	192.168.1.240	192.168.1.116	ALLOW	3306	UDP	2025-11-20 11:49:23.705358	f	f	f	f
1059	192.168.1.131	192.168.1.133	ALLOW	3306	UDP	2025-11-20 21:37:23.70542	f	f	f	t
1060	203.0.113.1	192.168.1.6	ALLOW	445	TCP	2025-11-21 01:53:23.705461	f	f	f	f
1061	192.168.1.21	192.168.1.89	ALLOW	1337	UDP	2025-11-20 01:58:23.70561	f	f	f	t
1062	192.168.1.144	192.168.1.123	DENY	135	ICMP	2025-11-20 12:09:23.705651	f	f	f	f
1063	203.0.113.171	192.168.1.67	ALLOW	3389	ICMP	2025-11-19 20:39:23.705687	f	f	f	f
1064	203.0.113.140	192.168.1.59	DENY	1337	UDP	2025-11-20 07:10:23.705724	f	f	f	f
1065	192.168.1.16	192.168.1.162	ALLOW	80	TCP	2025-11-20 18:29:23.705781	f	f	f	f
1066	192.168.1.176	192.168.1.103	ALLOW	443	UDP	2025-11-20 19:42:23.705819	f	f	f	f
1067	203.0.113.37	192.168.1.175	ALLOW	80	TCP	2025-11-20 05:40:23.705858	f	f	f	f
1068	203.0.113.210	192.168.1.52	ALLOW	135	TCP	2025-11-20 16:08:23.705895	f	f	f	f
1069	203.0.113.159	192.168.1.211	DENY	20	TCP	2025-11-21 02:29:37.70593	t	f	f	t
1070	203.0.113.159	192.168.1.211	DENY	21	TCP	2025-11-21 02:31:15.705952	t	f	f	t
1071	203.0.113.159	192.168.1.211	DENY	22	TCP	2025-11-21 02:29:16.705978	t	f	f	t
1072	203.0.113.159	192.168.1.211	DENY	23	TCP	2025-11-21 02:28:48.706018	t	f	f	t
1073	203.0.113.159	192.168.1.211	DENY	24	TCP	2025-11-21 02:28:46.706043	t	f	f	t
1074	203.0.113.159	192.168.1.211	DENY	25	TCP	2025-11-21 02:28:58.706067	t	f	f	t
1075	203.0.113.159	192.168.1.211	DENY	26	TCP	2025-11-21 02:28:34.706091	t	f	f	t
1076	203.0.113.159	192.168.1.211	DENY	27	TCP	2025-11-21 02:29:59.706115	t	f	f	t
1077	203.0.113.159	192.168.1.211	DENY	28	TCP	2025-11-21 02:26:37.706139	t	f	f	t
1078	203.0.113.159	192.168.1.211	DENY	29	TCP	2025-11-21 02:29:31.706164	t	f	f	t
1079	203.0.113.159	192.168.1.211	DENY	30	TCP	2025-11-21 02:30:41.70619	t	f	f	t
1080	203.0.113.159	192.168.1.211	DENY	31	TCP	2025-11-21 02:26:35.706214	t	f	f	t
1081	203.0.113.159	192.168.1.211	DENY	32	TCP	2025-11-21 02:26:33.706237	t	f	f	t
1082	203.0.113.159	192.168.1.211	DENY	33	TCP	2025-11-21 02:26:40.706262	t	f	f	t
1083	203.0.113.159	192.168.1.211	DENY	34	TCP	2025-11-21 02:28:31.706287	t	f	f	t
1084	203.0.113.155	192.168.1.220	ALLOW	445	TCP	2025-11-20 04:42:23.470976	f	f	f	f
1085	203.0.113.112	192.168.1.168	ALLOW	443	UDP	2025-11-20 01:11:23.471089	f	f	f	f
1086	192.168.1.164	192.168.1.92	ALLOW	31337	ICMP	2025-11-21 01:33:23.471122	f	f	f	f
1087	192.168.1.177	192.168.1.39	DENY	8080	ICMP	2025-11-20 13:47:23.471148	f	f	f	f
1088	203.0.113.127	192.168.1.200	DENY	445	TCP	2025-11-20 18:03:23.471172	f	f	f	f
1089	203.0.113.58	192.168.1.221	ALLOW	139	TCP	2025-11-20 08:54:23.471262	f	f	f	f
1090	192.168.1.80	192.168.1.161	DENY	4444	UDP	2025-11-20 02:36:23.471287	f	f	f	t
1091	192.168.1.1	192.168.1.23	ALLOW	135	TCP	2025-11-20 08:02:23.471311	f	f	f	f
1092	203.0.113.140	192.168.1.152	ALLOW	3389	ICMP	2025-11-20 12:42:23.471332	f	f	f	f
1093	192.168.1.248	192.168.1.241	ALLOW	443	TCP	2025-11-20 06:38:23.471356	f	f	f	f
1094	192.168.1.117	192.168.1.230	DENY	3306	ICMP	2025-11-20 13:28:23.471381	f	f	f	f
1095	192.168.1.182	192.168.1.172	ALLOW	6697	TCP	2025-11-20 23:09:23.471405	f	f	f	f
1096	192.168.1.143	192.168.1.21	DENY	6697	TCP	2025-11-20 20:48:23.471429	f	f	f	t
1097	203.0.113.137	192.168.1.21	ALLOW	135	ICMP	2025-11-21 02:15:23.471452	f	f	f	t
1098	192.168.1.211	192.168.1.128	ALLOW	6697	UDP	2025-11-21 03:16:23.471474	f	f	f	f
1099	203.0.113.33	192.168.1.107	DENY	4444	UDP	2025-11-20 12:52:23.471498	f	f	f	f
1100	192.168.1.52	192.168.1.40	ALLOW	443	UDP	2025-11-20 09:10:23.471521	f	f	f	f
1101	192.168.1.156	192.168.1.117	ALLOW	1337	ICMP	2025-11-20 02:37:23.471542	f	f	f	f
1102	192.168.1.144	192.168.1.71	ALLOW	80	UDP	2025-11-20 16:44:23.471565	f	f	f	f
1103	203.0.113.166	192.168.1.16	DENY	20	TCP	2025-11-21 03:27:32.471587	t	f	f	t
1104	203.0.113.166	192.168.1.16	DENY	21	TCP	2025-11-21 03:26:15.471614	t	f	f	t
1105	203.0.113.166	192.168.1.16	DENY	22	TCP	2025-11-21 03:25:02.471641	t	f	f	t
1106	203.0.113.166	192.168.1.16	DENY	23	TCP	2025-11-21 03:24:50.471659	t	f	f	t
1107	203.0.113.166	192.168.1.16	DENY	24	TCP	2025-11-21 03:27:40.471675	t	f	f	t
1108	203.0.113.166	192.168.1.16	DENY	25	TCP	2025-11-21 03:26:49.471692	t	f	f	t
1109	203.0.113.166	192.168.1.16	DENY	26	TCP	2025-11-21 03:25:45.471709	t	f	f	t
1110	203.0.113.166	192.168.1.16	DENY	27	TCP	2025-11-21 03:27:53.471725	t	f	f	t
1111	203.0.113.166	192.168.1.16	DENY	28	TCP	2025-11-21 03:28:06.471755	t	f	f	t
1112	203.0.113.166	192.168.1.16	DENY	29	TCP	2025-11-21 03:26:28.471772	t	f	f	t
1113	203.0.113.166	192.168.1.16	DENY	30	TCP	2025-11-21 03:28:03.471788	t	f	f	t
1114	203.0.113.166	192.168.1.16	DENY	31	TCP	2025-11-21 03:27:58.471804	t	f	f	t
1115	203.0.113.166	192.168.1.16	DENY	32	TCP	2025-11-21 03:25:02.47182	t	f	f	t
1116	203.0.113.166	192.168.1.16	DENY	33	TCP	2025-11-21 03:25:23.471836	t	f	f	t
1117	203.0.113.166	192.168.1.16	DENY	34	TCP	2025-11-21 03:24:21.471852	t	f	f	t
1118	203.0.113.115	192.168.1.214	DENY	3306	TCP	2025-11-20 18:20:23.872756	f	f	f	f
1119	203.0.113.210	192.168.1.214	ALLOW	445	ICMP	2025-11-20 09:22:23.872837	f	f	f	f
1120	192.168.1.236	192.168.1.9	ALLOW	139	UDP	2025-11-20 17:24:23.872878	f	f	f	f
1121	192.168.1.200	192.168.1.109	ALLOW	80	ICMP	2025-11-20 16:24:23.872907	f	f	f	f
1122	203.0.113.53	192.168.1.241	DENY	6667	ICMP	2025-11-20 08:51:23.872938	f	f	f	f
1123	192.168.1.92	192.168.1.132	DENY	6667	UDP	2025-11-20 16:44:23.872965	f	f	f	f
1124	192.168.1.158	192.168.1.193	DENY	139	ICMP	2025-11-20 05:04:23.872989	f	f	f	f
1125	192.168.1.243	192.168.1.8	ALLOW	6697	UDP	2025-11-20 18:43:23.873015	f	f	f	f
1126	203.0.113.177	192.168.1.124	ALLOW	8080	ICMP	2025-11-20 22:49:23.873041	f	f	f	f
1127	192.168.1.49	192.168.1.111	DENY	22	UDP	2025-11-20 01:41:23.873066	f	f	f	f
1128	203.0.113.162	192.168.1.166	ALLOW	5432	UDP	2025-11-20 11:30:23.87309	f	f	f	f
1129	203.0.113.175	192.168.1.208	ALLOW	4444	TCP	2025-11-20 09:09:23.873115	f	f	f	f
1130	192.168.1.59	192.168.1.233	DENY	22	ICMP	2025-11-21 03:36:23.87314	f	f	f	t
1131	203.0.113.196	192.168.1.13	ALLOW	31337	ICMP	2025-11-20 15:03:23.873169	f	f	f	f
1132	192.168.1.47	192.168.1.77	ALLOW	443	UDP	2025-11-20 13:10:23.873194	f	f	f	f
1133	203.0.113.201	192.168.1.94	ALLOW	445	UDP	2025-11-20 16:28:23.873218	f	f	f	f
1134	192.168.1.66	192.168.1.111	DENY	31337	TCP	2025-11-20 22:51:23.873243	f	f	f	f
1135	203.0.113.63	192.168.1.204	ALLOW	4444	ICMP	2025-11-20 14:37:23.873266	f	f	f	f
1136	203.0.113.82	192.168.1.154	ALLOW	3389	TCP	2025-11-20 05:05:23.873291	f	f	f	f
1137	192.168.1.178	192.168.1.93	DENY	80	UDP	2025-11-20 13:16:23.873321	f	f	f	t
1138	203.0.113.162	192.168.1.187	ALLOW	4444	ICMP	2025-11-21 01:17:23.873346	f	f	f	f
1139	203.0.113.110	192.168.1.190	ALLOW	443	UDP	2025-11-21 00:53:23.873371	f	f	f	f
1140	192.168.1.9	192.168.1.220	ALLOW	3389	TCP	2025-11-21 04:29:23.873394	f	f	f	f
1141	192.168.1.113	192.168.1.181	ALLOW	135	UDP	2025-11-21 02:00:23.873426	f	f	f	f
1142	192.168.1.72	192.168.1.211	ALLOW	80	ICMP	2025-11-20 17:02:23.873466	f	f	f	f
1143	192.168.1.193	192.168.1.171	DENY	3306	UDP	2025-11-20 22:02:23.873491	f	f	f	f
1144	203.0.113.108	192.168.1.153	DENY	135	TCP	2025-11-20 15:13:23.873523	f	f	f	f
1145	192.168.1.127	192.168.1.185	DENY	6697	ICMP	2025-11-20 13:12:23.873558	f	f	f	f
1146	203.0.113.198	192.168.1.163	DENY	20	TCP	2025-11-21 04:30:08.873586	t	f	f	t
1147	203.0.113.198	192.168.1.163	DENY	21	TCP	2025-11-21 04:30:38.873613	t	f	f	t
1148	203.0.113.198	192.168.1.163	DENY	22	TCP	2025-11-21 04:30:20.873631	t	f	f	t
1149	203.0.113.198	192.168.1.163	DENY	23	TCP	2025-11-21 04:33:17.873648	t	f	f	t
1150	203.0.113.198	192.168.1.163	DENY	24	TCP	2025-11-21 04:29:19.87367	t	f	f	t
1151	203.0.113.198	192.168.1.163	DENY	25	TCP	2025-11-21 04:28:31.873688	t	f	f	t
1152	203.0.113.198	192.168.1.163	DENY	26	TCP	2025-11-21 04:33:18.873711	t	f	f	t
1153	203.0.113.198	192.168.1.163	DENY	27	TCP	2025-11-21 04:28:56.873729	t	f	f	t
1154	203.0.113.198	192.168.1.163	DENY	28	TCP	2025-11-21 04:33:06.873764	t	f	f	t
1155	203.0.113.198	192.168.1.163	DENY	29	TCP	2025-11-21 04:29:47.873781	t	f	f	t
1156	203.0.113.198	192.168.1.163	DENY	30	TCP	2025-11-21 04:31:38.873798	t	f	f	t
1157	203.0.113.198	192.168.1.163	DENY	31	TCP	2025-11-21 04:30:20.873815	t	f	f	t
1158	203.0.113.198	192.168.1.163	DENY	32	TCP	2025-11-21 04:32:10.873834	t	f	f	t
1159	203.0.113.198	192.168.1.163	DENY	33	TCP	2025-11-21 04:30:22.873853	t	f	f	t
1160	203.0.113.198	192.168.1.163	DENY	34	TCP	2025-11-21 04:29:31.873871	t	f	f	t
1161	192.168.1.79	192.168.1.27	ALLOW	80	ICMP	2025-11-21 04:22:23.696555	f	f	f	f
1162	203.0.113.25	192.168.1.186	ALLOW	80	ICMP	2025-11-21 04:23:23.69663	f	f	f	f
1163	203.0.113.250	192.168.1.116	ALLOW	22	UDP	2025-11-20 03:01:23.696659	f	f	f	f
1164	203.0.113.120	192.168.1.23	ALLOW	139	TCP	2025-11-21 00:54:23.696684	f	f	f	f
1165	192.168.1.16	192.168.1.169	DENY	3306	UDP	2025-11-20 10:22:23.696722	f	f	f	f
1166	192.168.1.42	192.168.1.22	DENY	8080	UDP	2025-11-21 03:01:23.696778	f	f	f	f
1167	203.0.113.184	192.168.1.104	ALLOW	4444	ICMP	2025-11-21 02:39:23.696804	f	f	f	f
1168	203.0.113.69	192.168.1.142	DENY	8080	TCP	2025-11-21 01:27:23.696828	f	f	f	f
1169	203.0.113.90	192.168.1.33	ALLOW	3306	UDP	2025-11-21 00:37:23.696851	f	f	f	f
1170	203.0.113.80	192.168.1.43	DENY	31337	TCP	2025-11-20 12:05:23.696873	f	f	f	f
1171	192.168.1.35	192.168.1.38	ALLOW	4444	ICMP	2025-11-20 13:04:23.696896	f	f	f	f
1172	192.168.1.112	192.168.1.159	DENY	6697	ICMP	2025-11-20 09:52:23.696917	f	f	f	f
1173	203.0.113.196	192.168.1.112	DENY	443	UDP	2025-11-20 14:43:23.69694	f	f	f	f
1174	192.168.1.34	192.168.1.245	ALLOW	4444	TCP	2025-11-21 04:40:23.696963	f	f	f	f
1175	203.0.113.106	192.168.1.150	ALLOW	6667	UDP	2025-11-20 05:09:23.696987	f	f	f	f
1176	203.0.113.241	192.168.1.218	DENY	20	TCP	2025-11-21 06:01:09.697008	t	f	f	t
1177	203.0.113.241	192.168.1.218	DENY	21	TCP	2025-11-21 06:00:28.697026	t	f	f	t
1178	203.0.113.241	192.168.1.218	DENY	22	TCP	2025-11-21 05:56:29.697042	t	f	f	t
1179	203.0.113.241	192.168.1.218	DENY	23	TCP	2025-11-21 05:56:55.697058	t	f	f	t
1180	203.0.113.241	192.168.1.218	DENY	24	TCP	2025-11-21 05:59:41.697074	t	f	f	t
1181	203.0.113.241	192.168.1.218	DENY	25	TCP	2025-11-21 05:59:41.697089	t	f	f	t
1182	203.0.113.241	192.168.1.218	DENY	26	TCP	2025-11-21 06:00:12.697104	t	f	f	t
1183	203.0.113.241	192.168.1.218	DENY	27	TCP	2025-11-21 05:57:17.69712	t	f	f	t
1184	203.0.113.241	192.168.1.218	DENY	28	TCP	2025-11-21 05:59:06.697136	t	f	f	t
1185	203.0.113.241	192.168.1.218	DENY	29	TCP	2025-11-21 05:58:04.697152	t	f	f	t
1186	203.0.113.241	192.168.1.218	DENY	30	TCP	2025-11-21 05:58:12.697167	t	f	f	t
1187	203.0.113.241	192.168.1.218	DENY	31	TCP	2025-11-21 05:56:24.697183	t	f	f	t
1188	203.0.113.241	192.168.1.218	DENY	32	TCP	2025-11-21 05:59:36.6972	t	f	f	t
1189	203.0.113.241	192.168.1.218	DENY	33	TCP	2025-11-21 06:01:13.697216	t	f	f	t
1190	203.0.113.241	192.168.1.218	DENY	34	TCP	2025-11-21 06:00:35.697232	t	f	f	t
1191	192.168.1.151	192.168.1.167	ALLOW	22	UDP	2025-11-21 00:58:23.665237	f	f	f	f
1192	203.0.113.89	192.168.1.217	ALLOW	22	ICMP	2025-11-20 01:15:23.665334	f	f	f	f
1193	192.168.1.239	192.168.1.77	ALLOW	6697	ICMP	2025-11-20 19:20:23.665368	f	f	f	f
1194	192.168.1.84	192.168.1.220	DENY	1337	UDP	2025-11-20 13:24:23.665396	f	f	f	f
1195	203.0.113.146	192.168.1.189	ALLOW	445	ICMP	2025-11-20 01:06:23.665424	f	f	f	f
1196	192.168.1.71	192.168.1.212	ALLOW	80	ICMP	2025-11-20 03:15:23.665451	f	f	f	f
1197	203.0.113.193	192.168.1.159	DENY	139	UDP	2025-11-20 07:53:23.665492	f	f	f	f
1198	192.168.1.229	192.168.1.24	ALLOW	31337	TCP	2025-11-20 13:22:23.665521	f	f	f	f
1199	192.168.1.53	192.168.1.188	DENY	3389	ICMP	2025-11-20 21:00:23.665547	f	f	f	f
1200	192.168.1.233	192.168.1.186	DENY	22	TCP	2025-11-20 08:16:23.665586	f	f	f	f
1201	203.0.113.83	192.168.1.26	DENY	20	TCP	2025-11-21 06:59:00.665614	t	f	f	t
1202	203.0.113.83	192.168.1.26	DENY	21	TCP	2025-11-21 06:58:03.665638	t	f	f	t
1203	203.0.113.83	192.168.1.26	DENY	22	TCP	2025-11-21 06:56:14.665667	t	f	f	t
1204	203.0.113.83	192.168.1.26	DENY	23	TCP	2025-11-21 06:55:40.665692	t	f	f	t
1205	203.0.113.83	192.168.1.26	DENY	24	TCP	2025-11-21 06:56:23.665711	t	f	f	t
1206	203.0.113.83	192.168.1.26	DENY	25	TCP	2025-11-21 06:56:12.665746	t	f	f	t
1207	203.0.113.83	192.168.1.26	DENY	26	TCP	2025-11-21 06:59:51.66577	t	f	f	t
1208	203.0.113.83	192.168.1.26	DENY	27	TCP	2025-11-21 06:56:35.665798	t	f	f	t
1209	203.0.113.83	192.168.1.26	DENY	28	TCP	2025-11-21 06:56:09.665828	t	f	f	t
1210	203.0.113.83	192.168.1.26	DENY	29	TCP	2025-11-21 06:59:20.665857	t	f	f	t
1211	203.0.113.83	192.168.1.26	DENY	30	TCP	2025-11-21 07:00:17.665886	t	f	f	t
1212	203.0.113.83	192.168.1.26	DENY	31	TCP	2025-11-21 06:59:32.665914	t	f	f	t
1213	203.0.113.83	192.168.1.26	DENY	32	TCP	2025-11-21 06:57:50.665943	t	f	f	t
1214	203.0.113.83	192.168.1.26	DENY	33	TCP	2025-11-21 06:58:24.665971	t	f	f	t
1215	203.0.113.83	192.168.1.26	DENY	34	TCP	2025-11-21 06:58:33.666	t	f	f	t
1216	203.0.113.117	192.168.1.200	DENY	443	TCP	2025-11-20 10:20:23.178089	f	f	f	f
1217	192.168.1.19	192.168.1.98	ALLOW	6697	ICMP	2025-11-21 02:39:23.178153	f	f	f	f
1218	192.168.1.254	192.168.1.17	ALLOW	139	ICMP	2025-11-20 10:03:23.178181	f	f	f	f
1219	192.168.1.253	192.168.1.148	DENY	3389	UDP	2025-11-20 22:49:23.178207	f	f	f	f
1220	203.0.113.212	192.168.1.111	ALLOW	8080	UDP	2025-11-20 15:10:23.178232	f	f	f	f
1221	192.168.1.24	192.168.1.34	ALLOW	6697	TCP	2025-11-20 15:29:23.178255	f	f	f	f
1222	192.168.1.209	192.168.1.179	ALLOW	22	UDP	2025-11-20 07:05:23.178276	f	f	f	f
1223	203.0.113.132	192.168.1.246	DENY	6697	ICMP	2025-11-20 22:07:23.178301	f	f	f	f
1224	203.0.113.67	192.168.1.52	ALLOW	6667	UDP	2025-11-20 19:24:23.178324	f	f	f	f
1225	203.0.113.156	192.168.1.124	ALLOW	3306	ICMP	2025-11-20 18:01:23.178346	f	f	f	f
1226	192.168.1.188	192.168.1.205	ALLOW	443	TCP	2025-11-20 09:14:23.178368	f	f	f	f
1227	192.168.1.215	192.168.1.161	ALLOW	22	TCP	2025-11-21 07:25:23.178393	f	f	f	f
1228	203.0.113.228	192.168.1.145	ALLOW	1337	TCP	2025-11-20 22:27:23.178416	f	f	f	f
1229	192.168.1.222	192.168.1.28	ALLOW	3306	TCP	2025-11-20 16:03:23.178438	f	f	f	f
1230	192.168.1.238	192.168.1.22	ALLOW	22	UDP	2025-11-20 08:31:23.17846	f	f	f	f
1231	203.0.113.219	192.168.1.227	DENY	20	TCP	2025-11-21 07:49:35.178492	t	f	f	t
1232	203.0.113.219	192.168.1.227	DENY	21	TCP	2025-11-21 07:53:10.17851	t	f	f	t
1233	203.0.113.219	192.168.1.227	DENY	22	TCP	2025-11-21 07:53:45.178527	t	f	f	t
1234	203.0.113.219	192.168.1.227	DENY	23	TCP	2025-11-21 07:51:19.178542	t	f	f	t
1235	203.0.113.219	192.168.1.227	DENY	24	TCP	2025-11-21 07:52:57.178558	t	f	f	t
1236	203.0.113.219	192.168.1.227	DENY	25	TCP	2025-11-21 07:52:51.178574	t	f	f	t
1237	203.0.113.219	192.168.1.227	DENY	26	TCP	2025-11-21 07:50:40.17859	t	f	f	t
1238	203.0.113.219	192.168.1.227	DENY	27	TCP	2025-11-21 07:49:49.178612	t	f	f	t
1239	203.0.113.219	192.168.1.227	DENY	28	TCP	2025-11-21 07:52:20.178638	t	f	f	t
1240	203.0.113.219	192.168.1.227	DENY	29	TCP	2025-11-21 07:52:54.178664	t	f	f	t
1241	203.0.113.219	192.168.1.227	DENY	30	TCP	2025-11-21 07:52:06.178687	t	f	f	t
1242	203.0.113.219	192.168.1.227	DENY	31	TCP	2025-11-21 07:53:02.178706	t	f	f	t
1243	203.0.113.219	192.168.1.227	DENY	32	TCP	2025-11-21 07:51:13.178746	t	f	f	t
1244	203.0.113.219	192.168.1.227	DENY	33	TCP	2025-11-21 07:52:15.178772	t	f	f	t
1245	203.0.113.219	192.168.1.227	DENY	34	TCP	2025-11-21 07:50:00.17879	t	f	f	t
1327	192.168.1.86	192.168.1.57	ALLOW	445	ICMP	2025-11-20 11:35:23.423248	f	f	f	t
1328	203.0.113.148	192.168.1.94	ALLOW	6667	UDP	2025-11-20 06:23:23.423272	f	f	f	f
1329	192.168.1.156	192.168.1.4	DENY	31337	UDP	2025-11-21 05:59:23.423296	f	f	f	f
1330	192.168.1.151	192.168.1.225	ALLOW	443	TCP	2025-11-20 08:23:23.423318	f	f	f	f
1331	203.0.113.3	192.168.1.186	ALLOW	8443	ICMP	2025-11-20 10:29:23.423343	f	f	f	f
1332	192.168.1.108	192.168.1.205	ALLOW	22	TCP	2025-11-20 19:54:23.423366	f	f	f	f
1333	203.0.113.73	192.168.1.110	DENY	4444	ICMP	2025-11-21 08:09:23.423401	f	f	f	f
1334	203.0.113.91	192.168.1.114	DENY	1337	UDP	2025-11-20 05:56:23.423426	f	f	f	f
1335	203.0.113.74	192.168.1.76	ALLOW	445	TCP	2025-11-20 11:24:23.423451	f	f	f	f
1336	203.0.113.200	192.168.1.137	ALLOW	4444	UDP	2025-11-20 21:55:23.423474	f	f	f	f
1337	203.0.113.201	192.168.1.140	ALLOW	445	ICMP	2025-11-20 08:08:23.423498	f	f	f	f
1338	192.168.1.143	192.168.1.204	ALLOW	3389	ICMP	2025-11-21 11:27:23.423525	f	t	f	f
1339	203.0.113.68	192.168.1.32	DENY	6667	UDP	2025-11-21 00:07:23.423551	f	f	f	f
1340	192.168.1.174	192.168.1.166	ALLOW	80	TCP	2025-11-20 09:52:23.423574	f	f	f	f
1341	192.168.1.145	192.168.1.185	ALLOW	80	UDP	2025-11-20 14:28:23.423599	f	f	f	f
1342	203.0.113.221	192.168.1.40	DENY	4444	TCP	2025-11-20 20:02:23.423623	f	f	f	f
1343	203.0.113.214	192.168.1.83	ALLOW	443	UDP	2025-11-20 19:33:23.423647	f	f	f	f
1344	203.0.113.7	192.168.1.115	DENY	3306	ICMP	2025-11-20 14:33:23.42367	f	f	f	f
1345	192.168.1.201	192.168.1.82	ALLOW	22	TCP	2025-11-21 03:48:23.423692	f	f	f	f
1346	203.0.113.145	192.168.1.235	ALLOW	3389	TCP	2025-11-20 17:22:23.423716	f	f	f	f
1347	203.0.113.26	192.168.1.164	ALLOW	3306	UDP	2025-11-20 21:06:23.423758	f	f	f	t
1348	192.168.1.129	192.168.1.65	ALLOW	6697	UDP	2025-11-21 06:34:23.423783	f	f	f	f
1349	203.0.113.175	192.168.1.37	DENY	20	TCP	2025-11-21 11:26:36.423804	t	f	f	t
1350	203.0.113.175	192.168.1.37	DENY	21	TCP	2025-11-21 11:23:28.423823	t	f	f	t
1351	203.0.113.175	192.168.1.37	DENY	22	TCP	2025-11-21 11:23:37.42384	t	f	f	t
1352	203.0.113.175	192.168.1.37	DENY	23	TCP	2025-11-21 11:26:18.423856	t	f	f	t
1353	203.0.113.175	192.168.1.37	DENY	24	TCP	2025-11-21 11:23:51.423873	t	f	f	t
1354	203.0.113.175	192.168.1.37	DENY	25	TCP	2025-11-21 11:25:20.423889	t	f	f	t
1355	203.0.113.175	192.168.1.37	DENY	26	TCP	2025-11-21 11:24:42.423905	t	f	f	t
1356	203.0.113.175	192.168.1.37	DENY	27	TCP	2025-11-21 11:23:08.423921	t	f	f	t
1357	203.0.113.175	192.168.1.37	DENY	28	TCP	2025-11-21 11:25:50.423937	t	f	f	t
1358	203.0.113.175	192.168.1.37	DENY	29	TCP	2025-11-21 11:25:47.423952	t	f	f	t
1359	203.0.113.175	192.168.1.37	DENY	30	TCP	2025-11-21 11:22:24.423968	t	f	f	t
1360	203.0.113.175	192.168.1.37	DENY	31	TCP	2025-11-21 11:23:41.423985	t	f	f	t
1361	203.0.113.175	192.168.1.37	DENY	32	TCP	2025-11-21 11:25:16.424002	t	f	f	t
1362	203.0.113.175	192.168.1.37	DENY	33	TCP	2025-11-21 11:24:14.424018	t	f	f	t
1363	203.0.113.175	192.168.1.37	DENY	34	TCP	2025-11-21 11:23:16.424034	t	f	f	t
1364	203.0.113.3	192.168.1.56	DENY	5432	TCP	2025-11-20 09:27:23.357009	f	f	f	f
1365	203.0.113.18	192.168.1.35	ALLOW	5432	TCP	2025-11-21 01:49:23.357088	f	f	f	f
1366	203.0.113.249	192.168.1.149	DENY	139	ICMP	2025-11-21 11:41:23.357117	f	f	f	f
1367	203.0.113.157	192.168.1.220	ALLOW	5432	UDP	2025-11-21 05:06:23.357143	f	f	f	f
1368	203.0.113.2	192.168.1.32	ALLOW	31337	ICMP	2025-11-20 21:39:23.357167	f	f	f	f
1369	203.0.113.1	192.168.1.24	ALLOW	443	ICMP	2025-11-20 14:02:23.35719	f	f	f	f
1370	203.0.113.170	192.168.1.157	DENY	3306	ICMP	2025-11-20 15:54:23.357215	f	f	f	f
1371	192.168.1.107	192.168.1.170	ALLOW	6697	TCP	2025-11-20 18:04:23.35724	f	f	f	f
1372	192.168.1.225	192.168.1.184	ALLOW	31337	TCP	2025-11-21 05:06:23.357264	f	f	f	f
1373	203.0.113.236	192.168.1.6	ALLOW	3306	TCP	2025-11-21 02:18:23.357289	f	f	f	f
1374	192.168.1.59	192.168.1.88	ALLOW	139	TCP	2025-11-20 12:55:23.357313	f	f	f	f
1375	192.168.1.238	192.168.1.72	ALLOW	445	UDP	2025-11-20 21:43:23.357336	f	f	f	f
1376	192.168.1.170	192.168.1.138	ALLOW	8080	TCP	2025-11-21 07:50:23.357361	f	f	f	f
1377	192.168.1.85	192.168.1.211	DENY	135	TCP	2025-11-21 06:21:23.357386	f	f	f	f
1378	203.0.113.182	192.168.1.117	ALLOW	6697	TCP	2025-11-20 23:11:23.357412	f	f	f	f
1379	203.0.113.143	192.168.1.40	DENY	6697	ICMP	2025-11-21 04:46:23.357436	f	f	f	f
1380	203.0.113.98	192.168.1.163	ALLOW	443	UDP	2025-11-20 17:54:23.357459	f	f	f	f
1381	203.0.113.253	192.168.1.63	DENY	20	TCP	2025-11-21 12:26:17.357483	t	f	f	t
1382	203.0.113.253	192.168.1.63	DENY	21	TCP	2025-11-21 12:23:12.357501	t	f	f	t
1383	203.0.113.253	192.168.1.63	DENY	22	TCP	2025-11-21 12:22:18.357519	t	f	f	t
1384	203.0.113.253	192.168.1.63	DENY	23	TCP	2025-11-21 12:26:12.357536	t	f	f	t
1385	203.0.113.253	192.168.1.63	DENY	24	TCP	2025-11-21 12:23:30.357552	t	f	f	t
1386	203.0.113.253	192.168.1.63	DENY	25	TCP	2025-11-21 12:25:48.357569	t	f	f	t
1387	203.0.113.253	192.168.1.63	DENY	26	TCP	2025-11-21 12:22:30.357585	t	f	f	t
1388	203.0.113.253	192.168.1.63	DENY	27	TCP	2025-11-21 12:21:59.357601	t	f	f	t
1389	203.0.113.253	192.168.1.63	DENY	28	TCP	2025-11-21 12:25:36.357618	t	f	f	t
1390	203.0.113.253	192.168.1.63	DENY	29	TCP	2025-11-21 12:23:53.357646	t	f	f	t
1391	203.0.113.253	192.168.1.63	DENY	30	TCP	2025-11-21 12:25:55.357663	t	f	f	t
1392	203.0.113.253	192.168.1.63	DENY	31	TCP	2025-11-21 12:26:12.35768	t	f	f	t
1393	203.0.113.253	192.168.1.63	DENY	32	TCP	2025-11-21 12:24:46.357696	t	f	f	t
1394	203.0.113.253	192.168.1.63	DENY	33	TCP	2025-11-21 12:26:12.357713	t	f	f	t
1395	203.0.113.253	192.168.1.63	DENY	34	TCP	2025-11-21 12:24:33.357744	t	f	f	t
1396	203.0.113.249	192.168.1.174	DENY	6697	UDP	2025-11-21 06:22:23.475035	f	f	f	f
1397	192.168.1.243	192.168.1.236	ALLOW	4444	TCP	2025-11-20 23:14:23.475102	f	f	f	f
1398	203.0.113.194	192.168.1.241	ALLOW	6667	UDP	2025-11-20 17:51:23.475133	f	f	f	f
1399	192.168.1.43	192.168.1.170	ALLOW	6697	TCP	2025-11-21 13:06:23.475169	f	f	f	f
1400	192.168.1.171	192.168.1.192	ALLOW	8443	UDP	2025-11-20 14:54:23.475217	f	f	f	f
1401	192.168.1.20	192.168.1.235	DENY	443	TCP	2025-11-20 07:56:23.475259	f	f	f	f
1402	203.0.113.159	192.168.1.215	ALLOW	139	TCP	2025-11-21 08:25:23.475294	f	f	f	f
1403	203.0.113.191	192.168.1.211	DENY	1337	TCP	2025-11-20 23:59:23.475332	f	f	f	f
1404	203.0.113.77	192.168.1.207	ALLOW	135	UDP	2025-11-20 23:53:23.475368	f	f	f	f
1405	203.0.113.36	192.168.1.125	ALLOW	6697	TCP	2025-11-20 10:53:23.475403	f	f	f	f
1406	192.168.1.248	192.168.1.136	DENY	6667	ICMP	2025-11-20 17:07:23.475437	f	f	f	f
1407	203.0.113.16	192.168.1.109	ALLOW	3389	UDP	2025-11-21 02:40:23.475491	f	f	f	f
1408	203.0.113.5	192.168.1.251	DENY	1337	TCP	2025-11-20 12:10:23.475526	f	f	f	f
1409	192.168.1.44	192.168.1.166	DENY	31337	TCP	2025-11-20 22:36:23.475561	f	f	f	f
1410	203.0.113.201	192.168.1.105	ALLOW	139	ICMP	2025-11-20 19:27:23.475596	f	f	f	f
1411	203.0.113.212	192.168.1.83	ALLOW	6667	UDP	2025-11-20 19:53:23.475632	f	f	f	f
1412	203.0.113.42	192.168.1.196	DENY	6697	ICMP	2025-11-21 12:29:23.475669	f	f	f	f
1413	203.0.113.7	192.168.1.29	DENY	135	ICMP	2025-11-20 19:36:23.475705	f	f	f	f
1414	203.0.113.84	192.168.1.87	ALLOW	135	ICMP	2025-11-20 22:43:23.475762	f	f	f	f
1415	203.0.113.32	192.168.1.34	ALLOW	3306	UDP	2025-11-20 08:45:23.475799	f	f	f	f
1416	203.0.113.241	192.168.1.221	ALLOW	8443	UDP	2025-11-20 21:33:23.475832	f	f	f	f
1417	192.168.1.82	192.168.1.56	ALLOW	80	ICMP	2025-11-21 12:46:23.475868	f	f	f	f
1418	203.0.113.252	192.168.1.150	DENY	8443	TCP	2025-11-20 09:25:23.475902	f	f	f	f
1419	203.0.113.195	192.168.1.189	DENY	20	TCP	2025-11-21 13:25:24.475935	t	f	f	t
1420	203.0.113.195	192.168.1.189	DENY	21	TCP	2025-11-21 13:23:38.475961	t	f	f	t
1421	203.0.113.195	192.168.1.189	DENY	22	TCP	2025-11-21 13:27:41.475982	t	f	f	t
1422	203.0.113.195	192.168.1.189	DENY	23	TCP	2025-11-21 13:27:54.476009	t	f	f	t
1423	203.0.113.195	192.168.1.189	DENY	24	TCP	2025-11-21 13:24:13.476033	t	f	f	t
1424	203.0.113.195	192.168.1.189	DENY	25	TCP	2025-11-21 13:24:28.476058	t	f	f	t
1425	203.0.113.195	192.168.1.189	DENY	26	TCP	2025-11-21 13:26:59.476082	t	f	f	t
1426	203.0.113.195	192.168.1.189	DENY	27	TCP	2025-11-21 13:23:36.476099	t	f	f	t
1427	203.0.113.195	192.168.1.189	DENY	28	TCP	2025-11-21 13:24:33.476115	t	f	f	t
1428	203.0.113.195	192.168.1.189	DENY	29	TCP	2025-11-21 13:25:49.476131	t	f	f	t
1429	203.0.113.195	192.168.1.189	DENY	30	TCP	2025-11-21 13:28:04.476147	t	f	f	t
1430	203.0.113.195	192.168.1.189	DENY	31	TCP	2025-11-21 13:27:15.476163	t	f	f	t
1431	203.0.113.195	192.168.1.189	DENY	32	TCP	2025-11-21 13:24:14.476178	t	f	f	t
1432	203.0.113.195	192.168.1.189	DENY	33	TCP	2025-11-21 13:24:39.476193	t	f	f	t
1433	203.0.113.195	192.168.1.189	DENY	34	TCP	2025-11-21 13:23:52.476209	t	f	f	t
1434	203.0.113.190	192.168.1.246	ALLOW	139	ICMP	2025-11-21 06:55:23.342643	f	f	f	f
1435	203.0.113.88	192.168.1.194	ALLOW	139	TCP	2025-11-20 23:35:23.342753	f	f	f	f
1436	203.0.113.152	192.168.1.99	ALLOW	443	UDP	2025-11-20 11:06:23.342791	f	f	f	t
1437	203.0.113.45	192.168.1.203	ALLOW	8080	TCP	2025-11-21 02:53:23.342818	f	f	f	f
1438	192.168.1.195	192.168.1.116	ALLOW	5432	TCP	2025-11-20 21:59:23.342841	f	f	f	f
1439	192.168.1.148	192.168.1.231	ALLOW	443	UDP	2025-11-21 02:46:23.342865	f	f	f	f
1440	203.0.113.232	192.168.1.213	ALLOW	135	ICMP	2025-11-21 06:51:23.34289	f	f	f	f
1441	192.168.1.216	192.168.1.171	ALLOW	139	ICMP	2025-11-20 23:35:23.342914	f	f	f	f
1442	192.168.1.37	192.168.1.243	ALLOW	31337	UDP	2025-11-21 01:40:23.342939	f	f	f	f
1443	203.0.113.169	192.168.1.81	ALLOW	80	ICMP	2025-11-21 03:24:23.342963	f	f	f	f
1444	192.168.1.202	192.168.1.45	DENY	3389	TCP	2025-11-20 18:26:23.342987	f	f	f	f
1445	203.0.113.73	192.168.1.30	ALLOW	31337	TCP	2025-11-20 09:35:23.343011	f	f	f	f
1446	203.0.113.54	192.168.1.198	DENY	20	TCP	2025-11-21 14:22:49.343032	t	f	f	t
1447	203.0.113.54	192.168.1.198	DENY	21	TCP	2025-11-21 14:22:49.343051	t	f	f	t
1448	203.0.113.54	192.168.1.198	DENY	22	TCP	2025-11-21 14:25:42.343067	t	f	f	t
1449	203.0.113.54	192.168.1.198	DENY	23	TCP	2025-11-21 14:22:34.343084	t	f	f	t
1450	203.0.113.54	192.168.1.198	DENY	24	TCP	2025-11-21 14:24:58.343099	t	f	f	t
1451	203.0.113.54	192.168.1.198	DENY	25	TCP	2025-11-21 14:21:31.343115	t	f	f	t
1452	203.0.113.54	192.168.1.198	DENY	26	TCP	2025-11-21 14:23:44.343131	t	f	f	t
1453	203.0.113.54	192.168.1.198	DENY	27	TCP	2025-11-21 14:25:41.343148	t	f	f	t
1454	203.0.113.54	192.168.1.198	DENY	28	TCP	2025-11-21 14:21:39.343164	t	f	f	t
1455	203.0.113.54	192.168.1.198	DENY	29	TCP	2025-11-21 14:25:02.34318	t	f	f	t
1456	203.0.113.54	192.168.1.198	DENY	30	TCP	2025-11-21 14:26:09.343196	t	f	f	t
1457	203.0.113.54	192.168.1.198	DENY	31	TCP	2025-11-21 14:23:57.343212	t	f	f	t
1458	203.0.113.54	192.168.1.198	DENY	32	TCP	2025-11-21 14:24:49.343228	t	f	f	t
1459	203.0.113.54	192.168.1.198	DENY	33	TCP	2025-11-21 14:22:14.343244	t	f	f	t
1460	203.0.113.54	192.168.1.198	DENY	34	TCP	2025-11-21 14:21:54.34326	t	f	f	t
1461	203.0.113.151	192.168.1.132	ALLOW	3306	UDP	2025-11-21 07:21:23.187722	f	f	f	f
1462	192.168.1.75	192.168.1.180	ALLOW	80	ICMP	2025-11-21 09:08:23.187822	f	f	f	f
1463	203.0.113.254	192.168.1.160	ALLOW	6667	ICMP	2025-11-20 14:41:23.187853	f	f	f	f
1464	192.168.1.1	192.168.1.70	ALLOW	6667	TCP	2025-11-21 14:55:23.187878	f	f	f	f
1465	203.0.113.186	192.168.1.192	ALLOW	3389	ICMP	2025-11-20 11:45:23.187901	f	f	f	f
1466	203.0.113.251	192.168.1.135	DENY	135	TCP	2025-11-20 11:23:23.187931	f	f	f	f
1467	192.168.1.190	192.168.1.134	DENY	22	TCP	2025-11-20 19:27:23.187962	f	f	f	f
1468	203.0.113.27	192.168.1.95	ALLOW	3389	TCP	2025-11-20 10:49:23.187997	f	f	f	f
1469	192.168.1.97	192.168.1.132	ALLOW	80	UDP	2025-11-21 10:55:23.188029	f	f	f	f
1470	192.168.1.167	192.168.1.1	ALLOW	445	UDP	2025-11-20 22:11:23.18806	f	f	f	f
1471	192.168.1.94	192.168.1.70	ALLOW	135	ICMP	2025-11-21 11:04:23.188089	f	f	f	f
1472	203.0.113.228	192.168.1.247	DENY	3389	TCP	2025-11-20 23:43:23.188113	f	f	f	f
1473	203.0.113.7	192.168.1.26	DENY	3306	TCP	2025-11-21 13:48:23.188141	f	f	f	f
1474	203.0.113.90	192.168.1.79	ALLOW	8443	ICMP	2025-11-20 15:16:23.188173	f	f	f	f
1475	192.168.1.78	192.168.1.200	DENY	80	UDP	2025-11-21 01:46:23.188204	f	f	f	f
1476	192.168.1.186	192.168.1.216	ALLOW	8443	ICMP	2025-11-20 15:32:23.188234	f	f	f	f
1477	192.168.1.90	192.168.1.111	ALLOW	31337	ICMP	2025-11-20 16:49:23.18826	f	f	f	f
1478	192.168.1.125	192.168.1.10	ALLOW	80	ICMP	2025-11-21 04:10:23.188283	f	f	f	f
1479	203.0.113.17	192.168.1.203	ALLOW	5432	ICMP	2025-11-21 06:27:23.188309	f	f	f	f
1480	203.0.113.164	192.168.1.128	ALLOW	135	TCP	2025-11-20 11:36:23.188332	f	f	f	f
1481	192.168.1.71	192.168.1.251	DENY	5432	ICMP	2025-11-20 13:38:23.188362	f	f	f	f
1482	203.0.113.139	192.168.1.165	DENY	80	UDP	2025-11-20 19:45:23.188397	f	f	f	f
1483	203.0.113.21	192.168.1.215	ALLOW	3306	ICMP	2025-11-20 19:46:23.188422	f	f	f	f
1484	192.168.1.33	192.168.1.247	ALLOW	8080	UDP	2025-11-21 08:48:23.188444	f	f	f	f
1485	192.168.1.44	192.168.1.105	ALLOW	443	ICMP	2025-11-20 16:48:23.188467	f	f	f	f
1486	203.0.113.15	192.168.1.97	DENY	20	TCP	2025-11-21 15:23:38.188488	t	f	f	t
1487	203.0.113.15	192.168.1.97	DENY	21	TCP	2025-11-21 15:24:01.188513	t	f	f	t
1488	203.0.113.15	192.168.1.97	DENY	22	TCP	2025-11-21 15:20:11.188539	t	f	f	t
1489	203.0.113.15	192.168.1.97	DENY	23	TCP	2025-11-21 15:24:05.188557	t	f	f	t
1490	203.0.113.15	192.168.1.97	DENY	24	TCP	2025-11-21 15:23:25.188575	t	f	f	t
1491	203.0.113.15	192.168.1.97	DENY	25	TCP	2025-11-21 15:21:51.1886	t	f	f	t
1492	203.0.113.15	192.168.1.97	DENY	26	TCP	2025-11-21 15:21:13.188622	t	f	f	t
1493	203.0.113.15	192.168.1.97	DENY	27	TCP	2025-11-21 15:22:53.188639	t	f	f	t
1494	203.0.113.15	192.168.1.97	DENY	28	TCP	2025-11-21 15:20:58.188655	t	f	f	t
1495	203.0.113.15	192.168.1.97	DENY	29	TCP	2025-11-21 15:23:19.188671	t	f	f	t
1496	203.0.113.15	192.168.1.97	DENY	30	TCP	2025-11-21 15:20:15.188688	t	f	f	t
1497	203.0.113.15	192.168.1.97	DENY	31	TCP	2025-11-21 15:21:18.188725	t	f	f	t
1498	203.0.113.15	192.168.1.97	DENY	32	TCP	2025-11-21 15:23:00.188758	t	f	f	t
1499	203.0.113.15	192.168.1.97	DENY	33	TCP	2025-11-21 15:24:17.18878	t	f	f	t
1500	203.0.113.15	192.168.1.97	DENY	34	TCP	2025-11-21 15:22:29.188798	t	f	f	t
1501	203.0.113.163	192.168.1.96	ALLOW	8080	ICMP	2025-11-20 15:39:23.267629	f	f	f	f
1502	203.0.113.44	192.168.1.109	DENY	6697	UDP	2025-11-20 22:45:23.267713	f	f	f	f
1503	192.168.1.58	192.168.1.235	DENY	6667	ICMP	2025-11-21 07:14:23.267755	f	f	f	f
1504	192.168.1.189	192.168.1.59	ALLOW	6667	TCP	2025-11-21 10:42:23.267783	f	f	f	f
1505	192.168.1.99	192.168.1.38	ALLOW	6697	TCP	2025-11-21 10:43:23.267807	f	f	f	f
1506	203.0.113.59	192.168.1.187	DENY	135	UDP	2025-11-21 13:03:23.26783	f	f	f	f
1507	203.0.113.117	192.168.1.196	ALLOW	3306	ICMP	2025-11-20 23:10:23.267854	f	f	f	f
1508	192.168.1.55	192.168.1.194	ALLOW	6667	TCP	2025-11-21 04:01:23.267878	f	f	f	f
1509	192.168.1.206	192.168.1.235	ALLOW	80	UDP	2025-11-20 23:51:23.267902	f	f	f	f
1510	192.168.1.220	192.168.1.15	ALLOW	4444	ICMP	2025-11-20 22:40:23.267928	f	f	f	f
1511	192.168.1.84	192.168.1.254	ALLOW	22	UDP	2025-11-20 11:34:23.267952	f	f	f	f
1512	192.168.1.9	192.168.1.142	ALLOW	5432	TCP	2025-11-21 05:59:23.267976	f	f	f	f
1513	192.168.1.114	192.168.1.244	ALLOW	443	ICMP	2025-11-20 13:16:23.267998	f	f	f	f
1514	203.0.113.102	192.168.1.94	DENY	445	TCP	2025-11-20 23:15:23.268022	f	f	f	f
1515	203.0.113.222	192.168.1.94	ALLOW	443	UDP	2025-11-21 07:37:23.268045	f	f	f	f
1516	203.0.113.247	192.168.1.31	ALLOW	6697	TCP	2025-11-21 14:04:23.268069	f	f	f	f
1517	192.168.1.174	192.168.1.207	ALLOW	8080	ICMP	2025-11-20 19:49:23.268093	f	f	f	f
1518	203.0.113.229	192.168.1.246	ALLOW	445	UDP	2025-11-21 03:54:23.268118	f	f	f	f
1519	192.168.1.126	192.168.1.46	ALLOW	80	ICMP	2025-11-20 14:38:23.268141	f	f	f	f
1520	192.168.1.104	192.168.1.211	DENY	31337	ICMP	2025-11-20 14:51:23.268164	f	f	f	f
1521	192.168.1.54	192.168.1.121	ALLOW	80	UDP	2025-11-20 17:43:23.268189	f	f	f	f
1522	192.168.1.92	192.168.1.42	ALLOW	445	ICMP	2025-11-20 13:48:23.268212	f	f	f	t
1523	203.0.113.61	192.168.1.46	ALLOW	6667	TCP	2025-11-21 13:50:23.268235	f	f	f	f
1524	203.0.113.4	192.168.1.161	ALLOW	80	TCP	2025-11-20 21:03:23.268259	f	f	f	f
1525	203.0.113.181	192.168.1.246	ALLOW	8080	UDP	2025-11-20 11:59:23.268282	f	f	f	f
1526	203.0.113.5	192.168.1.103	ALLOW	1337	ICMP	2025-11-20 20:42:23.268305	f	f	f	f
1527	192.168.1.133	192.168.1.105	DENY	6667	ICMP	2025-11-21 08:28:23.268328	f	f	f	t
1528	192.168.1.117	192.168.1.137	DENY	443	UDP	2025-11-21 01:59:23.26835	f	f	f	f
1529	192.168.1.218	192.168.1.231	DENY	443	TCP	2025-11-21 13:25:23.268373	f	f	f	f
1530	203.0.113.115	192.168.1.74	DENY	20	TCP	2025-11-21 16:22:00.268397	t	f	f	t
1531	203.0.113.115	192.168.1.74	DENY	21	TCP	2025-11-21 16:21:43.268415	t	f	f	t
1532	203.0.113.115	192.168.1.74	DENY	22	TCP	2025-11-21 16:25:09.268431	t	f	f	t
1533	203.0.113.115	192.168.1.74	DENY	23	TCP	2025-11-21 16:21:19.268448	t	f	f	t
1534	203.0.113.115	192.168.1.74	DENY	24	TCP	2025-11-21 16:23:07.268465	t	f	f	t
1535	203.0.113.115	192.168.1.74	DENY	25	TCP	2025-11-21 16:24:08.268481	t	f	f	t
1536	203.0.113.115	192.168.1.74	DENY	26	TCP	2025-11-21 16:21:51.268497	t	f	f	t
1537	203.0.113.115	192.168.1.74	DENY	27	TCP	2025-11-21 16:21:00.268528	t	f	f	t
1538	203.0.113.115	192.168.1.74	DENY	28	TCP	2025-11-21 16:21:06.268546	t	f	f	t
1539	203.0.113.115	192.168.1.74	DENY	29	TCP	2025-11-21 16:20:29.268562	t	f	f	t
1540	203.0.113.115	192.168.1.74	DENY	30	TCP	2025-11-21 16:21:44.268578	t	f	f	t
1541	203.0.113.115	192.168.1.74	DENY	31	TCP	2025-11-21 16:22:37.268594	t	f	f	t
1542	203.0.113.115	192.168.1.74	DENY	32	TCP	2025-11-21 16:24:08.26861	t	f	f	t
1543	203.0.113.115	192.168.1.74	DENY	33	TCP	2025-11-21 16:22:23.268626	t	f	f	t
1544	203.0.113.115	192.168.1.74	DENY	34	TCP	2025-11-21 16:24:02.268642	t	f	f	t
1545	203.0.113.72	192.168.1.254	ALLOW	443	TCP	2025-11-21 13:17:23.135494	f	f	f	f
1546	192.168.1.237	192.168.1.73	ALLOW	6697	UDP	2025-11-20 12:14:23.135561	f	f	f	f
1547	203.0.113.209	192.168.1.13	ALLOW	3306	UDP	2025-11-21 13:57:23.135592	f	f	f	f
1548	192.168.1.6	192.168.1.121	ALLOW	6667	TCP	2025-11-20 16:57:23.135618	f	f	f	f
1549	192.168.1.175	192.168.1.89	DENY	443	TCP	2025-11-20 12:03:23.135645	f	f	f	f
1550	192.168.1.145	192.168.1.232	DENY	22	UDP	2025-11-21 17:05:23.135671	f	f	f	f
1551	192.168.1.182	192.168.1.107	ALLOW	6667	ICMP	2025-11-21 17:12:23.135697	f	f	f	f
1552	203.0.113.154	192.168.1.167	DENY	6697	ICMP	2025-11-21 16:29:23.135724	f	f	f	f
1553	203.0.113.98	192.168.1.141	ALLOW	8080	UDP	2025-11-21 15:33:23.135777	f	f	f	f
1554	203.0.113.104	192.168.1.59	ALLOW	5432	ICMP	2025-11-21 17:19:23.135804	f	f	f	f
1555	192.168.1.49	192.168.1.8	ALLOW	445	UDP	2025-11-21 05:55:23.135829	f	t	f	f
1556	192.168.1.92	192.168.1.67	ALLOW	6667	ICMP	2025-11-20 20:04:23.135852	f	f	f	f
1557	203.0.113.147	192.168.1.97	ALLOW	8443	UDP	2025-11-20 14:43:23.135877	f	f	f	f
1558	192.168.1.20	192.168.1.71	DENY	6667	TCP	2025-11-20 18:19:23.135902	f	f	f	f
1559	192.168.1.7	192.168.1.200	ALLOW	445	ICMP	2025-11-20 13:41:23.135925	f	f	f	f
1560	192.168.1.201	192.168.1.130	DENY	8443	UDP	2025-11-21 08:19:23.135949	f	f	f	f
1561	192.168.1.149	192.168.1.100	ALLOW	31337	UDP	2025-11-20 16:05:23.135974	f	f	f	f
1562	203.0.113.224	192.168.1.128	ALLOW	6667	ICMP	2025-11-21 08:36:23.135998	f	f	f	f
1563	203.0.113.181	192.168.1.9	ALLOW	80	TCP	2025-11-20 18:45:23.136022	f	f	f	f
1564	203.0.113.20	192.168.1.196	DENY	6667	UDP	2025-11-21 09:49:23.136046	f	f	f	f
1565	203.0.113.114	192.168.1.241	DENY	3389	UDP	2025-11-20 14:19:23.13607	f	f	f	f
1566	203.0.113.72	192.168.1.239	ALLOW	3389	TCP	2025-11-20 13:57:23.136094	f	f	f	f
1567	192.168.1.161	192.168.1.56	DENY	6697	ICMP	2025-11-20 11:36:23.136119	f	f	f	f
1568	203.0.113.127	192.168.1.133	DENY	20	TCP	2025-11-21 17:19:32.13614	t	f	f	t
1569	203.0.113.127	192.168.1.133	DENY	21	TCP	2025-11-21 17:21:10.13616	t	f	f	t
1570	203.0.113.127	192.168.1.133	DENY	22	TCP	2025-11-21 17:19:59.136177	t	f	f	t
1571	203.0.113.127	192.168.1.133	DENY	23	TCP	2025-11-21 17:21:13.136195	t	f	f	t
1572	203.0.113.127	192.168.1.133	DENY	24	TCP	2025-11-21 17:22:15.136212	t	f	f	t
1573	203.0.113.127	192.168.1.133	DENY	25	TCP	2025-11-21 17:18:34.136228	t	f	f	t
1574	203.0.113.127	192.168.1.133	DENY	26	TCP	2025-11-21 17:18:40.136244	t	f	f	t
1575	203.0.113.127	192.168.1.133	DENY	27	TCP	2025-11-21 17:21:10.13626	t	f	f	t
1576	203.0.113.127	192.168.1.133	DENY	28	TCP	2025-11-21 17:21:18.136276	t	f	f	t
1577	203.0.113.127	192.168.1.133	DENY	29	TCP	2025-11-21 17:21:13.136292	t	f	f	t
1578	203.0.113.127	192.168.1.133	DENY	30	TCP	2025-11-21 17:19:17.136309	t	f	f	t
1579	203.0.113.127	192.168.1.133	DENY	31	TCP	2025-11-21 17:18:45.136326	t	f	f	t
1580	203.0.113.127	192.168.1.133	DENY	32	TCP	2025-11-21 17:20:07.136342	t	f	f	t
1581	203.0.113.127	192.168.1.133	DENY	33	TCP	2025-11-21 17:22:31.136358	t	f	f	t
1582	203.0.113.127	192.168.1.133	DENY	34	TCP	2025-11-21 17:18:42.136375	t	f	f	t
1583	192.168.1.248	192.168.1.51	ALLOW	6667	UDP	2025-11-21 11:49:23.859128	f	f	f	f
1584	192.168.1.249	192.168.1.28	DENY	445	UDP	2025-11-21 16:54:23.859226	f	f	f	f
1585	203.0.113.88	192.168.1.67	ALLOW	8443	TCP	2025-11-21 08:07:23.859268	f	f	f	f
1586	192.168.1.20	192.168.1.154	ALLOW	31337	UDP	2025-11-20 13:27:23.859302	f	f	f	f
1587	192.168.1.172	192.168.1.22	ALLOW	22	ICMP	2025-11-21 07:02:23.859336	f	f	f	f
1588	192.168.1.104	192.168.1.194	DENY	22	UDP	2025-11-21 08:21:23.859373	f	f	f	f
1589	203.0.113.202	192.168.1.210	ALLOW	6667	ICMP	2025-11-20 20:23:23.859401	f	f	f	f
1590	203.0.113.244	192.168.1.149	ALLOW	6697	TCP	2025-11-21 10:43:23.859425	f	f	f	f
1591	203.0.113.153	192.168.1.9	ALLOW	4444	ICMP	2025-11-20 18:14:23.859449	f	f	f	f
1592	192.168.1.182	192.168.1.184	ALLOW	8443	ICMP	2025-11-21 05:48:23.859473	f	f	f	f
1593	203.0.113.96	192.168.1.218	DENY	5432	TCP	2025-11-21 07:23:23.859496	f	f	f	t
1594	203.0.113.102	192.168.1.25	ALLOW	8443	TCP	2025-11-21 13:55:23.859519	f	f	f	f
1595	192.168.1.114	192.168.1.48	DENY	135	UDP	2025-11-21 10:18:23.859543	f	f	f	f
1596	192.168.1.66	192.168.1.97	ALLOW	3389	UDP	2025-11-21 10:58:23.859565	f	f	f	f
1597	203.0.113.62	192.168.1.98	ALLOW	5432	ICMP	2025-11-21 01:41:23.859587	f	f	f	f
1598	203.0.113.201	192.168.1.118	ALLOW	5432	UDP	2025-11-21 13:29:23.859609	f	f	f	f
1599	203.0.113.102	192.168.1.48	DENY	20	TCP	2025-11-21 18:29:10.859631	t	f	f	t
1600	203.0.113.102	192.168.1.48	DENY	21	TCP	2025-11-21 18:29:20.859648	t	f	f	t
1601	203.0.113.102	192.168.1.48	DENY	22	TCP	2025-11-21 18:32:53.859664	t	f	f	t
1602	203.0.113.102	192.168.1.48	DENY	23	TCP	2025-11-21 18:29:28.859681	t	f	f	t
1603	203.0.113.102	192.168.1.48	DENY	24	TCP	2025-11-21 18:29:43.859697	t	f	f	t
1604	203.0.113.102	192.168.1.48	DENY	25	TCP	2025-11-21 18:30:23.859713	t	f	f	t
1605	203.0.113.102	192.168.1.48	DENY	26	TCP	2025-11-21 18:28:31.859745	t	f	f	t
1606	203.0.113.102	192.168.1.48	DENY	27	TCP	2025-11-21 18:29:18.859765	t	f	f	t
1607	203.0.113.102	192.168.1.48	DENY	28	TCP	2025-11-21 18:32:17.859782	t	f	f	t
1608	203.0.113.102	192.168.1.48	DENY	29	TCP	2025-11-21 18:28:52.859798	t	f	f	t
1609	203.0.113.102	192.168.1.48	DENY	30	TCP	2025-11-21 18:30:41.859814	t	f	f	t
1610	203.0.113.102	192.168.1.48	DENY	31	TCP	2025-11-21 18:31:33.85983	t	f	f	t
1611	203.0.113.102	192.168.1.48	DENY	32	TCP	2025-11-21 18:29:33.859846	t	f	f	t
1612	203.0.113.102	192.168.1.48	DENY	33	TCP	2025-11-21 18:28:25.859862	t	f	f	t
1613	203.0.113.102	192.168.1.48	DENY	34	TCP	2025-11-21 18:28:52.859878	t	f	f	t
1614	192.168.1.116	192.168.1.45	ALLOW	443	TCP	2025-11-21 06:27:23.741684	f	f	f	f
1615	203.0.113.23	192.168.1.140	DENY	139	ICMP	2025-11-21 00:20:23.741777	f	f	f	f
1616	203.0.113.64	192.168.1.169	DENY	8080	TCP	2025-11-20 20:59:23.741822	f	f	f	f
1617	203.0.113.182	192.168.1.106	DENY	135	ICMP	2025-11-20 19:48:23.741861	f	f	f	f
1618	203.0.113.225	192.168.1.54	ALLOW	6697	ICMP	2025-11-20 16:33:23.741901	f	f	f	t
1619	192.168.1.13	192.168.1.38	ALLOW	445	TCP	2025-11-21 13:59:23.741939	f	f	f	f
1620	203.0.113.138	192.168.1.31	DENY	80	TCP	2025-11-21 17:59:23.741974	f	f	f	f
1621	203.0.113.214	192.168.1.87	ALLOW	3306	ICMP	2025-11-20 16:29:23.742012	f	f	f	f
1622	203.0.113.42	192.168.1.156	DENY	6667	TCP	2025-11-21 15:49:23.742041	f	f	f	f
1623	203.0.113.84	192.168.1.17	ALLOW	8080	TCP	2025-11-20 23:50:23.742066	f	f	f	f
1624	192.168.1.170	192.168.1.149	DENY	6697	UDP	2025-11-21 18:35:23.742089	f	f	f	f
1625	203.0.113.170	192.168.1.8	ALLOW	3389	ICMP	2025-11-20 21:22:23.742113	f	f	f	f
1626	192.168.1.197	192.168.1.101	ALLOW	8443	UDP	2025-11-20 14:12:23.742135	f	f	f	f
1627	192.168.1.195	192.168.1.197	ALLOW	3306	UDP	2025-11-21 07:51:23.742158	f	f	f	f
1628	192.168.1.125	192.168.1.39	ALLOW	31337	TCP	2025-11-20 21:24:23.742181	f	f	f	f
1629	203.0.113.127	192.168.1.54	ALLOW	139	TCP	2025-11-21 00:28:23.742203	f	f	f	f
1630	203.0.113.82	192.168.1.175	ALLOW	139	ICMP	2025-11-21 09:57:23.742225	f	f	f	f
1631	192.168.1.163	192.168.1.136	DENY	3306	UDP	2025-11-20 19:14:23.742248	f	f	f	f
1632	203.0.113.15	192.168.1.179	DENY	445	UDP	2025-11-21 11:02:23.742272	f	f	f	f
1633	203.0.113.237	192.168.1.49	DENY	20	TCP	2025-11-21 19:31:07.742293	t	f	f	t
1634	203.0.113.237	192.168.1.49	DENY	21	TCP	2025-11-21 19:31:05.742311	t	f	f	t
1635	203.0.113.237	192.168.1.49	DENY	22	TCP	2025-11-21 19:28:07.742327	t	f	f	t
1636	203.0.113.237	192.168.1.49	DENY	23	TCP	2025-11-21 19:28:41.742343	t	f	f	t
1637	203.0.113.237	192.168.1.49	DENY	24	TCP	2025-11-21 19:27:41.742359	t	f	f	t
1638	203.0.113.237	192.168.1.49	DENY	25	TCP	2025-11-21 19:27:25.742375	t	f	f	t
1639	203.0.113.237	192.168.1.49	DENY	26	TCP	2025-11-21 19:29:01.74239	t	f	f	t
1640	203.0.113.237	192.168.1.49	DENY	27	TCP	2025-11-21 19:26:32.742407	t	f	f	t
1641	203.0.113.237	192.168.1.49	DENY	28	TCP	2025-11-21 19:28:24.742423	t	f	f	t
1642	203.0.113.237	192.168.1.49	DENY	29	TCP	2025-11-21 19:29:36.74244	t	f	f	t
1643	203.0.113.237	192.168.1.49	DENY	30	TCP	2025-11-21 19:28:36.742456	t	f	f	t
1644	203.0.113.237	192.168.1.49	DENY	31	TCP	2025-11-21 19:27:57.742472	t	f	f	t
1645	203.0.113.237	192.168.1.49	DENY	32	TCP	2025-11-21 19:27:12.742488	t	f	f	t
1646	203.0.113.237	192.168.1.49	DENY	33	TCP	2025-11-21 19:29:23.742504	t	f	f	t
1647	203.0.113.237	192.168.1.49	DENY	34	TCP	2025-11-21 19:30:34.74252	t	f	f	t
\.


--
-- Data for Name: login_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_events (id, username, src_ip, status, "timestamp", device_id, auth_method, is_burst_failure, is_suspicious_ip, is_admin) FROM stdin;
1	rlee	192.168.1.114	SUCCESS	2025-11-20 04:28:10.891252	WIN-LAPTOP-20	certificate	f	f	f
2	service_account	203.0.113.150	SUCCESS	2025-11-19 05:16:10.897835	MAC-DESKTOP-02	certificate	f	t	f
3	sysadmin	203.0.113.76	FAIL	2025-11-19 22:51:10.897913	MAC-DESKTOP-07	password	f	t	t
4	service_account	203.0.113.254	SUCCESS	2025-11-19 03:40:10.897991	WIN-LAPTOP-03	mfa	f	t	f
5	developer2	203.0.113.59	FAIL	2025-11-20 00:17:48.898041	MAC-DESKTOP-06	password	f	t	f
6	mjohnson	203.0.113.99	FAIL	2025-11-20 05:49:10.898082	WIN-LAPTOP-21	password	t	t	f
7	mjohnson	203.0.113.99	FAIL	2025-11-20 05:44:10.898109	WIN-LAPTOP-21	password	t	t	f
8	mjohnson	203.0.113.99	FAIL	2025-11-20 05:48:10.898139	WIN-LAPTOP-21	password	t	t	f
9	mjohnson	203.0.113.99	FAIL	2025-11-20 05:46:10.898175	WIN-LAPTOP-21	password	t	t	f
10	mjohnson	203.0.113.99	FAIL	2025-11-20 05:44:10.898201	WIN-LAPTOP-21	password	t	t	f
11	dbrown	192.168.1.14	SUCCESS	2025-11-20 04:47:41.889818	MAC-DESKTOP-01	certificate	f	f	f
12	developer1	203.0.113.224	SUCCESS	2025-11-19 02:24:10.889993	WIN-LAPTOP-07	password	f	t	f
13	kwilliams	203.0.113.220	SUCCESS	2025-11-19 06:34:10.890075	WIN-LAPTOP-14	password	f	t	f
14	sysadmin	203.0.113.79	FAIL	2025-11-19 22:45:10.890128	WIN-LAPTOP-10	certificate	f	t	t
15	sysadmin	203.0.113.203	SUCCESS	2025-11-20 01:53:10.890189	WIN-LAPTOP-17	certificate	f	t	t
16	asmith	192.168.1.143	SUCCESS	2025-11-19 23:43:10.890242	WIN-LAPTOP-04	sso	f	f	f
17	developer1	203.0.113.201	SUCCESS	2025-11-19 03:18:10.890296	WIN-LAPTOP-20	certificate	f	t	f
18	backup_user	203.0.113.93	SUCCESS	2025-11-19 18:50:10.890366	WIN-LAPTOP-25	password	f	t	f
19	developer1	203.0.113.29	FAIL	2025-11-20 06:10:10.890419	MAC-DESKTOP-04	password	t	t	f
20	developer1	203.0.113.29	FAIL	2025-11-20 06:16:10.890473	MAC-DESKTOP-04	password	t	t	f
21	developer1	203.0.113.29	FAIL	2025-11-20 06:14:10.89054	MAC-DESKTOP-04	password	t	t	f
22	developer1	203.0.113.29	FAIL	2025-11-20 06:18:10.890577	MAC-DESKTOP-04	password	t	t	f
23	developer1	203.0.113.29	FAIL	2025-11-20 06:09:10.89061	MAC-DESKTOP-04	password	t	t	f
24	backup_user	192.168.1.114	SUCCESS	2025-11-19 23:07:41.950079	MAC-DESKTOP-09	certificate	f	f	f
25	backup_user	203.0.113.246	SUCCESS	2025-11-19 20:02:41.958073	MAC-DESKTOP-10	sso	f	t	f
26	mjohnson	192.168.1.189	SUCCESS	2025-11-20 00:13:18.958129	WIN-LAPTOP-13	mfa	f	f	f
27	dbrown	203.0.113.157	SUCCESS	2025-11-19 03:13:41.95816	MAC-DESKTOP-07	password	f	t	f
28	root	203.0.113.249	SUCCESS	2025-11-20 02:37:41.958185	LINUX-SERVER-06	certificate	f	t	t
29	admin	203.0.113.147	SUCCESS	2025-11-19 07:35:41.958214	WIN-LAPTOP-15	certificate	f	t	t
30	scanner	203.0.113.88	FAIL	2025-11-20 06:43:41.958235	WIN-LAPTOP-17	password	t	t	f
31	scanner	203.0.113.88	FAIL	2025-11-20 06:44:41.958256	WIN-LAPTOP-17	password	t	t	f
32	scanner	203.0.113.88	FAIL	2025-11-20 06:43:41.95828	WIN-LAPTOP-17	password	t	t	f
33	scanner	203.0.113.88	FAIL	2025-11-20 06:39:41.958301	WIN-LAPTOP-17	password	t	t	f
34	scanner	203.0.113.88	FAIL	2025-11-20 06:37:41.958318	WIN-LAPTOP-17	password	t	t	f
35	sysadmin	192.168.1.161	SUCCESS	2025-11-20 02:12:02.622253	WIN-LAPTOP-28	certificate	f	f	t
36	sysadmin	203.0.113.85	SUCCESS	2025-11-19 11:06:39.626623	MAC-DESKTOP-02	password	f	t	t
37	monitoring	192.168.1.197	SUCCESS	2025-11-20 00:15:27.626681	MAC-DESKTOP-08	certificate	f	f	f
38	service_account	192.168.1.5	SUCCESS	2025-11-19 18:04:39.62672	MAC-DESKTOP-02	password	f	f	f
39	developer1	192.168.1.162	SUCCESS	2025-11-19 05:35:39.626779	MAC-DESKTOP-03	sso	f	f	f
40	netadmin	203.0.113.182	SUCCESS	2025-11-19 13:42:39.626806	LINUX-SERVER-07	sso	f	t	t
41	admin	203.0.113.250	FAIL	2025-11-20 06:47:39.626828	WIN-LAPTOP-28	password	t	t	t
42	admin	203.0.113.250	FAIL	2025-11-20 06:44:39.626853	WIN-LAPTOP-28	password	t	t	t
43	admin	203.0.113.250	FAIL	2025-11-20 06:43:39.626878	WIN-LAPTOP-28	password	t	t	t
44	admin	203.0.113.250	FAIL	2025-11-20 06:48:39.626896	WIN-LAPTOP-28	password	t	t	t
45	admin	203.0.113.250	FAIL	2025-11-20 06:45:39.626916	WIN-LAPTOP-28	password	t	t	t
46	developer2	203.0.113.108	SUCCESS	2025-11-20 00:44:17.202352	WIN-LAPTOP-05	certificate	f	t	f
47	jdoe	192.168.1.126	SUCCESS	2025-11-20 01:45:12.206427	WIN-LAPTOP-29	password	f	f	f
48	sysadmin	203.0.113.134	SUCCESS	2025-11-20 05:54:55.206492	WIN-LAPTOP-03	certificate	f	t	t
49	scanner	203.0.113.182	SUCCESS	2025-11-19 06:55:35.206538	MAC-DESKTOP-09	mfa	f	t	f
50	sysadmin	192.168.1.206	SUCCESS	2025-11-20 07:01:35.206598	WIN-LAPTOP-24	password	f	f	t
51	backup_user	192.168.1.115	SUCCESS	2025-11-20 01:52:59.206645	WIN-LAPTOP-22	password	f	f	f
52	developer1	203.0.113.190	SUCCESS	2025-11-19 09:01:35.206688	MAC-DESKTOP-06	certificate	f	t	f
53	scanner	192.168.1.245	SUCCESS	2025-11-19 12:23:35.206769	WIN-LAPTOP-07	mfa	f	f	f
54	mjohnson	203.0.113.125	SUCCESS	2025-11-19 13:17:35.206822	WIN-LAPTOP-20	password	f	t	f
55	netadmin	192.168.1.50	SUCCESS	2025-11-19 05:21:35.206858	WIN-LAPTOP-24	mfa	f	f	t
56	service_account	203.0.113.211	FAIL	2025-11-20 07:01:35.206895	MAC-DESKTOP-06	password	t	t	f
57	service_account	203.0.113.211	FAIL	2025-11-20 07:00:35.206923	MAC-DESKTOP-06	password	t	t	f
58	service_account	203.0.113.211	FAIL	2025-11-20 06:54:35.206957	MAC-DESKTOP-06	password	t	t	f
59	service_account	203.0.113.211	FAIL	2025-11-20 06:59:35.206988	MAC-DESKTOP-06	password	t	t	f
60	service_account	203.0.113.211	FAIL	2025-11-20 06:56:35.207017	MAC-DESKTOP-06	password	t	t	f
61	backup_user	203.0.113.72	SUCCESS	2025-11-19 10:22:35.201805	MAC-DESKTOP-07	certificate	f	t	f
62	rlee	192.168.1.185	SUCCESS	2025-11-19 04:38:35.201934	WIN-LAPTOP-11	certificate	f	f	f
63	mjohnson	203.0.113.183	SUCCESS	2025-11-19 13:26:35.201997	WIN-LAPTOP-24	mfa	f	t	f
64	scanner	203.0.113.152	SUCCESS	2025-11-20 04:19:08.202054	WIN-LAPTOP-29	mfa	f	t	f
65	dbrown	192.168.1.62	SUCCESS	2025-11-19 09:08:35.202107	MAC-DESKTOP-14	certificate	f	f	f
66	dbrown	192.168.1.177	SUCCESS	2025-11-20 05:55:35.202158	WIN-LAPTOP-29	sso	f	f	f
67	developer2	203.0.113.64	FAIL	2025-11-19 08:55:35.202209	MAC-DESKTOP-04	certificate	f	t	f
68	netadmin	203.0.113.245	SUCCESS	2025-11-20 01:28:45.20227	LINUX-SERVER-09	password	f	t	t
69	scanner	192.168.1.104	SUCCESS	2025-11-19 16:11:35.202347	WIN-LAPTOP-13	certificate	f	f	f
70	monitoring	192.168.1.23	SUCCESS	2025-11-19 10:56:35.202403	WIN-LAPTOP-02	mfa	f	f	f
71	mjohnson	203.0.113.192	SUCCESS	2025-11-19 01:34:35.20245	WIN-LAPTOP-18	password	f	t	f
72	monitoring	203.0.113.150	SUCCESS	2025-11-19 12:52:35.202497	WIN-LAPTOP-12	mfa	f	t	f
73	backup_user	203.0.113.82	FAIL	2025-11-20 07:29:35.202538	WIN-LAPTOP-22	password	t	t	f
74	backup_user	203.0.113.82	FAIL	2025-11-20 07:26:35.202574	WIN-LAPTOP-22	password	t	t	f
75	backup_user	203.0.113.82	FAIL	2025-11-20 07:29:35.202608	WIN-LAPTOP-22	password	t	t	f
76	backup_user	203.0.113.82	FAIL	2025-11-20 07:23:35.202642	WIN-LAPTOP-22	password	t	t	f
77	backup_user	203.0.113.82	FAIL	2025-11-20 07:26:35.202677	WIN-LAPTOP-22	password	t	t	f
78	rlee	192.168.1.102	SUCCESS	2025-11-19 19:21:35.201443	WIN-LAPTOP-08	password	f	f	f
79	monitoring	203.0.113.148	SUCCESS	2025-11-19 23:16:35.201606	WIN-LAPTOP-05	certificate	f	t	f
80	jdoe	192.168.1.11	SUCCESS	2025-11-19 15:17:35.201692	WIN-LAPTOP-07	sso	f	f	f
81	backup_user	192.168.1.95	FAIL	2025-11-19 16:59:35.2019	LINUX-SERVER-09	sso	f	f	f
82	jdoe	203.0.113.133	SUCCESS	2025-11-19 11:51:35.201998	WIN-LAPTOP-21	password	f	t	f
83	developer1	192.168.1.249	SUCCESS	2025-11-19 03:53:35.202071	WIN-LAPTOP-17	sso	f	f	f
84	rlee	192.168.1.79	SUCCESS	2025-11-20 07:14:35.202151	WIN-LAPTOP-06	mfa	f	f	f
85	service_account	203.0.113.241	SUCCESS	2025-11-19 13:06:35.202226	WIN-LAPTOP-28	sso	f	t	f
86	dbrown	192.168.1.233	SUCCESS	2025-11-19 07:06:35.202288	LINUX-SERVER-06	sso	f	f	f
87	jdoe	203.0.113.166	FAIL	2025-11-20 07:56:35.202358	WIN-LAPTOP-07	password	t	t	f
88	jdoe	203.0.113.166	FAIL	2025-11-20 07:54:35.202414	WIN-LAPTOP-07	password	t	t	f
89	jdoe	203.0.113.166	FAIL	2025-11-20 07:59:35.202468	WIN-LAPTOP-07	password	t	t	f
90	jdoe	203.0.113.166	FAIL	2025-11-20 07:56:35.202519	WIN-LAPTOP-07	password	t	t	f
91	jdoe	203.0.113.166	FAIL	2025-11-20 07:56:35.20257	WIN-LAPTOP-07	password	t	t	f
92	service_account	203.0.113.32	SUCCESS	2025-11-20 04:45:56.20147	MAC-DESKTOP-06	certificate	f	t	f
93	root	192.168.1.162	SUCCESS	2025-11-20 05:07:35.201551	WIN-LAPTOP-13	sso	f	f	t
94	sysadmin	192.168.1.94	FAIL	2025-11-20 02:26:35.201587	WIN-LAPTOP-10	mfa	f	f	t
95	asmith	203.0.113.43	SUCCESS	2025-11-19 20:53:35.201639	MAC-DESKTOP-04	mfa	f	t	f
96	kwilliams	192.168.1.237	SUCCESS	2025-11-20 00:03:34.201674	MAC-DESKTOP-10	password	f	f	f
97	admin	203.0.113.227	SUCCESS	2025-11-20 07:54:35.201704	MAC-DESKTOP-14	sso	f	t	t
98	jdoe	192.168.1.192	SUCCESS	2025-11-19 20:20:35.201764	WIN-LAPTOP-14	sso	f	f	f
99	dbrown	192.168.1.190	SUCCESS	2025-11-19 19:53:35.201809	MAC-DESKTOP-13	password	f	f	f
100	dbrown	203.0.113.72	FAIL	2025-11-20 08:23:35.20185	WIN-LAPTOP-16	password	t	t	f
101	dbrown	203.0.113.72	FAIL	2025-11-20 08:26:35.201877	WIN-LAPTOP-16	password	t	t	f
102	dbrown	203.0.113.72	FAIL	2025-11-20 08:25:35.201902	WIN-LAPTOP-16	password	t	t	f
103	dbrown	203.0.113.72	FAIL	2025-11-20 08:31:35.201927	WIN-LAPTOP-16	password	t	t	f
104	dbrown	203.0.113.72	FAIL	2025-11-20 08:31:35.201949	WIN-LAPTOP-16	password	t	t	f
105	admin	192.168.1.48	SUCCESS	2025-11-19 06:42:35.20138	MAC-DESKTOP-05	sso	f	f	t
106	root	203.0.113.112	SUCCESS	2025-11-19 08:32:35.201475	WIN-LAPTOP-22	password	f	t	t
107	developer1	192.168.1.102	SUCCESS	2025-11-20 03:04:44.201514	WIN-LAPTOP-17	certificate	f	f	f
108	developer1	203.0.113.130	SUCCESS	2025-11-19 20:20:35.201552	LINUX-SERVER-09	sso	f	t	f
109	backup_user	192.168.1.39	SUCCESS	2025-11-20 06:26:35.201586	WIN-LAPTOP-08	sso	f	f	f
110	monitoring	203.0.113.9	SUCCESS	2025-11-19 13:54:35.201632	WIN-LAPTOP-23	mfa	f	t	f
111	jdoe	203.0.113.48	SUCCESS	2025-11-20 04:18:35.201665	WIN-LAPTOP-01	certificate	f	t	f
112	developer2	203.0.113.108	FAIL	2025-11-20 09:03:35.201694	MAC-DESKTOP-14	password	t	t	f
113	developer2	203.0.113.108	FAIL	2025-11-20 09:03:35.201721	MAC-DESKTOP-14	password	t	t	f
114	developer2	203.0.113.108	FAIL	2025-11-20 09:01:35.201769	MAC-DESKTOP-14	password	t	t	f
115	developer2	203.0.113.108	FAIL	2025-11-20 09:03:35.201795	MAC-DESKTOP-14	password	t	t	f
116	developer2	203.0.113.108	FAIL	2025-11-20 08:55:35.20182	MAC-DESKTOP-14	password	t	t	f
117	root	203.0.113.158	SUCCESS	2025-11-20 05:52:08.201859	MAC-DESKTOP-03	certificate	f	t	t
118	sysadmin	203.0.113.216	SUCCESS	2025-11-19 10:12:35.202037	WIN-LAPTOP-02	mfa	f	t	t
119	developer2	203.0.113.169	FAIL	2025-11-19 04:39:35.202145	LINUX-SERVER-01	certificate	f	t	f
120	developer1	203.0.113.247	SUCCESS	2025-11-19 20:06:35.202265	WIN-LAPTOP-05	password	f	t	f
121	admin	192.168.1.113	SUCCESS	2025-11-19 15:31:35.20235	WIN-LAPTOP-15	sso	f	f	t
122	jdoe	203.0.113.11	FAIL	2025-11-20 05:49:36.20244	WIN-LAPTOP-21	password	f	t	f
123	netadmin	192.168.1.163	SUCCESS	2025-11-20 07:19:35.202548	WIN-LAPTOP-05	sso	f	f	t
124	backup_user	203.0.113.219	SUCCESS	2025-11-20 01:23:13.202703	WIN-LAPTOP-02	certificate	f	t	f
125	dbrown	203.0.113.203	SUCCESS	2025-11-20 01:40:11.202897	WIN-LAPTOP-19	mfa	f	t	f
126	admin	192.168.1.218	SUCCESS	2025-11-20 01:39:35.202984	WIN-LAPTOP-18	sso	f	f	t
127	jdoe	203.0.113.63	SUCCESS	2025-11-19 20:18:35.203051	WIN-LAPTOP-24	certificate	f	t	f
128	dbrown	203.0.113.38	SUCCESS	2025-11-20 02:32:30.203153	WIN-LAPTOP-04	mfa	f	t	f
129	developer1	203.0.113.180	FAIL	2025-11-20 09:26:35.203227	WIN-LAPTOP-05	password	t	t	f
130	developer1	203.0.113.180	FAIL	2025-11-20 09:24:35.203284	WIN-LAPTOP-05	password	t	t	f
131	developer1	203.0.113.180	FAIL	2025-11-20 09:27:35.20334	WIN-LAPTOP-05	password	t	t	f
132	developer1	203.0.113.180	FAIL	2025-11-20 09:33:35.203393	WIN-LAPTOP-05	password	t	t	f
133	developer1	203.0.113.180	FAIL	2025-11-20 09:28:35.203446	WIN-LAPTOP-05	password	t	t	f
134	scanner	192.168.1.21	FAIL	2025-11-20 06:45:35.201491	LINUX-SERVER-05	mfa	f	f	f
135	developer1	192.168.1.95	SUCCESS	2025-11-20 02:44:16.201602	MAC-DESKTOP-06	password	f	f	f
136	monitoring	203.0.113.163	SUCCESS	2025-11-20 04:52:20.201646	WIN-LAPTOP-10	sso	f	t	f
137	root	203.0.113.119	SUCCESS	2025-11-19 07:04:35.201683	WIN-LAPTOP-09	certificate	f	t	t
138	service_account	203.0.113.202	SUCCESS	2025-11-20 00:05:35.201718	WIN-LAPTOP-11	sso	f	t	f
139	scanner	203.0.113.239	SUCCESS	2025-11-19 15:26:35.201798	MAC-DESKTOP-05	mfa	f	t	f
140	sysadmin	203.0.113.36	SUCCESS	2025-11-20 08:17:35.201834	WIN-LAPTOP-06	password	f	t	t
141	scanner	192.168.1.190	SUCCESS	2025-11-19 13:24:35.201865	MAC-DESKTOP-10	mfa	f	f	f
142	sysadmin	203.0.113.146	FAIL	2025-11-20 09:59:35.201898	WIN-LAPTOP-14	password	t	t	t
143	sysadmin	203.0.113.146	FAIL	2025-11-20 09:55:35.20193	WIN-LAPTOP-14	password	t	t	t
144	sysadmin	203.0.113.146	FAIL	2025-11-20 09:54:35.201955	WIN-LAPTOP-14	password	t	t	t
145	sysadmin	203.0.113.146	FAIL	2025-11-20 09:59:35.20198	WIN-LAPTOP-14	password	t	t	t
146	sysadmin	203.0.113.146	FAIL	2025-11-20 09:53:35.202004	WIN-LAPTOP-14	password	t	t	t
147	root	203.0.113.110	SUCCESS	2025-11-19 08:25:35.201527	MAC-DESKTOP-01	sso	f	t	t
148	service_account	203.0.113.73	FAIL	2025-11-20 03:06:35.201646	WIN-LAPTOP-07	certificate	f	t	f
149	dbrown	203.0.113.37	SUCCESS	2025-11-19 11:00:35.201708	MAC-DESKTOP-01	sso	f	t	f
150	admin	203.0.113.233	SUCCESS	2025-11-19 14:38:35.201803	WIN-LAPTOP-22	sso	f	t	t
151	scanner	203.0.113.131	SUCCESS	2025-11-19 18:27:35.201857	MAC-DESKTOP-13	password	f	t	f
152	admin	203.0.113.156	SUCCESS	2025-11-20 01:51:35.201902	LINUX-SERVER-07	mfa	f	t	t
153	rlee	203.0.113.37	SUCCESS	2025-11-19 19:02:35.201949	MAC-DESKTOP-04	sso	f	t	f
154	dbrown	192.168.1.216	SUCCESS	2025-11-19 08:05:35.201994	WIN-LAPTOP-17	sso	f	f	f
155	mjohnson	192.168.1.254	SUCCESS	2025-11-19 17:34:35.202042	WIN-LAPTOP-09	password	f	f	f
156	service_account	203.0.113.138	FAIL	2025-11-20 10:28:35.20209	WIN-LAPTOP-21	password	t	t	f
157	service_account	203.0.113.138	FAIL	2025-11-20 10:26:35.20215	WIN-LAPTOP-21	password	t	t	f
158	service_account	203.0.113.138	FAIL	2025-11-20 10:30:35.202187	WIN-LAPTOP-21	password	t	t	f
159	service_account	203.0.113.138	FAIL	2025-11-20 10:33:35.202221	WIN-LAPTOP-21	password	t	t	f
160	service_account	203.0.113.138	FAIL	2025-11-20 10:29:35.202256	WIN-LAPTOP-21	password	t	t	f
161	developer2	203.0.113.10	SUCCESS	2025-11-19 07:44:35.201565	WIN-LAPTOP-26	password	f	t	f
162	root	192.168.1.214	SUCCESS	2025-11-20 04:26:56.201775	MAC-DESKTOP-05	password	f	f	t
163	jdoe	203.0.113.231	SUCCESS	2025-11-20 10:19:35.201867	MAC-DESKTOP-01	sso	f	t	f
164	monitoring	203.0.113.77	SUCCESS	2025-11-19 20:17:35.201925	MAC-DESKTOP-14	mfa	f	t	f
165	kwilliams	192.168.1.119	FAIL	2025-11-20 00:58:27.201979	WIN-LAPTOP-14	certificate	f	f	f
166	developer2	192.168.1.79	SUCCESS	2025-11-20 03:07:35.20204	MAC-DESKTOP-13	certificate	f	f	f
167	developer2	203.0.113.114	FAIL	2025-11-19 18:04:35.20209	WIN-LAPTOP-09	password	f	t	f
168	scanner	192.168.1.182	FAIL	2025-11-19 10:49:35.202144	WIN-LAPTOP-09	certificate	f	f	f
169	developer2	192.168.1.245	SUCCESS	2025-11-20 04:09:06.202202	WIN-LAPTOP-18	sso	f	f	f
170	sysadmin	203.0.113.113	FAIL	2025-11-20 11:00:35.202249	MAC-DESKTOP-14	password	t	t	t
171	sysadmin	203.0.113.113	FAIL	2025-11-20 10:53:35.202285	MAC-DESKTOP-14	password	t	t	t
172	sysadmin	203.0.113.113	FAIL	2025-11-20 11:00:35.202341	MAC-DESKTOP-14	password	t	t	t
173	sysadmin	203.0.113.113	FAIL	2025-11-20 10:58:35.202376	MAC-DESKTOP-14	password	t	t	t
174	sysadmin	203.0.113.113	FAIL	2025-11-20 10:55:35.202412	MAC-DESKTOP-14	password	t	t	t
175	mjohnson	192.168.1.155	SUCCESS	2025-11-20 04:47:48.201885	MAC-DESKTOP-06	password	f	f	f
176	rlee	203.0.113.217	SUCCESS	2025-11-20 02:55:43.202072	LINUX-SERVER-03	mfa	f	t	f
177	mjohnson	203.0.113.154	SUCCESS	2025-11-19 12:14:35.202164	WIN-LAPTOP-14	sso	f	t	f
178	developer1	192.168.1.24	FAIL	2025-11-19 11:55:35.202249	WIN-LAPTOP-05	password	f	f	f
179	developer2	192.168.1.178	SUCCESS	2025-11-19 15:40:35.20237	MAC-DESKTOP-02	mfa	f	f	f
180	admin	203.0.113.149	FAIL	2025-11-20 02:36:35.202454	LINUX-SERVER-01	sso	f	t	t
181	developer1	203.0.113.44	SUCCESS	2025-11-19 08:40:35.202535	WIN-LAPTOP-09	certificate	f	t	f
182	netadmin	203.0.113.216	SUCCESS	2025-11-19 20:13:35.202608	WIN-LAPTOP-16	mfa	f	t	t
183	dbrown	192.168.1.186	SUCCESS	2025-11-19 12:11:35.202683	WIN-LAPTOP-22	password	f	f	f
184	admin	192.168.1.22	SUCCESS	2025-11-20 00:53:47.202809	WIN-LAPTOP-29	certificate	f	f	t
185	rlee	192.168.1.84	SUCCESS	2025-11-19 05:56:35.202895	WIN-LAPTOP-27	mfa	f	f	f
186	jdoe	192.168.1.119	SUCCESS	2025-11-19 05:53:35.20298	LINUX-SERVER-05	sso	f	f	f
187	service_account	192.168.1.52	FAIL	2025-11-19 11:11:35.203069	LINUX-SERVER-02	sso	f	f	f
188	kwilliams	203.0.113.44	SUCCESS	2025-11-20 06:10:35.20316	LINUX-SERVER-01	certificate	f	t	f
189	developer1	203.0.113.136	FAIL	2025-11-20 11:24:35.203231	WIN-LAPTOP-28	password	t	t	f
190	developer1	203.0.113.136	FAIL	2025-11-20 11:28:35.203349	WIN-LAPTOP-28	password	t	t	f
191	developer1	203.0.113.136	FAIL	2025-11-20 11:28:35.203415	WIN-LAPTOP-28	password	t	t	f
192	developer1	203.0.113.136	FAIL	2025-11-20 11:31:35.203473	WIN-LAPTOP-28	password	t	t	f
193	developer1	203.0.113.136	FAIL	2025-11-20 11:27:35.203529	WIN-LAPTOP-28	password	t	t	f
194	admin	203.0.113.22	SUCCESS	2025-11-20 03:31:32.201489	MAC-DESKTOP-04	password	f	t	t
195	netadmin	203.0.113.38	SUCCESS	2025-11-20 08:37:35.20159	WIN-LAPTOP-07	sso	f	t	t
196	developer2	203.0.113.226	FAIL	2025-11-19 07:49:35.201636	MAC-DESKTOP-03	sso	f	t	f
197	scanner	203.0.113.37	SUCCESS	2025-11-19 20:47:35.201665	WIN-LAPTOP-23	certificate	f	t	f
198	sysadmin	203.0.113.56	FAIL	2025-11-20 05:23:35.201687	WIN-LAPTOP-16	mfa	f	t	t
199	sysadmin	192.168.1.64	FAIL	2025-11-20 06:02:35.20171	WIN-LAPTOP-06	certificate	f	f	t
200	developer1	203.0.113.50	SUCCESS	2025-11-19 11:46:35.201759	WIN-LAPTOP-27	password	f	t	f
201	kwilliams	192.168.1.106	SUCCESS	2025-11-20 02:19:35.201781	WIN-LAPTOP-25	mfa	f	f	f
202	kwilliams	192.168.1.17	SUCCESS	2025-11-19 06:29:35.201803	MAC-DESKTOP-01	certificate	f	f	f
203	dbrown	203.0.113.136	SUCCESS	2025-11-19 10:48:35.201824	WIN-LAPTOP-01	password	f	t	f
204	netadmin	192.168.1.163	SUCCESS	2025-11-19 23:53:35.201843	MAC-DESKTOP-04	certificate	f	f	t
205	developer1	192.168.1.118	SUCCESS	2025-11-19 20:17:35.201883	LINUX-SERVER-06	mfa	f	f	f
206	developer2	203.0.113.95	SUCCESS	2025-11-19 09:41:35.201929	WIN-LAPTOP-13	mfa	f	t	f
207	root	203.0.113.33	SUCCESS	2025-11-19 10:57:35.201963	LINUX-SERVER-08	password	f	t	t
208	monitoring	192.168.1.36	SUCCESS	2025-11-19 13:17:35.201996	LINUX-SERVER-09	certificate	f	f	f
209	mjohnson	203.0.113.209	FAIL	2025-11-20 11:53:35.202019	MAC-DESKTOP-13	password	t	t	f
210	mjohnson	203.0.113.209	FAIL	2025-11-20 11:58:35.202036	MAC-DESKTOP-13	password	t	t	f
211	mjohnson	203.0.113.209	FAIL	2025-11-20 11:59:35.202051	MAC-DESKTOP-13	password	t	t	f
212	mjohnson	203.0.113.209	FAIL	2025-11-20 11:54:35.202066	MAC-DESKTOP-13	password	t	t	f
213	mjohnson	203.0.113.209	FAIL	2025-11-20 12:00:35.202081	MAC-DESKTOP-13	password	t	t	f
214	service_account	192.168.1.28	SUCCESS	2025-11-19 19:46:35.201506	WIN-LAPTOP-27	certificate	f	f	f
215	developer1	192.168.1.92	SUCCESS	2025-11-20 09:42:35.201632	WIN-LAPTOP-10	sso	f	f	f
216	asmith	203.0.113.200	SUCCESS	2025-11-20 08:00:35.201694	WIN-LAPTOP-26	mfa	f	t	f
217	jdoe	203.0.113.157	SUCCESS	2025-11-20 06:11:35.20179	MAC-DESKTOP-09	certificate	f	t	f
218	root	203.0.113.164	SUCCESS	2025-11-20 00:21:35.201846	WIN-LAPTOP-22	sso	f	t	t
219	root	203.0.113.246	SUCCESS	2025-11-20 03:11:07.20192	LINUX-SERVER-08	sso	f	t	t
220	developer1	192.168.1.72	SUCCESS	2025-11-19 18:54:35.201974	MAC-DESKTOP-07	certificate	f	f	f
221	backup_user	203.0.113.55	SUCCESS	2025-11-19 09:33:35.202029	WIN-LAPTOP-13	mfa	f	t	f
222	monitoring	203.0.113.235	SUCCESS	2025-11-19 08:09:35.202077	MAC-DESKTOP-08	password	f	t	f
223	jdoe	192.168.1.82	SUCCESS	2025-11-19 08:47:35.20213	WIN-LAPTOP-18	mfa	f	f	f
224	backup_user	192.168.1.213	SUCCESS	2025-11-20 05:44:35.202184	WIN-LAPTOP-08	sso	f	f	f
225	jdoe	192.168.1.134	FAIL	2025-11-20 11:58:35.202239	LINUX-SERVER-09	password	f	f	f
226	monitoring	203.0.113.2	SUCCESS	2025-11-19 19:58:35.202301	WIN-LAPTOP-10	sso	f	t	f
227	sysadmin	192.168.1.69	SUCCESS	2025-11-20 04:21:35.202347	LINUX-SERVER-05	sso	f	f	t
228	scanner	192.168.1.84	SUCCESS	2025-11-20 03:50:36.202403	MAC-DESKTOP-04	mfa	f	f	f
229	developer1	203.0.113.151	FAIL	2025-11-20 12:31:35.202457	MAC-DESKTOP-06	password	t	t	f
230	developer1	203.0.113.151	FAIL	2025-11-20 12:30:35.202498	MAC-DESKTOP-06	password	t	t	f
231	developer1	203.0.113.151	FAIL	2025-11-20 12:32:35.202537	MAC-DESKTOP-06	password	t	t	f
232	developer1	203.0.113.151	FAIL	2025-11-20 12:33:35.202575	MAC-DESKTOP-06	password	t	t	f
233	developer1	203.0.113.151	FAIL	2025-11-20 12:24:35.202612	MAC-DESKTOP-06	password	t	t	f
234	developer2	203.0.113.220	SUCCESS	2025-11-19 09:34:35.201208	WIN-LAPTOP-02	password	f	t	f
235	kwilliams	203.0.113.41	SUCCESS	2025-11-19 16:50:35.201282	WIN-LAPTOP-26	sso	f	t	f
236	admin	192.168.1.24	SUCCESS	2025-11-20 10:50:35.201306	WIN-LAPTOP-19	sso	f	f	t
237	sysadmin	203.0.113.164	FAIL	2025-11-20 03:10:32.201332	MAC-DESKTOP-13	mfa	f	t	t
238	kwilliams	203.0.113.221	FAIL	2025-11-20 02:09:02.20137	LINUX-SERVER-07	password	f	t	f
239	dbrown	203.0.113.203	SUCCESS	2025-11-20 01:58:52.201412	WIN-LAPTOP-08	sso	f	t	f
240	scanner	192.168.1.92	SUCCESS	2025-11-20 02:08:59.201456	WIN-LAPTOP-27	sso	f	f	f
241	admin	203.0.113.244	SUCCESS	2025-11-20 02:45:35.20149	MAC-DESKTOP-12	mfa	f	t	t
242	asmith	203.0.113.145	SUCCESS	2025-11-19 19:08:35.201568	LINUX-SERVER-09	mfa	f	t	f
243	admin	203.0.113.147	SUCCESS	2025-11-20 12:08:35.20159	MAC-DESKTOP-01	password	f	t	t
244	dbrown	203.0.113.86	FAIL	2025-11-20 12:54:35.201609	WIN-LAPTOP-10	password	t	t	f
245	dbrown	203.0.113.86	FAIL	2025-11-20 12:57:35.201626	WIN-LAPTOP-10	password	t	t	f
246	dbrown	203.0.113.86	FAIL	2025-11-20 12:55:35.201641	WIN-LAPTOP-10	password	t	t	f
247	dbrown	203.0.113.86	FAIL	2025-11-20 12:58:35.201657	WIN-LAPTOP-10	password	t	t	f
248	dbrown	203.0.113.86	FAIL	2025-11-20 12:56:35.201694	WIN-LAPTOP-10	password	t	t	f
249	dbrown	192.168.1.8	SUCCESS	2025-11-20 01:23:43.201658	WIN-LAPTOP-14	certificate	f	f	f
250	developer2	192.168.1.64	SUCCESS	2025-11-20 10:01:35.201841	WIN-LAPTOP-13	mfa	f	f	f
251	scanner	192.168.1.32	SUCCESS	2025-11-20 04:25:19.201941	LINUX-SERVER-06	mfa	f	f	f
252	service_account	192.168.1.58	SUCCESS	2025-11-20 05:13:52.202037	MAC-DESKTOP-11	password	f	f	f
253	root	203.0.113.201	SUCCESS	2025-11-20 00:43:13.202134	WIN-LAPTOP-11	certificate	f	t	t
254	kwilliams	203.0.113.124	SUCCESS	2025-11-19 10:23:35.202183	WIN-LAPTOP-25	password	f	t	f
255	root	192.168.1.199	SUCCESS	2025-11-19 23:00:35.202233	WIN-LAPTOP-14	certificate	f	f	t
256	asmith	203.0.113.206	SUCCESS	2025-11-19 22:01:35.202282	LINUX-SERVER-03	certificate	f	t	f
257	monitoring	192.168.1.109	SUCCESS	2025-11-19 09:05:35.202328	WIN-LAPTOP-07	sso	f	f	f
258	monitoring	192.168.1.40	SUCCESS	2025-11-20 02:14:35.202377	WIN-LAPTOP-20	certificate	f	f	f
259	monitoring	203.0.113.75	SUCCESS	2025-11-20 00:28:49.202429	LINUX-SERVER-03	mfa	f	t	f
260	monitoring	192.168.1.168	SUCCESS	2025-11-20 00:54:30.202476	MAC-DESKTOP-04	certificate	f	f	f
261	scanner	203.0.113.144	FAIL	2025-11-20 13:25:35.202521	MAC-DESKTOP-01	password	t	t	f
262	scanner	203.0.113.144	FAIL	2025-11-20 13:26:35.202558	MAC-DESKTOP-01	password	t	t	f
263	scanner	203.0.113.144	FAIL	2025-11-20 13:24:35.202593	MAC-DESKTOP-01	password	t	t	f
264	scanner	203.0.113.144	FAIL	2025-11-20 13:25:35.202627	MAC-DESKTOP-01	password	t	t	f
265	scanner	203.0.113.144	FAIL	2025-11-20 13:26:35.202659	MAC-DESKTOP-01	password	t	t	f
266	rlee	203.0.113.97	SUCCESS	2025-11-20 05:42:37.20153	LINUX-SERVER-04	sso	f	t	f
267	kwilliams	203.0.113.219	SUCCESS	2025-11-19 13:17:35.201607	MAC-DESKTOP-13	password	f	t	f
268	kwilliams	192.168.1.162	SUCCESS	2025-11-20 04:07:35.201634	MAC-DESKTOP-06	sso	f	f	f
269	service_account	192.168.1.132	SUCCESS	2025-11-20 03:55:35.201658	MAC-DESKTOP-04	certificate	f	f	f
270	admin	192.168.1.210	SUCCESS	2025-11-19 10:50:35.201682	LINUX-SERVER-09	mfa	f	f	t
271	admin	192.168.1.223	FAIL	2025-11-19 09:47:35.201705	MAC-DESKTOP-06	certificate	f	f	t
272	asmith	203.0.113.65	FAIL	2025-11-19 11:38:35.201745	WIN-LAPTOP-20	password	f	t	f
273	scanner	192.168.1.127	SUCCESS	2025-11-20 02:32:24.201773	MAC-DESKTOP-13	mfa	f	f	f
274	developer2	203.0.113.230	SUCCESS	2025-11-19 23:12:35.201798	WIN-LAPTOP-07	sso	f	t	f
275	developer2	192.168.1.218	SUCCESS	2025-11-20 02:49:35.20182	WIN-LAPTOP-01	certificate	f	f	f
276	developer1	192.168.1.227	SUCCESS	2025-11-19 12:37:35.201842	LINUX-SERVER-01	sso	f	f	f
277	jdoe	192.168.1.46	FAIL	2025-11-20 10:07:35.201864	MAC-DESKTOP-02	password	f	f	f
278	admin	203.0.113.118	FAIL	2025-11-20 13:58:35.201888	LINUX-SERVER-04	password	t	t	t
279	admin	203.0.113.118	FAIL	2025-11-20 13:59:35.201905	LINUX-SERVER-04	password	t	t	t
280	admin	203.0.113.118	FAIL	2025-11-20 13:55:35.201922	LINUX-SERVER-04	password	t	t	t
281	admin	203.0.113.118	FAIL	2025-11-20 14:00:35.201939	LINUX-SERVER-04	password	t	t	t
282	admin	203.0.113.118	FAIL	2025-11-20 13:57:35.201962	LINUX-SERVER-04	password	t	t	t
283	dbrown	192.168.1.48	SUCCESS	2025-11-20 04:00:49.20119	WIN-LAPTOP-08	certificate	f	f	f
284	scanner	192.168.1.101	SUCCESS	2025-11-20 08:25:35.201263	WIN-LAPTOP-03	password	f	f	f
285	monitoring	192.168.1.204	SUCCESS	2025-11-19 17:51:35.201291	WIN-LAPTOP-02	sso	f	f	f
286	jdoe	203.0.113.183	SUCCESS	2025-11-19 20:16:35.201315	WIN-LAPTOP-04	password	f	t	f
287	kwilliams	192.168.1.219	SUCCESS	2025-11-20 05:14:35.201338	LINUX-SERVER-04	sso	f	f	f
288	sysadmin	203.0.113.194	SUCCESS	2025-11-20 14:54:35.201363	MAC-DESKTOP-05	certificate	f	t	t
289	netadmin	203.0.113.165	SUCCESS	2025-11-19 10:42:35.201384	WIN-LAPTOP-07	certificate	f	t	t
290	kwilliams	192.168.1.228	SUCCESS	2025-11-20 07:29:35.201405	MAC-DESKTOP-02	password	f	f	f
291	admin	203.0.113.125	FAIL	2025-11-20 02:14:35.201428	WIN-LAPTOP-24	sso	f	t	t
292	netadmin	192.168.1.18	SUCCESS	2025-11-20 08:35:35.201453	MAC-DESKTOP-08	password	f	f	t
293	root	192.168.1.143	SUCCESS	2025-11-20 11:12:35.201476	MAC-DESKTOP-09	certificate	f	f	t
294	developer2	192.168.1.169	SUCCESS	2025-11-20 04:18:25.2015	WIN-LAPTOP-05	certificate	f	f	f
295	dbrown	192.168.1.131	SUCCESS	2025-11-20 11:36:35.201524	WIN-LAPTOP-01	password	f	f	f
296	kwilliams	203.0.113.81	FAIL	2025-11-20 14:58:35.201547	LINUX-SERVER-09	password	t	t	f
297	kwilliams	203.0.113.81	FAIL	2025-11-20 14:53:35.201563	LINUX-SERVER-09	password	t	t	f
298	kwilliams	203.0.113.81	FAIL	2025-11-20 14:57:35.20158	LINUX-SERVER-09	password	t	t	f
299	kwilliams	203.0.113.81	FAIL	2025-11-20 14:58:35.201597	LINUX-SERVER-09	password	t	t	f
300	kwilliams	203.0.113.81	FAIL	2025-11-20 14:54:35.201613	LINUX-SERVER-09	password	t	t	f
301	monitoring	203.0.113.149	SUCCESS	2025-11-19 13:40:35.201224	MAC-DESKTOP-05	sso	f	t	f
302	sysadmin	203.0.113.162	SUCCESS	2025-11-20 00:25:38.20132	MAC-DESKTOP-09	certificate	f	t	t
303	mjohnson	203.0.113.56	SUCCESS	2025-11-20 05:21:25.20136	WIN-LAPTOP-24	certificate	f	t	f
304	service_account	192.168.1.91	SUCCESS	2025-11-19 21:44:35.201393	WIN-LAPTOP-10	password	f	f	f
305	developer2	192.168.1.162	SUCCESS	2025-11-20 15:44:35.20143	MAC-DESKTOP-08	certificate	f	f	f
306	sysadmin	192.168.1.186	SUCCESS	2025-11-20 00:15:38.201475	WIN-LAPTOP-05	sso	f	f	t
307	developer2	192.168.1.43	SUCCESS	2025-11-20 09:15:35.201511	MAC-DESKTOP-14	certificate	f	f	f
308	mjohnson	203.0.113.70	SUCCESS	2025-11-20 03:27:36.201548	WIN-LAPTOP-10	mfa	f	t	f
309	jdoe	192.168.1.34	SUCCESS	2025-11-19 22:15:35.201579	MAC-DESKTOP-13	mfa	f	f	f
310	mjohnson	203.0.113.30	FAIL	2025-11-20 15:58:35.201612	LINUX-SERVER-01	password	t	t	f
311	mjohnson	203.0.113.30	FAIL	2025-11-20 15:58:35.201638	LINUX-SERVER-01	password	t	t	f
312	mjohnson	203.0.113.30	FAIL	2025-11-20 15:59:35.201662	LINUX-SERVER-01	password	t	t	f
313	mjohnson	203.0.113.30	FAIL	2025-11-20 15:59:35.201686	LINUX-SERVER-01	password	t	t	f
314	mjohnson	203.0.113.30	FAIL	2025-11-20 16:01:35.20171	LINUX-SERVER-01	password	t	t	f
315	monitoring	192.168.1.75	SUCCESS	2025-11-20 03:22:35.201059	WIN-LAPTOP-25	certificate	f	f	f
316	jdoe	203.0.113.167	SUCCESS	2025-11-20 01:42:12.201133	WIN-LAPTOP-25	sso	f	t	f
317	admin	192.168.1.140	SUCCESS	2025-11-20 15:02:35.20116	WIN-LAPTOP-12	password	f	f	t
318	asmith	203.0.113.112	FAIL	2025-11-20 07:48:35.201185	WIN-LAPTOP-25	certificate	f	t	f
319	developer1	192.168.1.207	FAIL	2025-11-20 11:44:35.201211	WIN-LAPTOP-03	sso	f	f	f
320	developer1	203.0.113.209	SUCCESS	2025-11-20 04:12:35.201246	WIN-LAPTOP-15	sso	f	t	f
321	developer2	192.168.1.127	SUCCESS	2025-11-20 05:37:35.201279	WIN-LAPTOP-21	certificate	f	f	f
322	dbrown	192.168.1.86	SUCCESS	2025-11-20 03:10:26.201314	MAC-DESKTOP-10	sso	f	f	f
323	jdoe	203.0.113.40	SUCCESS	2025-11-20 00:31:16.201348	MAC-DESKTOP-08	sso	f	t	f
324	dbrown	203.0.113.85	SUCCESS	2025-11-19 21:05:35.201368	WIN-LAPTOP-11	password	f	t	f
325	scanner	203.0.113.123	FAIL	2025-11-20 14:51:35.201388	WIN-LAPTOP-28	mfa	f	t	f
326	netadmin	203.0.113.244	FAIL	2025-11-20 16:55:35.201411	WIN-LAPTOP-23	password	t	t	t
327	netadmin	203.0.113.244	FAIL	2025-11-20 16:57:35.201428	WIN-LAPTOP-23	password	t	t	t
328	netadmin	203.0.113.244	FAIL	2025-11-20 16:53:35.201444	WIN-LAPTOP-23	password	t	t	t
329	netadmin	203.0.113.244	FAIL	2025-11-20 16:59:35.20146	WIN-LAPTOP-23	password	t	t	t
330	netadmin	203.0.113.244	FAIL	2025-11-20 17:00:35.201476	WIN-LAPTOP-23	password	t	t	t
331	service_account	192.168.1.142	FAIL	2025-11-19 18:31:35.201219	MAC-DESKTOP-09	mfa	f	f	f
332	rlee	203.0.113.228	SUCCESS	2025-11-20 00:16:31.201331	MAC-DESKTOP-11	password	f	t	f
333	mjohnson	203.0.113.140	FAIL	2025-11-20 04:17:35.201377	WIN-LAPTOP-10	mfa	f	t	f
334	backup_user	203.0.113.83	SUCCESS	2025-11-19 13:29:35.201424	LINUX-SERVER-03	mfa	f	t	f
335	developer1	203.0.113.129	SUCCESS	2025-11-20 17:45:35.201454	LINUX-SERVER-01	sso	f	t	f
336	netadmin	203.0.113.227	SUCCESS	2025-11-19 15:50:35.201477	MAC-DESKTOP-07	sso	f	t	t
337	backup_user	192.168.1.90	SUCCESS	2025-11-20 07:31:35.201499	WIN-LAPTOP-05	certificate	f	f	f
338	rlee	192.168.1.164	SUCCESS	2025-11-20 02:26:01.201523	WIN-LAPTOP-19	certificate	f	f	f
339	kwilliams	192.168.1.40	SUCCESS	2025-11-20 06:44:35.201548	WIN-LAPTOP-24	certificate	f	f	f
340	asmith	192.168.1.28	SUCCESS	2025-11-20 02:06:35.201584	MAC-DESKTOP-04	sso	f	f	f
341	root	192.168.1.30	FAIL	2025-11-20 02:02:42.201624	LINUX-SERVER-05	password	f	f	t
342	admin	192.168.1.169	SUCCESS	2025-11-20 03:09:45.20167	LINUX-SERVER-05	mfa	f	f	t
343	kwilliams	192.168.1.46	SUCCESS	2025-11-19 14:47:35.201713	MAC-DESKTOP-05	mfa	f	f	f
344	developer1	203.0.113.164	FAIL	2025-11-20 18:02:35.201771	LINUX-SERVER-08	password	t	t	f
345	developer1	203.0.113.164	FAIL	2025-11-20 17:53:35.201791	LINUX-SERVER-08	password	t	t	f
346	developer1	203.0.113.164	FAIL	2025-11-20 17:59:35.201807	LINUX-SERVER-08	password	t	t	f
347	developer1	203.0.113.164	FAIL	2025-11-20 17:55:35.201824	LINUX-SERVER-08	password	t	t	f
348	developer1	203.0.113.164	FAIL	2025-11-20 17:55:35.201846	LINUX-SERVER-08	password	t	t	f
349	monitoring	203.0.113.37	SUCCESS	2025-11-20 18:25:35.201133	LINUX-SERVER-07	password	f	t	f
350	developer1	203.0.113.83	SUCCESS	2025-11-20 10:28:35.201205	MAC-DESKTOP-09	mfa	f	t	f
351	backup_user	203.0.113.183	SUCCESS	2025-11-19 13:57:35.201232	WIN-LAPTOP-14	sso	f	t	f
352	kwilliams	203.0.113.175	SUCCESS	2025-11-20 07:13:35.201256	MAC-DESKTOP-03	certificate	f	t	f
353	developer2	203.0.113.159	FAIL	2025-11-20 05:33:35.201278	WIN-LAPTOP-15	mfa	f	t	f
354	service_account	203.0.113.39	SUCCESS	2025-11-19 19:02:35.201305	WIN-LAPTOP-27	sso	f	t	f
355	kwilliams	203.0.113.78	FAIL	2025-11-20 04:14:01.201328	LINUX-SERVER-06	sso	f	t	f
356	root	203.0.113.96	SUCCESS	2025-11-20 16:08:35.201353	LINUX-SERVER-02	mfa	f	t	t
357	service_account	203.0.113.220	SUCCESS	2025-11-19 13:30:35.201375	MAC-DESKTOP-06	mfa	f	t	f
358	admin	203.0.113.12	FAIL	2025-11-20 18:55:35.201395	LINUX-SERVER-06	password	t	t	t
359	admin	203.0.113.12	FAIL	2025-11-20 18:54:35.201411	LINUX-SERVER-06	password	t	t	t
360	admin	203.0.113.12	FAIL	2025-11-20 19:01:35.201427	LINUX-SERVER-06	password	t	t	t
361	admin	203.0.113.12	FAIL	2025-11-20 19:03:35.201443	LINUX-SERVER-06	password	t	t	t
362	admin	203.0.113.12	FAIL	2025-11-20 19:02:35.201458	LINUX-SERVER-06	password	t	t	t
363	mjohnson	192.168.1.25	SUCCESS	2025-11-20 15:33:22.326281	MAC-DESKTOP-14	password	f	f	f
364	developer1	192.168.1.80	SUCCESS	2025-11-20 04:47:22.333042	WIN-LAPTOP-16	certificate	f	f	f
365	developer2	203.0.113.92	SUCCESS	2025-11-19 21:52:22.333122	MAC-DESKTOP-08	password	f	t	f
366	service_account	203.0.113.16	FAIL	2025-11-19 21:24:22.333185	WIN-LAPTOP-15	mfa	f	t	f
367	jdoe	203.0.113.129	SUCCESS	2025-11-20 11:12:22.333231	MAC-DESKTOP-09	sso	f	t	f
368	developer2	192.168.1.24	SUCCESS	2025-11-20 14:55:22.333269	WIN-LAPTOP-28	password	f	f	f
369	root	203.0.113.227	FAIL	2025-11-20 19:08:22.333308	WIN-LAPTOP-25	password	t	t	t
370	root	203.0.113.227	FAIL	2025-11-20 19:11:22.333344	WIN-LAPTOP-25	password	t	t	t
371	root	203.0.113.227	FAIL	2025-11-20 19:04:22.333381	WIN-LAPTOP-25	password	t	t	t
372	root	203.0.113.227	FAIL	2025-11-20 19:11:22.333415	WIN-LAPTOP-25	password	t	t	t
373	root	203.0.113.227	FAIL	2025-11-20 19:08:22.333445	WIN-LAPTOP-25	password	t	t	t
374	scanner	203.0.113.53	FAIL	2025-11-20 02:47:22.32306	LINUX-SERVER-07	password	f	t	f
375	admin	192.168.1.76	FAIL	2025-11-20 14:52:22.323143	MAC-DESKTOP-10	mfa	f	f	t
376	service_account	192.168.1.68	SUCCESS	2025-11-19 21:08:22.323174	LINUX-SERVER-01	password	f	f	f
377	netadmin	203.0.113.194	FAIL	2025-11-20 14:51:22.323199	WIN-LAPTOP-22	password	f	t	t
378	mjohnson	192.168.1.109	SUCCESS	2025-11-19 19:07:22.323228	WIN-LAPTOP-07	certificate	f	f	f
379	scanner	203.0.113.45	SUCCESS	2025-11-20 01:01:22.323253	WIN-LAPTOP-19	mfa	f	t	f
380	dbrown	192.168.1.73	SUCCESS	2025-11-20 01:48:22.323283	LINUX-SERVER-07	certificate	f	f	f
381	sysadmin	203.0.113.248	SUCCESS	2025-11-20 19:36:22.323328	WIN-LAPTOP-08	password	f	t	t
382	service_account	203.0.113.23	FAIL	2025-11-20 19:37:22.323381	LINUX-SERVER-09	password	t	t	f
383	service_account	203.0.113.23	FAIL	2025-11-20 19:41:22.323403	LINUX-SERVER-09	password	t	t	f
384	service_account	203.0.113.23	FAIL	2025-11-20 19:38:22.323419	LINUX-SERVER-09	password	t	t	f
385	service_account	203.0.113.23	FAIL	2025-11-20 19:35:22.323434	LINUX-SERVER-09	password	t	t	f
386	service_account	203.0.113.23	FAIL	2025-11-20 19:36:22.32345	LINUX-SERVER-09	password	t	t	f
387	sysadmin	192.168.1.43	SUCCESS	2025-11-19 17:10:22.32309	MAC-DESKTOP-12	mfa	f	f	t
388	jdoe	192.168.1.52	FAIL	2025-11-19 18:37:22.323198	WIN-LAPTOP-07	sso	f	f	f
389	jdoe	203.0.113.193	SUCCESS	2025-11-20 06:52:22.323249	WIN-LAPTOP-25	password	f	t	f
390	root	192.168.1.251	SUCCESS	2025-11-20 06:43:22.323294	MAC-DESKTOP-14	certificate	f	f	t
391	service_account	203.0.113.208	SUCCESS	2025-11-19 17:04:22.323335	LINUX-SERVER-07	password	f	t	f
392	service_account	203.0.113.98	SUCCESS	2025-11-20 04:25:19.323378	MAC-DESKTOP-05	password	f	t	f
393	service_account	192.168.1.242	SUCCESS	2025-11-20 00:14:40.323419	WIN-LAPTOP-26	mfa	f	f	f
394	mjohnson	203.0.113.46	FAIL	2025-11-20 21:04:22.323456	WIN-LAPTOP-01	password	t	t	f
395	mjohnson	203.0.113.46	FAIL	2025-11-20 21:03:22.323486	WIN-LAPTOP-01	password	t	t	f
396	mjohnson	203.0.113.46	FAIL	2025-11-20 21:10:22.323512	WIN-LAPTOP-01	password	t	t	f
397	mjohnson	203.0.113.46	FAIL	2025-11-20 21:06:22.323539	WIN-LAPTOP-01	password	t	t	f
398	mjohnson	203.0.113.46	FAIL	2025-11-20 21:11:22.323567	WIN-LAPTOP-01	password	t	t	f
399	sysadmin	203.0.113.51	FAIL	2025-11-20 11:34:22.322774	MAC-DESKTOP-13	password	f	t	t
400	kwilliams	192.168.1.206	SUCCESS	2025-11-20 06:11:22.322854	MAC-DESKTOP-13	certificate	f	f	f
401	sysadmin	203.0.113.165	FAIL	2025-11-20 12:13:22.322884	MAC-DESKTOP-07	password	f	t	t
402	asmith	192.168.1.112	SUCCESS	2025-11-20 08:31:22.322911	LINUX-SERVER-07	mfa	f	f	f
403	mjohnson	192.168.1.131	SUCCESS	2025-11-20 17:02:22.322938	MAC-DESKTOP-03	password	f	f	f
404	developer2	192.168.1.58	SUCCESS	2025-11-20 08:59:22.322963	LINUX-SERVER-02	certificate	f	f	f
405	dbrown	192.168.1.122	SUCCESS	2025-11-20 16:23:22.322987	WIN-LAPTOP-14	password	f	f	f
406	asmith	203.0.113.162	FAIL	2025-11-20 22:07:22.32301	WIN-LAPTOP-01	password	t	t	f
407	asmith	203.0.113.162	FAIL	2025-11-20 22:12:22.323028	WIN-LAPTOP-01	password	t	t	f
408	asmith	203.0.113.162	FAIL	2025-11-20 22:12:22.323045	WIN-LAPTOP-01	password	t	t	f
409	asmith	203.0.113.162	FAIL	2025-11-20 22:11:22.323062	WIN-LAPTOP-01	password	t	t	f
410	asmith	203.0.113.162	FAIL	2025-11-20 22:12:22.323079	WIN-LAPTOP-01	password	t	t	f
411	root	192.168.1.134	SUCCESS	2025-11-20 05:09:21.322859	MAC-DESKTOP-10	certificate	f	f	t
412	service_account	192.168.1.122	SUCCESS	2025-11-20 09:06:22.322964	WIN-LAPTOP-27	password	f	f	f
413	asmith	192.168.1.60	SUCCESS	2025-11-20 14:48:22.323011	WIN-LAPTOP-10	sso	f	f	f
414	root	203.0.113.209	SUCCESS	2025-11-20 11:13:22.323048	WIN-LAPTOP-14	password	f	t	t
415	backup_user	192.168.1.46	SUCCESS	2025-11-19 21:32:22.323084	WIN-LAPTOP-28	certificate	f	f	f
416	developer2	203.0.113.189	FAIL	2025-11-20 23:05:22.323121	LINUX-SERVER-08	password	t	t	f
417	developer2	203.0.113.189	FAIL	2025-11-20 23:05:22.323151	LINUX-SERVER-08	password	t	t	f
418	developer2	203.0.113.189	FAIL	2025-11-20 23:07:22.323177	LINUX-SERVER-08	password	t	t	f
419	developer2	203.0.113.189	FAIL	2025-11-20 23:06:22.323203	LINUX-SERVER-08	password	t	t	f
420	developer2	203.0.113.189	FAIL	2025-11-20 23:11:22.323229	LINUX-SERVER-08	password	t	t	f
421	developer1	203.0.113.147	SUCCESS	2025-11-20 15:12:22.322747	MAC-DESKTOP-02	certificate	f	t	f
422	scanner	203.0.113.220	SUCCESS	2025-11-20 08:46:22.322819	MAC-DESKTOP-09	certificate	f	t	f
423	scanner	192.168.1.206	SUCCESS	2025-11-20 01:16:22.322846	WIN-LAPTOP-24	certificate	f	f	f
424	asmith	192.168.1.130	FAIL	2025-11-20 20:35:22.322872	LINUX-SERVER-02	mfa	f	f	f
425	root	203.0.113.213	SUCCESS	2025-11-20 17:44:22.3229	WIN-LAPTOP-15	mfa	f	t	t
426	service_account	203.0.113.232	SUCCESS	2025-11-20 14:52:22.322922	WIN-LAPTOP-11	password	f	t	f
427	backup_user	203.0.113.179	SUCCESS	2025-11-20 16:15:22.322945	WIN-LAPTOP-02	sso	f	t	f
428	root	203.0.113.220	SUCCESS	2025-11-20 21:33:22.322966	MAC-DESKTOP-12	mfa	f	t	t
429	admin	192.168.1.55	SUCCESS	2025-11-21 01:52:43.32299	WIN-LAPTOP-03	sso	f	f	t
430	rlee	192.168.1.32	SUCCESS	2025-11-20 12:48:22.323014	LINUX-SERVER-07	mfa	f	f	f
431	backup_user	192.168.1.62	FAIL	2025-11-20 23:36:22.323037	WIN-LAPTOP-29	mfa	f	f	f
432	dbrown	192.168.1.86	SUCCESS	2025-11-20 18:47:22.323063	WIN-LAPTOP-17	password	f	f	f
433	monitoring	203.0.113.45	FAIL	2025-11-21 00:07:22.323083	MAC-DESKTOP-03	password	t	t	f
434	monitoring	203.0.113.45	FAIL	2025-11-21 00:13:22.323101	MAC-DESKTOP-03	password	t	t	f
435	monitoring	203.0.113.45	FAIL	2025-11-21 00:12:22.323117	MAC-DESKTOP-03	password	t	t	f
436	monitoring	203.0.113.45	FAIL	2025-11-21 00:08:22.323133	MAC-DESKTOP-03	password	t	t	f
437	monitoring	203.0.113.45	FAIL	2025-11-21 00:07:22.323149	MAC-DESKTOP-03	password	t	t	f
438	service_account	192.168.1.222	FAIL	2025-11-20 17:37:22.322841	WIN-LAPTOP-18	sso	f	f	f
439	mjohnson	203.0.113.119	SUCCESS	2025-11-21 05:16:18.32292	WIN-LAPTOP-29	sso	f	t	f
440	netadmin	192.168.1.237	SUCCESS	2025-11-21 05:57:49.32295	WIN-LAPTOP-14	password	f	f	t
441	jdoe	203.0.113.11	SUCCESS	2025-11-20 03:13:22.322975	WIN-LAPTOP-02	password	f	t	f
442	service_account	192.168.1.231	SUCCESS	2025-11-21 02:13:08.322999	WIN-LAPTOP-10	certificate	f	f	f
443	asmith	192.168.1.196	SUCCESS	2025-11-20 03:43:22.323024	WIN-LAPTOP-13	password	f	f	f
444	monitoring	203.0.113.218	SUCCESS	2025-11-20 23:12:22.323048	WIN-LAPTOP-24	mfa	f	t	f
445	asmith	192.168.1.191	SUCCESS	2025-11-20 00:37:22.32307	WIN-LAPTOP-22	mfa	f	f	f
446	sysadmin	203.0.113.233	SUCCESS	2025-11-21 01:18:40.323094	WIN-LAPTOP-08	password	f	t	t
447	kwilliams	203.0.113.227	SUCCESS	2025-11-19 23:55:22.323116	WIN-LAPTOP-05	certificate	f	t	f
448	asmith	192.168.1.143	SUCCESS	2025-11-20 07:22:22.323138	MAC-DESKTOP-09	certificate	f	f	f
449	dbrown	203.0.113.91	SUCCESS	2025-11-21 02:11:58.323162	MAC-DESKTOP-14	sso	f	t	f
450	asmith	203.0.113.167	SUCCESS	2025-11-21 03:29:47.323184	WIN-LAPTOP-16	mfa	f	t	f
451	rlee	203.0.113.211	SUCCESS	2025-11-19 20:31:22.323204	WIN-LAPTOP-10	mfa	f	t	f
452	admin	203.0.113.79	FAIL	2025-11-21 01:04:22.323224	MAC-DESKTOP-14	password	t	t	t
453	admin	203.0.113.79	FAIL	2025-11-21 01:03:22.32324	MAC-DESKTOP-14	password	t	t	t
454	admin	203.0.113.79	FAIL	2025-11-21 01:04:22.323256	MAC-DESKTOP-14	password	t	t	t
455	admin	203.0.113.79	FAIL	2025-11-21 01:11:22.323272	MAC-DESKTOP-14	password	t	t	t
456	admin	203.0.113.79	FAIL	2025-11-21 01:06:22.323289	MAC-DESKTOP-14	password	t	t	t
457	scanner	203.0.113.180	SUCCESS	2025-11-20 12:57:22.322774	MAC-DESKTOP-09	sso	f	t	f
458	jdoe	203.0.113.115	SUCCESS	2025-11-19 21:44:22.322851	WIN-LAPTOP-06	certificate	f	t	f
459	jdoe	203.0.113.238	SUCCESS	2025-11-21 02:09:22.322877	MAC-DESKTOP-06	mfa	f	t	f
460	netadmin	203.0.113.220	SUCCESS	2025-11-20 16:35:22.322903	WIN-LAPTOP-01	password	f	t	t
461	admin	203.0.113.173	SUCCESS	2025-11-20 21:28:22.322926	WIN-LAPTOP-02	sso	f	t	t
462	service_account	192.168.1.118	SUCCESS	2025-11-20 13:52:22.322952	LINUX-SERVER-08	password	f	f	f
463	developer1	203.0.113.170	SUCCESS	2025-11-20 09:23:22.323	WIN-LAPTOP-06	password	f	t	f
464	monitoring	203.0.113.83	FAIL	2025-11-19 21:25:22.323026	WIN-LAPTOP-25	password	f	t	f
465	netadmin	192.168.1.16	SUCCESS	2025-11-20 22:28:22.323053	LINUX-SERVER-06	certificate	f	f	t
466	admin	203.0.113.74	SUCCESS	2025-11-21 01:59:02.32308	WIN-LAPTOP-07	password	f	t	t
467	root	192.168.1.6	SUCCESS	2025-11-20 05:13:22.323102	WIN-LAPTOP-29	sso	f	f	t
468	developer2	192.168.1.234	SUCCESS	2025-11-20 09:10:22.323125	MAC-DESKTOP-10	mfa	f	f	f
469	dbrown	192.168.1.87	SUCCESS	2025-11-19 21:09:22.323148	WIN-LAPTOP-23	mfa	f	f	f
470	root	203.0.113.189	FAIL	2025-11-21 02:10:22.323169	LINUX-SERVER-01	password	t	t	t
471	root	203.0.113.189	FAIL	2025-11-21 02:09:22.323186	LINUX-SERVER-01	password	t	t	t
472	root	203.0.113.189	FAIL	2025-11-21 02:07:22.323202	LINUX-SERVER-01	password	t	t	t
473	root	203.0.113.189	FAIL	2025-11-21 02:05:22.323219	LINUX-SERVER-01	password	t	t	t
474	root	203.0.113.189	FAIL	2025-11-21 02:12:22.323235	LINUX-SERVER-01	password	t	t	t
475	developer1	203.0.113.96	SUCCESS	2025-11-21 01:18:33.322747	WIN-LAPTOP-01	mfa	f	t	f
476	netadmin	192.168.1.195	SUCCESS	2025-11-21 05:04:38.322819	WIN-LAPTOP-11	sso	f	f	t
477	monitoring	192.168.1.221	FAIL	2025-11-20 11:22:22.322847	MAC-DESKTOP-14	mfa	f	f	f
478	backup_user	192.168.1.180	SUCCESS	2025-11-19 23:27:22.322878	MAC-DESKTOP-07	mfa	f	f	f
479	kwilliams	192.168.1.38	SUCCESS	2025-11-20 11:29:22.322903	WIN-LAPTOP-05	sso	f	f	f
480	rlee	192.168.1.40	SUCCESS	2025-11-20 00:07:22.322928	WIN-LAPTOP-22	sso	f	f	f
481	sysadmin	203.0.113.199	SUCCESS	2025-11-20 23:54:22.322952	WIN-LAPTOP-20	certificate	f	t	t
482	root	203.0.113.197	SUCCESS	2025-11-20 13:55:22.322987	WIN-LAPTOP-03	certificate	f	t	t
483	kwilliams	192.168.1.78	SUCCESS	2025-11-19 21:15:22.323019	WIN-LAPTOP-03	sso	f	f	f
484	scanner	203.0.113.28	SUCCESS	2025-11-20 10:25:22.323044	WIN-LAPTOP-25	sso	f	t	f
485	rlee	203.0.113.188	FAIL	2025-11-21 03:03:22.323065	WIN-LAPTOP-29	password	t	t	f
486	rlee	203.0.113.188	FAIL	2025-11-21 03:09:22.323083	WIN-LAPTOP-29	password	t	t	f
487	rlee	203.0.113.188	FAIL	2025-11-21 03:06:22.323101	WIN-LAPTOP-29	password	t	t	f
488	rlee	203.0.113.188	FAIL	2025-11-21 03:03:22.323118	WIN-LAPTOP-29	password	t	t	f
489	rlee	203.0.113.188	FAIL	2025-11-21 03:05:22.323134	WIN-LAPTOP-29	password	t	t	f
490	mjohnson	192.168.1.70	SUCCESS	2025-11-20 17:01:22.322831	WIN-LAPTOP-06	sso	f	f	f
491	asmith	192.168.1.124	SUCCESS	2025-11-20 08:18:22.32293	MAC-DESKTOP-14	password	f	f	f
492	mjohnson	203.0.113.199	SUCCESS	2025-11-21 03:10:09.322969	WIN-LAPTOP-16	certificate	f	t	f
493	jdoe	192.168.1.19	SUCCESS	2025-11-21 03:31:22.322995	WIN-LAPTOP-24	sso	f	f	f
494	kwilliams	192.168.1.129	FAIL	2025-11-20 11:50:22.32302	MAC-DESKTOP-12	certificate	f	f	f
495	developer1	192.168.1.9	SUCCESS	2025-11-20 22:36:22.323049	WIN-LAPTOP-29	password	f	f	f
496	netadmin	192.168.1.55	SUCCESS	2025-11-20 12:34:22.323071	WIN-LAPTOP-16	mfa	f	f	t
497	netadmin	192.168.1.83	SUCCESS	2025-11-20 16:45:22.323094	WIN-LAPTOP-17	mfa	f	f	t
498	service_account	192.168.1.236	SUCCESS	2025-11-20 21:48:22.323117	MAC-DESKTOP-02	certificate	f	f	f
499	root	192.168.1.203	SUCCESS	2025-11-20 02:37:22.323141	MAC-DESKTOP-02	password	f	f	t
500	dbrown	192.168.1.196	SUCCESS	2025-11-20 00:35:22.323164	MAC-DESKTOP-12	mfa	f	f	f
501	backup_user	192.168.1.63	SUCCESS	2025-11-20 08:13:22.323187	LINUX-SERVER-07	sso	f	f	f
502	scanner	203.0.113.220	SUCCESS	2025-11-20 23:32:22.32321	WIN-LAPTOP-07	sso	f	t	f
503	developer1	192.168.1.157	SUCCESS	2025-11-21 05:20:10.323234	MAC-DESKTOP-01	password	f	f	f
504	rlee	192.168.1.13	SUCCESS	2025-11-20 17:01:22.323261	WIN-LAPTOP-19	password	f	f	f
505	dbrown	203.0.113.151	FAIL	2025-11-21 04:10:22.323284	WIN-LAPTOP-16	password	t	t	f
506	dbrown	203.0.113.151	FAIL	2025-11-21 04:13:22.323302	WIN-LAPTOP-16	password	t	t	f
507	dbrown	203.0.113.151	FAIL	2025-11-21 04:11:22.323319	WIN-LAPTOP-16	password	t	t	f
508	dbrown	203.0.113.151	FAIL	2025-11-21 04:07:22.323336	WIN-LAPTOP-16	password	t	t	f
509	dbrown	203.0.113.151	FAIL	2025-11-21 04:06:22.323353	WIN-LAPTOP-16	password	t	t	f
510	backup_user	192.168.1.186	SUCCESS	2025-11-20 00:41:22.322758	MAC-DESKTOP-01	sso	f	f	f
511	scanner	203.0.113.105	SUCCESS	2025-11-21 02:24:56.322832	WIN-LAPTOP-18	certificate	f	t	f
512	admin	203.0.113.39	SUCCESS	2025-11-20 18:24:22.322859	LINUX-SERVER-06	sso	f	t	t
513	admin	192.168.1.83	SUCCESS	2025-11-20 04:26:22.322882	MAC-DESKTOP-02	sso	f	f	t
514	mjohnson	203.0.113.244	SUCCESS	2025-11-20 22:26:22.322906	MAC-DESKTOP-09	sso	f	t	f
515	root	192.168.1.167	SUCCESS	2025-11-20 09:54:22.322929	WIN-LAPTOP-03	certificate	f	f	t
516	netadmin	203.0.113.226	SUCCESS	2025-11-20 01:54:22.322952	LINUX-SERVER-02	mfa	f	t	t
517	service_account	203.0.113.71	SUCCESS	2025-11-21 01:06:26.322976	WIN-LAPTOP-17	sso	f	t	f
518	sysadmin	203.0.113.134	SUCCESS	2025-11-20 22:46:22.322997	WIN-LAPTOP-03	mfa	f	t	t
519	root	203.0.113.90	SUCCESS	2025-11-21 03:47:29.323019	WIN-LAPTOP-07	certificate	f	t	t
520	admin	203.0.113.148	SUCCESS	2025-11-20 20:58:22.323041	WIN-LAPTOP-29	sso	f	t	t
521	monitoring	203.0.113.111	SUCCESS	2025-11-20 15:18:22.323063	MAC-DESKTOP-01	certificate	f	t	f
522	developer2	192.168.1.56	SUCCESS	2025-11-21 02:37:22.323083	WIN-LAPTOP-24	certificate	f	f	f
523	mjohnson	203.0.113.47	FAIL	2025-11-21 05:36:22.323105	LINUX-SERVER-01	password	t	t	f
524	mjohnson	203.0.113.47	FAIL	2025-11-21 05:38:22.323122	LINUX-SERVER-01	password	t	t	f
525	mjohnson	203.0.113.47	FAIL	2025-11-21 05:35:22.323139	LINUX-SERVER-01	password	t	t	f
526	mjohnson	203.0.113.47	FAIL	2025-11-21 05:42:22.323154	LINUX-SERVER-01	password	t	t	f
527	mjohnson	203.0.113.47	FAIL	2025-11-21 05:34:22.323171	LINUX-SERVER-01	password	t	t	f
528	netadmin	192.168.1.110	SUCCESS	2025-11-20 03:04:22.322951	LINUX-SERVER-06	certificate	f	f	t
529	root	192.168.1.101	SUCCESS	2025-11-21 01:53:40.323057	WIN-LAPTOP-06	sso	f	f	t
530	mjohnson	203.0.113.7	FAIL	2025-11-20 11:27:22.323102	LINUX-SERVER-06	mfa	f	t	f
531	asmith	192.168.1.154	SUCCESS	2025-11-21 02:43:57.323147	WIN-LAPTOP-16	sso	f	f	f
532	root	192.168.1.206	SUCCESS	2025-11-20 01:30:22.323187	WIN-LAPTOP-08	password	f	f	t
533	developer2	203.0.113.252	SUCCESS	2025-11-20 13:24:22.323225	WIN-LAPTOP-27	sso	f	t	f
534	kwilliams	203.0.113.92	SUCCESS	2025-11-20 10:27:22.323262	WIN-LAPTOP-01	certificate	f	t	f
535	netadmin	192.168.1.93	SUCCESS	2025-11-20 15:39:22.323298	WIN-LAPTOP-18	certificate	f	f	t
536	monitoring	203.0.113.165	SUCCESS	2025-11-20 04:52:22.323336	LINUX-SERVER-06	sso	f	t	f
537	developer1	192.168.1.221	FAIL	2025-11-20 11:09:22.323375	WIN-LAPTOP-11	certificate	f	f	f
538	backup_user	203.0.113.12	SUCCESS	2025-11-20 23:46:22.323418	MAC-DESKTOP-03	password	f	t	f
539	netadmin	203.0.113.236	SUCCESS	2025-11-20 10:09:22.323464	MAC-DESKTOP-13	password	f	t	t
540	jdoe	203.0.113.197	FAIL	2025-11-21 06:35:22.3235	LINUX-SERVER-07	password	t	t	f
541	jdoe	203.0.113.197	FAIL	2025-11-21 06:38:22.323519	LINUX-SERVER-07	password	t	t	f
542	jdoe	203.0.113.197	FAIL	2025-11-21 06:40:22.323535	LINUX-SERVER-07	password	t	t	f
543	jdoe	203.0.113.197	FAIL	2025-11-21 06:40:22.323551	LINUX-SERVER-07	password	t	t	f
544	jdoe	203.0.113.197	FAIL	2025-11-21 06:38:22.323568	LINUX-SERVER-07	password	t	t	f
556	dbrown	192.168.1.2	SUCCESS	2025-11-20 17:33:22.322775	LINUX-SERVER-01	sso	f	f	f
557	developer1	203.0.113.150	SUCCESS	2025-11-21 08:15:22.322866	LINUX-SERVER-05	password	f	t	f
558	scanner	192.168.1.141	SUCCESS	2025-11-21 03:45:22.322905	WIN-LAPTOP-25	sso	f	f	f
559	netadmin	192.168.1.177	FAIL	2025-11-20 05:50:22.322932	WIN-LAPTOP-22	certificate	f	f	t
560	sysadmin	192.168.1.142	SUCCESS	2025-11-20 09:58:22.322961	WIN-LAPTOP-05	certificate	f	f	t
561	dbrown	192.168.1.193	SUCCESS	2025-11-21 06:48:22.322987	WIN-LAPTOP-10	certificate	f	f	f
562	admin	203.0.113.11	SUCCESS	2025-11-20 18:52:22.323021	LINUX-SERVER-01	password	f	t	t
563	netadmin	192.168.1.21	SUCCESS	2025-11-20 19:26:22.323049	WIN-LAPTOP-29	mfa	f	f	t
564	asmith	203.0.113.191	FAIL	2025-11-21 03:32:35.323077	MAC-DESKTOP-12	password	f	t	f
565	jdoe	203.0.113.199	FAIL	2025-11-21 08:37:22.323105	WIN-LAPTOP-07	password	t	t	f
566	jdoe	203.0.113.199	FAIL	2025-11-21 08:38:22.323123	WIN-LAPTOP-07	password	t	t	f
567	jdoe	203.0.113.199	FAIL	2025-11-21 08:40:22.32314	WIN-LAPTOP-07	password	t	t	f
568	jdoe	203.0.113.199	FAIL	2025-11-21 08:33:22.323156	WIN-LAPTOP-07	password	t	t	f
569	jdoe	203.0.113.199	FAIL	2025-11-21 08:36:22.323173	WIN-LAPTOP-07	password	t	t	f
570	rlee	203.0.113.230	SUCCESS	2025-11-20 03:45:22.322911	WIN-LAPTOP-05	certificate	f	t	f
571	scanner	203.0.113.233	SUCCESS	2025-11-20 09:10:22.322985	MAC-DESKTOP-10	password	f	t	f
572	mjohnson	192.168.1.250	FAIL	2025-11-20 20:10:22.323012	WIN-LAPTOP-12	password	f	f	f
573	kwilliams	203.0.113.225	SUCCESS	2025-11-20 09:56:22.323042	WIN-LAPTOP-05	certificate	f	t	f
574	developer2	203.0.113.40	SUCCESS	2025-11-20 16:35:22.323066	WIN-LAPTOP-01	password	f	t	f
575	admin	192.168.1.246	SUCCESS	2025-11-20 17:22:22.323087	WIN-LAPTOP-02	password	f	f	t
576	developer2	203.0.113.207	SUCCESS	2025-11-20 07:33:22.323111	WIN-LAPTOP-29	certificate	f	t	f
577	jdoe	192.168.1.197	SUCCESS	2025-11-20 08:10:22.323134	WIN-LAPTOP-17	mfa	f	f	f
578	asmith	192.168.1.176	SUCCESS	2025-11-20 04:16:22.323157	WIN-LAPTOP-26	password	f	f	f
579	dbrown	192.168.1.248	SUCCESS	2025-11-20 23:24:22.323181	WIN-LAPTOP-15	mfa	f	f	f
580	monitoring	203.0.113.4	SUCCESS	2025-11-20 18:53:22.323215	WIN-LAPTOP-09	password	f	t	f
581	root	192.168.1.251	SUCCESS	2025-11-20 19:14:22.323236	LINUX-SERVER-05	certificate	f	f	t
582	mjohnson	203.0.113.68	SUCCESS	2025-11-20 14:05:22.323259	MAC-DESKTOP-05	certificate	f	t	f
583	rlee	203.0.113.158	FAIL	2025-11-21 09:43:22.323278	MAC-DESKTOP-06	password	t	t	f
584	rlee	203.0.113.158	FAIL	2025-11-21 09:37:22.323296	MAC-DESKTOP-06	password	t	t	f
585	rlee	203.0.113.158	FAIL	2025-11-21 09:33:22.323312	MAC-DESKTOP-06	password	t	t	f
586	rlee	203.0.113.158	FAIL	2025-11-21 09:40:22.323328	MAC-DESKTOP-06	password	t	t	f
587	rlee	203.0.113.158	FAIL	2025-11-21 09:35:22.323345	MAC-DESKTOP-06	password	t	t	f
588	backup_user	203.0.113.105	SUCCESS	2025-11-20 07:42:22.322889	WIN-LAPTOP-26	sso	f	t	f
589	scanner	203.0.113.235	SUCCESS	2025-11-20 16:58:22.322979	WIN-LAPTOP-19	mfa	f	t	f
590	admin	192.168.1.138	FAIL	2025-11-21 02:05:27.323014	MAC-DESKTOP-09	certificate	f	f	t
591	root	203.0.113.164	FAIL	2025-11-20 16:06:22.323046	LINUX-SERVER-08	mfa	f	t	t
592	rlee	192.168.1.74	SUCCESS	2025-11-21 05:14:22.323073	MAC-DESKTOP-04	certificate	f	f	f
593	mjohnson	203.0.113.44	SUCCESS	2025-11-21 03:34:05.323101	MAC-DESKTOP-09	mfa	f	t	f
594	admin	192.168.1.166	SUCCESS	2025-11-21 08:46:22.323124	WIN-LAPTOP-03	sso	f	f	t
595	kwilliams	203.0.113.119	SUCCESS	2025-11-20 13:31:22.323148	WIN-LAPTOP-04	password	f	t	f
596	jdoe	192.168.1.212	SUCCESS	2025-11-21 05:07:22.323169	WIN-LAPTOP-13	mfa	f	f	f
597	developer1	203.0.113.223	FAIL	2025-11-21 11:05:22.323192	LINUX-SERVER-02	password	t	t	f
598	developer1	203.0.113.223	FAIL	2025-11-21 11:05:22.32321	LINUX-SERVER-02	password	t	t	f
599	developer1	203.0.113.223	FAIL	2025-11-21 11:08:22.323235	LINUX-SERVER-02	password	t	t	f
600	developer1	203.0.113.223	FAIL	2025-11-21 11:09:22.32327	LINUX-SERVER-02	password	t	t	f
601	developer1	203.0.113.223	FAIL	2025-11-21 11:04:22.323295	LINUX-SERVER-02	password	t	t	f
545	scanner	192.168.1.240	SUCCESS	2025-11-21 03:24:59.322706	WIN-LAPTOP-25	mfa	f	f	f
546	dbrown	203.0.113.104	SUCCESS	2025-11-20 11:23:22.322794	LINUX-SERVER-05	certificate	f	t	f
547	sysadmin	192.168.1.66	SUCCESS	2025-11-20 16:09:22.322821	MAC-DESKTOP-09	certificate	f	f	t
548	service_account	192.168.1.222	SUCCESS	2025-11-20 18:19:22.322846	MAC-DESKTOP-02	mfa	f	f	f
549	root	203.0.113.17	SUCCESS	2025-11-21 03:54:22.322872	WIN-LAPTOP-06	sso	f	t	t
550	admin	192.168.1.214	SUCCESS	2025-11-20 19:48:22.322893	WIN-LAPTOP-03	certificate	f	f	t
551	service_account	203.0.113.85	FAIL	2025-11-21 07:40:22.322915	WIN-LAPTOP-04	password	t	t	f
552	service_account	203.0.113.85	FAIL	2025-11-21 07:42:22.322932	WIN-LAPTOP-04	password	t	t	f
553	service_account	203.0.113.85	FAIL	2025-11-21 07:42:22.322949	WIN-LAPTOP-04	password	t	t	f
554	service_account	203.0.113.85	FAIL	2025-11-21 07:40:22.322965	WIN-LAPTOP-04	password	t	t	f
555	service_account	203.0.113.85	FAIL	2025-11-21 07:42:22.322981	WIN-LAPTOP-04	password	t	t	f
602	netadmin	192.168.1.93	SUCCESS	2025-11-21 02:03:22.322923	WIN-LAPTOP-02	password	f	f	t
603	developer2	203.0.113.19	SUCCESS	2025-11-20 22:29:22.323022	LINUX-SERVER-07	password	f	t	f
604	rlee	192.168.1.168	SUCCESS	2025-11-21 10:04:22.32306	MAC-DESKTOP-11	sso	f	f	f
605	jdoe	203.0.113.16	SUCCESS	2025-11-20 22:53:22.323099	WIN-LAPTOP-07	sso	f	t	f
606	sysadmin	203.0.113.226	SUCCESS	2025-11-20 07:02:22.323132	MAC-DESKTOP-11	password	f	t	t
607	mjohnson	203.0.113.207	SUCCESS	2025-11-20 22:53:22.323168	WIN-LAPTOP-24	password	f	t	f
608	netadmin	203.0.113.218	SUCCESS	2025-11-21 02:18:22.323202	MAC-DESKTOP-06	mfa	f	t	t
609	dbrown	192.168.1.49	SUCCESS	2025-11-20 09:46:22.323237	WIN-LAPTOP-04	password	f	f	f
610	netadmin	203.0.113.175	FAIL	2025-11-21 12:10:22.32327	LINUX-SERVER-04	password	t	t	t
611	netadmin	203.0.113.175	FAIL	2025-11-21 12:13:22.323297	LINUX-SERVER-04	password	t	t	t
612	netadmin	203.0.113.175	FAIL	2025-11-21 12:05:22.323322	LINUX-SERVER-04	password	t	t	t
613	netadmin	203.0.113.175	FAIL	2025-11-21 12:11:22.323347	LINUX-SERVER-04	password	t	t	t
614	netadmin	203.0.113.175	FAIL	2025-11-21 12:08:22.323372	LINUX-SERVER-04	password	t	t	t
615	mjohnson	192.168.1.254	FAIL	2025-11-21 06:46:22.322882	WIN-LAPTOP-23	password	f	f	f
616	asmith	192.168.1.97	FAIL	2025-11-20 13:48:22.322958	MAC-DESKTOP-01	sso	f	f	f
617	service_account	203.0.113.33	SUCCESS	2025-11-21 12:19:22.322989	WIN-LAPTOP-05	mfa	f	t	f
618	asmith	192.168.1.164	SUCCESS	2025-11-20 18:32:22.323012	WIN-LAPTOP-20	mfa	f	f	f
619	service_account	203.0.113.24	SUCCESS	2025-11-21 10:45:22.323036	WIN-LAPTOP-15	certificate	f	t	f
620	service_account	192.168.1.151	SUCCESS	2025-11-21 08:28:22.323057	MAC-DESKTOP-01	mfa	f	f	f
621	mjohnson	192.168.1.160	SUCCESS	2025-11-20 13:57:22.323079	WIN-LAPTOP-11	mfa	f	f	f
622	service_account	203.0.113.52	SUCCESS	2025-11-20 23:57:22.323102	MAC-DESKTOP-11	password	f	t	f
623	developer1	192.168.1.146	SUCCESS	2025-11-20 18:07:22.323123	MAC-DESKTOP-06	mfa	f	f	f
624	rlee	203.0.113.248	FAIL	2025-11-21 07:32:22.323147	MAC-DESKTOP-08	mfa	f	t	f
625	rlee	203.0.113.199	FAIL	2025-11-21 13:13:22.32317	WIN-LAPTOP-01	password	t	t	f
626	rlee	203.0.113.199	FAIL	2025-11-21 13:06:22.323188	WIN-LAPTOP-01	password	t	t	f
627	rlee	203.0.113.199	FAIL	2025-11-21 13:09:22.323204	WIN-LAPTOP-01	password	t	t	f
628	rlee	203.0.113.199	FAIL	2025-11-21 13:04:22.32322	WIN-LAPTOP-01	password	t	t	f
629	rlee	203.0.113.199	FAIL	2025-11-21 13:08:22.323236	WIN-LAPTOP-01	password	t	t	f
630	dbrown	203.0.113.28	SUCCESS	2025-11-21 08:55:22.322962	MAC-DESKTOP-02	certificate	f	t	f
631	service_account	203.0.113.121	SUCCESS	2025-11-20 15:20:22.323053	MAC-DESKTOP-06	password	f	t	f
632	sysadmin	192.168.1.111	SUCCESS	2025-11-20 08:48:22.323092	WIN-LAPTOP-29	password	f	f	t
633	sysadmin	203.0.113.149	SUCCESS	2025-11-21 05:45:22.323131	WIN-LAPTOP-14	sso	f	t	t
634	sysadmin	203.0.113.20	SUCCESS	2025-11-21 05:06:05.323167	MAC-DESKTOP-03	password	f	t	t
635	dbrown	203.0.113.21	SUCCESS	2025-11-21 12:03:22.3232	WIN-LAPTOP-18	password	f	t	f
636	developer1	192.168.1.2	FAIL	2025-11-21 00:44:58.323234	MAC-DESKTOP-09	password	f	f	f
637	netadmin	192.168.1.60	SUCCESS	2025-11-21 03:22:24.323274	WIN-LAPTOP-18	mfa	f	f	t
638	kwilliams	203.0.113.188	FAIL	2025-11-21 14:13:22.323308	WIN-LAPTOP-06	password	t	t	f
639	kwilliams	203.0.113.188	FAIL	2025-11-21 14:05:22.323336	WIN-LAPTOP-06	password	t	t	f
640	kwilliams	203.0.113.188	FAIL	2025-11-21 14:03:22.323364	WIN-LAPTOP-06	password	t	t	f
641	kwilliams	203.0.113.188	FAIL	2025-11-21 14:03:22.323388	WIN-LAPTOP-06	password	t	t	f
642	kwilliams	203.0.113.188	FAIL	2025-11-21 14:03:22.323415	WIN-LAPTOP-06	password	t	t	f
643	developer2	203.0.113.211	SUCCESS	2025-11-21 06:39:22.32285	LINUX-SERVER-08	mfa	f	t	f
644	backup_user	203.0.113.184	SUCCESS	2025-11-21 07:57:22.322926	WIN-LAPTOP-17	certificate	f	t	f
645	developer2	203.0.113.209	SUCCESS	2025-11-21 13:00:22.322953	LINUX-SERVER-01	sso	f	t	f
646	kwilliams	192.168.1.73	SUCCESS	2025-11-21 06:35:22.322976	MAC-DESKTOP-10	sso	f	f	f
647	jdoe	192.168.1.81	SUCCESS	2025-11-21 14:55:22.323001	WIN-LAPTOP-05	sso	f	f	f
648	developer2	203.0.113.142	SUCCESS	2025-11-21 08:17:22.323026	WIN-LAPTOP-26	sso	f	t	f
649	developer2	203.0.113.116	FAIL	2025-11-21 15:04:22.323061	WIN-LAPTOP-21	password	t	t	f
650	developer2	203.0.113.116	FAIL	2025-11-21 15:09:22.323096	WIN-LAPTOP-21	password	t	t	f
651	developer2	203.0.113.116	FAIL	2025-11-21 15:12:22.323116	WIN-LAPTOP-21	password	t	t	f
652	developer2	203.0.113.116	FAIL	2025-11-21 15:10:22.323132	WIN-LAPTOP-21	password	t	t	f
653	developer2	203.0.113.116	FAIL	2025-11-21 15:10:22.323148	WIN-LAPTOP-21	password	t	t	f
654	developer1	192.168.1.45	SUCCESS	2025-11-20 16:37:22.32284	WIN-LAPTOP-24	password	f	f	f
655	jdoe	192.168.1.129	SUCCESS	2025-11-21 10:36:22.322927	WIN-LAPTOP-19	sso	f	f	f
656	backup_user	203.0.113.48	SUCCESS	2025-11-21 05:40:22.322966	WIN-LAPTOP-16	certificate	f	t	f
657	asmith	203.0.113.188	SUCCESS	2025-11-20 12:09:22.32299	WIN-LAPTOP-24	mfa	f	t	f
658	dbrown	192.168.1.195	FAIL	2025-11-20 14:04:22.323012	MAC-DESKTOP-01	password	f	f	f
659	developer1	192.168.1.141	SUCCESS	2025-11-21 10:07:22.32304	MAC-DESKTOP-11	certificate	f	f	f
660	root	192.168.1.222	FAIL	2025-11-21 02:19:31.323067	MAC-DESKTOP-04	certificate	f	f	t
661	backup_user	203.0.113.8	FAIL	2025-11-21 16:11:22.323093	MAC-DESKTOP-03	password	t	t	f
662	backup_user	203.0.113.8	FAIL	2025-11-21 16:10:22.323111	MAC-DESKTOP-03	password	t	t	f
663	backup_user	203.0.113.8	FAIL	2025-11-21 16:10:22.323129	MAC-DESKTOP-03	password	t	t	f
664	backup_user	203.0.113.8	FAIL	2025-11-21 16:03:22.323145	MAC-DESKTOP-03	password	t	t	f
665	backup_user	203.0.113.8	FAIL	2025-11-21 16:04:22.323161	MAC-DESKTOP-03	password	t	t	f
666	netadmin	203.0.113.49	FAIL	2025-11-21 16:47:22.322827	WIN-LAPTOP-21	sso	f	t	t
667	sysadmin	203.0.113.115	SUCCESS	2025-11-21 12:57:22.322911	WIN-LAPTOP-15	password	f	t	t
668	developer1	192.168.1.204	SUCCESS	2025-11-21 11:36:22.322937	LINUX-SERVER-03	mfa	f	f	f
669	backup_user	203.0.113.250	SUCCESS	2025-11-21 04:32:00.322965	MAC-DESKTOP-06	certificate	f	t	f
670	mjohnson	192.168.1.150	SUCCESS	2025-11-20 20:06:22.32299	WIN-LAPTOP-04	password	f	f	f
671	dbrown	203.0.113.191	FAIL	2025-11-21 17:04:22.323012	WIN-LAPTOP-20	password	t	t	f
672	dbrown	203.0.113.191	FAIL	2025-11-21 17:04:22.32303	WIN-LAPTOP-20	password	t	t	f
673	dbrown	203.0.113.191	FAIL	2025-11-21 17:13:22.323047	WIN-LAPTOP-20	password	t	t	f
674	dbrown	203.0.113.191	FAIL	2025-11-21 17:08:22.323064	WIN-LAPTOP-20	password	t	t	f
675	dbrown	203.0.113.191	FAIL	2025-11-21 17:10:22.323082	WIN-LAPTOP-20	password	t	t	f
676	monitoring	203.0.113.107	SUCCESS	2025-11-20 23:54:22.32284	MAC-DESKTOP-14	sso	f	t	f
677	root	192.168.1.64	SUCCESS	2025-11-20 23:19:22.322917	WIN-LAPTOP-28	certificate	f	f	t
678	developer1	192.168.1.237	FAIL	2025-11-21 07:13:22.322946	WIN-LAPTOP-26	password	f	f	f
679	mjohnson	203.0.113.224	FAIL	2025-11-21 04:19:30.322975	WIN-LAPTOP-18	sso	f	t	f
680	asmith	192.168.1.170	SUCCESS	2025-11-20 15:17:22.323003	WIN-LAPTOP-10	sso	f	f	f
681	jdoe	192.168.1.164	SUCCESS	2025-11-21 04:59:13.323029	WIN-LAPTOP-25	sso	f	f	f
682	dbrown	192.168.1.30	SUCCESS	2025-11-20 22:08:22.323052	WIN-LAPTOP-18	mfa	f	f	f
683	asmith	192.168.1.60	SUCCESS	2025-11-21 08:32:22.323076	WIN-LAPTOP-26	sso	f	f	f
684	asmith	192.168.1.114	SUCCESS	2025-11-21 14:17:22.3231	WIN-LAPTOP-18	certificate	f	f	f
685	admin	203.0.113.241	SUCCESS	2025-11-21 04:20:22.323123	WIN-LAPTOP-24	password	f	t	t
686	netadmin	192.168.1.199	SUCCESS	2025-11-21 02:17:22.323145	WIN-LAPTOP-23	sso	f	f	t
687	sysadmin	203.0.113.201	SUCCESS	2025-11-21 04:12:22.323168	MAC-DESKTOP-02	certificate	f	t	t
688	backup_user	203.0.113.66	SUCCESS	2025-11-21 07:33:22.323189	WIN-LAPTOP-19	certificate	f	t	f
689	sysadmin	192.168.1.72	FAIL	2025-11-20 22:48:22.323208	WIN-LAPTOP-25	mfa	f	f	t
690	developer1	192.168.1.250	SUCCESS	2025-11-21 06:09:22.323232	WIN-LAPTOP-18	mfa	f	f	f
691	kwilliams	203.0.113.246	FAIL	2025-11-21 18:05:22.323254	MAC-DESKTOP-13	password	t	t	f
692	kwilliams	203.0.113.246	FAIL	2025-11-21 18:10:22.323271	MAC-DESKTOP-13	password	t	t	f
693	kwilliams	203.0.113.246	FAIL	2025-11-21 18:06:22.323288	MAC-DESKTOP-13	password	t	t	f
694	kwilliams	203.0.113.246	FAIL	2025-11-21 18:04:22.323304	MAC-DESKTOP-13	password	t	t	f
695	kwilliams	203.0.113.246	FAIL	2025-11-21 18:12:22.32332	MAC-DESKTOP-13	password	t	t	f
696	netadmin	192.168.1.166	SUCCESS	2025-11-20 19:37:22.322945	WIN-LAPTOP-28	sso	f	f	t
697	backup_user	192.168.1.54	SUCCESS	2025-11-21 10:42:22.323025	WIN-LAPTOP-11	sso	f	f	f
698	monitoring	203.0.113.218	SUCCESS	2025-11-21 08:25:22.323053	MAC-DESKTOP-03	mfa	f	t	f
699	backup_user	192.168.1.64	SUCCESS	2025-11-21 11:09:22.323077	MAC-DESKTOP-01	mfa	f	f	f
700	mjohnson	203.0.113.152	SUCCESS	2025-11-21 05:16:37.323102	WIN-LAPTOP-14	sso	f	t	f
701	asmith	192.168.1.21	SUCCESS	2025-11-21 12:26:22.323127	WIN-LAPTOP-09	password	f	f	f
702	mjohnson	192.168.1.104	SUCCESS	2025-11-21 02:48:27.323152	LINUX-SERVER-06	password	f	f	f
703	root	192.168.1.210	SUCCESS	2025-11-21 15:34:22.323175	MAC-DESKTOP-08	password	f	f	t
704	developer2	192.168.1.38	FAIL	2025-11-21 05:13:20.323203	WIN-LAPTOP-27	mfa	f	f	f
705	developer2	203.0.113.96	FAIL	2025-11-20 13:35:22.32323	WIN-LAPTOP-05	sso	f	t	f
706	service_account	192.168.1.24	SUCCESS	2025-11-20 13:30:22.323254	WIN-LAPTOP-25	mfa	f	f	f
707	scanner	192.168.1.151	SUCCESS	2025-11-21 04:04:22.323278	WIN-LAPTOP-08	certificate	f	f	f
708	service_account	203.0.113.37	SUCCESS	2025-11-21 13:33:22.323301	MAC-DESKTOP-09	password	f	t	f
709	developer2	203.0.113.163	FAIL	2025-11-21 19:07:22.32332	LINUX-SERVER-03	password	t	t	f
710	developer2	203.0.113.163	FAIL	2025-11-21 19:10:22.323337	LINUX-SERVER-03	password	t	t	f
711	developer2	203.0.113.163	FAIL	2025-11-21 19:06:22.323353	LINUX-SERVER-03	password	t	t	f
712	developer2	203.0.113.163	FAIL	2025-11-21 19:04:22.323369	LINUX-SERVER-03	password	t	t	f
713	developer2	203.0.113.163	FAIL	2025-11-21 19:12:22.323397	LINUX-SERVER-03	password	t	t	f
\.


--
-- Data for Name: patch_levels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patch_levels (id, device_id, os, last_patch_date, missing_critical, missing_high, update_failures, is_unsupported, updated_at) FROM stdin;
4	MAC-DESKTOP-11	macOS 13	2025-11-20	0	0	0	f	2025-11-20 06:22:41.216843
11	MAC-DESKTOP-10	Windows 11	2025-08-15	0	0	0	f	2025-11-20 06:22:41.217523
14	LINUX-SERVER-04	macOS 13	2025-11-20	0	0	0	f	2025-11-20 06:47:12.208798
25	WIN-LAPTOP-20	macOS 14	2025-10-21	0	0	0	f	2025-11-20 06:47:12.210108
34	WIN-LAPTOP-14	Ubuntu 20.04	2025-11-21	0	0	0	f	2025-11-21 14:06:26.438889
39	WIN-LAPTOP-23	Ubuntu 20.04	2025-11-21	0	0	0	f	2025-11-21 14:06:26.438891
42	WIN-LAPTOP-18	macOS 14	2025-11-07	0	0	0	f	2025-11-21 14:06:26.438891
43	WIN-LAPTOP-22	macOS 14	2025-11-21	0	0	0	f	2025-11-21 02:00:25.993785
22	WIN-LAPTOP-08	Windows Server 2012	2025-11-20	0	0	0	t	2025-11-20 07:24:26.051938
7	LINUX-SERVER-06	Ubuntu 22.04	2025-11-21	0	0	0	f	2025-11-21 14:53:25.482305
29	WIN-LAPTOP-25	Windows Server 2019	2025-11-20	0	0	0	f	2025-11-20 07:45:57.621297
30	WIN-LAPTOP-26	Windows 11	2025-11-21	0	0	0	f	2025-11-21 14:53:25.482632
47	WIN-LAPTOP-05	macOS 14	2025-11-21	0	0	0	f	2025-11-21 14:53:25.482634
5	WIN-LAPTOP-28	macOS 14	2025-11-21	0	0	0	f	2025-11-21 03:00:26.036514
48	MAC-DESKTOP-06	RHEL 8	2025-11-21	0	0	0	f	2025-11-21 14:53:25.482634
15	WIN-LAPTOP-11	Ubuntu 20.04	2025-11-21	0	0	0	f	2025-11-21 03:00:26.036515
31	WIN-LAPTOP-15	Windows 11	2025-10-22	0	0	0	f	2025-11-21 03:00:26.036515
37	WIN-LAPTOP-12	macOS 14	2025-11-21	0	0	0	f	2025-11-21 03:00:26.036516
32	WIN-LAPTOP-04	macOS 14	2025-11-20	0	0	0	f	2025-11-20 09:17:31.785685
51	WIN-LAPTOP-29	Ubuntu 22.04	2025-11-21	0	0	0	f	2025-11-21 03:00:26.036516
10	WIN-LAPTOP-16	macOS 14	2025-11-20	0	0	0	f	2025-11-20 10:16:54.062236
52	LINUX-SERVER-09	Windows 10	2025-11-21	0	0	0	f	2025-11-21 14:53:25.482634
24	WIN-LAPTOP-01	Windows 10	2025-11-21	0	0	0	f	2025-11-21 04:02:26.156355
20	WIN-LAPTOP-19	Windows Server 2022	2025-10-27	0	0	0	f	2025-11-21 16:04:26.350682
27	WIN-LAPTOP-21	macOS 14	2025-11-21	0	0	0	f	2025-11-21 16:04:26.350685
40	WIN-LAPTOP-02	RHEL 8	2025-11-21	0	0	0	f	2025-11-21 04:02:26.156357
6	MAC-DESKTOP-03	Windows Server 2022	2025-11-20	0	0	0	f	2025-11-20 11:45:48.358085
26	WIN-LAPTOP-06	Ubuntu 22.04	2025-11-20	0	0	0	f	2025-11-20 11:45:48.358787
9	MAC-DESKTOP-05	Windows Server 2019	2025-11-20	0	0	0	f	2025-11-20 12:20:50.99451
23	WIN-LAPTOP-17	macOS 13	2025-11-21	0	0	0	f	2025-11-21 17:09:26.685107
36	WIN-LAPTOP-09	RHEL 9	2025-11-03	0	0	0	f	2025-11-21 17:09:26.685108
17	MAC-DESKTOP-07	Ubuntu 22.04	2025-11-20	0	0	0	f	2025-11-20 14:56:38.050679
44	WIN-LAPTOP-27	Windows Server 2022	2025-11-21	0	0	0	f	2025-11-21 04:02:26.156357
1	MAC-DESKTOP-13	Windows 11	2025-11-21	0	0	0	f	2025-11-21 18:01:26.188444
21	WIN-LAPTOP-07	RHEL 9	2025-10-22	0	0	0	f	2025-11-21 18:01:26.188446
33	MAC-DESKTOP-08	RHEL 8	2025-11-09	0	0	0	f	2025-11-21 18:01:26.188447
46	WIN-LAPTOP-10	Windows Server 2022	2025-11-21	0	0	0	f	2025-11-21 04:02:26.170152
28	LINUX-SERVER-03	Windows Server 2012	2025-11-21	0	0	0	t	2025-11-21 19:04:26.2888
38	LINUX-SERVER-05	RHEL 8	2025-10-24	0	9	0	f	2025-11-21 19:04:26.288801
12	WIN-LAPTOP-03	macOS 13	2025-11-21	0	0	0	f	2025-11-21 00:07:26.529978
41	MAC-DESKTOP-01	Windows 10	2025-11-21	0	0	0	f	2025-11-21 00:07:26.52998
49	WIN-LAPTOP-13	Windows 10	2025-11-21	0	0	0	f	2025-11-21 00:07:26.529981
16	LINUX-SERVER-07	Windows 11	2025-11-21	0	0	0	f	2025-11-21 01:03:26.279972
18	WIN-LAPTOP-24	RHEL 8	2025-11-21	0	0	0	f	2025-11-21 01:03:26.279975
13	MAC-DESKTOP-02	Windows Server 2022	2025-11-21	0	0	0	f	2025-11-21 08:24:25.563754
19	LINUX-SERVER-08	Windows 11	2025-11-21	0	0	0	f	2025-11-21 08:24:25.563757
50	MAC-DESKTOP-04	RHEL 8	2025-11-21	0	0	0	f	2025-11-21 09:27:25.788255
2	MAC-DESKTOP-12	Ubuntu 22.04	2025-11-21	0	0	0	f	2025-11-21 10:45:27.310662
35	LINUX-SERVER-01	Windows Server 2022	2025-11-21	0	0	0	f	2025-11-21 10:45:27.310663
45	MAC-DESKTOP-14	RHEL 9	2025-11-21	0	0	0	f	2025-11-21 10:45:27.310664
3	LINUX-SERVER-02	Windows 11	2025-11-03	0	0	0	f	2025-11-21 12:11:26.881672
8	MAC-DESKTOP-09	Windows 10	2025-11-21	0	0	0	f	2025-11-21 12:58:25.946881
\.


--
-- Name: event_analyses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_analyses_id_seq', 1908, true);


--
-- Name: firewall_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.firewall_logs_id_seq', 1647, true);


--
-- Name: login_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_events_id_seq', 713, true);


--
-- Name: patch_levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patch_levels_id_seq', 52, true);


--
-- Name: event_analyses event_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_analyses
    ADD CONSTRAINT event_analyses_pkey PRIMARY KEY (id);


--
-- Name: firewall_logs firewall_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.firewall_logs
    ADD CONSTRAINT firewall_logs_pkey PRIMARY KEY (id);


--
-- Name: login_events login_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_events
    ADD CONSTRAINT login_events_pkey PRIMARY KEY (id);


--
-- Name: patch_levels patch_levels_device_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patch_levels
    ADD CONSTRAINT patch_levels_device_id_key UNIQUE (device_id);


--
-- Name: patch_levels patch_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patch_levels
    ADD CONSTRAINT patch_levels_pkey PRIMARY KEY (id);


--
-- Name: ix_event_analyses_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_event_analyses_id ON public.event_analyses USING btree (id);


--
-- Name: ix_firewall_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_firewall_logs_id ON public.firewall_logs USING btree (id);


--
-- Name: ix_login_events_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_login_events_id ON public.login_events USING btree (id);


--
-- Name: ix_patch_levels_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_patch_levels_id ON public.patch_levels USING btree (id);


--
-- PostgreSQL database dump complete
--

\unrestrict 8dYHMVOFhQOmSF9t0cEMG9JnpimMVqmUfZqFwYafVAasyXOA5waNf0hmkfwOFYg

