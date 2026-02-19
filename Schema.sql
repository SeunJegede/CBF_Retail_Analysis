--
-- PostgreSQL database dump
--

\restrict MTauYCGO3F6fbAGMRCWcf0SaqSPZS0nyZAsl1lsqCjhv4cgVj5uGrGXUOo34ldH

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

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
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    product_id integer,
    inventory_item_id integer,
    status text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    returned_at timestamp with time zone,
    sale_price numeric NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    user_id integer NOT NULL,
    status text NOT NULL,
    gender character(1),
    created_at timestamp with time zone NOT NULL,
    returned_at timestamp with time zone,
    shipped_at timestamp with time zone,
    delivered_at timestamp with time zone,
    num_of_item integer NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id integer NOT NULL,
    cost numeric NOT NULL,
    category text NOT NULL,
    name text,
    brand text,
    retail_price numeric NOT NULL,
    department text,
    sku text,
    distribution_center_id integer
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(255),
    age integer,
    gender character varying(10),
    state character varying(100),
    street_address character varying(255),
    postal_code character varying(50),
    city character varying(100),
    country character varying(50),
    latitude numeric,
    longitude numeric,
    traffic_source character varying(50),
    created_date date
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: order_items order_items_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict MTauYCGO3F6fbAGMRCWcf0SaqSPZS0nyZAsl1lsqCjhv4cgVj5uGrGXUOo34ldH

