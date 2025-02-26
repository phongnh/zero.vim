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

### Step 3: Generate language definitions in VimL from `dumb-jump-find-rules.el`

```shell
bundle exec rake generate
```

### Step 4: Install language definitions to `autoload/zero/dumb_jump.vim`

```
bundle exec rake install
```

### Run all steps

```shell
bundle exec rake update
```
