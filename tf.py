# This is a dummy tf module to allow module testing outside of TinyFugue.
#
# If you are actually /python_load-ing or import-ing the module in TF
# then this file is NOT LOADED, it is only a stub for debugging.

def err(arg):
	print 'tf.err(%r)' % arg

def eval(arg):
	print 'tf.eval(%r)' % arg
	return ''

def getvar(var, default=''):
	print 'tf.getvar(%r, %r)' % (var, default)
	return default

def out(arg):
	print 'tf.out(%r)' % arg

def send(text, world='<current>'):
	print 'tf.send(%r, %r)' % (text, world)

def world():
	return 'tf'
