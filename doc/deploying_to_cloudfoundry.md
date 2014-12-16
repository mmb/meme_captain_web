# Deploying Meme Captain to Pivotal Web Services (Cloud Foundry)

Sign up for a Pivotal Web Services account at http://run.pivotal.io/

Clone the repository:

```sh
git clone git@github.com:mmb/meme_captain_web
cd meme_captain_web
```

Login to Cloud Foundry:

```sh
cf login
```

Push the app but do not start it:

```sh
cf push <unique app name> --no-start
```

Create the PostgreSQL service and bind it to the app:

```sh
cf create-service elephantsql turtle memecaptain
cf bind-service <unique app name> memecaptain
```

Get the database connect string:

```sh
cf env <unique app name>
```

Get the `postgres://` URI under VCAP_SERVICES.elephantsql.

```sh
psql <PostgreSQL URI>
```

Change bytea_output from hex to escape so images will display properly:

```sql
ALTER DATABASE get_database_name_from_prompt SET bytea_output TO 'escape';
```

Run the database migrations:

```sh
cf push <unique app name> -c 'bundle exec rake db:migrate'
```

Turn off delayed job workers for this simple deployment:

```sh
cf set-env <unique app name> DELAY_JOBS false
```

Restart app with default start command:

```sh
cf push <unique app name> -c null
```
