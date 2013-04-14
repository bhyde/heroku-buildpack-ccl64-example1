# Very Simple example of using heroku-buildapp-ccl64

Heroku-buildapp-ccl64 is a buildapp for the 64 bit Closure Common Lisp (aka ccl),
and this heroku-buildapp-ccl64 is a very simple example of how to use that to make
a single page web site via Hunchentoot.

# Try it.

```bash
# 1. Clone it
git clone https://github.com/bhyde/superman.git

# 2. Create an heroku application to be built by heroku-buildpack-ccl64.
cd superman
heroku create -s cedar --buildpack https://github.com/bhyde/heroku-buildpack-ccl64.git

# 3. Push this example and watch it build
git push heroku master

# 4. Visit the new site.
heroku open
```

# A few notes.

In main.lisp you'll note that cl-user:initialize-application is responsible
for any startup activities your application needs to do.  The saved application's
main thread does to sleep when this routine returns.  This happens at run time.

Notice how heroku-compile.lisp is responsible for compiling your code.  That's
typcially just a matter letting quicklisp do that via your ASDF file.  This happens
at buildt time.

Note that none of your .lisp or .asd files survive into the slug, and hence are
not around at runtime due to the contents of .slugignore.  CCL it's self, any fasl
files created during compilation, and all the systems downloaded by quicklisp
are stored in the so called "cache" which is visibly only when we are building
the system.  They don't appear in the slug and so they too are around at runtime.

# A few heroku tricks.

Look at your heroku logs
```bash
heroku logs -n 20
```

Limit the scaling so your more likely to avoid
exceeding limits on free.
```bash
heroku ps:scale web=1
```

You shutdown all your processing by doing:
```bash
heroku ps:scale web=0
```

You can take the website online/online by doing:
```bash
heroku maintenance:off
heroku maintenance:on
```

You can dive into a running slug to poke around by doing:
```bash
heroku run bash
```

Reset your buildpack to force a recompile from scratch or to update if
you changed the buildpack>
```bash
heroku config:add BUILDPACK_URL=https://github.com/bhyde/heroku-buildpack-ccl64.git
```
