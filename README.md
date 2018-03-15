# Curious Moon

Docker setup for the curious moon book, provides a postgres 10 server and a client.

## Git LFS
This repo uses git lfs for storing the datasets. It requires the git-lfs package to be installed. Check your package manager or https://help.github.com/articles/installing-git-large-file-storage/

## Usage

### First use
- Setup postgres: `docker-compose up -d`
- Create the db: `./connect.sh bash` and then `createdb -U postgres enceladus`
- Seed the db: `./connect.sh bash` and then `cd /repo && make clean && make`

### Subsequent uses
- `psql` prompt to the db: `./connect.sh`

## Structure
SQL queries are in `sql/` and the datasets are in `data/`. Some CSV files are compressed with `xz` to avoid gigantic files stored on LFS.

The queries can be run manually from psql with `\i <path to repo>/sql/<file>.sql`

The SQL query files are prefixed by numbers to denote the sequential order in which they were meant to run. i.e. they usually depend on the queries from the files coming before them.
