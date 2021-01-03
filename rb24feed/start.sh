#!/bin/sh
envsubst < /etc/rbfeeder.ini.tpl > /etc/rbfeeder.ini
supervisord -c /etc/supervisor/supervisord.conf
