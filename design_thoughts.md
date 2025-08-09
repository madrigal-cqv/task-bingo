# Task Bingo

## Initial thoughts
- store data in a json file (not great for obvious reason, but works fine enough for a small sample webapp)
- data included: username, password, number of tasks, layout, list of tasks, done tasks
- new/returning user, unique username prompted for new, username not found for returning. wrong password
- one page, changing pop-ups
- session if available
- 9/16/25 avaible (if 9/25, middle is free space)
- reshuffle
- bingo notification
- time limit?

## Actual design
- Single user
- Prompt user to make a bingo card if there are none active right now
- 2 page: input page and bingo page
- JSon for storing data