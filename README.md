# Buildio Cli

## How do I install these formulae?

`brew install buildio/cli/<formula>`

Or `brew tap buildio/cli` and then `brew install <formula>`.

Or, in a [`brew bundle`](https://github.com/Homebrew/homebrew-bundle) `Brewfile`:

```ruby
tap "buildio/cli"
brew "<formula>"
```


## Development

### Building Locally

To build the formula locally from the `bld.rb` file, run:

   ```sh
   brew install --build-from-source ./bld.rb
   ```

### Running Tests

To run tests for the `bld` formula:

1. **Uninstall Existing Version** (if necessary):

   ```sh
   brew uninstall --force bld
   ```

2. **Install the Updated Formula Locally:**

   ```sh
   brew install --build-from-source ./bld.rb
   ```

3. **Run the Test Block:**

   ```sh
   brew test bld
   ```

### Debugging

If you encounter any issues during installation or testing, you can enable verbose output to get more details:

```sh
brew install --build-from-source --verbose --debug ./bld.rb
brew test --verbose bld
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

