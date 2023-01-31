#!/bin/bash

# If env _condor_SCHEDD_HOST is set, then likely we have been spawned by a hub
# that wants to use an HTCondor instance outside of the container.  So
# in this case, just exit without starting a personal condor.

_condor_local_dir=`condor_config_val LOCAL_DIR` || exit 5

_MSG="Did NOT start HTCondor because using remote schedd"

[ ! -v "_condor_SCHEDD_HOST" ] && if [ $(id -u) == 0 ] ; then
  _MSG="Started HTCondor via sudo"
  sudo -E -H -u $NB_USER PATH=$PATH -- mkdir -p "$_condor_local_dir/lock" "$_condor_local_dir/log" "$_condor_local_dir/run" "$_condor_local_dir/spool" "$_condor_local_dir/execute" "$_condor_local_dir/cred_dir"
  sudo -E -H -u $NB_USER PATH=$PATH -- condor_master
else
  _MSG="Started HTCondor"
  mkdir -p "$_condor_local_dir/lock" "$_condor_local_dir/log" "$_condor_local_dir/run" "$_condor_local_dir/spool" "$_condor_local_dir/execute" "$_condor_local_dir/cred_dir"

  # Running the master under sg is a hack to bypass an issue where, when a
  # container is run under Kubernetes with the feature flag RunAsGroup=true but
  # without a group actually set in the pod security context, the container is
  # run with group ID 0.
  # This causes users to not be able to submit jobs in the container, because
  # HTCondor thought they were root (it checks for uid == 0 || gid == 0).
  # Incredibly, sg does not accept gids, only group names.
  # So, we need to grab the group's actual name by parsing getent output.
  # If we're already in the right group, sg is a no-op and everything
  # behaves as expected.
  sg $(getent group $NB_GID | awk -F: '{ print $1 }') condor_master
fi

echo $_MSG

# Allow derived images to run additional runtime customizations.
shopt -s nullglob
for x in /image-init.d/*.sh; do source "$x"; done
shopt -u nullglob

exec "$@"
