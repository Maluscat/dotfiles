vim9script noclear

UltiSnipsAddFiletypes css.less

augroup lesstocss
  autocmd!
  autocmd BufWritePost *.less call LessToCSS()
augroup END

if !exists("*LessToCSS")
def LessToCSS()
python3 << EOF

import vim
import pathlib
import subprocess

def less_to_CSS(path):
    firstline = read_first_line(path)[2:]

    options = {}
    for option in firstline.split(','):
        if option == '\n':
            continue
        split_option = option.split(':')
        options[split_option[0].strip()] = split_option[1].strip()

    if 'main' in options:
        for main_file in options['main'].split('|'):
            main_file_path = path.parent / main_file
            return less_to_CSS(main_file_path)
    elif 'out' in options:
        sourcemap = ('sourcemap' in options) and options['sourcemap']
        return subprocess.run([
            'lessc',
            '--no-color',
            ('--source-map' if sourcemap == 'true' else ''),
            str(path),
            str(path.parent / options['out'])
        ], shell=True, stderr=subprocess.PIPE).stderr


def read_first_line(file_name):
    with open(file_name) as file:
        return file.readline()

output = less_to_CSS(pathlib.Path(vim.eval('expand("%:p")')))
output = output.decode('UTF-8')
if output:
  print(output)

EOF
enddef
endif

# function LessToCSS(path = expand("%:p"), line = getline(1))
#   let options = {}
#   for option in split(a:line[2:], ',')
#     let splitOption = split(option, ':')
#     let options[trim(splitOption[0])] = trim(splitOption[1])
#   endfor
#
#   " If the options contain a 'main' flag, relay to the given file
#   if has_key(options, 'main')
#     for mainFile in split(options.main, '|')
#       let mainPath = fnamemodify(a:path, ':h') . '/' . mainFile
#       call LessToCSS(mainPath, readfile(mainPath)[:1][0])
#     endfor
#   elseif has_key(options, 'out')
#     " we will ignore compress...
#     silent execute
#         \ '!lessc '
#         \ . (get(options, 'sourcemap') == 'true' ? '--source-map ' : '')
#         \ . a:path . ' '
#         \ . fnamemodify(a:path, ':h') . '/' . options.out
#   endif
# endfunction

