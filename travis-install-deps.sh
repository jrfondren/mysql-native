#!/bin/sh
if ! [ $(which rdmd) ]; then
	DMD_ZIP=dmd.2.076.0.${TRAVIS_OS_NAME}.zip
	wget http://downloads.dlang.org/releases/2017/$DMD_ZIP
	unzip -d local-dmd $DMD_ZIP
fi

# If an alternate dub.selections.json was requested, use it.
cp "dub.selections.${DUB_SELECT}.json" dub.selections.json 2>/dev/null
cp "examples/homePage/dub.selections.${DUB_SELECT}.json" examples/homePage/dub.selections.json 2>/dev/null

echo "In install: DUB_UPGRADE=$DUB_UPGRADE"

if [ "$DUB_UPGRADE" = "true" ]; then
	# Update all dependencies
	dub upgrade
	cd examples/homePage
	dub upgrade
	cd ../..
else
	# Don't upgrade dependencies.
	# But download & resolve deps now so intermittent failures are more likely
	# to be correctly marked as "job error" rather than "tests failed".
	dub upgrade --missing-only
	cd examples/homePage
	dub upgrade --missing-only
	cd ../..
fi
