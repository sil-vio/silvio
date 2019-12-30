#bin/bash

hugo server -b http://`hostname -I` --bind=0.0.0.0 --navigateToChanged
