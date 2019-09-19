This is a small programs to extract i18n entry from Vue/Nuxt files.
Also to replace i18n tag entry with pair-translated csv file.

Please look in a sample folder for an example.

# Install gems

```
 bundle install --path vendor/bundle
```

# Execute

This will extract i18n entries to a csv file.
```
ruby i18n-extract.rb [root folder path] [output csv file]
```
```
ruby i18n-extract.rb samples samples/extructed.csv
```

This will replace i18n tag entry with the given csv file.
```
ruby i18n-replace.rb [root folder path] [input csv file]
ruby i18n-replace.rb samples samples/translated.csv
```

# Note

If you want do not want to keep original file then comment out a line in `i18n-replace.rb` like this.

```
# if you do not want to keep original file comment out next line
# File.open("#{path}.bak" , "w") { |f| f.write(buffer) }
```
