===================
podcast.spodeli.org
===================

This is the setup of our podcast.spodeli.org_ site. The site is static html
generated with hyde_, using markdown for writing content, and html5 features
for audio (with flash as a fallback).

The build/publish system is based on a Makefile.



Do-it: Install, Build and Deploy
===============================

The site is generated with hyde_ 0.8 and uses html5media_ to create the audio/video
widgets. To install all, just run ``make get-deps``.

Next step is to build the static files with ``make build``, it will create the directory
``output``. You can run the ``make preprocess`` target to convert all of the audio files
to the needed format and codec.

Last, you deploy the static files in ``output`` to your server by using rsync with ``make deploy``.


.. _podcast.spodeli.org: http://podcast.spodeli.org/
.. _hyde: http://github.com/hyde/hyde
.. _html5media: http://html5media.info/


Configuration
=============

hyde_ is configured in ``site.yaml``. See its documentation about what goes there.



Deploy
======

Deployment is nothing short of putting the ``output`` directory on a public web server.

For deployment I use rsync over ssh. To configure rsync settings, you'll need
to create a ``settings.mk`` file and specify the host, username and destination
directory for deploying. For example::

    DEPLOY_HOST = podcast.spodeli.org
    DEPLOY_USER = podcast
    DEPLOY_DEST = /srv/html/podcast-site

Additionaly in ``settings.mk`` you can override your Python program (``python2`` by default)
and pip (used to install hyde, ``pip2`` by default).

If you don't specify DEPLOY_HOST and DEPLOY_USER, you can also deploy localy in DEPLOY_DEST.

Of course, you might prefer to use git, ftp, scp or tar files for deployment, in that case you
should create your custom make rule in ``settings.mk``.



