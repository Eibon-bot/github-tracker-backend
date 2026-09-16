# github-tracker-backend

API del proyecto GitHub Tracker: seguimiento personal de releases, hitos y
actividad del ecosistema de GitHub.

Frontend del proyecto: [github-tracker-frontend](https://github.com/Eibon-bot/github-tracker-frontend)

## Stack

- NestJS 12 sobre Node 24, en modo ESM
- PostgreSQL con Drizzle ORM
- GraphQL para consumir la API de GitHub
- Swagger/OpenAPI para documentar los endpoints
- Docker Compose para levantar API y base de datos
- oxlint, Prettier y vitest

## Estructura

```
src/
├── config/     validacion y carga de la configuracion
├── modules/    un modulo por dominio (health, y los que vengan)
└── main.ts     arranque; todas las rutas cuelgan de /api
```

## Puesta en marcha en local

```bash
npm install
cp .env.example .env
npm run start:dev
```

La API queda en `http://localhost:3000/api`. Para comprobar que responde:

```bash
curl http://localhost:3000/api/health
```

Las variables de entorno se validan al arrancar: si falta alguna o tiene un
valor invalido, la aplicacion no levanta y te dice cuales son todas las que
estan mal.

## Comandos

| Comando | Que hace |
| --- | --- |
| `npm run start:dev` | Arranca en modo desarrollo, recargando ante cambios |
| `npm run build` | Compila a `dist/` |
| `npm run lint` | Pasa oxlint sobre `src/` y `test/` |
| `npm run test` | Pruebas unitarias |
| `npm run test:e2e` | Pruebas de extremo a extremo |

## Base de datos

Drizzle ORM sobre PostgreSQL, con el driver `pg`. La conexion sale de
`DATABASE_URL`, que se valida al arrancar como cualquier otra variable.

Las migraciones **se aplican solas al arrancar la aplicacion**: si hay alguna
pendiente, corre antes de que la API acepte peticiones. En el servidor no hay
ningun paso extra que recordar.

```bash
npm run db:generate   # genera una migracion a partir de los cambios del esquema
npm run db:migrate    # aplica las pendientes a mano, sin arrancar la app
npm run db:studio     # abre el visor de datos de Drizzle
```

El esquema vive en `src/database/schema/` y las migraciones generadas en
`drizzle/`, ambos versionados. Nunca se editan las migraciones a mano: se
cambia el esquema y se regenera.

`DATABASE_URL` apunta a `localhost` en el `.env` y a `db` dentro del compose.
Son dos vistas de la misma base: `localhost` es como la ves desde tu maquina
(para `drizzle-kit` o para correr la API fuera de Docker) y `db` es el nombre
del servicio en la red interna de Docker.

## Docker

El compose levanta la API y PostgreSQL. Son dos archivos:

- `docker-compose.yml` define los servicios tal como corren en el servidor.
- `docker-compose.override.yml` lo aplica Docker automaticamente en local: monta
  el codigo dentro del contenedor, arranca en modo watch y publica el puerto de
  la base para poder conectarse con un cliente grafico.

### En local

```bash
cp .env.example .env
docker compose up -d
```

Levanta ambos servicios en modo desarrollo con recarga en caliente: al guardar
un archivo el contenedor se reinicia solo, sin reconstruir la imagen. La API
queda en `http://localhost:3000/api` y la base en `localhost:5432`.

```bash
docker compose logs -f api    # ver los registros
docker compose down           # parar, conservando los datos
docker compose down -v        # parar y borrar tambien la base
```

### Como corre en el servidor

Ignorando el override, que es lo que se hace en el Fedora Server:

```bash
docker compose -f docker-compose.yml up -d --build
```

Ahi la API corre desde la imagen de produccion: compilada, sin dependencias de
desarrollo, con `NODE_ENV=production` y como usuario sin privilegios. Solo
cambian las variables del `.env`.

La API no arranca hasta que PostgreSQL responde al healthcheck, y los datos
viven en un volumen que sobrevive a `docker compose down`.
