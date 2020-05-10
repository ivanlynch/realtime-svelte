docker run -d -p 8080:8080 \
  -e HASURA_GRAPHQL_DATABASE_URL=postgres://hasurauser:hasurauser@host.docker.internal:port/postgres \
  -e HASURA_GRAPHQL_ENABLE_CONSOLE=true \
  hasura/graphql-engine:latest