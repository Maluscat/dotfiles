def Settings( **kwargs ):
  if kwargs[ 'language' ] == 'deno':
    return {
      'ls': {
        'enable': True,
        'lint': True
      }
    }
