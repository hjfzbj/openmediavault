# This file is part of OpenMediaVault.
#
# @license   https://www.gnu.org/licenses/gpl.html GPL Version 3
# @author    Volker Theile <volker.theile@openmediavault.org>
# @copyright Copyright (c) 2009-2025 Volker Theile
#
# OpenMediaVault is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# OpenMediaVault is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenMediaVault. If not, see <https://www.gnu.org/licenses/>.

{% set config = salt['omv_conf.get']('conf.service.tftp') %}

{% if config.enable | to_bool %}

configure_default_tftpd-hpa:
  file.managed:
    - name: "/etc/default/tftpd-hpa"
    - source:
      - salt://{{ tpldir }}/files/etc-default-tftpd-hpa.j2
    - template: jinja
    - context:
        config: {{ config | json }}
    - user: root
    - group: root
    - mode: 644

start_tftpd-hpa_service:
  service.running:
    - name: tftpd-hpa
    - enable: True
    - watch:
      - file: configure_default_tftpd-hpa

{% else %}

stop_tftpd-hpa_service:
  service.dead:
    - name: tftpd-hpa
    - enable: False

{% endif %}
