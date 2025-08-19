# Task Bingo
A simple webapp for making and keeping track of task bingos. Users can choose between bingo boards of size 3, 4 or 5, and pick a deadline of 1 day, 1 week or 1 month. 

## Features
- Data persists between run, providing that the user is using the same browser (stored locally).
- Users can create new bingo cards by inputting tasks and choosing a size and a duration.
- Tasks are shuffled automatically when a new card is created.
- Users can click on each task on the bingo board to mark them as done.
- Bingos are automatically tracked and notified.
- The amount of time left to finish the current board is displayed at the top right corner.
- Once the deadline has passed, users cannot mark more tasks as done.
- User can clear and delete the current bingo board at any time.

## How to run
- Download or clone this repo.
- Navigate to the downloaded folder.
- Run `dart pub global run webdev serve`.

## Structure
- **Generate** (mixin): handles generation of HTML elements on startup
- **BingoMonitor** (mixin): handles the monitoring of bingo status
- **Utils with Generate, BingoMonitor** (class): contains helper functions for other functionalities
- **Facade extends Utils** (class): contains selection of HTML elements, handles button listening and timer

## Dependencies
- `package:web/web.dart`: For web functionalities
- `dart:convert`: For JSON handling

## Key Dart features demonstrated
- Stream handling (with listen)
- Null safety
- Future and async-await
- Generics
- Extension
- Mixins
- Late variables
- List and Map
- User input handling through web UI
