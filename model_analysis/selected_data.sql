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


