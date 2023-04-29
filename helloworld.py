#!/usr/bin/env python3
from pyln.client import Plugin # We import `Plugin` from the `pyln-client` pip package, which does all the hard work for us

plugin = Plugin() # This is our plugin's handle

@plugin.init() # Decorator to define a callback once the `init` method call has successfully completed
def init(options, configuration, plugin, **kwargs):
    plugin.log("Plugin helloworld.py initialized")

@plugin.method("hello")
def hello(plugin, name="world"):
    """This is the documentation string for the hello-function.
    It gets reported as the description when registering the function
    as a method with `lightningd`.
    """
    greeting = plugin.get_option('greeting')
    s = '{} {}'.format(greeting, name)
    plugin.log(s)
    return s

plugin.add_option('greeting', 'Hello', 'The greeting I should use.')

plugin.run() # Run our plugin
