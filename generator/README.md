# dumb-jump-generator

Code is copied from https://github.com/pechorin/any-jump.vim/tree/master/generator and modified for my usecase.

All credits go to:
- https://github.com/pechorin/any-jump.vim
- https://github.com/jacktasia/dumb-jump

## Source

https://github.com/jacktasia/dumb-jump/blob/master/dumb-jump.el

## Build process

### Step 1: Download `dumb-jump.el`

```shell
bundle exec rake download
```

### Step 2: Extract definitions (`find-rules`) from `dumb-jump.el` to `dumb-jump-find-rules.el`

```shell
bundle exec rake extract
```

### Step 3: Generate and install VimL language definitions from `dumb-jump-find-rules.el`

```shell
bundle exec rake generate
```

### Run all steps

```shell
bundle exec rake update
```
