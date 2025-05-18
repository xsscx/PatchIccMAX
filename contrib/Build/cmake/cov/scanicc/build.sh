gcc scanicc-port-linux.c ~/lcms2/Little-CMS/src/*.o  -I/home/xss/lcms2/Little-CMS/include     -fsanitize=address -fno-omit-frame-pointer -g3 -O1     -Wall -Wextra -pedantic     -o xscan     -lz -lm     -Wno-unused-parameter -Wno-type-limits  -Wno-mislead
ing-indentation
