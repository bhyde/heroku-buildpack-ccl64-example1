# It's easy, try it!

You'll need a [Heroku acount and tools](https://devcenter.heroku.com/articles/quickstart), as 
well as git and curl.  Given that then all you need do is run the following command.  /tmp
might be a good working directory.

```bash
curl https://gist.github.com/bhyde/5383182/raw/gistfile1.txt | bash
```

When this finishes your browser will display our trival website running on Heroku.

# What is this?

This is a trival working example of running a Common Lisp web app on Heroku, for free.

First some definitions.  [Heroku](https://www.heroku.com/) is a cloud
computing platform.  You run apps on Heroku.  Ccl64 is the 64 bit
version of [Clozure Common Lisp](http://ccl.clozure.com/), it's one of
many Common Lisp implementations.  We will use that.
[Heroku-buildapp-ccl64](https://github.com/bhyde/heroku-buildpack-ccl64)
is a heroku buildapp.  Buildapps are tools used to convert the sources
of your app into slugs.  And, slugs are internal object of Heroku; as
Heroku scales up your app up it instantiates the slugs into workers,
known as dynos.

So this repository is an example of using heroku-buildapp-ccl64 to run
a simple Common Lisp application on Heroku.  It uses
[Hutchentoot](http://weitz.de/hunchentoot/) to serve a single page
(and an image).

# What now?

The sources of you little application are in the directory heroku-buildpack-ccl64-example1.

You can tinker with main.lisp to change the web site, and then update the site by commiting
your changes and pushing them to heroku.

```bash
git commit -m 'geewiz' main.lisp
git push heroku master
```

You can delete the application using ```heroku apps:destroy <name>```, and then
you can delete the heroku-buildpack-ccl64-example1 directory.

# A few notes.

Heroku is free for low volume applications.

Notice that in the instructions we didn't even install Closure Common Lisp.  But, going forward you'll probably
want that.

In main.lisp you'll note that cl-user:initialize-application is responsible
for any startup activities your application needs to do.  The saved application's
main thread does to sleep when this routine returns.  This happens at run time.

Main.lisp is also were we define our single webpage, and ask Hutchentoot to server
any files it find in the static subdirectory (i.e. the image).

Notice how heroku-compile.lisp is responsible for compiling your code.  That's
typcially just a matter letting quicklisp do it, via your ASDF file.  This happens
at build time.

Note we do not include much into the slug.  Not CCL, none of the fasl files,
none of the source for the systems downloaded by Quicklisp and ASDF.  These
are all stored, at build time, in the so called "cache."

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

You can list all your existing apps:
```bash
heroku apps
```

You can delete on of these:
```bash
heroku apps:destroy <name>
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
