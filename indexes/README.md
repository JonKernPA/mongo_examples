## Purpose

I discovered some odd behavior with MongoMapper ensure_index for *uniqueness* that I wanted to document.

Bottom line, it seems that the *unique* index is picky...

This works:

    key :email, String, :required => true, :unique => true

This fails:

    User.ensure_index([[:name,1]], :unique => true)
    
Consult the Gemfile for versions...

    ruby 1.8.7 (2011-02-18 patchlevel 334) [i686-darwin10.7.0]

    *** LOCAL GEMS ***
    activesupport (3.1.3)
    bson (1.4.0)
    bson_ext (1.4.0)
    builder (2.1.2)
    bundler (1.0.21)
    i18n (0.6.0)
    jnunemaker-validatable (1.8.4)
    json_pure (1.6.1)
    mongo (1.4.0)
    mongo_mapper (0.8.6)
    multi_json (1.0.3)
    plucky (0.3.8)
    rake (0.8.7)
