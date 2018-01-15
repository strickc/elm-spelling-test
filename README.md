# Elm Spelling Test

An demonstration Elm app for writing and taking spelling tests, using speechSynthesis native browser api.

## Installation

Clone this repo into a new project folder and run install script.
(I ignore the errors about missing jquery as it is best not to use the Bootstrap jquery-based components with Elm)

With npm

```sh
$ npm run dev
```

With yarn
```sh
$ git clone git@github.com:simonh1000/elm-webpack-starter.git new-project
$ cd new-project
$ yarn
$ yarn dev
 ```

Open http://localhost:3000 and start modifying the code in /src.
(An example using Routing is provided in the `navigation` branch)

## Production

Build production assets with:

```sh
npm run prod
```

## Static assets

Just add to `src/assets/` and the production build copies them to `/dist`

## Testing

[Install elm-test globally](https://github.com/elm-community/elm-test#running-tests-locally)

`elm-test init` is run when you install your dependencies. After that all you need to do to run the tests is

```sh
yarn test
```

Take a look at the examples in `tests/`

If you add dependencies to your main app, then run `elm-test --add-dependencies`

<hr />

## Credits

Starting layout cloned from simonh1000/elm-webpack-starter

