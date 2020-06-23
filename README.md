# TodaysPizza

Replacement twitterbot for http://cheeseboardcollective.coop/pizza/
The original ruby version is at https://github.com/JohnB/cheeseboardpizza

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Cron Job
It runs daily at 4:30 PM UTC (9:30am PDT)
via [Heroku's Scheduler add-on](https://dashboard.heroku.com/apps/todays-pizza/scheduler)
using this command:
```
mix run -e 'IO.puts TodaysPizza.tweet_about_pizza'
```
$ 

## History
Over time, I've used one github repo (JohnB/cheeseboardpizza) as the source
for a series of heroku sites.

The currently running site, as of 6/21/2020, is cedar-pizzabot 
- which seemed the easiest (only?) way to get it onto the newer stack.

The previously-running app, cheese-board-pizza, can be deleted.
I believe I created it for an interim heroku stack.
DELETED 6/21/2020.

The oldest version, last deployed in 2015, was called todays-pizza.
I'd like to resurrect it to be an elixir bot using the new JohnB/todays_pizza repo.

## Replacement Process
- [x] tell Heroku to use the newer stack
- [x] add it as a remote to the JohnB/todays_pizza client (and in heroku UI?)
- [x] attempt _any_ deployment, even if it is not reachable
- [x] make the code changes needed for successfule deployment 
      (mostly adding a `Procfile` containing 
      `web: mix phx.server`)
- [x] verify the static ("TEST DATA") homepage works correctly
- [x] verify the homepage works correctly
- [x] set twitter env vars in heroku
- [x] refactor so it can be used from cron
- [x] add a tweet button (hidden maybe?)
- [x] add the cron job
- [x] disable the old cron job
- [ ] after seeing it work, delete the link to `/send_pizza_message`
- [ ] after seeing it work, delete the 
      [entire old app](https://dashboard.heroku.com/apps/cedar-pizzabot/settings)
      by scrolling down to the "`Delete app...`" button at the bottom of the page.
