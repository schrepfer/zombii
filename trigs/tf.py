# This is a dummy tf module to allow module testing outside of TinyFugue.
#
# If you are actually /python_load-ing or import-ing the module in TF
# then this file is NOT LOADED, it is only a stub for debugging.

def err(arg):
	print 'tf.err(%s)' % repr(arg)

def eval(arg):
	print 'tf.eval(%s)' % repr(arg)
	return ''

def getvar(var, default=''):
	print 'tf.getvar(%s, %s)' % (repr(var), repr(default))
	return default

def out(arg):
	print 'tf.out(%s)' % repr(arg)

def send(text, world='<current>'):
	print 'tf.send(%s, %s)' % (repr(text), repr(world))

def world():
	return 'tf'
