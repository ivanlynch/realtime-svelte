<script>
  /* Comentario */
  import ApolloClient from "apollo-client";
  import gql from "graphql-tag";
  import { InMemoryCache } from "apollo-cache-inmemory";
  import { split } from "apollo-link";
  import { HttpLink } from "apollo-link-http";
  import { WebSocketLink } from "apollo-link-ws";
  import { getMainDefinition } from "apollo-utilities";
  import { subscribe } from "svelte-apollo";

  const wsLink = new WebSocketLink({
    uri: `ws://localhost:8080/v1/graphql`,
    options: {
      reconnect: true
    }
  });

  // Create an http link:
  const httpLink = new HttpLink({
    uri: `http://localhost:8080/v1/graphql`
  });

  const link = split(
    // split based on operation type
    ({ query }) => {
      const definition = getMainDefinition(query);
      return (
        definition.kind === "OperationDefinition" &&
        definition.operation === "subscription"
      );
    },
    wsLink,
    httpLink
  );

  const client = new ApolloClient({
    link,
    cache: new InMemoryCache()
  });
  const CURSOS = gql`
    subscription Cursos {
      cursos {
        nombre
        descripcion
      }
    }
  `;

  const cursosList = subscribe(client, { query: CURSOS });

  export let name;
</script>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  ul {
	  text-decoration: none;
	  list-style: none;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>

<main>
  <h1>Hello {name}!</h1>
  {#await $cursosList}
    <li>Cargando...</li>
  {:then result}
    {#each result.data.cursos as curso}
      <ul>
        <li>
          <div>{curso.nombre}</div>
          <div>{curso.descripcion}</div>
        </li>
      </ul>
    {/each}
  {:catch error}
    <li>Error loading authors: {error}</li>
  {/await}
</main>
