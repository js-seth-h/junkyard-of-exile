upath = require 'upath'
MONO_REPO_DIR = upath.dirname upath.dirname upath.dirname __dirname
PACKAGES_DIR = upath.join MONO_REPO_DIR, 'packages'
TEMP_DIR = upath.join MONO_REPO_DIR, 'tmp'

consts = {
  MONO_REPO_DIR
  PACKAGES_DIR
  TEMP_DIR
}
Object.assign exports, consts

if process?.env?
  Object.assign process.env, consts
