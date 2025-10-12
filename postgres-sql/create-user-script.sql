-- Replace 'mydatabase', 'myuser', and 'mypassword' with your desired values

CREATE DATABASE mydatabase;

CREATE USER myuser WITH PASSWORD 'mypassword';

GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;


GRANT ALL ON SCHEMA public TO myuser;