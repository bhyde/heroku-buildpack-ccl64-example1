# Using the Heroku buildapp for ccl64

First some definitions: [Heroku](https://www.heroku.com/) is a cloud computing platform, and ccl64 is the 64 bit version of [Clozure 
Common Lisp](http://ccl.clozure.com/).  [Heroku-buildapp-ccl64](https://github.com/bhyde/heroku-buildpack-ccl64)
is a heroku buildapp, i.e. a tool that is used to convert your application's sources into a so called slug.  Slugs
are instantiated by Heroku as it scales up your application.

This repository is an example of using that build app to build a very trivial web server.  It
uses [Hutchentoot](http://weitz.de/hunchentoot/) to serve a single page (and an image).

# It's easy, try it!

You'll need a [Heroku acount and tools](https://devcenter.heroku.com/articles/quickstart). Given that then all you need do is run this command:

```bash
curl https://gist.github.com/bhyde/5383182/raw/gistfile1.txt | bash
```

# A few notes.

In main.lisp you'll note that cl-user:initialize-application is responsible
for any startup activities your application needs to do.  The saved application's
main thread does to sleep when this routine returns.  This happens at run time.

Main.lisp is also were we define our single webpage, and ask Hutchentoot to server
any files it find in the static subdirectory (i.e. the image).

Notice how heroku-compile.lisp is responsible for compiling your code.  That's
typcially just a matter letting quicklisp do that via your ASDF file.  This happens
at build time.

Note that CCL it's self, any fasl files created during compilation, and all the
systems downloaded by quicklisp are stored in build's so called "cache." That
cache is visible only when we are building the system, they don't appear in the
slug and so they are not around at runtime.

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

# Appendix A

If you'd prefer to step thru setting up the application 
by hand you can use these instructions, or read the script.

```bash
# 1. Clone it
git clone https://github.com/bhyde/heroku-buildpack-ccl64-example1.git

# 2. Create an heroku application to be built by heroku-buildpack-ccl64.
cd heroku-buildpack-ccl64-example1
heroku create -s cedar --buildpack https://github.com/bhyde/heroku-buildpack-ccl64.git

# 3. Push this example and watch it build
git push heroku master

# 4. Visit the new site.
heroku open
```
