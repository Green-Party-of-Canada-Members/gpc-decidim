# Decidim for the Green Party Canada

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for https://gpcmembers.com based on [Decidim](https://github.com/decidim/decidim).

![Test](https://github.com/Green-Party-of-Canada-Members/gpc-decidim/actions/workflows/test.yml/badge.svg)

![GPC Homepage](app/packs/images/screenshot.png)

## Deploying the app

Deployed with [Capistrano](http://capistranorb.com/) using [Figaro](https://github.com/laserlemon/figaro) for `ENV` configuration.

In your machine, execute:

```bash
cap production deploy
```

### ENV vars

These ENV vars modifies the behavior of the application in some ways:

| ENV | Description |
| --- | --- |
| `DONATE_BUTTON` | If present, it will show a button with the text "donate" linked to this url. Currently in the process sidebar and when creating a proposal. Locale can be handled with interpolations (ie: `http://some.thing/${locale}/pay_here`) |
| `REDIRECT_SIGN_UP` | If present and sign up is enabled, it redirects user registration to the URL specified in it. Can process some variable interpolation like `%{locale}` that would be replace by the current users' locale |
| `REDIRECT_AFTER_INVITATION` | If present, it redirects users registered that registers using an internal invitation (not users registered without it) to the URL specified in this var. |
| `WATCH_RACE_IFRAME` | If present, it adds a menu named "Watch race! Live" and a page with and iframe pointing to whatever URL specified in this var. |
| `REDIRECT_HOMEPAGE` | If present, it makes homepage requests (ie `/`) to be redirected to whatever URL specified in this var. It also removes the main "home" menu item.  |
| `DISABLE_EXTERNAL_INVITES` | If present and set to non-empty value (ie `1`), it disables the ability to invite external participants to meetings |
| `QUESTIONNAIRE_NOTIFY_EMAILS` | Fill it with different emails, separated by spaces, to send each one of them a notification each time a questionnaire is submitted |
| `PROCESS_LEADERSHIP` | If defined, shows a menu directly to the process indicated (used when leadership race is on). Used to be `leadership` |
| `PROCESS_POLICY` | If defined, shows a menu directly to the process indicated. Use to be `Policy2021` |
| `ASSEMBLY_LEADERSHIP` | If defined, shows a menu directly to that assembly (used when leadership race is on). It also applies some custom design to the assembly children (each being an assembly contestant), particularly, it adds a "donate" button. Used to be `leadership-campaigns` |
| `ASSEMBLY_LEADERSHIP_EVENTS` | If defined, redirects the specified assembly to the first published component instead of showing the main info page of the assembly. Used to be `events` |
| `CONTESTANTS_COMPONENTS` | IDs of components (separated by spaces) that will hold contestants. This applies a special design to the proposals page, removing filters for instance. It also adds a link to "donate" money to this particular candidate. |
| `TRANSLATOR_API_KEY` | If defined, automic translations are enabled. We use [DeepL API](https://www.deepl.com/pro-api) service, only api keys from there are valid |
| `TRANSLATOR_HOST` | The URL for the translator API. For the free service must be `https://api-free.deepl.com`. For the "pro" service is `https://api.deepl.com` |

Please refer to the private documentation repository for further details.

## Contributing

If you wan to contribute to this repository, please open a Pull Request and wait until the test pass.

In order to configure your enviroment for development, please install [RBENV](https://github.com/rbenv/rbenv) and (optionally but recommended) [RBENV-VARS](https://github.com/rbenv/rbenv-vars) and [PostgreSQL](https://www.postgresql.org/) in your own machine.

Then, make a copy of this repository, create a development instance with seeds and start your local application:

```bash
git clone git@github.com:Green-Party-of-Canada-Members/gpc-decidim.git
cd gpc-decidim
bundle install
bundle exec rake db:create db:migrate db:seed
bin/rails s
```

Visit: http://localhost:3000/
