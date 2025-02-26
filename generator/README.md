# Modified version of https://github.com/pechorin/any-jump.vim/tree/master/generator

## Source

https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

## Build process

### Step 1: Download `dump-jump.el`

```shell
bundle exec rake download
```

### Step 2: Extract definitions

```shell
bundle exec rake extract
```

### Step 3: Generate language definitions in VimL

```shell
bundle exec rake generate
```

### Step 4: Install language definitions to `autoload`

```
bundle exec rake install
```

### Run all steps

```shell
bundle exec rake update
```
