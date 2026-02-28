DROP TABLE IF EXISTS users;

-- Create the user table
CREATE TABLE users (
    id INT PRIMARY KEY,
    first_name 			VARCHAR(50) NOT NULL,
    last_name 			VARCHAR(50) NOT NULL,
    email 				VARCHAR(255) UNIQUE NOT NULL,
    age 				INT,
    gender				VARCHAR(10),
    street_address 		VARCHAR(255),
    city 				VARCHAR(100),
    state 				VARCHAR(30),
    postal_code 		VARCHAR(50),
    country 			VARCHAR(50),
    latitude 			INT,
    longitude 			INT,
    traffic_source 		VARCHAR(50),
    created_date 		DATE
);

select * from users

-- altered product table to match existing data set
ALTER TABLE products
ALTER COLUMN name DROP NOT NULL;

SELECT * FROM order_items;

orders table created
CREATE TABLE orders(
	order_id      INTEGER PRIMARY KEY,
    user_id       INTEGER NOT NULL REFERENCES users(id),
    status        TEXT NOT NULL,
    gender        CHAR(1),
    created_at    TIMESTAMPTZ NOT NULL,
    returned_at   TIMESTAMPTZ,
    shipped_at    TIMESTAMPTZ,
    delivered_at  TIMESTAMPTZ,
    num_of_item   INTEGER NOT NULL
);
-- product table created
CREATE TABLE products(
 	id                         INTEGER PRIMARY KEY,
    cost                       NUMERIC NOT NULL,
    category                   TEXT NOT NULL,
    name                       TEXT NOT NULL,
    brand                      TEXT,
    retail_price               NUMERIC NOT NULL,
    department                 TEXT,
    sku                        TEXT UNIQUE,
    distribution_center_id     INTEGER
);

-- create order items table
CREATE TABLE order_items(
  	id                  INTEGER PRIMARY KEY,
    order_id            INTEGER REFERENCES orders(order_id),
	user_id             INTEGER REFERENCES users(id),
	product_id          INTEGER REFERENCES products(id),
    inventory_item_id   INTEGER,
	status              TEXT NOT NULL,
    created_at          TIMESTAMPTZ NOT NULL,
    shipped_at          TIMESTAMPTZ,
    delivered_at        TIMESTAMPTZ,
    returned_at         TIMESTAMPTZ,
    sale_price          NUMERIC NOT NULL
);
