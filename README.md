# Next.js + Azure (based on the 'with Docker' and 'with Tailwind CSS' examples)

This example shows:

* how to use [Tailwind CSS](https://tailwindcss.com/) [(v3.0)](https://tailwindcss.com/blog/tailwindcss-v3) with Next.js. It follows the steps outlined in the official [Tailwind docs](https://tailwindcss.com/docs/guides/nextjs)
* how to use Docker with Next.js based on the [deployment documentation](https://nextjs.org/docs/deployment#docker-image)
* how to deploy a Next.js application to Azure, via Azure Container Registry and Azure App Service

## How to use

Execute [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app) with [npm](https://docs.npmjs.com/cli/init) or [Yarn](https://yarnpkg.com/lang/en/docs/cli/create/) to bootstrap the example:

```bash
npx create-next-app --example https://github.com/finalist/nextjs-with-azure azure-app
# or
yarn create next-app --example https://github.com/finalist/nextjs-with-azure azure-app
# or
pnpm create next-app -- --example https://github.com/finalist/nextjs-with-azure azure-app
```

Create an .env.local file for environment variables (of course, do not check in if it carries secrets).


## Deployment

### Configure 

In ./bin/config.sh, set:

- RESOURCE_GROUP: name of the [Azure resource group](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)
- REGISTRY: name of the [Azure Container Registry](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal)


### Provision

You will run this script only once for the web app.

This script will do the following:

- Create an App Service Plan
- Create an App Service
- Set parameters according to .env.local
- Set registry permissions
- Configure logging

```bash
./bin/provision.sh -n <your-app-name>
```

The value for `<your-app-name>` should be globally unique, as it will be made available as a subdomain azurewebsites.net.


### Build

The build script will do the following:

- Build and tag a Docker image
- Push to the Azure container registry

```bash
./bin/build.sh -n <your-app-name>
```


### Deploy

This script will deploy the image from the container registry to the web app.

```bash
./bin/deploy.sh -n <your-app-name>
```

Optionally, you can create a web hook, so that the app will be deployed when a new image is pushed to the container registry:

```bash
./bin/webhook.sh -n <your-app-name>
```
