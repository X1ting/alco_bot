# Hi!

# How to run
0. VPN or live outside the Roskomnadzor-controlled area (otherwise it won't connect to the telegram servers)
1. Clone `git clone https://github.com/x1ting/alco_bot.git && cd alco_bot`
2. Get bot token([Instruction](https://core.telegram.org/bots#6-botfather))
3. Copy `cp .env.example .env` and replace with obtained token
4. Run `docker build -t alco:bot . && docker run -it alco:bot`
