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

## Docker

Pendiente: se documenta al montar el docker-compose.
