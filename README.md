# Curious Moon

Docker setup for the curious moon book, provides a postgres 10 server and a client.

## Usage

### First use
- Setup postgres: `docker-compose up -d`
- Create the db: `./connect.sh bash` and then `createdb -U postgres enceladus`
- Seed the db: `./connect.sh bash` and then `cd /repo && make clean && make`

### Subsequent uses
- `psql` prompt to the db: `./connect.sh`
