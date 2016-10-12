import sys
sys.path.append('/grid/fermiapp/products/larsoft/larbatch/v01_22_00/bin')
from project import *

def main(argv):
  xmlfile=""
  projectname=""
  stagename=""
  args = argv[1:]
  while len(args) > 0:
      if args[0] == '--xml' and len(args) > 1:
          xmlfile = args[1]
          del args[0:2]
      elif args[0] == '--project' and len(args) > 1:
          projectname = args[1]
          del args[0:2]
      elif args[0] == '--stage' and len(args) > 1:
          stagename = args[1]
          del args[0:2]
      else:
          print 'Unknown option %s' % args[0]
          return 1

  projects = get_projects("/sbnd/app/users/dbrailsf/mcc/scratch/prodsingle_sbnd_test.xml")
  project = select_project(projects, projectname, stagename)
  if project != None:
      if projectname == '':
          projectname = project.name
  else:
      raise RuntimeError, 'No project selected.\n'

  stage = project.get_stage(stagename)
  print stage.outdir


if __name__ == '__main__':
    sys.exit(main(sys.argv))


