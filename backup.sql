--
-- PostgreSQL database dump
--

\restrict qrdjbGXDDGl2lap2AIacf3JcDo5ZZSfGm2OoypMINHkvh8XnQBlePkqQoutKzmj

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

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

--
-- Name: bookingstatus; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.bookingstatus AS ENUM (
    'PENDING',
    'CONFIRMED',
    'CANCELLED',
    'CHECKED_IN'
);


ALTER TYPE public.bookingstatus OWNER TO admin;

--
-- Name: flightstatus; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.flightstatus AS ENUM (
    'SCHEDULED',
    'DELAYED',
    'CANCELLED',
    'BOARDING',
    'COMPLETED'
);


ALTER TYPE public.flightstatus OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: airports; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.airports (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(200) NOT NULL,
    city character varying(100) NOT NULL,
    country character varying(100) NOT NULL,
    timezone character varying(100) NOT NULL
);


ALTER TABLE public.airports OWNER TO admin;

--
-- Name: airports_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.airports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.airports_id_seq OWNER TO admin;

--
-- Name: airports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.airports_id_seq OWNED BY public.airports.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    flight_id integer NOT NULL,
    passenger_id integer NOT NULL,
    seat_number character varying(10) NOT NULL,
    booking_date timestamp without time zone NOT NULL,
    booking_status public.bookingstatus NOT NULL,
    fare numeric(10,2) NOT NULL
);


ALTER TABLE public.bookings OWNER TO admin;

--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bookings_id_seq OWNER TO admin;

--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: flights; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.flights (
    id integer NOT NULL,
    flight_number character varying(20) NOT NULL,
    airline character varying(100) NOT NULL,
    source_airport_id integer NOT NULL,
    destination_airport_id integer NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    duration_minutes integer NOT NULL,
    aircraft character varying(100) NOT NULL,
    total_seats integer NOT NULL,
    available_seats integer NOT NULL,
    price numeric(10,2) NOT NULL,
    status public.flightstatus NOT NULL
);


ALTER TABLE public.flights OWNER TO admin;

--
-- Name: flights_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.flights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flights_id_seq OWNER TO admin;

--
-- Name: flights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.flights_id_seq OWNED BY public.flights.id;


--
-- Name: passengers; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.passengers (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(20),
    email character varying(100),
    phone character varying(20),
    passport_number character varying(50) NOT NULL,
    nationality character varying(100),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.passengers OWNER TO admin;

--
-- Name: passengers_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.passengers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passengers_id_seq OWNER TO admin;

--
-- Name: passengers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.passengers_id_seq OWNED BY public.passengers.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    booking_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    transaction_id character varying(100) NOT NULL,
    payment_date timestamp without time zone NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_status character varying(50) NOT NULL
);


ALTER TABLE public.payments OWNER TO admin;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO admin;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: airports id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.airports ALTER COLUMN id SET DEFAULT nextval('public.airports_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: flights id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.flights ALTER COLUMN id SET DEFAULT nextval('public.flights_id_seq'::regclass);


--
-- Name: passengers id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.passengers ALTER COLUMN id SET DEFAULT nextval('public.passengers_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Data for Name: airports; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.airports (id, code, name, city, country, timezone) FROM stdin;
1	BLR	Kempegowda International Airport	Bengaluru	India	Asia/Kolkata
2	DXB	Dubai International Airport	Dubai	United Arab Emirates	Asia/Dubai
3	LHR	London Heathrow Airport	London	United Kingdom	Europe/London
4	JFK	John F. Kennedy International Airport	New York	United States	America/New_York
5	SIN	Singapore Changi Airport	Singapore	Singapore	Asia/Singapore
6	HND	Tokyo Haneda Airport	Tokyo	Japan	Asia/Tokyo
7	CDG	Charles de Gaulle Airport	Paris	France	Europe/Paris
8	SYD	Sydney Kingsford Smith Airport	Sydney	Australia	Australia/Sydney
9	DEL	Indira Gandhi International Airport	New Delhi	India	Asia/Kolkata
10	FRA	Frankfurt Airport	Frankfurt	Germany	Europe/Berlin
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.bookings (id, flight_id, passenger_id, seat_number, booking_date, booking_status, fare) FROM stdin;
1	1	1	12A	2026-08-06 11:58:00	PENDING	450.50
2	1	2	12B	2026-08-06 10:15:00	CONFIRMED	450.50
3	2	3	03C	2026-08-06 11:00:00	CONFIRMED	1200.00
4	2	4	03D	2026-08-06 11:05:00	PENDING	1200.00
5	3	5	21F	2026-08-06 12:30:00	CANCELLED	320.75
6	4	6	14A	2026-08-06 13:45:00	CONFIRMED	650.00
7	4	7	14B	2026-08-06 13:50:00	CONFIRMED	650.00
8	5	8	01A	2026-08-06 14:20:00	CONFIRMED	2500.00
9	5	9	10E	2026-08-06 15:10:00	PENDING	180.00
10	1	10	18C	2026-08-06 16:00:00	CONFIRMED	450.50
11	98	11	12A	2026-08-27 00:00:00	CONFIRMED	14500.00
12	99	12	12A	2026-08-27 00:00:00	CONFIRMED	13200.00
13	99	13	12A	2026-08-27 00:00:00	CONFIRMED	13200.00
\.


--
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.flights (id, flight_number, airline, source_airport_id, destination_airport_id, departure_time, arrival_time, duration_minutes, aircraft, total_seats, available_seats, price, status) FROM stdin;
1	AI202	Air India	1	2	2026-08-10 09:30:00	2026-08-10 12:15:00	165	Airbus A320	180	150	5500.00	SCHEDULED
2	6E521	IndiGo	2	3	2026-08-11 06:00:00	2026-08-11 08:30:00	150	ATR 72	70	65	3200.00	BOARDING
3	UK101	Vistara	3	4	2026-08-12 14:00:00	2026-08-12 16:45:00	165	Boeing 737	160	120	4800.00	SCHEDULED
4	SG401	SpiceJet	4	5	2026-08-13 10:15:00	2026-08-13 12:00:00	105	Bombardier Q400	78	70	2800.00	DELAYED
5	AI305	Air India	5	6	2026-08-14 07:45:00	2026-08-14 11:00:00	195	Boeing 787	250	200	7200.00	SCHEDULED
6	6E789	IndiGo	6	7	2026-08-15 18:00:00	2026-08-15 20:30:00	150	Airbus A321	200	180	5600.00	COMPLETED
7	UK202	Vistara	7	8	2026-08-16 09:00:00	2026-08-16 11:45:00	165	Boeing 737 MAX	180	160	5000.00	SCHEDULED
8	SG555	SpiceJet	8	9	2026-08-17 13:30:00	2026-08-17 15:15:00	105	Bombardier Q400	78	60	2900.00	CANCELLED
9	AI450	Air India	9	10	2026-08-18 05:30:00	2026-08-18 08:15:00	165	Airbus A320	180	170	5400.00	SCHEDULED
10	6E999	IndiGo	10	1	2026-08-19 21:00:00	2026-08-19 23:30:00	150	Airbus A321	200	190	5800.00	SCHEDULED
14	AI101	Air India	1	2	2026-08-15 08:00:00	2026-08-15 11:30:00	210	Boeing 787	250	180	12500.00	SCHEDULED
15	6E202	IndiGo	9	1	2026-08-15 09:15:00	2026-08-15 12:00:00	165	Airbus A320	180	45	6200.00	BOARDING
16	UK303	Vistara	2	5	2026-08-15 14:30:00	2026-08-15 20:00:00	330	Boeing 737	160	112	18400.00	SCHEDULED
17	SG404	SpiceJet	1	9	2026-08-15 18:45:00	2026-08-15 21:30:00	145	Bombardier Q400	78	12	5800.00	DELAYED
18	AI105	Air India	3	10	2026-08-16 06:00:00	2026-08-16 07:45:00	105	Airbus A321	200	190	9500.00	SCHEDULED
19	6E206	IndiGo	5	6	2026-08-16 11:00:00	2026-08-16 17:30:00	390	Airbus A320	180	0	22000.00	COMPLETED
20	UK307	Vistara	7	3	2026-08-16 13:15:00	2026-08-16 14:30:00	75	Boeing 737 MAX	180	155	7800.00	SCHEDULED
21	SG408	SpiceJet	9	2	2026-08-16 22:00:00	2026-08-17 01:30:00	210	Boeing 737	160	140	11500.00	CANCELLED
22	AI109	Air India	4	3	2026-08-17 19:00:00	2026-08-18 07:30:00	750	Boeing 787	250	60	45000.00	SCHEDULED
23	6E210	IndiGo	2	1	2026-08-17 04:30:00	2026-08-17 09:15:00	285	Airbus A321	200	178	13200.00	SCHEDULED
24	UK311	Vistara	10	7	2026-08-17 12:00:00	2026-08-17 13:45:00	105	Airbus A320	180	130	8900.00	COMPLETED
25	SG412	SpiceJet	6	8	2026-08-17 20:30:00	2026-08-18 06:45:00	615	Boeing 737 MAX	180	95	38000.00	SCHEDULED
26	AI113	Air India	5	1	2026-08-18 10:15:00	2026-08-18 14:45:00	270	Boeing 787	250	210	14000.00	BOARDING
27	6E214	IndiGo	8	5	2026-08-18 15:00:00	2026-08-19 00:30:00	570	Airbus A321	200	142	34500.00	DELAYED
28	UK315	Vistara	1	4	2026-08-18 23:30:00	2026-08-19 13:00:00	810	Boeing 787	250	88	52000.00	SCHEDULED
29	SG416	SpiceJet	2	9	2026-08-19 02:15:00	2026-08-19 05:00:00	165	Boeing 737	160	150	10900.00	SCHEDULED
30	AI117	Air India	7	10	2026-08-19 08:45:00	2026-08-19 10:15:00	90	Airbus A320	180	165	6400.00	COMPLETED
31	6E218	IndiGo	3	2	2026-08-19 16:00:00	2026-08-20 01:30:00	570	Airbus A321	200	195	28000.00	SCHEDULED
32	UK319	Vistara	6	9	2026-08-19 21:30:00	2026-08-20 04:15:00	405	Boeing 787	250	204	24500.00	CANCELLED
33	SG420	SpiceJet	10	3	2026-08-20 05:30:00	2026-08-20 07:15:00	105	ATR 72	70	68	4900.00	SCHEDULED
34	AI121	Air India	9	4	2026-08-20 11:15:00	2026-08-21 00:45:00	810	Boeing 787	250	130	54000.00	BOARDING
35	6E222	IndiGo	1	5	2026-08-20 14:00:00	2026-08-20 16:30:00	150	Airbus A320	180	24	6900.00	DELAYED
36	UK323	Vistara	5	9	2026-08-20 19:30:00	2026-08-20 22:15:00	165	Airbus A321	200	170	7500.00	SCHEDULED
37	SG424	SpiceJet	2	7	2026-08-21 01:00:00	2026-08-21 07:45:00	405	Boeing 737 MAX	180	142	21000.00	SCHEDULED
38	AI125	Air India	8	1	2026-08-21 07:15:00	2026-08-21 16:30:00	555	Boeing 787	250	190	32000.00	COMPLETED
39	6E226	IndiGo	4	9	2026-08-21 13:00:00	2026-08-22 02:30:00	810	Airbus A321	200	55	49000.00	SCHEDULED
40	UK327	Vistara	3	1	2026-08-21 21:00:00	2026-08-22 06:15:00	555	Boeing 787	250	220	31000.00	SCHEDULED
41	SG428	SpiceJet	6	2	2026-08-22 03:30:00	2026-08-22 11:45:00	495	Boeing 737	160	110	26000.00	CANCELLED
42	AI129	Air India	1	6	2026-08-22 09:00:00	2026-08-22 16:15:00	435	Boeing 787	250	145	23000.00	BOARDING
43	6E230	IndiGo	9	5	2026-08-22 15:45:00	2026-08-22 18:30:00	165	Airbus A320	180	162	7100.00	SCHEDULED
44	UK331	Vistara	2	3	2026-08-22 20:00:00	2026-08-23 05:15:00	555	Boeing 737 MAX	180	92	29500.00	DELAYED
45	SG432	SpiceJet	5	2	2026-08-23 02:00:00	2026-08-23 07:30:00	330	Boeing 737	160	144	19000.00	SCHEDULED
46	AI133	Air India	10	1	2026-08-23 08:30:00	2026-08-23 10:15:00	105	Airbus A321	200	185	5400.00	COMPLETED
47	6E234	IndiGo	7	10	2026-08-23 12:15:00	2026-08-23 14:00:00	105	Airbus A320	180	150	8200.00	SCHEDULED
48	UK335	Vistara	3	4	2026-08-23 16:00:00	2026-08-23 23:30:00	450	Boeing 787	250	201	27000.00	SCHEDULED
49	SG436	SpiceJet	4	1	2026-08-23 21:45:00	2026-08-24 07:15:00	570	Bombardier Q400	78	32	31000.00	CANCELLED
50	AI137	Air India	1	7	2026-08-24 05:15:00	2026-08-24 12:00:00	405	Boeing 787	250	164	24000.00	SCHEDULED
51	6E238	IndiGo	2	6	2026-08-24 11:30:00	2026-08-24 19:45:00	495	Airbus A321	200	182	28500.00	BOARDING
52	UK339	Vistara	9	3	2026-08-24 15:00:00	2026-08-24 23:30:00	510	Boeing 787	250	115	29000.00	DELAYED
53	SG440	SpiceJet	5	10	2026-08-24 20:15:00	2026-08-25 01:45:00	330	Boeing 737 MAX	180	169	14200.00	SCHEDULED
54	AI141	Air India	6	1	2026-08-25 02:45:00	2026-08-25 10:00:00	435	Boeing 787	250	210	23500.00	COMPLETED
55	6E242	IndiGo	10	2	2026-08-25 08:00:00	2026-08-25 13:30:00	330	Airbus A320	180	141	16000.00	SCHEDULED
56	UK343	Vistara	8	9	2026-08-25 12:30:00	2026-08-26 02:15:00	825	Boeing 787	250	94	54000.00	SCHEDULED
57	SG444	SpiceJet	3	7	2026-08-25 17:15:00	2026-08-25 18:30:00	75	Boeing 737	160	158	4200.00	CANCELLED
58	AI145	Air India	1	8	2026-08-25 22:00:00	2026-08-26 07:15:00	555	Boeing 787	250	173	33000.00	SCHEDULED
59	6E246	IndiGo	2	5	2026-08-26 04:15:00	2026-08-26 09:45:00	330	Airbus A321	200	188	17800.00	BOARDING
60	UK347	Vistara	5	1	2026-08-26 10:00:00	2026-08-26 14:30:00	270	Airbus A320	180	160	13900.00	DELAYED
61	SG448	SpiceJet	7	2	2026-08-26 15:30:00	2026-08-26 22:15:00	405	Boeing 737	160	122	20500.00	SCHEDULED
62	AI149	Air India	9	6	2026-08-26 21:00:00	2026-08-27 03:45:00	405	Boeing 787	250	140	24000.00	COMPLETED
63	6E250	IndiGo	4	3	2026-08-27 01:15:00	2026-08-27 13:45:00	750	Airbus A321	200	191	42000.00	SCHEDULED
64	UK351	Vistara	3	9	2026-08-27 06:30:00	2026-08-27 15:00:00	510	Boeing 787	250	211	28500.00	SCHEDULED
65	SG452	SpiceJet	6	1	2026-08-27 11:45:00	2026-08-27 19:00:00	435	Boeing 737 MAX	180	145	22000.00	CANCELLED
66	AI153	Air India	2	10	2026-08-27 16:30:00	2026-08-27 22:00:00	330	Airbus A320	180	90	15500.00	BOARDING
67	6E254	IndiGo	1	10	2026-08-27 21:15:00	2026-08-27 23:00:00	105	Airbus A320	180	33	5300.00	DELAYED
68	UK355	Vistara	10	2	2026-08-28 02:00:00	2026-08-28 07:30:00	330	Boeing 737	160	152	16400.00	SCHEDULED
69	SG456	SpiceJet	9	8	2026-08-28 07:45:00	2026-08-28 21:30:00	825	Boeing 737	160	61	51000.00	COMPLETED
70	AI157	Air India	5	8	2026-08-28 13:00:00	2026-08-28 22:30:00	570	Boeing 787	250	199	35000.00	SCHEDULED
71	6E258	IndiGo	8	1	2026-08-28 18:30:00	2026-08-29 03:45:00	555	Airbus A321	200	180	31500.00	SCHEDULED
72	UK359	Vistara	4	1	2026-08-28 23:45:00	2026-08-29 09:15:00	570	Boeing 787	250	234	32000.00	CANCELLED
73	SG460	SpiceJet	7	4	2026-08-29 03:15:00	2026-08-29 10:45:00	450	Bombardier Q400	78	44	26500.00	SCHEDULED
74	AI161	Air India	3	2	2026-08-29 09:00:00	2026-08-29 18:30:00	570	Boeing 787	250	128	27500.00	BOARDING
75	6E262	IndiGo	2	4	2026-08-29 14:15:00	2026-08-30 03:45:00	810	Airbus A320	180	142	48000.00	DELAYED
76	UK363	Vistara	1	9	2026-08-29 19:30:00	2026-08-29 22:15:00	145	Airbus A321	200	167	6100.00	SCHEDULED
77	SG464	SpiceJet	9	10	2026-08-30 01:00:00	2026-08-30 03:45:00	165	Boeing 737	160	148	10500.00	SCHEDULED
78	AI165	Air India	10	3	2026-08-30 06:15:00	2026-08-30 08:00:00	105	Airbus A321	200	194	5200.00	COMPLETED
79	6E266	IndiGo	6	4	2026-08-30 11:30:00	2026-08-31 01:00:00	810	Airbus A321	200	81	50000.00	SCHEDULED
80	UK367	Vistara	4	6	2026-08-30 17:00:00	2026-08-31 06:30:00	810	Boeing 787	250	220	51500.00	SCHEDULED
81	SG468	SpiceJet	3	1	2026-08-30 22:30:00	2026-08-31 07:45:00	555	Boeing 737 MAX	180	139	29000.00	CANCELLED
82	AI169	Air India	2	1	2026-08-31 04:30:00	2026-08-31 09:15:00	285	Boeing 787	250	105	13500.00	BOARDING
83	6E270	IndiGo	1	2	2026-08-31 10:15:00	2026-08-31 13:45:00	210	Airbus A320	180	154	12000.00	SCHEDULED
84	UK371	Vistara	5	2	2026-08-31 15:00:00	2026-08-31 20:30:00	330	Airbus A321	200	181	18100.00	DELAYED
85	SG472	SpiceJet	9	1	2026-08-31 20:45:00	2026-08-31 23:30:00	165	Boeing 737	160	110	6300.00	SCHEDULED
86	AI173	Air India	8	6	2026-09-01 02:00:00	2026-09-01 11:45:00	585	Boeing 787	250	142	39000.00	COMPLETED
87	6E274	IndiGo	6	5	2026-09-01 08:15:00	2026-09-01 14:45:00	390	Airbus A320	180	165	21500.00	SCHEDULED
88	UK375	Vistara	3	7	2026-09-01 13:30:00	2026-09-01 14:45:00	75	Boeing 737 MAX	180	172	4100.00	SCHEDULED
89	SG476	SpiceJet	2	9	2026-09-01 19:00:00	2026-09-01 21:45:00	165	Boeing 737	160	125	11200.00	CANCELLED
90	AI177	Air India	7	3	2026-09-01 23:30:00	2026-09-02 00:45:00	75	Airbus A320	180	155	7900.00	SCHEDULED
91	6E278	IndiGo	1	3	2026-09-02 04:15:00	2026-09-02 13:30:00	555	Airbus A321	200	190	30500.00	BOARDING
92	UK379	Vistara	9	2	2026-09-02 10:00:00	2026-09-02 13:30:00	210	Boeing 787	250	230	12000.00	DELAYED
93	SG480	SpiceJet	10	7	2026-09-02 15:30:00	2026-09-02 17:15:00	105	ATR 72	70	54	8400.00	SCHEDULED
94	AI901	Air India	1	2	2026-08-25 06:00:00	2026-08-25 09:30:00	210	Boeing 787	250	140	12500.00	SCHEDULED
95	6E902	IndiGo	1	2	2026-08-25 14:15:00	2026-08-25 17:45:00	210	Airbus A320	180	95	9800.00	SCHEDULED
96	UK903	Vistara	9	3	2026-08-26 08:30:00	2026-08-26 17:00:00	510	Boeing 787	250	185	28500.00	SCHEDULED
97	AI904	Air India	9	3	2026-08-26 21:00:00	2026-08-27 05:30:00	510	Boeing 777	300	210	31000.00	SCHEDULED
98	6E905	IndiGo	2	5	2026-08-27 10:00:00	2026-08-27 15:30:00	330	Airbus A321	200	162	14500.00	SCHEDULED
99	SG906	SpiceJet	2	5	2026-08-27 18:45:00	2026-08-28 00:15:00	330	Boeing 737	160	40	13200.00	SCHEDULED
\.


--
-- Data for Name: passengers; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.passengers (id, first_name, last_name, date_of_birth, gender, email, phone, passport_number, nationality, created_at, updated_at) FROM stdin;
1	Amit	Sharma	1988-04-12	Male	amit.sharma@example.com	+919876543210	Z1234567	Indian	2026-08-05 16:42:32.4963	2026-08-05 16:42:32.496317
2	Priya	Patel	1993-09-25	Female	priya.patel@example.com	+919123456789	Z7654321	Indian	2026-08-05 16:43:42.130016	2026-08-05 16:43:42.130025
3	Sarah	Connor	1985-11-10	Female	sconnor@example.com	+12025550143	A9876543	American	2026-08-05 16:44:10.453981	2026-08-05 16:44:10.453988
4	David	Smith	1978-01-30	Male	dsmith@example.com	+442079460192	G5432109	British	2026-08-05 16:44:25.321792	2026-08-05 16:44:25.321797
5	Yuki	Tanaka	1995-07-14	Female	yuki.t@example.com	+81355550199	TK123456	Japanese	2026-08-05 16:44:39.953453	2026-08-05 16:44:39.953458
6	Carlos	Silva	1990-03-22	Male	carlos.silva@example.com	+5511999999999	BR876543	Brazilian	2026-08-05 16:44:53.336178	2026-08-05 16:44:53.336186
7	Elena	Petrova	1992-12-05	Female	epetrova@example.com	+74951234567	RU456789	Russian	2026-08-05 16:45:45.28065	2026-08-05 16:45:45.280659
8	Liam	Müller	1982-08-19	Male	l.mueller@example.com	+49301234567	DE987654	German	2026-08-05 16:45:56.465098	2026-08-05 16:45:56.465104
9	Zarah	Ahmed	2000-05-02	Non-binary	zarah.a@example.com	+97141234567	DXB00123	Emirati	2026-08-05 16:46:09.280967	2026-08-05 16:46:09.280973
10	Kwame	Mensah	1987-10-08	Male	kwame.m@example.com	+233241234567	GH765432	Ghanaian	2026-08-05 16:46:15.399142	2026-08-05 16:46:15.399149
11	Om		2000-01-01	\N	panjagallom@gmail.com	\N	1234567	\N	2026-08-10 07:35:59.430198	2026-08-10 07:35:59.430211
12	Omkar		2000-01-01	\N	omkar.panjagall@gmail.com	\N	DXX988398	\N	2026-08-10 08:02:33.224941	2026-08-10 08:02:33.224947
13	ABC		2000-01-01	\N	adb@gmail.com	\N	ABC234533	\N	2026-08-10 09:18:27.69411	2026-08-10 09:18:27.694116
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.payments (id, booking_id, amount, transaction_id, payment_date, payment_method, payment_status) FROM stdin;
1	13	13200.00	1786353507775-9999	2026-08-10 14:48:27.775	card	SUCCESS
\.


--
-- Name: airports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.airports_id_seq', 10, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.bookings_id_seq', 13, true);


--
-- Name: flights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.flights_id_seq', 99, true);


--
-- Name: passengers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.passengers_id_seq', 13, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.payments_id_seq', 1, true);


--
-- Name: airports airports_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.airports
    ADD CONSTRAINT airports_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (id);


--
-- Name: passengers passengers_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.passengers
    ADD CONSTRAINT passengers_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: payments payments_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_transaction_id_key UNIQUE (transaction_id);


--
-- Name: ix_airports_code; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_airports_code ON public.airports USING btree (code);


--
-- Name: ix_airports_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_airports_id ON public.airports USING btree (id);


--
-- Name: ix_bookings_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_bookings_id ON public.bookings USING btree (id);


--
-- Name: ix_flights_flight_number; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_flights_flight_number ON public.flights USING btree (flight_number);


--
-- Name: ix_flights_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_flights_id ON public.flights USING btree (id);


--
-- Name: ix_passengers_email; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_passengers_email ON public.passengers USING btree (email);


--
-- Name: ix_passengers_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_passengers_id ON public.passengers USING btree (id);


--
-- Name: ix_passengers_passport_number; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_passengers_passport_number ON public.passengers USING btree (passport_number);


--
-- Name: ix_payments_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_payments_id ON public.payments USING btree (id);


--
-- Name: bookings bookings_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(id);


--
-- Name: bookings bookings_passenger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES public.passengers(id);


--
-- Name: flights flights_destination_airport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_destination_airport_id_fkey FOREIGN KEY (destination_airport_id) REFERENCES public.airports(id);


--
-- Name: flights flights_source_airport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_source_airport_id_fkey FOREIGN KEY (source_airport_id) REFERENCES public.airports(id);


--
-- Name: payments payments_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_booking_id_fkey FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- PostgreSQL database dump complete
--

\unrestrict qrdjbGXDDGl2lap2AIacf3JcDo5ZZSfGm2OoypMINHkvh8XnQBlePkqQoutKzmj

