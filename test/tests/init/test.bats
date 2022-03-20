setup() {
	# load helper scripts definitions and bats plugins/modules
	# working dir is root test script
	load $(readlink -f "${PWD}")/test_helper/helpers.bash

	# set common environment
	_common_setup
}

@test "init: run init scripts in order" {
	# execute init scripts from directories or commands/scripts
	run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -v ${CTX}/init.d/:/testbin/init.d/ ${INIT} ${IMAGE} true
	assert_success

	assert_output - <<- EOF
		init 01
		init 99_sub/01
		init 99_sub/10
		init 01
		EOF
	
	assert_equal "${stderr}" ""
}
