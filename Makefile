ifndef TARGET
$(error TARGET is not set)
endif

zxdb: FORCE
	${FUCHSIA_DIR}/buildtools/ninja -C ${FUCHSIA_DIR}/out/${TARGET} host_x64/zxdb

zxdb_tests: FORCE
	${FUCHSIA_DIR}/buildtools/ninja -C ${FUCHSIA_DIR}/out/${TARGET} host_x64/zxdb_tests

test: zxdb zxdb_tests FORCE
	${FUCHSIA_DIR}/out/${TARGET}/host_x64/zxdb_tests

FORCE:
