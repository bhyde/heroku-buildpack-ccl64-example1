# Using the Heroku buildapp for ccl64

First some definitions.  [Heroku](https://www.heroku.com/) is a cloud computing platform.  You can run your applications on Heroku.  Ccl64 is the 64 bit version of [Clozure Common Lisp](http://ccl.clozure.com/).  [Heroku-buildapp-ccl64](https://github.com/bhyde/heroku-buildpack-ccl64)
is a heroku buildapp.  Buildapps are tools used to convert the sources of your app into slugs.  Slugs are internal to Heroku; as Heroku scales up your app up and down it instantiates the slugs into works, known as dynos.

With that out of the way, this repository is an example  of using heroku-buildapp-ccl64 to run a simple Common Lisp application on Heroku.  It uses [Hutchentoot](http://weitz.de/hunchentoot/) to serve a single page (and an image).

# It's easy, try it!

You'll need a [Heroku acount and tools](https://devcenter.heroku.com/articles/quickstart), as well as git and curl.  Given that then all you need do is run this command and you'll have a running application.

```bash
curl https://gist.github.com/bhyde/5383182/raw/gistfile1.txt | bash
```

Heroku is free for low volume applications.  Notice we didn't even install Clozure Common Lisp on your local machine.

# A few notes.

Notice that in the instructions we didn't even install Closure Common Lisp.  Going forward you'll probably want that.

In main.lisp you'll note that cl-user:initialize-application is responsible
for any startup activities your application needs to do.  The saved application's
main thread does to sleep when this routine returns.  This happens at run time.

Main.lisp is also were we define our single webpage, and ask Hutchentoot to server
any files it find in the static subdirectory (i.e. the image).

Notice how heroku-compile.lisp is responsible for compiling your code.  That's
typcially just a matter letting quicklisp do it, via your ASDF file.  This happens
at build time.

Note that CCL it's self, any fasl files created during compilation, and all the
systems downloaded by quicklisp are stored in build's so called "cache." That
cache is visible only when we are building the system, they don't appear in the
slug and so they are not around at runtime.

The buildapp uses CCL 1.7, the latest quicklisp, and the ASDF from quicklisp.  To
change these things fork and modify the buildapp.

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

If you'd prefer to step thru setting up the application by hand you can
read [the script](https://gist.github.com/bhyde/5383182), or use these instructions:

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
