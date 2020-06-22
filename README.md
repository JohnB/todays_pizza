# TodaysPizza

Replacement twitterbot for http://cheeseboardcollective.coop/pizza/
The original ruby version is at https://github.com/JohnB/cheeseboardpizza

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

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
- [ ] attempt _any_ deployment, even if it is not reachable
- [ ] make the code changes needed for successfule deployment
- [ ] verify the homepage works correctly
- [ ] set twitter env vars in heroku
- [ ] add a tweet button (hidden mayber?)
- [ ] refactor so it can be used from cron
- [ ] add the cron job

## Notes added on top of 'heroku info' results
CURRENT === cedar-pizzabot
https://github.com/JohnB/cheeseboardpizza
Addons:         heroku-postgresql:hobby-dev
                scheduler:standard
Auto Cert Mgmt: false
Dynos:          web: 1
Git URL:        https://git.heroku.com/cedar-pizzabot.git
Owner:          john.baylor@gmail.com
Region:         us
Repo Size:      27 MB
Slug Size:      41 MB
Stack:          heroku-18
Web URL:        https://cedar-pizzabot.herokuapp.com/

delete === cheese-board-pizza - last touched 5/20/2016 
https://github.com/JohnB/cheeseboardpizza
Addons:         heroku-postgresql:dev
                scheduler:standard
Auto Cert Mgmt: false
Dynos:          
Git URL:        https://git.heroku.com/cheese-board-pizza.git
Owner:          john.baylor@gmail.com
Region:         us
Repo Size:      13 MB
Slug Size:      11 MB
Stack:          bamboo-ree-1.8.7
Web URL:        https://cheese-board-pizza.herokuapp.com/

ENDED 2015 === todays-pizza - CAN I RESURRECT with new repo?
https://github.com/JohnB/cheeseboardpizza
Auto Cert Mgmt: false
Dynos:          
Git URL:        https://git.heroku.com/todays-pizza.git
Owner:          john.baylor@gmail.com
Region:         us
Repo Size:      0 B
Slug Size:      0 B
Stack:          cedar-14
Web URL:        https://todays-pizza.herokuapp.com/
