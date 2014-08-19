import sys
import os
import re

input_file_name = sys.argv[1]

f = open(input_file_name)
lines = f.readlines()
f.close()

cyitklines = [line for line in lines if line.startswith('//@cyitk')]

cimport_cyitk = 'cimport cyitk'
import_cyitk = 'import cyitk'

print cimport_cyitk
print import_cyitk
print
print

def image_repl(match):
    return 'cyitk.itkImage%s* ' % match.groups()[0]

def cy_image_repl(match):
    return '(<cyitk.Image%s>%s).GetITKImage()' % (match.groups()[0],match.groups()[1])

for line in cyitklines:
    cdef_extern = 'cdef extern from "%s":' % os.path.basename(input_file_name)
    function_re = re.compile('(//@cyitk)\s*(.*)(\(.*\))')
    parts = function_re.findall(line)
    if not parts:
        #TODO: complain
        continue
    tag = parts[0][0].strip()
    ret_func = parts[0][1].strip()
    args = parts[0][2].strip()
    ret_func_split = ret_func.split()
    ret = ' '.join(ret_func_split[:-1])
    func = ret_func_split[-1]
    image_re = re.compile('(?:@Image)(\w*)\s')
    args_sub = image_re.sub(image_repl,args)
    cdecl = '    %s itk%s "%s" %s except +' % (ret,func,func,args_sub)    
    split_args = args[1:-1].split(',')
    argnames = [arg.split()[-1] for arg in split_args]
    pyfunc = 'def %s (%s):' % (func,','.join(argnames))
    pre_cyargs = []
    for arg in split_args:
        if arg.split()[0].strip().startswith('@Image'):
            pre_cyargs.append(arg)
        else:
            pre_cyargs.append(arg.split()[-1])
    cy_image_re = re.compile('(?:@Image)(\w*)(?:\s*)(\w*)(?:(?=[,])|$)')
    cyargnames = cy_image_re.sub(cy_image_repl,','.join(pre_cyargs))
    if ret != 'void':
        cycall = '    return itk%s(%s)' % (func,cyargnames)
    else:
        cycall = '    itk%s(%s)' % (func,cyargnames)
    print cdef_extern
    print
    print cdecl
    print
    print pyfunc
    print
    print cycall
    print
    print

