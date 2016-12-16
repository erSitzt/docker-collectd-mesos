Hostname "{{ COLLECTD_HOST | default(HOST) }}"

FQDNLookup false
Interval 10
Timeout 2
ReadThreads 5

{% if GRAPHITE_HOST is defined %}
LoadPlugin write_graphite
<Plugin "write_graphite">
    <Carbon>
        Host "{{ GRAPHITE_HOST }}"
        Port "{{ GRAPHITE_PORT | default("2003") }}"
        Protocol "tcp"
        Prefix "{{ GRAPHITE_PREFIX | default("collectd.") }}"
        StoreRates true
        AlwaysAppendDS false
        SeparateInstances true
    </Carbon>
</Plugin>
{% endif %}

{% if INFLUXDB_HOST is defined %}
LoadPlugin network
<Plugin "network">
    Server "{{ INFLUXDB_HOST }}" "{{ INFLUXDB_PORT | default("25826") }}"
</Plugin>
{% endif %}

<LoadPlugin "python">
    Globals true
</LoadPlugin>

<Plugin "python">
    ModulePath "/usr/share/collectd/plugins/mesos"

    Import "mesos-{{ MESOS_MODE }}"
    <Module "mesos-{{ MESOS_MODE }}">
        Host "{{ MESOS_HOST | default(HOST) }}"
        Port {{ MESOS_PORT }}
        Verbose false
        Version "{{ MESOS_VERSION }}"
    </Module>

    ModulePath "/usr/share/collectd/plugins/marathon"

    Import "marathon"

    <Module "marathon">
        Host "{{ MARATHON_HOST }}" 
        Port "{{ MARATHON_PORT }}"
	User "{{ MARATHON_USER }}"
	Pass "{{ MARATHON_PASS }}"
        Verbose false
    </Module>
</Plugin>
